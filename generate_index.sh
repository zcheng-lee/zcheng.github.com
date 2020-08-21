#!/usr/local/bin/bash
repo=$(basename $(git remote get-url origin) |sed 's/.git$//')
branch=$(git branch |grep -E "^\*" |cut -c3-)

declare -A catalog_comment_dict
catalog_comment_dict=([Emacs]="" [Vue]="" [React]="" [JavaScript]="")

catalogs=$(for catalog in ${!catalog_comment_dict[*]};do
							 echo $catalog
					 done |sort)


function generate_headline()
{
		local catalog="$*"
		echo "* $catalog"
		echo ${catalog_comment_dict[$catalog]}
		echo
		generate_links $catalog |sort -t "<" -k2 -r
}

function generate_links()
{
		local catalog=$1
		if [[ ! -d $catalog ]];then
				mkdir -p $catalog
		fi
		posts=$(find $catalog -maxdepth 1 -type f)
		old_ifs=$IFS
		IFS="
"
		for post in $posts
		do
				modify_date=$(git log --date=short --pretty=format:"%cd" -n 1 $post) # 去除日期前的空格
				if [[ -n "$modify_date" ]];then # 没有修改日期的文件没有纳入仓库中,不予统计
						postname=$(basename $post)
						echo "+ [[https://github.com/gcclll/${repo}/blob/${branch}/$post][$postname]]		<$modify_date>"
				fi
		done|sort -k 2
		IFS=$old_ifs
}

cat <<EOF
[[https://app.netlify.com/sites/nostalgic-kalam-a25ef1/deploys][https://api.netlify.com/api/v1/badges/ec819038-0fad-4d00-9af4-3797cc53c106/deploy-status]]
EOF

for catalog in $catalogs
do
		generate_headline $catalog
done

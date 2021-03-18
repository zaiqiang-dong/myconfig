#!/bin/bash 
name="./files-all"
rm -rf $name 
for a in `ls $1/common/build/ufs/gpt_backup*.bin`
do
echo $a>>$name
done

for b in `ls $1/common/build/ufs/gpt_main*.bin`
do
echo $b>>$name
done

for c in `ls $1/common/build/ufs/patch*.xml`
do
echo $c>>$name
done

num=0
for d in `ls $1/common/build/ufs/bin/asic/sparse_images/rawprogram_unsparse*.xml`
do
echo $d>>$name
unpar=`echo ${d##*/}|grep rawprogram_unsparse|awk -F 'rawprogram_unsparse' '{print $2}'`
if [ -n $unpar ];then
    grep_v[$num]=$unpar
    ((num++))
    echo $num 
fi
done
echo "grep -v is $grep_v"

for d in `ls $1/common/build/ufs/rawprogram*.xml|grep -v _`
do
    for g in ${grep_v[*]}
    do   
     d=`echo $d|grep -v $g` 
    done
     echo $d
    if [ -n $d ];then
        echo $d>>$name
    fi
done

sed -i '/^$/d' $name

for e in `ls $1/common/build/ufs/bin/asic/sparse_images/*.img`
do
echo $e>>$name
done

# for i in `cat ./files-bp`
# do
#     echo $1/$i>>$name
# done

echo "$1/LINUX/android/out/target/product/sdm845/abl.elf" >> $name
echo "$1/aop_proc/build/ms/bin/AAAAANAZO/aop.mbn" >> $name
echo "$1/LINUX/android/out/target/product/sdm845/boot.img" >> $name
echo "$1/common/build/ufs/bin/BTFM.bin" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/cmnlib64.mbn" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/cmnlib.mbn" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/devcfg.mbn" >> $name
echo "$1/common/build/ufs/bin/asic/dspso.bin" >> $name
echo "$1/LINUX/android/out/target/product/sdm845/dtbo.img" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/hyp.mbn" >> $name
echo "$1/boot_images/QcomPkg/SDM845Pkg/Bin/845/LA/RELEASE/imagefv.elf" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/keymaster64.mbn" >> $name
echo "$1/boot_images/QcomPkg/Tools/binaries/logfs_ufs_8mb.bin" >> $name
echo "$1/common/build/ufs/bin/asic/NON-HLOS.bin" >> $name
echo "$1/boot_images/QcomPkg/SDM845Pkg/Bin/845/LA/RELEASE/prog_firehose_ddr.elf" >> $name
echo "$1/common/core_qupv3fw/sdm845/rel/1.0/qupv3fw.elf" >> $name
echo "$1/common/sectools/resources/build/fileversion2/sec.dat" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/storsec.mbn" >> $name
echo "$1/trustzone_images/build/ms/bin/WAXAANAA/tz.mbn" >> $name
echo "$1/LINUX/android/out/target/product/sdm845/vbmeta.img" >> $name
echo "$1/boot_images/QcomPkg/SDM845Pkg/Bin/845/LA/RELEASE/xbl_config.elf" >> $name
echo "$1/boot_images/QcomPkg/SDM845Pkg/Bin/845/LA/RELEASE/xbl.elf" >> $name

rm ufs -rf
mkdir ufs
for f in `cat $name`
do
    if [ -f "$f" ]
    then
	echo "copy file $f ..."
	cp $f ./ufs/
    else
	echo "$f is not exit!"
    fi
done

rm $name

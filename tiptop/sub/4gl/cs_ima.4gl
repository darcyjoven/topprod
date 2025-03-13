# Prog. Version..: '5.30.07-13.05.20(00004)'     #
#
# Pattern name...: cs_ima.4gl
# Descriptions...: 生成料号相关函数
# Date & Author..: darcy:2024/05/28
 

database ds

GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"

# 依据分群码产生料号
function cs_ima(p_ima06,p_ima02,p_ima021)
    define p_ima06      like ima_file.ima06,
           p_ima02      like ima_file.ima02,
           p_ima021     like ima_file.ima021
    define l_ima        record like ima_file.*
    define l_ima01      like ima_file.ima01
    define l_no         integer
    #darcy:2024/07/26 mod s---
    # 增加锁
    define l_sql        string

    #let l_sql = "select max(ima01) from ima_file ",
    #            " where ima06 = ? and ima01 like ?||'%'? ",
    #            " for update"
    #declare cs_ima01_cur cursor from l_sql
    #open cs_ima01_cur using p_ima06,p_ima06
    #if sqlca.sqlcode then
    #    close cs_ima01_cur
    #    return ""
    #end if
    #execute cs_ima01_cur into l_ima01
    #if sqlca.sqlcode then
    #    close cs_ima01_cur
    #    return ""
    #end if
    select max(ima01) into l_ima01 from ima_file
     where ima06 = p_ima06 and ima01 like p_ima06||"%"
    #darcy:2024/07/26 mod e--- 
    if cl_null(l_ima01) then
        let l_no = 0
    else
        let l_no = cws_create_asfi514_decode(l_ima01[6,9])
    end if
    let l_no = l_no + 1

    call cs_ima_default(p_ima06) returning l_ima.*
    
    let l_ima.ima01 = sfmt("%1.%2R",p_ima06,cws_create_asfi514_encode(l_no))
    let l_ima.ima02 = p_ima02
    let l_ima.ima021 = p_ima021
    let l_ima.ima06 = p_ima06
 
    insert into ima_file values (l_ima.*)
    if sqlca.sqlcode then
        return ""
    end if    
    return l_ima.ima01
end function

function cs_ima_default(p_ima06)
    define p_ima06      like ima_file.ima06
    define p_ima        record like ima_file.*
    DEFINE
            l_imz02        LIKE imz_file.imz02,
            l_imaacti      LIKE ima_file.imaacti,
            l_imauser      LIKE ima_file.imauser,
            l_imagrup      LIKE ima_file.imagrup,
            l_imamodu      LIKE ima_file.imamodu,
            l_imadate      LIKE ima_file.imadate

    SELECT imz01,imz02,imz03 ,imz04,
           imz07,imz08,imz09,imz10,
           imz11,imz12,imz14,imz15,
           imz17,imz19,imz21,
           imz23,imz24,imz25,imz27,
           imz28,imz31,imz31_fac,imz34,
           imz35,imz36,imz37,imz38,
           imz39,imz42,imz43,imz44,
           imz44_fac,imz45,imz46 ,imz47,
           imz48,imz49,imz491,imz50,
           imz51,imz52,imz54,imz55,
           imz55_fac,imz56,imz561,imz562,
           imz571,
           imz59 ,imz60,imz61,imz62,
           imz63,imz63_fac ,imz64,imz641,
           imz65,imz66,imz67,imz68,
           imz69,imz70,imz71,imz86,
           imz86_fac ,imz87,imz871,imz872,
           imz873,imz874,imz88,imz89,
           imz90,imz94,imz99,imz100 ,
           imz101,imz102 ,imz103,imz105,
           imz106,imz107,imz108,imz109,
           imz110,imz130,imz131,imz132,
           imz133,imz134,
           imz147,imz148,imz903,
           imzacti,imzuser,imzgrup,imzmodu,imzdate,
           imz906,imz907,imz908,imz909,
           imz911,
           imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,   #FUN-A10004
           imz136,imz137,imz391,imz1321,
           imz72,imz153,imz601,  #FUN-910053   #MOD-9C0032 add imz601
           imz926,        #FUN-930108 add imz926
           imz156,imz157,imz158,               #FUN-A80150 add 
           imz022,imz251,imz159,                #FUN-B30092 add  #FUN-B50096 add ima159
           imz163,imz1631                       #FUN-C80094
 
      INTO p_ima.ima06,l_imz02,p_ima.ima03,p_ima.ima04,
           p_ima.ima07,p_ima.ima08,p_ima.ima09,p_ima.ima10,
           p_ima.ima11,p_ima.ima12,p_ima.ima14,p_ima.ima15,
           p_ima.ima17,p_ima.ima19,p_ima.ima21,
           p_ima.ima23,p_ima.ima24,p_ima.ima25,p_ima.ima27, #No:7703 add ima24
           p_ima.ima28,p_ima.ima31,p_ima.ima31_fac,p_ima.ima34,
           p_ima.ima35,p_ima.ima36,p_ima.ima37,p_ima.ima38,
           p_ima.ima39,p_ima.ima42,p_ima.ima43,p_ima.ima44,
           p_ima.ima44_fac,p_ima.ima45,p_ima.ima46,p_ima.ima47,
           p_ima.ima48,p_ima.ima49,p_ima.ima491,p_ima.ima50,
           p_ima.ima51,p_ima.ima52,p_ima.ima54,p_ima.ima55,
           p_ima.ima55_fac,p_ima.ima56,p_ima.ima561,p_ima.ima562,
           p_ima.ima571,
           p_ima.ima59, p_ima.ima60,p_ima.ima61,p_ima.ima62,
           p_ima.ima63, p_ima.ima63_fac,p_ima.ima64,p_ima.ima641,
           p_ima.ima65, p_ima.ima66,p_ima.ima67,p_ima.ima68,
           p_ima.ima69, p_ima.ima70,p_ima.ima71,p_ima.ima86,
           p_ima.ima86_fac, p_ima.ima87,p_ima.ima871,p_ima.ima872,
           p_ima.ima873, p_ima.ima874,p_ima.ima88,p_ima.ima89,
           p_ima.ima90,p_ima.ima94,p_ima.ima99,p_ima.ima100,     #NO:6842養生
           p_ima.ima101,p_ima.ima102,p_ima.ima103,p_ima.ima105,  #NO:6842養生
           p_ima.ima106,p_ima.ima107,p_ima.ima108,p_ima.ima109,  #NO:6842養生
           p_ima.ima110,p_ima.ima130,p_ima.ima131,p_ima.ima132,  #NO:6842養生
           p_ima.ima133,p_ima.ima134,                            #NO:6842養生
           p_ima.ima147,p_ima.ima148,p_ima.ima903,
           l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
           p_ima.ima906,p_ima.ima907,p_ima.ima908,p_ima.ima909,  #FUN-540025
           p_ima.ima911,                                         #FUN-610080 加ima911
           p_ima.ima918,p_ima.ima919,p_ima.ima920,               #FUN-A10004  
           p_ima.ima921,p_ima.ima922,p_ima.ima923,               #FUN-A10004  
           p_ima.ima924,p_ima.ima925,                            #FUN-A10004 
           p_ima.ima136,p_ima.ima137,p_ima.ima391,p_ima.ima1321, #FUN-650004   #FUN-680034
           p_ima.ima915,p_ima.ima153,p_ima.ima601,               #FUN-710060 add #FUN-910053 add ima153 #MOD-9C0032 add ima601
           p_ima.ima926,                                         #FUN-930108 add ima926
           p_ima.ima156,p_ima.ima157,p_ima.ima158,               #FUN-A80150 add
           p_ima.ima022,p_ima.ima251,p_ima.ima159,               #FUN-B30092 add   #FUN-B50096
           p_ima.ima163,p_ima.ima1631                            #FUN-C80094
           FROM  imz_file
           WHERE imz01 = p_ima06

    IF p_ima.ima99 IS NULL THEN LET p_ima.ima99 = 0 END IF
    IF p_ima.ima133 IS NULL THEN LET p_ima.ima133 = p_ima.ima01 END IF
    
    IF g_sma.sma95 = "N" THEN
        LET p_ima.ima918 = "N"
        LET p_ima.ima919 = "N"
        LET p_ima.ima920 = NULL 
        LET p_ima.ima921 = "N"
        LET p_ima.ima922 = "N"
        LET p_ima.ima923 = NULL 
        LET p_ima.ima924 = "N"
        LET p_ima.ima925 = "1" 
    END IF 
    
    IF p_ima.ima01[1,4]='MISC' THEN 
        LET p_ima.ima08='Z'
    END IF
        
    IF cl_null(p_ima.ima159) THEN
        LET p_ima.ima159 = '3'
    END IF 
    IF p_ima.ima918 = 'Y' OR p_ima.ima921 = 'Y' THEN
        IF cl_null(p_ima.ima925) THEN
            LET p_ima.ima925 = '1'
        END IF 
    END IF 

    LET p_ima.ima05  =NULL      #目前使用版本
    LET p_ima.ima18  =0
    LET p_ima.ima16  =99         #NO:6973
    LET p_ima.ima29  =NULL      #最近易動日期
    LET p_ima.ima30  =NULL      #最近盤點日期
    LET p_ima.ima32  =0         #標準售價
    LET p_ima.ima33  =0         #最近售價
    LET p_ima.ima40  =0         #累計使用數量 期間
    LET p_ima.ima41  =0         #累計使用數量 年度
    LET p_ima.ima47  =0         #採購損耗率
    LET p_ima.ima52  =1         #平均訂購量
    LET p_ima.ima140 ='N'       #phase out
    LET p_ima.ima53  =0         #最近採購單價
    LET p_ima.ima531 =0         #市價
    LET p_ima.ima532 =NULL      #市價最近異動日期
    LET p_ima.ima562 =0         #生產損耗率
    LET p_ima.ima73  =NULL      #最近入庫日期
    LET p_ima.ima74  =NULL      #最近出庫日期
    LET p_ima.ima75  =''        #海關編號
    LET p_ima.ima76  =''        #商品類別
    LET p_ima.ima77  =0         #在途量
    LET p_ima.ima78  =0         #在驗量
    LET p_ima.ima80  =0         #未耗預測量
    LET p_ima.ima81  =0         #確認生產量
    LET p_ima.ima82  =0         #計劃量
    LET p_ima.ima83  =0         #MRP需求量
    LET p_ima.ima84  =0         #OM 銷單備置量
    LET p_ima.ima85  =0         #MFP銷單備置量
    LET p_ima.ima881 =NULL      #期間採購最近採購日期
    LET p_ima.ima91  =0         #平均採購單價
    LET p_ima.ima92  ='N'       #net change status
    LET p_ima.ima93  ='NNNNNNNN'#new parts status
    LET p_ima.ima94  =''        #
    LET p_ima.ima95  =0         #
    LET p_ima.ima96  =0         #A. T. P. 量
    LET p_ima.ima97  =0         #MFG 接單量
    LET p_ima.ima98  =0         #OM 接單量
    LET p_ima.ima104 =0         #廠商分配起始量
    LET p_ima.ima901 = g_today  #料件建檔日期
    LET p_ima.ima902 = NULL     #NO:6973
    LET p_ima.ima9021 = NULL    #No.FUN-8C0131
    LET p_ima.ima121 = 0        #單位材料成本
    LET p_ima.ima122 = 0        #單位人工成本
    LET p_ima.ima123 = 0        #單位製造費用
    LET p_ima.ima124 = 0        #單位管銷成本
    LET p_ima.ima125 = 0        #單位成本
    LET p_ima.ima126 = 0        #單位利潤率
    LET p_ima.ima127 = 0        #未稅訂價(本幣)
    LET p_ima.ima128 = 0        #含稅訂價(本幣)
    LET p_ima.ima132 = NULL     #費用科目編號
    LET p_ima.ima133 = NULL     #產品預測料號
    LET p_ima.ima134 = NULL     #主要包裝方式編號
    LET p_ima.ima135 = NULL     #產品條碼編號
    LET p_ima.ima139 = 'N'
    LET p_ima.ima913 = 'N'      #No.MOD-640061
    LET p_ima.ima1010 = '1'                    #FUN-690060
    LET p_ima.imauser=g_user    #資料所有者
    LET p_ima.imagrup=g_grup    #資料所有者所屬群
    LET p_ima.imamodu=NULL      #資料修改日期
    LET p_ima.imadate=g_today   #資料建立日期
    LET p_ima.imaacti='Y'       #有效資料 #FUN-690060

    IF cl_null(p_ima.ima910) THEN LET p_ima.ima910 = ' ' END IF
    IF p_ima.ima926 IS NULL THEN LET p_ima.ima926 = 'N' END IF
    IF cl_null(p_ima.ima022) THEN
        LET p_ima.ima022 = 0
    END IF
    IF cl_null(p_ima.ima156) THEN LET p_ima.ima156 ='N' END IF 
    IF cl_null(p_ima.ima156) THEN LET p_ima.ima156 ='N' END IF  #FUN-A80102
    IF cl_null(p_ima.ima157) THEN LET p_ima.ima157 =' ' END IF  #FUN-A80102
    IF cl_null(p_ima.ima158) THEN LET p_ima.ima158 ='N' END IF  #FUN-A80102
    LET p_ima.ima927='N'
    IF cl_null(p_ima.ima912) THEN LET p_ima.ima912 = 0 END IF   #TQC-B20161
    IF cl_null(p_ima.ima159) THEN LET p_ima.ima159 = '3' END IF #FUN-B90035
    IF cl_null(p_ima.ima928) THEN LET p_ima.ima928 = 'N' END IF #TQC-C20131  add
    IF cl_null(p_ima.ima918) THEN LET p_ima.ima918 = 'N' END IF
    IF cl_null(p_ima.ima919) THEN LET p_ima.ima919 = 'N' END IF
    IF cl_null(p_ima.ima921) THEN LET p_ima.ima921 = 'N' END IF
    IF cl_null(p_ima.ima922) THEN LET p_ima.ima922 = 'N' END IF
    IF cl_null(p_ima.ima924) THEN LET p_ima.ima924 = 'N' END IF
    IF cl_null(p_ima.ima160) THEN LET p_ima.ima160 = 'N' END IF

    LET p_ima.ima915 = 'N'
    LET p_ima.ima916 = ' '
    LET p_ima.ima150 = ' '
    LET p_ima.ima151 = ' '
    LET p_ima.ima152 = ' '
    LET p_ima.ima120 = '1'
    LET p_ima.ima934 = 'Y'

    return p_ima.*
end function

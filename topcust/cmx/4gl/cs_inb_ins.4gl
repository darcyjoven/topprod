# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_inb_ins.4gl
# Descriptions...: 杂收发单身
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值: 
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_ins_inb(p_ina01,p_ima01,p_imd01,p_ime01,p_inb07,p_unit,p_qty,p_reason)
DEFINE l_ret            RECORD
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE p_ina01          LIKE ina_file.ina01
DEFINE p_ima01          LIKE ima_file.ima01
DEFINE p_imd01          LIKE imd_file.imd01
DEFINE p_ime01          LIKE ime_file.ime01
DEFINE p_inb07          LIKE inb_file.inb07
DEFINE p_unit           LIKE inb_file.inb08
DEFINE p_qty            LIKE inb_file.inb09
DEFINE p_reason         LIKE inb_file.inb15
DEFINE l_inb            RECORD LIKE inb_file.*
DEFINE l_ima            RECORD LIKE ima_file.*
DEFINE l_fac            LIKE rvb_file.rvb90_fac
DEFINE l_flag           LIKE type_file.num5

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    IF cl_null(p_ina01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入单号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_ima01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无料件编号！"
        RETURN l_ret.*
    END IF 

    IF cl_null(p_imd01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无仓库编号！"
        RETURN l_ret.*
    END IF 

    INITIALIZE l_inb TO NULL
    LET l_inb.inb01 = p_ina01                    #单号
    SELECT NVL(MAX(inb03),0) + 1                 #项次
      INTO l_inb.inb03
      FROM inb_file
     WHERE inb01 = l_inb.inb01
    LET l_inb.inb04 = p_ima01                    #料号 
    LET l_inb.inb05 = p_imd01                    #仓库
    LET l_inb.inb06 = p_ime01                    #库位
    LET l_inb.inb07 = p_inb07                    #批号

    IF cl_null(l_inb.inb06) THEN 
        LET l_inb.inb06 = ' '
    END IF 
    IF cl_null(l_inb.inb07) THEN 
        LET l_inb.inb07 = ' '
    END IF 

    INITIALIZE l_ima TO NULL
    SELECT * INTO l_ima.* FROM ima_file 
     WHERE ima01 = l_inb.inb04
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = " sel ima_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 
    
    IF cl_null(p_unit) THEN 
        LET l_inb.inb08 = l_ima.ima25
    ELSE 
        LET l_inb.inb08 = p_unit
    END IF 
    CALL s_umfchk(l_inb.inb04,l_inb.inb08,l_ima.ima25)
       RETURNING l_flag,l_fac
    IF l_flag THEN 
        LET l_inb.inb08_fac = 1
    ELSE
        LET l_inb.inb08_fac = l_fac
    END IF 
        
    LET l_inb.inb09 = p_qty
    LET l_inb.inb10 = 'N'
   #LET l_inb.inb11 = 
   #LET l_inb.inb12 = 
    LET l_inb.inb13 = 0
    LET l_inb.inb132= 0
    LET l_inb.inb133= 0
    LET l_inb.inb134= 0
    LET l_inb.inb135= 0
    LET l_inb.inb136= 0
    LET l_inb.inb137= 0
    LET l_inb.inb138= 0
    LET l_inb.inb14 = 0
    LET l_inb.inb15 = p_reason
    LET l_inb.inb16 = p_qty
   #LET l_inb.inb41 = 
   #LET l_inb.inb42 = 
   #LET l_inb.inb43 = 
   #LET l_inb.inb44 = 
   #LET l_inb.inb45 = 
   #LET l_inb.inb46 = 
   #LET l_inb.inb47 = 
   #LET l_inb.inb48 = 
    LET l_inb.inb901= ' '
   #LET l_inb.inb902= 
   #LET l_inb.inb903= 
   #LET l_inb.inb904=
   #LET l_inb.inb905=
   #LET l_inb.inb906=
   #LET l_inb.inb907=
    LET l_inb.inb908= YEAR(g_today)
    LET l_inb.inb909= MONTH(g_today)
  # LET l_inb.inb910=
  # LET l_inb.inb911=
  # LET l_inb.inb912=
    LET l_inb.inb922= l_inb.inb902
    LET l_inb.inb923= l_inb.inb903
    LET l_inb.inb924= l_inb.inb904
    LET l_inb.inb925= l_inb.inb905
    LET l_inb.inb926= l_inb.inb906
    LET l_inb.inb927= l_inb.inb907
   #LET l_inb.inb930= g_plant
    LET l_inb.inbplant= g_plant
    LET l_inb.inblegal= g_legal
   #LET l_inb.inbud01 = 
   #LET l_inb.inbud02 = 
   #LET l_inb.inbud03 = 
   #LET l_inb.inbud04 = 
   #LET l_inb.inbud05 = 
   #LET l_inb.inbud06 = 
   #LET l_inb.inbud07 = 
   #LET l_inb.inbud08 = 
   #LET l_inb.inbud09 = 
   #LET l_inb.inbud10 = 
   #LET l_inb.inbud11 = 
   #LET l_inb.inbud12 = 
   #LET l_inb.inbud13 = 
   #LET l_inb.inbud14 = 
   #LET l_inb.inbud15 = 
     
    INSERT INTO inb_file VALUES(l_inb.*)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "ins inb_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
    ELSE 
        LET l_ret.code = l_inb.inb03
    END IF 

    RETURN l_ret.*
END FUNCTION 


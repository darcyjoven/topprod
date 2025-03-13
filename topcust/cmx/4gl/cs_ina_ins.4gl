# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_ina_ins.4gl
# Descriptions...: 条码基本资料
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功，则msg为单号

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"


FUNCTION cs_ins_ina(p_ina01,p_user,p_doc,p_ina00)
DEFINE p_ina01          LIKE ina_file.ina01
DEFINE p_user           LIKE gen_file.gen01
DEFINE p_doc            LIKE ina_file.ina01
DEFINE p_ina00          LIKE ina_file.ina00
DEFINE l_ret            RECORD 
              success   LIKE type_file.chr1,
              code      LIKE type_file.chr10,
              msg       STRING
                        END RECORD
DEFINE l_ina            RECORD LIKE ina_file.*
DEFINE l_user           LIKE gen_file.gen01
DEFINE l_grup           LIKE gem_file.gem01
DEFINE li_result        LIKE type_file.num5

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'

    INITIALIZE l_user TO NULL 
    INITIALIZE l_grup TO NULL 
    LET l_user = p_user
    SELECT gen03 INTO l_grup FROM gen_file 
     WHERE gen01 = l_user
    
    INITIALIZE l_ina TO NULL 
    LET l_ina.ina00 = p_ina00                    #单据类型   
    IF cl_null(p_ina01) THEN     
        LET l_ina.ina01 = 'IT01'                 #单据单号     未取号前为单别
    END IF 
    LET l_ina.ina02 = g_today                    #扣账日期
    LET l_ina.ina03 = g_today                    #录入日期
    LET l_ina.ina11 = l_user                     #申请人
    LET l_ina.ina04 = l_grup                     #部门编号
   #LET l_ina.ina05 = ''                         #No Use
    LET l_ina.ina06 = ''                         #项目编号
    LET l_ina.ina07 = ''                         #备注
   #LET l_ina.ina08 =                            #No Use
   #LET l_ina.ina09 =                            #No Use
   #LET l_ina.ina10 =                            #工单单号
    LET l_ina.inaprsw = 0                        #打印次数
    LET l_ina.inapost = 'N'                      #过账码
    LET l_ina.inauser = l_user                   #资料所有者
    LET l_ina.inagrup = l_grup                   #资料所有部门
   #LET l_ina.inamodu =                          #资料更改者
   #LET l_ina.inadate =                          #最近修改日
    LET l_ina.inamksg = 'N'                      #签核否
   #LET l_ina.ina1001 =                          #客户编号
   #LET l_ina.ina1003 =                          #送货客户
   #LET l_ina.ina1002 =                          #账款客户
   #LET l_ina.ina1004 =                          #收款客户
   #LET l_ina.ina1005 =                          #地址码
   #LET l_ina.ina1006 = 
   #LET l_ina.ina1007 = 
   #LET l_ina.ina1008 = 
   #LET l_ina.ina1009 = 
   #LET l_ina.ina1010 = 
   #LET l_ina.ina1011 = 
   #LET l_ina.ina1012 = 
   #LET l_ina.ina1013 =
   #LET l_ina.ina1014 = 
   #LET l_ina.ina1015 = 
   #LET l_ina.ina1016 =
   #LET l_ina.ina1017 =
   #LET l_ina.ina1018 =
   #LET l_ina.ina1019 =
   #LET l_ina.ina1020 =
   #LET l_ina.ina1021 =
   #LET l_ina.ina1022 =
   #LET l_ina.ina1023 =
   #LET l_ina.ina1024 =
   #LET l_ina.ina1025 =
    LET l_ina.inaconf = 'N'                      #确认码
    LET l_ina.inaspc  = '0'
   #LET l_ina.ina100  = 
   #LET l_ina.ina101  =
   #LET l_ina.ina102  =
   #LET l_ina.ina103  = ''                       #VMI发/退料单号
    LET l_ina.ina12   = 'N'                      #
   #LET l_ina.inacond =                          #审核日期
   #LET l_ina.inacont =                          #审核时间
   #LET l_ina.inaconu =                          #审核人员
    LET l_ina.inapos  = '1'                      #已传POS否
    LET l_ina.inaplant= g_plant                  #所属营运中心
    LET l_ina.inalegal= g_legal                  #所属法人
    LET l_ina.inaoriu = l_user                   #资料建立者
    LET l_ina.inaorig = l_grup                   #资料建立部门
    LET l_ina.ina13   = ''                       #POS单号
    CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,"1","ina_file","ina01","","","")
         RETURNING li_result,l_ina.ina01
    IF (NOT li_result) THEN
        LET l_ret.success = 'N'
        RETURN l_ret.*
    END IF

    INSERT INTO ina_file VALUES(l_ina.*) 
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "ins ina_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
    ELSE 
        LET l_ret.msg = l_ina.ina01
    END IF 

    RETURN l_ret.*

END FUNCTION 




# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: bzmp002.4gl
# Descriptions...: 条码扫描处理后台程序
# Date & Author..: 16/01/01  By  LGe
# Note           : 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

#################################################
#模组变量
#################################################
DEFINE g_sql            STRING
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_type           LIKE type_file.chr2
DEFINE g_cmd            STRING

MAIN

    OPTIONS                               #改變一些系統預設值
       FORM LINE       FIRST + 2,         #畫面開始的位置
       MESSAGE LINE    LAST,              #訊息顯示的位置
       PROMPT LINE     LAST,              #提示訊息的位置
       INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

    LET g_type = ARG_VAL(1)               #取外部参数,该参数用来控制本次操作用于什么类型
    
    IF (NOT cl_user()) THEN               #抓取部分參數(g_prog,g_user...)
       EXIT PROGRAM                       #切換成使用者預設的營運中心
    END IF

  # DISPLAY ''
  # DISPLAY '**********************************************************************'
  # DISPLAY 'ARG_VAL:',g_type
  # DISPLAY '**********************************************************************'
  # EXIT PROGRAM                       #切換成使用者預設的營運中心

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CMX")) THEN         #抓取權限共用變數及模組變數(g_aza.*...)
       EXIT PROGRAM                       #判斷使用者執行程式權限
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_bgjob = 'Y'

    CALL p200_deal()
    
    CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN


#批次处理
FUNCTION p200_deal()
DEFINE l_tc_zmx02       LIKE type_file.chr10

    INITIALIZE g_cnt TO NULL 
    INITIALIZE g_sql TO NULL 

    LET g_sql = "UPDATE tc_zmx_file SET tc_zmx04 = ?,tc_zmx05 = ?,tc_zmx06 = ?,tc_zmx08 = sysdate,tc_zmx10 = nvl(tc_zmx10,0)+1,tc_zmx15 = ? ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = ? ",
                "   AND tc_zmx03 = ? "
    PREPARE p200_upd_tc_zmx_prep FROM g_sql
                
             
    
    LET g_sql = "SELECT DISTINCT tc_zmx02 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx04 = '0' ",
                "   AND nvl(tc_zmx10,0)<=4 "
    IF NOT cl_null(g_type) THEN 
        LET g_sql = g_sql," AND tc_zmx02 = '",g_type CLIPPED,"'"
    END IF 
    LET g_sql =  g_sql," ORDER BY tc_zmx02"
    DECLARE p200_tc_zmx02_cs CURSOR WITH HOLD FROM g_sql
    
    INITIALIZE l_tc_zmx02 TO NULL
    FOREACH p200_tc_zmx02_cs INTO l_tc_zmx02
    
    
        CASE 
            WHEN l_tc_zmx02 = '11'   #收货单
                CALL p200_rva()
            WHEN l_tc_zmx02 = '13' OR l_tc_zmx02 = '14'   #13 入库单   14 仓退
                CALL p200_rvu(l_tc_zmx02)
            WHEN l_tc_zmx02 = '15' OR l_tc_zmx02 = '16'   #15 发料单  16 退料   19 倒扣料 OR l_tc_zmx02='19'
                CALL p200_sfp(l_tc_zmx02)
#            WHEN l_tc_zmx02 = '17'                        #17 超领
#                CALL p200_sfp_cl(l_tc_zmx02)            
#            WHEN l_tc_zmx02 = '18'                        #18  倒扣
#                CALL p200_sfu_dk()
            WHEN l_tc_zmx02 = '20'                        #20 调拨单
                CALL p200_imm()
            WHEN l_tc_zmx02 = '23' OR l_tc_zmx02 = '24'  #23 杂收单  24 杂发
                CALL p200_ina(l_tc_zmx02)
            WHEN l_tc_zmx02 = '25'   #工单入库单
                CALL p200_sfu()
#           # WHEN l_tc_zmx02 = '34'   #报工单
            WHEN l_tc_zmx02 = '40'   #出货单
                CALL p200_oga()
#            WHEN l_tc_zmx02 = '41'   #销退单
#                CALL p200_oha()  
            
        END CASE 
    
    
    END FOREACH    

   #No.17102301--begin--
    #CALL p200_sfu()
    #CALL p200_sfp('15')
    #CALL p200_ina('23')
    #CALL p200_ina('24')
    #CALL p200_imm()
    #CALL p200_sfu()
    
   #No.17102301---end---

    IF g_type = '99' THEN 
    #   CALL p200_sfp_conf()
    END IF


END FUNCTION 

#收货单处理
FUNCTION p200_rva()
DEFINE l_rva01          LIKE rva_file.rva01
DEFINE l_rva10          LIKE rva_file.rva10
DEFINE l_rvaconf        LIKE rva_file.rvaconf 
DEFINE l_prog           LIKE type_file.chr10
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD

    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '11' ",
                "   AND tc_zmx04 = '0'  ",
                "   AND nvl(tc_zmx10,0)<=4  "
    DECLARE p200_rva_cs CURSOR WITH HOLD FROM g_sql

    INITIALIZE l_rva01 TO NULL
    FOREACH p200_rva_cs INTO l_rva01

        SELECT rva10,rvaconf INTO l_rva10,l_rvaconf FROM rva_file 
         WHERE rva01 = l_rva01   
        IF l_rvaconf = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','N','','11',l_rva01
            CONTINUE FOREACH
        END IF 
        IF l_rvaconf = 'X' OR cl_null(l_rvaconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','','11',l_rva01
            CONTINUE FOREACH
        END IF 

        CASE l_rva10
           WHEN "SUB"
              LET l_prog = 'apmt200'
           WHEN "TAP"
              LET l_prog = 'apmt300'
           OTHERWISE
              LET l_prog = 'apmt110'
        END CASE
        LET g_cmd=l_prog," '",l_rva01 CLIPPED,"' ' ' '1'"
        CALL cl_cmdrun_wait(g_cmd)
        SELECT rvaconf INTO l_rvaconf FROM rva_file 
         WHERE rva01 = l_rva01
        IF l_rvaconf = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','N','','11',l_rva01
            ELSE 
            EXECUTE p200_upd_tc_zmx_prep USING '0','N','N','','11',l_rva01
        END IF 
    END FOREACH
  
   #追加记录

END FUNCTION

FUNCTION p200_rvu(p_tc_zmx02)
DEFINE l_rvu00          LIKE rvu_file.rvu00
DEFINE l_rvu01          LIKE rvu_file.rvu01
DEFINE l_rvu08          LIKE rvu_file.rvu08
DEFINE l_rvuconf        LIKE rvu_file.rvuconf
DEFINE l_prog           LIKE type_file.chr10
DEFINE p_tc_zmx02       LIKE type_file.chr10
DEFINE l_sql            STRING  


    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '",p_tc_zmx02 CLIPPED,"'",
                "   AND tc_zmx04 = '0'  ",
                "   AND nvl(tc_zmx10,0)<=4 "

    DECLARE p200_rvu_cs CURSOR WITH HOLD FROM g_sql

    INITIALIZE l_rvu01 TO NULL
    FOREACH p200_rvu_cs INTO l_rvu01

        SELECT rvu00,rvu08,rvuconf INTO l_rvu00,l_rvu08,l_rvuconf FROM rvu_file 
         WHERE rvu01 = l_rvu01
        IF l_rvuconf = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','N','',p_tc_zmx02,l_rvu01
            CONTINUE FOREACH
        END IF 

        IF l_rvuconf = 'X' OR cl_null(l_rvuconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','',p_tc_zmx02,l_rvu01
            CONTINUE FOREACH
        END IF 

        CASE l_rvu00
          WHEN "1"  #1:入庫
             CASE l_rvu08
                WHEN "SUB"
                   LET l_prog="apmt730"
                WHEN "TAP"
                   LET l_prog="apmt740"
                OTHERWISE
                   LET l_prog="apmt720"
             END CASE
          WHEN "2"  #2:驗退
             CASE l_rvu08
                WHEN "SUB"
                   LET l_prog="apmt731"
                WHEN "TAP"
                   LET l_prog="apmt741"
                OTHERWISE
                   LET l_prog="apmt721"
             END CASE
          WHEN "3"  #3:倉退
             CASE l_rvu08
                WHEN "SUB"
                   LET l_prog="apmt732"
                WHEN "TAP"
                   LET l_prog="apmt742"
                OTHERWISE
                   LET l_prog="apmt722"
             END CASE
        END CASE
        LET g_cmd=l_prog," '",l_rvu01 CLIPPED,"' '' '' '6'"
        DISPLAY "run ",g_cmd 
        CALL cl_cmdrun_wait(g_cmd)
        INITIALIZE l_rvuconf TO NULL
        SELECT rvuconf INTO l_rvuconf FROM rvu_file 
         WHERE rvu01 = l_rvu01
        IF l_rvuconf = 'Y' THEN 
             EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','',p_tc_zmx02,l_rvu01
             ELSE 
             EXECUTE p200_upd_tc_zmx_prep USING '0','N','N','',p_tc_zmx02,l_rvu01
        END IF 
    END FOREACH

END FUNCTION


FUNCTION p200_ina(p_tc_zmx02)
DEFINE l_ina00          LIKE ina_file.ina00
DEFINE l_ina01          LIKE ina_file.ina01
DEFINE l_inaconf        LIKE ina_file.inaconf 
DEFINE l_inapost        LIKE ina_file.inapost
DEFINE l_prog           LIKE type_file.chr10
DEFINE p_tc_zmx02       LIKE type_file.chr10


    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '",p_tc_zmx02 CLIPPED,"'",
                "   AND tc_zmx04 = '0'  ",
                "   AND nvl(tc_zmx10,0)<=4 "
    DECLARE p200_ina_cs CURSOR WITH HOLD FROM g_sql

    INITIALIZE l_ina01 TO NULL
    FOREACH p200_ina_cs INTO l_ina01

        DISPLAY 'doc:',l_ina01

        SELECT ina00,inaconf,inapost INTO l_ina00,l_inaconf,l_inapost FROM ina_file 
         WHERE ina01 = l_ina01
        IF l_inapost ='Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','',p_tc_zmx02,l_ina01
            CONTINUE FOREACH
        END IF  
        IF l_inaconf='X'  OR cl_null(l_inaconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','',p_tc_zmx02,l_ina01
            CONTINUE FOREACH
        END IF  

        LET l_prog = 'aimt370'

        LET g_cmd=l_prog," '",l_ina00,"' '",l_ina01 CLIPPED,"' 'stock_post' '' 'Y'"
        DISPLAY 'g_cmd:',g_cmd
         CALL cl_cmdrun_wait(g_cmd)
        INITIALIZE l_inaconf TO NULL 
        INITIALIZE l_inapost TO NULL
        SELECT inaconf,inapost INTO l_inaconf,l_inapost FROM ina_file 
         WHERE ina01 = l_ina01
        IF l_inapost = 'Y' THEN
            DISPLAY '单号：',l_ina01 clipped ,'过账成功'
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','',p_tc_zmx02,l_ina01
        ELSE 
            EXECUTE p200_upd_tc_zmx_prep USING '0',l_inaconf,'N','',p_tc_zmx02,l_ina01
            DISPLAY '单号：',l_ina01 clipped ,'过账失败'
        END IF 


    END FOREACH


END FUNCTION

FUNCTION p200_sfu()
DEFINE l_sfu01          LIKE sfu_file.sfu01
DEFINE l_sfuconf        LIKE sfu_file.sfuconf
DEFINE l_sfupost        LIKE sfu_file.sfupost
DEFINE l_prog           LIKE type_file.chr10

    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '25' ",
                "   AND tc_zmx04 = '0'  ",
                "   AND nvl(tc_zmx10,0)<=4  "
    DECLARE p200_sfu_cs CURSOR WITH HOLD FROM g_sql

    INITIALIZE l_sfu01 TO NULL
    FOREACH p200_sfu_cs INTO l_sfu01

        SELECT sfuconf,sfupost INTO l_sfuconf,l_sfupost FROM sfu_file 
         WHERE sfu01 = l_sfu01
        IF l_sfupost = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','25',l_sfu01
            CONTINUE FOREACH
        END IF 

        IF l_sfuconf = 'X' OR cl_null(l_sfuconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','Y',' XXXX ','25',l_sfu01
            CONTINUE FOREACH
        END IF 
        LET l_prog = 'asft623'
        LET g_cmd=l_prog," '",l_sfu01 CLIPPED,"' 'stock_post' 'Y'"
        CALL cl_cmdrun_wait(g_cmd)

        SELECT sfupost,sfuconf INTO l_sfupost,l_sfuconf FROM sfu_file 
         WHERE sfu01 = l_sfu01
        IF l_sfupost = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','25',l_sfu01
            ELSE 
            EXECUTE p200_upd_tc_zmx_prep USING '0',l_sfuconf,'N','','25',l_sfu01
        END IF

    END FOREACH

END FUNCTION

FUNCTION p200_imm()
DEFINE l_imm01          LIKE imm_file.imm01
DEFINE l_immconf        LIKE imm_file.immconf 
DEFINE l_imm03          LIKE imm_file.imm03
DEFINE l_prog           LIKE type_file.chr10
DEFINE l_chr            LIKE type_file.chr1

    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '20' ",
                "   AND tc_zmx04 = '0'  ",
                "   AND nvl(tc_zmx10,0)<=4 "

    DECLARE p200_imm_cs CURSOR  WITH HOLD FROM g_sql

    INITIALIZE l_imm01 TO NULL
    FOREACH p200_imm_cs INTO l_imm01

        SELECT immconf,imm03 INTO l_immconf,l_imm03 FROM imm_file 
         WHERE imm01 = l_imm01
        IF l_imm03 = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','20',l_imm01
            CONTINUE FOREACH
        END IF 

        IF l_immconf = 'X'  OR cl_null(l_immconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','','20',l_imm01
            CONTINUE FOREACH
        END IF 

       #//有问题，画面会弹出来输入调拨日期，要调整一下
        INITIALIZE l_chr TO NULL
        IF l_immconf = 'N' AND l_imm03 = 'N' THEN 
            LET l_chr = 'M'
        END IF 
        IF l_immconf = 'Y' AND l_imm03 = 'N' THEN 
            LET l_chr = 'A'
        END IF 

        UPDATE imm_file SET imm17 = g_today
         WHERE imm01 = l_imm01
       
        LET g_cmd="aimt324 '",l_imm01,"' '' '",l_chr CLIPPED,"' '' 'Y'"
        CALL cl_cmdrun_wait(g_cmd)  

        SELECT imm03,immconf INTO l_imm03,l_immconf FROM imm_file 
         WHERE imm01 = l_imm01
        IF l_imm03 = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','20',l_imm01
            ELSE 
            EXECUTE p200_upd_tc_zmx_prep USING '0',l_immconf,'N','','20',l_imm01
        END IF 

    END FOREACH

END FUNCTION 



FUNCTION p200_sfp(p_tc_zmx02)
DEFINE l_sfp01          LIKE sfp_file.sfp01
DEFINE l_sfp            RECORD LIKE sfp_file.*
DEFINE l_prog           LIKE type_file.chr10
DEFINE l_cmd            LIKE type_file.chr1000
DEFINE p_tc_zmx02       LIKE type_file.chr10
DEFINE l_chr            LIKE type_file.chr1


    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '",p_tc_zmx02 CLIPPED,"'",
                "   AND tc_zmx04 = '0' ",
                "   AND nvl(tc_zmx10,0)<=4 "
                

    DECLARE p200_sfp_cs CURSOR WITH HOLD FROM g_sql

    IF p_tc_zmx02 = '15' OR p_tc_zmx02='19' THEN 
        LET l_chr = '1'
    END IF 

    IF p_tc_zmx02 = '16' THEN 
        LET l_chr = '2'
    END IF 

    INITIALIZE l_sfp01 TO NULL
    FOREACH p200_sfp_cs INTO l_sfp01

        LET g_success = 'Y'
        INITIALIZE l_sfp TO NULL
        SELECT * INTO l_sfp.* FROM sfp_file 
         WHERE sfp01 = l_sfp01
        IF l_sfp.sfp04 = 'Y' THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','',p_tc_zmx02,l_sfp01
            CONTINUE FOREACH 
        END IF 

        IF l_sfp.sfpconf  = 'X' OR cl_null(l_sfp.sfpconf) THEN 
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','',p_tc_zmx02,l_sfp01
            CONTINUE FOREACH 
        END IF 

        IF l_sfp.sfpconf = 'N' THEN 
            CALL i501sub_y_chk(l_sfp.sfp01,NULL)   
           #CALL i501sub_y_chk(l_sfp.sfp01)   
            IF g_success = "Y" THEN
                BEGIN WORK
                CALL i501sub_y_upd(l_sfp.sfp01,NULL,TRUE)  #FUN-840012
                    RETURNING l_sfp.*
                IF l_sfp.sfpconf = 'Y' THEN 
                    COMMIT WORK
                ELSE 
                    ROLLBACK WORK
                    CONTINUE FOREACH
                END IF 
            END IF 
        END IF 
        CASE l_sfp.sfp06
          WHEN "1" LET l_prog='asfi511'
          WHEN "2" LET l_prog='asfi512'
          WHEN "3" LET l_prog='asfi513'
          WHEN "4" LET l_prog='asfi514'
          WHEN "6" LET l_prog='asfi526'
          WHEN "7" LET l_prog='asfi527'
          WHEN "8" LET l_prog='asfi528'
          WHEN "9" LET l_prog='asfi529'
          WHEN "D" LET l_prog='asfi519'                    #FUN-C70014
       END CASE

       IF g_success = "Y" THEN
          LET l_cmd = g_prog 
          LET g_prog= l_prog 
         #CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')  #FUN-840012
          CALL i501sub_s(l_chr,l_sfp.sfp01,FALSE,'N')  #FUN-840012
          LET g_prog= l_cmd
       END IF
       SELECT * INTO l_sfp.* FROM sfp_file 
        WHERE sfp01 = l_sfp01
       IF l_sfp.sfp04 = 'Y' THEN
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','',p_tc_zmx02,l_sfp01
            ELSE 
            EXECUTE p200_upd_tc_zmx_prep USING '0',l_sfp.sfpconf,'N','',p_tc_zmx02,l_sfp01
       END IF 
      #COMMIT WORK
    END FOREACH


END FUNCTION 
#
#
#
#FUNCTION p200_sfp_cl(p_tc_zmx02)
#DEFINE l_sfp01          LIKE sfp_file.sfp01
#DEFINE l_sfp            RECORD LIKE sfp_file.*
#DEFINE l_prog           LIKE type_file.chr10
#DEFINE l_cmd            LIKE type_file.chr1000
#DEFINE p_tc_zmx02       LIKE type_file.chr10
#DEFINE l_chr            LIKE type_file.chr1
#
#    LET g_sql = "insert into tc_zmx_file ",
#                " select 'HY','17',SOURCE_CODE,'0','N','N',to_date(to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'YYYY/MM/DD HH24:Mi:SS'),'','','','','','','',''   FROM ZMSCM.VIEW_SCM_SCCL  ",
#                " WHERE SOURCE_CODE NOT IN (SELECT tc_zmx03 FROM tc_zmx_file where TC_ZMX02='17')"
#    DISPLAY " p200_pre_sccl sql :",g_sql 
#    PREPARE p200_pre_sccl FROM g_sql 
#    EXECUTE p200_pre_sccl 
#
#    
#    
#    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM ",g_zmxdb CLIPPED,".tc_zmx_file ",
#                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
#                "   AND tc_zmx02 = '",p_tc_zmx02 CLIPPED,"'",
#                "   AND tc_zmx04 = '0'  ",
#                "   AND (tc_zmx05 = 'N' OR tc_zmx06 = 'N') "
#                
#
#   # LET g_sql = "select sfp01 from sfp_file where sfpud01 IS NOT NULL AND sfp02 >=to_date('191003','yymmdd') AND sfpconf <> 'X' AND sfp04 <>'Y'"
#    #DECLARE p200_sfp_cs CURSOR FOR
#        
#    DECLARE p200_sfp_cscl CURSOR WITH HOLD FROM g_sql
#
#    IF p_tc_zmx02 = '17' THEN 
#        LET l_chr = '1'
#    END IF 
#    
#    INITIALIZE l_sfp01 TO NULL
#    FOREACH p200_sfp_cscl INTO l_sfp01
#
#        LET g_success = 'Y'
#        INITIALIZE l_sfp TO NULL
#        SELECT * INTO l_sfp.* FROM sfp_file 
#         WHERE sfp01 = l_sfp01
#        IF l_sfp.sfp04 = 'Y' THEN 
#            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,'',p_tc_zmx02,l_sfp01
#            CONTINUE FOREACH 
#        END IF 
#        IF l_sfp.sfpconf = 'X' OR cl_null(l_sfp.sfpconf) THEN
#            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X',g_today,'',p_tc_zmx02,l_sfp01
#            CONTINUE FOREACH 
#        END IF 
#
#        IF l_sfp.sfpconf = 'N' THEN 
#            CALL i501sub_y_chk(l_sfp.sfp01,NULL)   
#           #CALL i501sub_y_chk(l_sfp.sfp01)   
#            IF g_success = "Y" THEN
#                BEGIN WORK
#                CALL i501sub_y_upd(l_sfp.sfp01,NULL,TRUE)  #FUN-840012
#                    RETURNING l_sfp.*
#                IF l_sfp.sfpconf = 'Y' THEN 
#                    COMMIT WORK
#                ELSE 
#                    ROLLBACK WORK
#                    CONTINUE FOREACH
#                END IF 
#            END IF 
#        END IF 
#        CASE l_sfp.sfp06
#          WHEN "1" LET l_prog='asfi511'
#          WHEN "2" LET l_prog='asfi512'
#          WHEN "3" LET l_prog='asfi513'
#          WHEN "4" LET l_prog='asfi514'
#          WHEN "6" LET l_prog='asfi526'
#          WHEN "7" LET l_prog='asfi527'
#          WHEN "8" LET l_prog='asfi528'
#          WHEN "9" LET l_prog='asfi529'
#          WHEN "D" LET l_prog='asfi519'                    #FUN-C70014
#       END CASE
#
#       IF g_success = "Y" THEN
#          LET l_cmd = g_prog 
#          LET g_prog= l_prog 
#         #CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')  #FUN-840012
#          CALL i501sub_s(l_chr,l_sfp.sfp01,FALSE,'N')  #FUN-840012
#          LET g_prog= l_cmd
#       END IF
#       SELECT * INTO l_sfp.* FROM sfp_file 
#        WHERE sfp01 = l_sfp01
#       IF l_sfp.sfp04 = 'Y' THEN
#            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,'',p_tc_zmx02,l_sfp01
#      #ELSE 
#      #    ROLLBACK WORK 
#      #    CONTINUE FOREACH
#       END IF 
#      #COMMIT WORK
#    END FOREACH
#    DISPLAY "-------------------------------p200_sfp_cl --end -------------------------------"
#
#END FUNCTION 

FUNCTION p200_oga()
DEFINE l_oga01          LIKE oga_file.oga01
DEFINE l_oga09          LIKE oga_file.oga09
DEFINE l_ogaconf        LIKE oga_file.ogaconf
DEFINE l_ogapost        LIKE oga_file.ogapost
DEFINE l_prog           LIKE type_file.chr10



    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM tc_zmx_file ",
                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
                "   AND tc_zmx02 = '40' ",
                "   AND tc_zmx04 = '0'  ",
                "   AND tc_zmx05 = 'N'  "
    DECLARE p200_oga_cs CURSOR WITH HOLD FROM g_sql

    INITIALIZE l_oga01 TO NULL
    FOREACH p200_oga_cs INTO l_oga01

        SELECT oga09,ogaconf,ogapost INTO l_oga09,l_ogaconf,l_ogapost FROM oga_file 
         WHERE oga01 = l_oga01

        IF l_ogapost = 'Y' THEN
            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','40',l_oga01
            CONTINUE FOREACH
        END IF 

        IF l_ogaconf = 'X' OR cl_null(l_ogaconf) THEN
            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X','','40',l_oga01
            CONTINUE FOREACH
        END IF

        IF l_oga09 MATCHES '[246]' THEN
            IF l_oga09 = '2' THEN 
                LET g_cmd="axmt620 '",l_oga01 CLIPPED,"' 'M' 'Y'"
                CALL cl_cmdrun_wait(g_cmd)
            ELSE 
                IF l_oga09 = '4' THEN
                     LET g_cmd="axmt820 '",l_oga01 CLIPPED,"' 'M' 'Y'"
                     CALL cl_cmdrun_wait(g_cmd)
                ELSE 
                     LET g_cmd="axmt821 '",l_oga01 CLIPPED,"' 'M' 'Y'"
                     CALL cl_cmdrun_wait(g_cmd)
                END IF
            END IF 
        ELSE 
            IF l_oga09 = '3' THEN 
               LET g_cmd="axmt650 '",l_oga01 CLIPPED,"' 'M' 'Y'"
               CALL cl_cmdrun_wait(g_cmd)
            END IF 
        END IF 

        SELECT ogaconf,ogapost INTO l_ogaconf,l_ogapost FROM oga_file 
         WHERE oga01 = l_oga01
        IF l_ogapost = 'Y' THEN 
             EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y','','40',l_oga01
             ELSE 
             EXECUTE p200_upd_tc_zmx_prep USING '0',l_ogaconf,'N','','40',l_oga01
        END IF 

    END FOREACH


END FUNCTION
#
#
#FUNCTION p200_iqc_conf()
#DEFINE l_sql            STRING
#DEFINE l_qcs01          LIKE qcs_file.qcs01
#DEFINE l_qcs02          LIKE qcs_file.qcs02
#DEFINE l_qcs05          LIKE qcs_file.qcs05
#DEFINE l_cnt            LIKE type_file.num5
#
#
#   #IF g_plant <> 'HYT' THEN 
#   #    RETURN
#   #END IF 
#
#    INITIALIZE l_sql TO NULL 
#       
#    INITIALIZE l_qcs01 TO NULL 
#    INITIALIZE l_qcs02 TO NULL
#    INITIALIZE l_qcs05 TO NULL
#    LET l_sql = "SELECT qcs01,qcs02,qcs05 FROM qcs_file ",
#                " WHERE qcs00 = '1' ",
#                "   AND qcs14 = 'N' ",
#                "   AND qcs04 >= to_date('17/10/01','yy/mm/dd')"
#    DECLARE p200_iqc_cs CURSOR FROM l_sql
#    FOREACH p200_iqc_cs INTO l_qcs01,l_qcs02,l_qcs05
#        
#        INITIALIZE l_cnt TO NULL 
#        SELECT COUNT(*) INTO l_cnt FROM rvb_file 
#         WHERE rvb01 = l_qcs01
#           AND rvb02 = l_qcs02
#        IF SQLCA.SQLCODE THEN
#            LET l_cnt = 0
#        END IF 
#        IF l_cnt = 0 THEN 
#            CONTINUE FOREACH
#        END IF 
#
#        UPDATE qcs_file SET qcs14 = 'Y',
#                            qcs15 = g_today
#         WHERE qcs01 = l_qcs01
#           AND qcs02 = l_qcs02
#           AND qcs05 = l_qcs05
#   
#    END FOREACH
#
#
#END FUNCTION 
#
#FUNCTION p200_oha()
#DEFINE l_oha01          LIKE oha_file.oha01
#DEFINE l_oha09          LIKE oha_file.oha09
#DEFINE l_ohaconf        LIKE oha_file.ohaconf
#DEFINE l_ohapost        LIKE oha_file.ohapost
#DEFINE l_prog           LIKE type_file.chr10
#
#    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM ",g_zmxdb CLIPPED,".tc_zmx_file ",
#                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
#                "   AND tc_zmx02 = '41' ",
#                "   AND tc_zmx04 = '0'  ",
#                "   AND tc_zmx05 = 'N'  "
#    DECLARE p200_oha_cs CURSOR WITH HOLD FROM g_sql
#
#    INITIALIZE l_oha01 TO NULL
#    FOREACH p200_oha_cs INTO l_oha01
#
#        SELECT oha09,ohaconf,ohapost INTO l_oha09,l_ohaconf,l_ohapost FROM oha_file 
#         WHERE oha01 = l_oha01
#
#        IF l_ohapost = 'Y' THEN
#            EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,'','41',l_oha01
#            CONTINUE FOREACH
#        END IF 
#
#        IF l_ohaconf = 'X' OR cl_null(l_ohaconf) THEN
#            EXECUTE p200_upd_tc_zmx_prep USING '1','X','X',g_today,'','41',l_oha01
#            CONTINUE FOREACH
#        END IF 
#
#       #IF l_oha09 MATCHES '[246]' THEN
#       #    IF l_oga09 = '2' THEN 
#       #        LET g_cmd="axmt620 '",l_oga01 CLIPPED,"' 'M' 'Y'"
#       #        CALL cl_cmdrun_wait(g_cmd)
#       #    ELSE 
#       #        IF l_oga09 = '4' THEN
#       #             LET g_cmd="axmt820 '",l_oga01 CLIPPED,"' 'M' 'Y'"
#       #             CALL cl_cmdrun_wait(g_cmd)
#       #        ELSE 
#       #             LET g_cmd="axmt821 '",l_oga01 CLIPPED,"' 'M' 'Y'"
#       #             CALL cl_cmdrun_wait(g_cmd)
#       #        END IF
#       #    END IF 
#       #ELSE 
#       #    IF l_oga09 = '3' THEN 
#       #       #CALL t650sub_s('2',l_oga01)
#       #    END IF 
#       #END IF 
#
#       #IF g_plant = 'HYT' THEN 
#            LET g_cmd = "axmt700 '",l_oha01 CLIPPED,"' 'M' 'Y'"
#            CALL cl_cmdrun_wait(g_cmd)
#       #END IF 
#
#        SELECT ohaconf,ohapost INTO l_ohaconf,l_ohapost FROM oha_file 
#         WHERE oha01 = l_oha01
#        IF l_ohapost = 'Y' THEN 
#             EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,'','40',l_oha01
#        END IF 
#
#    END FOREACH
#
#
#END FUNCTION
#
#
#FUNCTION p200_sfp_conf()
#DEFINE l_sfp            RECORD LIKE sfp_file.*
#DEFINE l_sql            STRING 
#DEFINE l_gen02          LIKE gen_file.gen02
#DEFINE l_ac             LIKE type_file.num10
#DEFINE l_prog           LIKE type_file.chr10
#DEFINE l_cmd            LIKE type_file.chr1000
#
#    INITIALIZE l_sql TO NULL
#    LET l_sql = "SELECT * FROM sfp_file ",
#                " WHERE sfpconf = 'N'",
#                "   AND sfp06 IN ('1')",
#                "   AND sfp02 >= to_date('17/11/01','yy/mm/dd')",
#                "   AND sfpud05 IS NOT NULL"
#    DECLARE p200_sfp_conf_cs CURSOR WITH HOLD FROM l_sql
#
#
#    INITIALIZE l_sfp TO NULL
#    CALL g_sfp_data.clear()
#    FOREACH p200_sfp_conf_cs INTO l_sfp.*
#
#        IF l_sfp.sfpconf = 'Y' THEN 
#            CONTINUE FOREACH
#        END IF 
#
#        BEGIN WORK
#        LET l_cmd = g_prog 
#        CASE l_sfp.sfp06
#          WHEN "1" LET l_prog='asfi511'
#          WHEN "2" LET l_prog='asfi512'
#          WHEN "3" LET l_prog='asfi513'
#          WHEN "4" LET l_prog='asfi514'
#          WHEN "6" LET l_prog='asfi526'
#          WHEN "7" LET l_prog='asfi527'
#          WHEN "8" LET l_prog='asfi528'
#          WHEN "9" LET l_prog='asfi529'
#          WHEN "D" LET l_prog='asfi519'                    #FUN-C70014
#        END CASE
#        LET g_prog= l_prog 
#        LET g_success = 'Y'
#        CALL i501sub_y_chk(l_sfp.sfp01,NULL)
#        IF g_success = "Y" THEN
#            CALL i501sub_y_upd(l_sfp.sfp01,NULL,TRUE)  #FUN-840012
#                RETURNING l_sfp.*
#        END IF
#        IF g_success = 'Y' THEN 
#            COMMIT WORK
#        ELSE 
#
#            CALL g_sfp_data.appendElement()
#            LET g_sfp_data[g_sfp_data.getLength()].sfp01 = l_sfp.sfp01
#            LET g_sfp_data[g_sfp_data.getLength()].sfp16 = l_sfp.sfp16
#            INITIALIZE l_gen02 TO NULL
#            SELECT gen02 INTO l_gen02 FROM gen_file 
#             WHERE gen01 = l_sfp.sfp16
#            LET g_sfp_data[g_sfp_data.getLength()].gen02 = l_gen02
#
#            ROLLBACK WORK
#        END IF 
#        LET g_prog= l_cmd
#
#    END FOREACH
#
#    IF g_sfp_data.getLength() > 0 THEN 
#        CALL p200_sfp_mail()
#    END IF 
#
#
#END FUNCTION 
#
#
#FUNCTION p200_sfp_mail()
#
#
#    WHENEVER ERROR CONTINUE
#    INITIALIZE g_xml TO NULL
#
#    LET g_xml.subject = "[",g_plant CLIPPED,"]ERP发料单自动审核失败提醒！系统邮件，请勿回复！"
#    LET g_xml.recipient = "huzhongyang@addchina.com:胡忠杨;mayun@addchina.com:马赟"
#    LET g_xml.cc = "chenliang@zmmax.com:陈梁"
#    LET g_xml.body = p200_sfp_mail_body()
#    LET g_xml.sender = "huzhongyang@addchina.com:系统管理员"
#
#    IF cl_null(g_xml.body) THEN
#        RETURN
#    END IF
#    CALL cl_jmail()
#
#END FUNCTION }
#
#FUNCTION p200_sfp_mail_body()
#DEFINE l_str            STRING
#DEFINE l_path           STRING
#DEFINE l_sql            STRING
#DEFINE l_ac             LIKE type_file.num10
#
#    INITIALIZE l_path TO NULL
#
#    IF g_sfp_data.getLength() = 0 THEN 
#        RETURN
#    END IF 
#
#    LET l_str = CURRENT YEAR TO FRACTION(4)
#    LET l_str = cl_replace_str(l_str,' ','')
#    LET l_str = cl_replace_str(l_str,':','')
#    LET l_str = cl_replace_str(l_str,'-','')
#    LET l_str = cl_replace_str(l_str,'.','')
#
#    LET l_str = l_str.trim(),".htm"
#
#    LET l_path = FGL_GETENV("TEMPDIR") CLIPPED,"/",l_str.trim()
#
#    LET l_str = "<html>"
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#     LET l_str = '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>'
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#    LET l_str = '<style type="text/css">  body{ font-size:14px }  table { table-layout: fixed;  word-wrap:break-word; } </style>'
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#    LET l_str = '<table border="0">'
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#    #此处开始邮件正文内容编写
#    LET l_str = "<tr>"
#    LET l_str = l_str.trim(),"<td>单据编号</td>"
#    LET l_str = l_str.trim(),"<td>申请人员</td>"
#    LET l_str = l_str.trim(),"<td>员工姓名</td>"
#    LET l_str = l_str.trim(),"</tr>"
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#    FOR l_ac = 1 TO g_sfp_data.getLength()
#
#        LET l_str = "<tr>"
#        LET l_str = l_str.trim(),"<td>",g_sfp_data[l_ac].sfp01 CLIPPED,"</td>"
#        LET l_str = l_str.trim(),"<td>",g_sfp_data[l_ac].sfp16 CLIPPED,"</td>"
#        LET l_str = l_str.trim(),"<td>",g_sfp_data[l_ac].gen02 CLIPPED,"</td>"
#        LET l_str = l_str.trim(),"</tr>"
#        LET l_str = "echo '",l_str,"' >> ",l_path
#        RUN l_str
#
#    END FOR
#
#   #LET l_str = "<tr><td>"
#   #LET l_str = l_str,"</td></tr>"
#   #LET l_str = "echo '",l_str,"' >> ",l_path
#   #RUN l_str
#
#    LET l_str = "</table></html>"
#    LET l_str = "echo '",l_str,"' >> ",l_path
#    RUN l_str
#
#    RETURN l_path
#
#END FUNCTION
#
##产生倒扣料
#FUNCTION p200_sfu_dk()
#DEFINE l_sfu01          LIKE sfu_file.sfu01
#DEFINE l_sfu09          LIKE sfu_file.sfu09
#DEFINE l_sfuconf        LIKE sfu_file.sfuconf
#DEFINE l_sfupost        LIKE sfu_file.sfupost
#DEFINE l_prog           LIKE type_file.chr10
#DEFINE l_cnt            LIKE type_file.num5 
#
#    #获取未产生产生倒扣资料的入库单 
#    
#    LET g_sql = "INSERT INTO tc_zmx_file ",
#                "SELECT 'HY','18',sfu01,0,'N','N',to_date(to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'YYYY/MM/DD HH24:Mi:SS'),'','','','','','','','' FROM ",g_zmxdb CLIPPED,".sfu_file ",
#                " WHERE sfu02 >=to_date('191101','yymmdd') and sfu09 is null and sfupost = 'Y'",  #and rownum <=10 ",    #and sfu01 = 'HDA1-191201830' ",
#                " and sfu01 not in (select tc_zmx03 from tc_zmx_file where tc_zmx02='18') " ,
#                " and sfu01 in (select sfv01 from sfv_file v where exists(select sfa01 from sfa_file where sfa11='E' and sfa01=v.sfv11)) ",
#                " order by sfu01 "
#    PREPARE p_sfu_dk_pre FROM g_sql  
#    EXECUTE p_sfu_dk_pre
#                
#
#    LET g_sql = "SELECT DISTINCT tc_zmx03 FROM ",g_zmxdb CLIPPED,".tc_zmx_file ",
#                " WHERE tc_zmx01 = '",g_plant CLIPPED,"'",
#                "   AND tc_zmx02 = '18' ",
#                "   AND tc_zmx04 = '0'  ",
#                "   AND tc_zmx05 = 'N'  "
#              #  "   AND tc_zmx03 = 'HDA1-191201735' " 
#    DECLARE p200_sfu_dk_cs CURSOR WITH HOLD FROM g_sql
#
#    INITIALIZE l_sfu01 TO NULL
#    FOREACH p200_sfu_dk_cs INTO l_sfu01
#
#        SELECT sfu09,sfuconf,sfupost INTO l_sfu09,l_sfuconf,l_sfupost FROM sfu_file 
#         WHERE sfu01 = l_sfu01
#
#        IF l_sfupost <> 'Y' THEN
#            #EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,'','41',l_sfu01
#            CONTINUE FOREACH
#        END IF 
#
#        IF NOT cl_null(l_sfu09) THEN
#            SELECT count(*) INTO l_cnt FROM sfp_file WHERE sfp01=l_sfu09 
#            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
#            IF l_cnt = 0 THEN 
#                UPDATE sfu_file SET sfu09 = '' WHERE sfu01= l_sfu01 
#                EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,l_sfu09,'18',l_sfu01
#            ELSE 
#                EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,l_sfu09,'18',l_sfu01
#            END IF 
#            CONTINUE FOREACH
#        END IF 
#
#        CALL t620_dk(l_sfu01)
#
#        SELECT sfu09,sfuconf,sfupost INTO l_sfu09,l_sfuconf,l_sfupost FROM sfu_file 
#         WHERE sfu01 = l_sfu01
#        IF NOT cl_null(l_sfu09) THEN
#            SELECT count(*) INTO l_cnt FROM sfp_file WHERE sfp01=l_sfu09 
#            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
#            IF l_cnt = 0 THEN 
#                UPDATE sfu_file SET sfu09 = '' WHERE sfu01= l_sfu01 
#                EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,l_sfu09,'18',l_sfu01
#                DISPLAY '-----failsure:--',l_sfu01 CLIPPED ,'------ '
#            ELSE 
#                EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,l_sfu09,'18',l_sfu01
#                DISPLAY '-----Success:--',l_sfu01 CLIPPED ,'------ '
#            END IF 
#        END IF 
#
#    END FOREACH
#    DISPLAY '-----620_dk  end---------'
#
#
#END FUNCTION
#
#FUNCTION t620_dk(p_sfu01)
#DEFINE li_result   LIKE type_file.num5        #No.FUN-540055        #No.FUN-680121 SMALLINT
#DEFINE p_sfu01     LIKE sfu_file.sfu01 
#  DEFINE l_sfv    RECORD LIKE sfv_file.*,
#         l_sfa    RECORD LIKE sfa_file.*,
#         l_sfs    RECORD LIKE sfs_file.*,
#         l_sfu    RECORD LIKE sfu_file.*,
#         l_qpa    LIKE sfa_file.sfa161,        #No:MOD-640013 add
#         l_qty    LIKE sfs_file.sfs05,         #No:MOD-640013 add
#         g_sfu09  LIKE sfu_file.sfu09,
#         g_t1     LIKE oay_file.oayslip, #No.FUN-540055        #No.FUN-680121 CHAR(5)
#         l_flag   LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
#         l_name   LIKE type_file.chr20,         #No:FUN-680121 CHAR(12)
#         l_sfp    RECORD
#               sfp01   LIKE sfp_file.sfp01,
#               sfp02   LIKE sfp_file.sfp02,
#               sfp03   LIKE sfp_file.sfp03,
#               sfp04   LIKE sfp_file.sfp04,
#               sfp05   LIKE sfp_file.sfp05,
#               sfp06   LIKE sfp_file.sfp06,
#               sfp07   LIKE sfp_file.sfp07,
#               sfp14   LIKE sfp_file.sfp14
#                  END RECORD,
#         l_sfb82  LIKE sfb_file.sfb82,
#         l_bdate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
#         l_edate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
#         l_day    LIKE type_file.num5,          #No:FUN-680121 SMALLINT #bugno:6287 add
#         l_cnt    LIKE type_file.num5           #No.FUN-680121 SMALLINT
#    DEFINE l_sfv11 LIKE sfv_file.sfv11
#    DEFINE l_msg  LIKE type_file.chr1000        #No:FUN-680121 CHAR(300)
#    DEFINE l_sfb04  LIKE sfb_file.sfb04
#    DEFINE l_sfb81  LIKE sfb_file.sfb81
#    DEFINE l_sfb02  LIKE sfb_file.sfb02
#    DEFINE l_sfp02  LIKE sfp_file.sfp02
#    DEFINE l_smy73  LIKE smy_file.smy73   #TQC-AC0293
#    DEFINE p_sfp   RECORD LIKE  sfp_file.* #No.160430001
#    DEFINE l_zidong   LIKE type_file.chr1
#    DEFINE l_rg1      LIKE type_file.chr1  
#    DEFINE l_ima35    LIKE ima_file.ima35 
#    DEFINE l_ima36    LIKE ima_file.ima36 
#    DEFINE l_ima25    LIKE ima_file.ima25,
#           l_ima906   LIKE ima_file.ima906,
#           l_ima907   LIKE ima_file.ima907,
#           l_ima55    LIKE ima_file.ima55,
#           l_factor   LIKE type_file.chr1
#    DEFINE l_sql      STRING ,
#           l_x        LIKE type_file.num5 
#
#   DROP TABLE tmp
#   CREATE TEMP TABLE tmp(
#    a         LIKE type_file.chr20,  #FUN-A70138
#    b         LIKE type_file.chr1000,
#    c         LIKE type_file.num15_3);
#
#    IF p_sfu01 IS NULL THEN RETURN END IF
#    LET l_rg1 = '1' 
#    SELECT * INTO l_sfu.* FROM sfu_file
#     WHERE sfu01 = p_sfu01
#    IF l_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
#    IF l_sfu.sfupost = 'N' THEN  #未過帳
#       CALL cl_err(l_sfu.sfu09,'asf-666',0)
#       RETURN
#    END IF
#    IF l_sfu.sfu09 IS NOT NULL THEN  #已產生領料單
#       CALL cl_err(l_sfu.sfu09,'asf-826',0)
#       RETURN
#    END IF
#
#       LET l_sql = "SELECT * FROM sfu_file WHERE sfu01 = ? FOR UPDATE"  #No.TQC-9A0120 mod
#       DECLARE t620_cl CURSOR FROM l_sql 
#
##...check單身工單是否有使用消秏性料件 -> 沒有則不可產生領料單
#    SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfa_file
#     WHERE sfv01 = l_sfu.sfu01
#       AND sfv11 = sfa01 AND sfa11 = 'E'
#    IF l_cnt = 0 THEN 
#       DELETE FROM tc_zmx_file WHERE tc_zmx03=  l_sfu.sfu01 AND tc_zmx02='18'
#       RETURN  
#    END IF
#
#    BEGIN WORK      #No:7829
#
#    LET l_flag =' '
#    LET g_success = 'Y'
#    LET l_zidong='Y' 
#   IF l_zidong='Y'   THEN #No.160430001
#    LET g_sfu09='HD33' #No.160430001
#    DISPLAY g_sfu09  TO sfu09 #No.160430001
#   END IF  #No.160430001----
###
#  #TQC-C90071--add--start
#    IF NOT cl_null(l_sfu.sfu09) THEN  #已產生領料單
#     #  CALL cl_err('','asf-826',0)
#     ROLLBACK WORK
#     EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,'','18',l_sfu.sfu01
#     RETURN 
#    END IF
#  #TQC-C90071-add--end
#    #新增一筆資料
#    IF g_sfu09 IS NOT NULL AND l_sfu.sfupost = 'Y' THEN
#    CALL s_auto_assign_no("asf",g_sfu09,l_sfu.sfu14,"","sfp_file","sfp01","","","")     #MOD-D10117 l_sfu.sfu09 -> g_sfu09
#         RETURNING li_result,l_sfu.sfu09
#    IF (NOT li_result) THEN
#       ROLLBACK WORK
#       EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,l_sfu.sfu09,'18',l_sfu.sfu01
#       RETURN
#    END IF
#    LET g_sfu09=l_sfu.sfu09
#      #----先檢查領料單身資料是否已經存在------------
#       DECLARE count_cur CURSOR FOR
#           SELECT COUNT(*) FROM sfs_file
#       WHERE sfs01 = g_sfu09
#       OPEN count_cur
#       FETCH count_cur INTO g_cnt
#       IF g_cnt > 0  THEN  #已存在
#          LET l_flag ='Y'
#       ELSE
#          LET l_flag ='N'
#       END IF
#       #-----------產生領料資料------------------------
#
#       DECLARE t620_sfv_cur CURSOR  WITH HOLD FOR
#          SELECT *  FROM  sfv_file
#           WHERE sfv01 = l_sfu.sfu01
#       LET l_cnt = 0
#       #CALL cl_outnam('asft620') RETURNING l_name
#       #START REPORT t620_rep TO l_name
#
#       LET g_success = 'Y'
#       FOREACH t620_sfv_cur INTO l_sfv.*
#         IF STATUS THEN
#            CALL cl_err('foreach s:',STATUS,0)
#            LET g_success = 'N'    #No:7829
#            EXIT FOREACH
#         END IF
#         SELECT sfb04,sfb81,sfb02          #MOD-890168 mark ,sfp02
#           INTO l_sfb04,l_sfb81,l_sfb02    #MOD-890168 mark ,l_sfp02 
#           FROM sfb_file                   #MOD-8A0031 mark ,sfp_file
#          WHERE sfb01 = l_sfv.sfv11
#
#
#         IF STATUS THEN
#            CALL cl_err3("sel","sfb_file",l_sfv.sfv11,"",STATUS,"","sel sfb",1) 
#            CONTINUE FOREACH
#         END IF
#
#         IF l_sfb04='1' THEN
#            #CALL cl_err('sfb04=1','asf-381',0) 
#            CONTINUE FOREACH
#         END IF
#
#         {IF l_sfb04='8' THEN
#            #CALL cl_err('sfb04=8','asf-345',0) 
#            CONTINUE FOREACH
#          END IF}
#        
#
#         IF l_sfb02=13 THEN  
#            #CALL cl_err('sfb02=13','asf-346',0) 
#            CONTINUE FOREACH
#         END IF
#         DECLARE t620_sfs_cur CURSOR WITH HOLD FOR
#         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file
#          WHERE sfb01 = l_sfv.sfv11   #工單單號
#            AND sfb01 = sfa01
#            AND sfa11 = 'E'
#            AND sfa05<>0         #MOD-C10064 add
#            ORDER BY sfa26       #No:MOD-640013 add
#        LET l_x  = 1
#        FOREACH t620_sfs_cur INTO l_sfa.*,l_sfb82
#            INITIALIZE l_sfs.* TO NULL
#            INITIALIZE l_sfp.* TO NULL
#
#         #-------發料單頭--------------
#          LET l_sfp.sfp01 = g_sfu09
##領料單月份已與完工入庫單月份不同時,以完工入庫日期該月的最後一天為領料日
#          {LET l_sfp.sfp02 = g_today
#          LET l_sfp.sfp03 = g_today      #No:MOD-950184 add    
#          IF MONTH(g_today) != MONTH(l_sfu.sfu02) THEN
#             IF MONTH(l_sfu.sfu02) = 12 THEN
#                LET l_bdate = MDY(MONTH(l_sfu.sfu02),1,YEAR(l_sfu.sfu02))
#                LET l_edate = MDY(1,1,YEAR(l_sfu.sfu02)+1)
#             ELSE
#                LET l_bdate = MDY(MONTH(l_sfu.sfu02),1,YEAR(l_sfu.sfu02))
#                LET l_edate = MDY(MONTH(l_sfu.sfu02)+1,1,YEAR(l_sfu.sfu02))
#             END IF
#             LET l_day = l_edate - l_bdate   #計算最後一天日期
#             LET l_sfp.sfp03 = MDY(MONTH(l_sfu.sfu02),l_day,YEAR(l_sfu.sfu02))   #No:MOD-950184 add    
#          END IF}
#          LET l_sfp.sfp02 = l_sfu.sfu02  #modify 191210  
#          LET l_sfp.sfp03 = l_sfu.sfu02  
#          LET l_sfp.sfp04 = 'N'
#          LET l_sfp.sfp05 = 'N'
#          LET l_sfp.sfp06 ='4'
#          LET l_sfp.sfp07 = l_sfb82
#          LET l_sfp.sfp14 = l_sfu.sfu01 
#          #OUTPUT TO REPORT t620_rep(l_sfp.*,l_flag)
#          SELECT count(*) INTO l_cnt FROM sfs_file  WHERE sfs01 = g_sfu09 
#          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
#          IF l_cnt = 0 THEN 
#          #IF l_x = 1 THEN 
#            CALL t620_insert_sfp(l_sfp.*,l_flag)
#          END IF 
#          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file
#           WHERE sfs01 = g_sfu09
#          IF l_cnt IS NULL THEN    #項次
#             LET l_cnt = 1
#          ELSE  LET l_cnt = l_cnt + 1
#          END IF
#         #-------發料單身--------------
#          LET l_sfs.sfs01 = g_sfu09
#          LET l_sfs.sfs02 = l_cnt
#          LET l_sfs.sfs03 = l_sfa.sfa01
#          LET l_sfs.sfs04 = l_sfa.sfa03
#          LET l_sfs.sfs05 = l_sfv.sfv09*l_sfa.sfa161 #已發料量
#          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位
#          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084
#          #CHI-A40030 mod --start--
#          #LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫
#          #LET l_sfs.sfs08 = l_sfa.sfa31  #儲位
#          CASE l_rg1
#             WHEN '1'
#              SELECT ima35,ima36 INTO l_ima35,l_ima36
#                 FROM ima_file
#                WHERE ima01= l_sfa.sfa03
#              ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
#              #IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
#              #   LET g_success = 'N'
#              #END IF
#              ##End Add No.FUN-AA0055
#               LET l_sfs.sfs07 = l_ima35  #倉庫
#               LET l_sfs.sfs08 = l_ima36  #儲位
#             WHEN '2'
#               LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫
#               LET l_sfs.sfs08 = l_sfa.sfa31  #儲位
#             WHEN '3'
#               LET l_sfs.sfs07 = l_ima35  #倉庫
#               LET l_sfs.sfs08 = l_ima36  #儲位
#          END CASE
#          LET l_sfs.sfs07 = '112'
#          LET l_sfs.sfs08 = ' '
#          #CHI-A40030 mod --end--
#          LET l_sfs.sfs09 = ' '          #批號
#          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號
#          LET l_sfs.sfs26 = NULL         #替代碼
#          LET l_sfs.sfs27 = NULL         #被替代料號
#         #LET l_sfs.sfs28 = NULL         #替代率      #MOD-C60203 mark
#          LET l_sfs.sfs28 = 1            #替代率      #MOD-C60203 add
#          LET l_sfs.sfs930 = l_sfv.sfv930 #FUN-670103
#          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN    #bugno:7111 add 'T'  #FUN-A20037 add 'Z'
#             LET l_sfs.sfs26 = l_sfa.sfa26
#             LET l_sfs.sfs27 = l_sfa.sfa27
#             LET l_sfs.sfs28 = l_sfa.sfa28
#             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file
#                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27
#                  AND sfa012 = l_sfa.sfa012 AND sfa013 = l_sfa.sfa013        #FUN-A60076 
#             LET l_sfs.sfs05 = l_sfv.sfv09*l_qpa
#             LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)             #FUN-BB0084 
#             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01
#                AND b = l_sfa.sfa27
#             IF  cl_null(l_qty) THEN LET l_qty=0 END IF       #MOD-C10064 add
#             IF l_sfs.sfs05 < l_qty THEN
#                LET l_sfs.sfs05 = 0
#             ELSE
#                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty
#                LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)          #FUN-BB0084
#             END IF
#          ELSE                               #No:MOD-8B0086 add
#             LET l_sfs.sfs27 = l_sfa.sfa27   #No:MOD-8B0086 add
#          END IF
#         #CALL t620_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05  #MOD-850193 add   #MOD-C80187 mark
#          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)    #FUN-BB0084
#       ##判斷發料是否大於可發料數(sfa05-sfa06)
#       ##TQC-B80264  --begin   #MOD-C10064 str mark
#       # # IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
#       # #    LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06
#       # # END IF
#       # IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
#       #    CALL cl_err('sfs05','asf-774',1)  
#       #     LET g_success = 'N'     
#       #     LET l_sfu.sfu09 = NULL   
#       #     DISPLAY BY NAME l_sfu.sfu09    
#       #     RETURN
#       # END IF 
#       ##TQC-B80264  --end     #MOD-C10064 end mark
#          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN
#            #No.160430001----
#            SELECT gem04 INTO l_sfs.sfs07 FROM sfb_file,gem_file  WHERE sfb82=gem01 AND sfb01=l_sfs.sfs03
#            IF cl_null(l_sfs.sfs07) THEN
#              SELECT ima136 INTO l_sfs.sfs07 FROM ima_file WHERE ima01=l_sfs.sfs04
#              IF cl_null(l_sfs.sfs07) THEN 
#                LET l_sfs.sfs07='112'
#              END IF
#            END IF   
#            #No.160430001----          	
##             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08
##               FROM ima_file
##              WHERE ima01 = l_sfs.sfs04
#            ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
#            #IF NOT s_chk_ware(l_sfs.sfs07) THEN  #检查仓库是否属于当前门店
#            #   LET g_success = 'N'
#            #END IF
#            ##End Add No.FUN-AA0055
#          END IF
#          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
#          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
#          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
#          INSERT INTO tmp
#            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)
#          IF g_sma.sma115 = 'Y' THEN
#             SELECT ima25,ima55,ima906,ima907
#               INTO l_ima25,l_ima55,l_ima906,l_ima907
#               FROM ima_file
#              WHERE ima01=l_sfs.sfs04
#             IF SQLCA.sqlcode THEN
#                CALL cl_err('sel ima',SQLCA.sqlcode,1)
#                LET g_success = 'N'
#             END IF
#             IF cl_null(l_ima55) THEN LET l_ima55 = l_ima25 END IF
#             LET l_sfs.sfs30=l_sfs.sfs06
#             LET l_factor = 1
#             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_ima55)
#               RETURNING g_cnt,l_factor
#             IF g_cnt = 1 THEN
#                LET l_factor = 1
#             END IF
#             LET l_sfs.sfs31=l_factor
#             LET l_sfs.sfs32=l_sfs.sfs05
#             LET l_sfs.sfs33=l_ima907
#             LET l_factor = 1
#             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_ima55)
#               RETURNING g_cnt,l_factor
#             IF g_cnt = 1 THEN
#                LET l_factor = 1
#             END IF
#             LET l_sfs.sfs34=l_factor
#             LET l_sfs.sfs35=0
#             IF l_ima906 = '3' THEN
#                LET l_factor = 1
#                CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33)
#                  RETURNING g_cnt,l_factor
#                IF g_cnt = 1 THEN
#                   LET l_factor = 1
#                END IF
#                LET l_sfs.sfs35=l_sfs.sfs32*l_factor
#                LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)    #FUN-BB0084
#             END IF
#             IF l_ima906='1' THEN
#                LET l_sfs.sfs33=NULL
#                LET l_sfs.sfs34=NULL
#                LET l_sfs.sfs35=NULL
#             END IF
#          END IF
#
#         OPEN t620_cl USING l_sfu.sfu01    #No.TQC-9A0120 mod
#         IF STATUS THEN
#            CALL cl_err("OPEN t620_cl:", STATUS, 1)
#            CLOSE t620_cl
#            ROLLBACK WORK
#            RETURN
#         END IF
#         FETCH t620_cl INTO l_sfu.*          # 鎖住將被更改或取消的資料
#         IF SQLCA.sqlcode THEN
#            CALL cl_err(l_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#            CLOSE t620_cl ROLLBACK WORK RETURN
#         END IF
#
#         IF l_flag ='N' THEN
#
#            #LET l_sfv.sfvplant = g_plant #FUN-980008 add  #TQC-AB0097 mark
#            #LET l_sfv.sfvlegal = g_legal #FUN-980008 add  #TQC-AB0097 mark
#            LET l_sfs.sfsplant = g_plant #TQC-AB0097
#            LET l_sfs.sfslegal = g_legal #TQC-AB0097
##FUN-A70125 --begin--
#            IF cl_null(l_sfs.sfs012) THEN
#               LET l_sfs.sfs012 = ' ' 
#            END IF 
#            IF cl_null(l_sfs.sfs013) THEN
#               LET l_sfs.sfs013 = 0 
#            END IF            
##FUN-A70125 --end--
##TQC-C90055--remark--add--start--
##FUN-C70014 add begin-----------------
#            IF cl_null(l_sfs.sfs014) THEN
#               LET l_sfs.sfs014 = ' '  
#            END IF
##FUN-C70014 add end ------------------
##TQC-C90055--remark--add--end--
#            #FUN-CB0087---add---str---
#            IF g_aza.aza115 = 'Y' THEN
#               CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_user,l_sfp.sfp07) RETURNING l_sfs.sfs37
#               IF cl_null(l_sfs.sfs37) THEN
#                  CALL cl_err('','aim-425',1)
#                  LET g_success = 'N'
#               END IF
#            END IF
#            #FUN-CB0087---add---end--
#            INSERT INTO sfs_file VALUES (l_sfs.*)
#            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#              CALL cl_err('ins sfs',STATUS,0)
#              LET g_success = 'N'
#            ELSE 
#               LET l_x = 0 
#            END IF
#         ELSE
#            UPDATE sfs_file SET * = l_sfs.* WHERE sfs01 = l_sfs.sfs01
#            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#               CALL cl_err('ins sfs',STATUS,0)
#               LET g_success = 'N'
#            END IF
#         END IF
#       END FOREACH
#     END FOREACH
#     #FINISH REPORT t620_rep
#     #MOD-C80170 str add-----
#     LET l_cnt = 0                                                 
#     SELECT COUNT(*) INTO l_cnt FROM sfp_file WHERE sfp01 = g_sfu09 
#     IF l_cnt = 0 THEN 
#        LET l_sfu.sfu09 = NULL 
#        DISPLAY BY NAME l_sfu.sfu09
#     END IF
#    #MOD-C80170 end add-----
#     IF g_sfu09 IS NOT NULL THEN
#        LET l_sfu.sfu09 = g_sfu09
#        UPDATE sfu_file SET sfu09 = l_sfu.sfu09
#         WHERE sfu01 = l_sfu.sfu01
#        IF STATUS THEN
#           CALL cl_err('upd sfu',STATUS,1)
#           LET g_success = 'N'
#        END IF
#        DISPLAY BY NAME l_sfu.sfu09
#     END IF
#    END IF
#    IF g_success = 'Y' THEN
#       EXECUTE p200_upd_tc_zmx_prep USING '1','Y','Y',g_today,l_sfu.sfu09,'18',l_sfu.sfu01
#       COMMIT WORK
#    ELSE
#       EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,l_sfu.sfu09,'18',l_sfu.sfu01
#       ROLLBACK WORK
#    END IF
##No.160430001-------
#  IF l_zidong='Y' THEN 
#   CALL t620_add_img1(l_sfu.sfu09,l_sfu.sfu02) #No.160421001
#   CALL i501sub_y_chk(l_sfu.sfu09,'')  #TQC-C60079
#   IF g_success='N' THEN
#      RETURN  
#   END IF
#   CALL i501sub_y_upd(l_sfu.sfu09,'',FALSE)  #FUN-840012  
#     RETURNING p_sfp.*
#   IF g_success='N' THEN
#      RETURN  
#   END IF
#  # CALL i501sub_s('1',l_sfu.sfu09,FALSE,'N')   #191210 
#  # IF g_success='N' THEN
#      SELECT count(*) INTO l_cnt FROM tc_zmx_file WHERE tc_zmx03 = l_sfu.sfu09
#      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
#      IF l_cnt = 0 THEN 
#        INSERT  INTO  tc_zmx_file values('HY','19',l_sfu.sfu09,'0','N','N',to_date(to_char(sysdate,'YYYY/MM/DD HH24:Mi:SS'),'YYYY/MM/DD HH24:Mi:SS'),'','','','','','','',l_sfu.sfu01)
#      ELSE 
#        EXECUTE p200_upd_tc_zmx_prep USING '0','N','N',g_today,l_sfu.sfu01,'19',l_sfu.sfu09
#      END IF 
#      RETURN  
#   END IF
#  #END IF 
#  LET l_zidong='N'
##No.160430001-------    
#
#END FUNCTION
#
#
##No.160430001----begin---------
#FUNCTION t620_add_img1(p_sfp01,p_sfp03)
#DEFINE p_sfp01  LIKE sfp_file.sfp01
#DEFINE p_sfp03  LIKE sfp_file.sfp03
#DEFINE l_sfs    DYNAMIC ARRAY OF RECORD LIKE sfs_file.*
#DEFINE l_sql    STRING
#DEFINE l_i      LIKE type_file.num5
#DEFINE l_img09  LIKE ima_file.ima09  
#  
#   LET l_sql="SELECT * FROM sfs_file WHERE sfs01='",p_sfp01,"'"
#   PREPARE inb1_pb FROM l_sql
#   DECLARE inb1_curs  CURSOR FOR inb1_pb
#  
#   CALL l_sfs.clear()
#   LET l_i = 1
#   FOREACH inb1_curs INTO l_sfs[l_i].*
#      IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#      END IF
#      IF NOT cl_null(l_sfs[l_i].sfs04) AND NOT cl_null(l_sfs[l_i].sfs07) THEN
#         IF cl_null(l_sfs[l_i].sfs08) THEN LET l_sfs[l_i].sfs08 = ' ' END IF
#         IF cl_null(l_sfs[l_i].sfs09) THEN LET l_sfs[l_i].sfs09 = ' ' END IF
#             IF (NOT cl_null(l_sfs[l_i].sfs04)) AND (NOT cl_null(l_sfs[l_i].sfs07)) THEN
#                LET l_img09 = ''  
#                SELECT img09 INTO l_img09 FROM img_file
#                 WHERE img01=l_sfs[l_i].sfs04
#                   AND img02=l_sfs[l_i].sfs07
#                   AND img03=l_sfs[l_i].sfs08
#                   AND img04=l_sfs[l_i].sfs09
#                  IF SQLCA.sqlcode=100 THEN
#                     CALL s_add_img(l_sfs[l_i].sfs04,l_sfs[l_i].sfs07,l_sfs[l_i].sfs08,
#                                    l_sfs[l_i].sfs09,p_sfp01,l_sfs[l_i].sfs02,p_sfp03)
#                     IF g_errno='N' THEN
#                         RETURN "sfs04"
#                     END IF             
#                  END IF                                       
#              END IF 
#      END IF 
#      LET l_i = l_i + 1                        
#   END FOREACH 
# 
#END FUNCTION
##No.160430001--------------end---------
#
#
#FUNCTION  t620_insert_sfp(sr,p_flag)
#  DEFINE p_flag  LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
#        sr  RECORD
#            sfp01 LIKE sfp_file.sfp01,
#            sfp02 LIKE sfp_file.sfp02,
#            sfp03 LIKE sfp_file.sfp03,
#            sfp04 LIKE sfp_file.sfp04,
#            sfp05 LIKE sfp_file.sfp05,
#            sfp06 LIKE sfp_file.sfp06,
#            sfp07 LIKE sfp_file.sfp07,
#            sfp14 LIKE sfp_file.sfp14
#             END RECORD
#
#      IF p_flag ='Y' THEN
#            UPDATE sfp_file SET sfp02= sr.sfp02,  #sfp03 = sr.sfp03,
#                                sfp04= sr.sfp04,sfp05 = sr.sfp05,
#                                 sfp06= sr.sfp06,sfp07 = sr.sfp07,  #MOD-470503
#                                 sfpgrup=g_grup,sfp14=sr.sfp14,                   #No:MOD-770140 add
#                                 sfpmodu=g_user,sfpdate=g_today #MOD-470503 add
#               WHERE sfp01 = sr.sfp01
#            IF SQLCA.sqlcode THEN LET g_success='N' END IF
#      ELSE
#           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09, #MOD-5A0044 add sfp09
#                                sfpuser,sfpdate,sfpconf,sfpgrup, #FUN-660106     #No:MOD-770140 add sfpgrup
#                                sfpmksg,sfp15,sfp16, sfp14,                         #FUN-AB0001 add
#                                sfpplant,sfplegal)                               #FUN-980008 add
#                         VALUES(sr.sfp01,sr.sfp02,sr.sfp03,sr.sfp04,
#                                sr.sfp05,sr.sfp06,sr.sfp07,'N',        #MOD-5A0044 add 'N'
#                                g_user,g_today,'N',g_grup,             #FUN-660106       #No:MOD-770140 add g_grup
#                                g_smy.smyapr,'0',g_user,sr.sfp14,               #FUN-AB0001 add
#                                g_plant,g_legal)                       #FUN-980008 add
#            IF SQLCA.sqlcode THEN LET g_success='N' END IF
#      END IF
# 
#END FUNCTION 

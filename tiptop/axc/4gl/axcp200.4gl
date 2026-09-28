# Prog. Version..: '5.30.02-12.08.01(00002)'     #
#
# Pattern name...: axcp200.4gl
# Descriptions...: 发出商品档整批产生作业
# Date & Author..: FUN-C60033 12/06/18 By minpp
# Modify.........: No:TQC-C80008 12/08/01 By xuxz 若發票號碼omf01為空，則cfb02 = omf00,;若發票代碼omf02為空，則cfb16 = ' '
# Modify.........: No:FUN-C80094 12/09/06 By minpp 年度，期别必须录入不可为空
# Modify.........: No:FUN-C80094 12/09/06 By xuxz 取消特殊條件選框
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:FUN-C80092 12/09/12 By xujing 成本相關作業程式日誌
# Modify.........: No:MOD-CC0218 12/12/24 By wujie 选择不重新生成资料时，发出商品月统计档也不该重计
# Modify.........: No:FUN-D70058 13/07/10 By wangrr 增加庫存單位科目等欄位,轉入日期和轉出日期分為兩個欄位顯示
# Modify.........: No:CHI-E40001 14/04/01 By SunLM 跨月開票導致轉入發出商品異常
# Modify.........: No:MOD-F70172 15/07/30 By catmoon 排除非成本倉的資料

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc       STRING                   #QBE_1的條件
DEFINE g_wc2      STRING                   #QBE_2的條件
DEFINE g_sql      STRING                   #組sql
DEFINE g_plant_new    LIKE type_file.chr21     #營運中心

DEFINE tm         RECORD 
       yy         LIKE type_file.chr4,
       mm         LIKE type_file.chr2,
       MORE       LIKE type_file.chr1
                  END RECORD

DEFINE p_row,p_col   LIKE type_file.num5
DEFINE g_success     LIKE type_file.chr1
DEFINE g_oga         RECORD LIKE oga_file.*
DEFINE g_ogb         RECORD LIKE ogb_file.*
DEFINE g_oha         RECORD LIKE oha_file.*
DEFINE g_ohb         RECORD LIKE ohb_file.*
DEFINE g_omf         RECORD LIKE omf_file.*
DEFINE g_field       STRING     #FUN-C80094
DEFINE g_cka00       LIKE cka_file.cka00   #FUN-C80092 add
DEFINE g_cka09       LIKE cka_file.cka09   #FUN-C80092 add
DEFINE g_cka08       LIKE cka_file.cka08    #FUN-C80092 add

MAIN

   DEFINE l_flag  LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   INITIALIZE tm.* TO NULL
   LET g_wc  = ARG_VAL(1)
   LET g_wc2 = ARG_VAL(2)
   LET tm.yy = ARG_VAL(3)
   LET tm.mm = ARG_VAL(4)
   LET tm.more= ARG_VAL(5)
   LET g_bgjob=ARG_VAL(6)

   LET tm.more ='N'

   IF cl_null(g_bgjob) THEN
      LET g_bgjob ="N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log


   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p200_tm()
         IF cl_sure(18,20) THEN
            LET g_cka08 = g_wc,";",g_wc2                   #FUN-C80092 add
            LET g_cka09 = "yy=",tm.yy,"'mm=",tm.mm,";more='",tm.MORE,"'"           #FUN-C80092 add
            CALL s_log_ins(g_prog,tm.yy,tm.mm,g_cka08,g_cka09) RETURNING g_cka00   #FUN-C80092 add
            LET g_success = 'Y'
            CALL s_showmsg_init()
            CALL p200()
            CALL s_showmsg()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cka08 = g_wc,";",g_wc2                   #FUN-C80092 add
         LET g_cka09 = "yy=",tm.yy,"'mm=",tm.mm,";more='",tm.MORE,"'"           #FUN-C80092 add
         CALL s_log_ins(g_prog,tm.yy,tm.mm,g_cka08,g_cka09) RETURNING g_cka00   #FUN-C80092 add
         LET g_success = 'Y'
         CALL s_showmsg_init()
         CALL p200()
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN 


FUNCTION p200_tm()

LET p_row = 5 LET p_col = 28
OPEN WINDOW p200_w AT p_row,p_col WITH FORM "axc/42f/axcp200"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM

   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
         BEFORE CONSTRUCT                 
         DISPLAY g_plant TO azp01
         LET tm.more='N'
       
      END CONSTRUCT  

      CONSTRUCT BY NAME g_wc2 ON occ01,ima01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      INPUT BY NAME tm.yy,tm.mm,tm.MORE
#No.MOD-CB0110 --begin
         BEFORE INPUT 
            LET tm.yy = g_ccz.ccz01
            LET tm.mm = g_ccz.ccz02
            DISPLAY BY NAME tm.yy,tm.mm
#No.MOD-CB0110 --end        
         AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN 
            IF tm.yy > 9999 OR tm.yy < 1000 THEN 
              CALL cl_err('','ask-003',0)
              NEXT FIELD yy
            END IF
         ELSE
            NEXT FIELD yy 
         END IF 
         
         AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN 
           IF tm.mm >13 OR tm.mm < 1 THEN 
              CALL cl_err('','agl-013',0)
              NEXT FIELD mm
            END IF  
          ELSE
            NEXT FIELD mm
          END IF 
          
         AFTER FIELD MORE 
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF

#FUN-C80094--mark-by xuxz --str
#           IF tm.more = 'Y' THEN
#              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                             g_bgjob,g_time,g_prtway,g_copies)
#                   RETURNING g_pdate,g_towhom,g_rlang,
#                             g_bgjob,g_time,g_prtway,g_copies
#           END IF 
#FUn_C80094--mark--by xuxz --end
    END INPUT  

      ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azp01)  #機構別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
                   
               WHEN INFIELD (occ01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO occ01
                    NEXT FIELD occ01

               WHEN INFIELD (ima01)     
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
               OTHERWISE
                  EXIT CASE    
            END CASE

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION accept
        # EXIT DIALOG                #FUN-C80094
          LET INT_FLAG = 0           #FUN-C80094
          ACCEPT DIALOG              #FUN-C80094
 

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      #FUN-C80094--minpp--12/09/06--str
      AFTER DIALOG
         IF NOT p200_chk_datas() THEN
            IF g_field = "yy" THEN
               NEXT FIELD yy
            END IF
            IF g_field = "mm" THEN
               NEXT FIELD mm
            END IF
            LET g_field = ''
         END IF
      #FUN-C80094--minpp--12/09/06--end 
   END DIALOG
   
   IF INT_FLAG THEN
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM  
   END IF
END FUNCTION

#FUN-C80094--minpp--add--str
#栏位输入管控
FUNCTION p200_chk_datas()
   IF tm.yy IS NULL OR cl_null(tm.yy) THEN
      CALL cl_err('','alm-809',0)
      LET g_field = "yy"
      RETURN FALSE
   END IF
   IF tm.mm IS NULL OR cl_null(tm.mm) THEN
      CALL cl_err('','alm-809',0)
      LET g_field = "mm"
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION 
#FUN-C80094--minpp--add--end

FUNCTION p200()
DEFINE l_n,l_i,l_i_1,l_i_2,l_i_3   LIKE type_file.num5
DEFINE l_sql     STRING 
DEFINE l_wc      STRING 
DEFINE l_str     STRING 
DEFINE l_wc1     STRING
DEFINE l_wc2     STRING
DEFINE l_wc3     STRING
DEFINE l_wc4     STRING
DEFINE l_cfb07   LIKE cfb_file.cfb07
DEFINE l_cfb11   LIKE cfb_file.cfb11
BEGIN WORK
   LET g_success = 'Y'
   LET l_wc1=g_wc2
   LET l_wc2=g_wc2
   LET l_wc3=g_wc2
   LET l_wc4=g_wc2
   INITIALIZE g_oga.* TO NULL
   INITIALIZE g_ogb.* TO NULL
   INITIALIZE g_oha.* TO NULL
   INITIALIZE g_oha.* TO NULL
   INITIALIZE g_omf.* TO NULL
   CALL s_showmsg_init()
  # 抓当前营运中心
   LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"'"

   PREPARE p200_azp01_pre FROM g_sql
   DECLARE p200_azp01_cs CURSOR FOR p200_azp01_pre
   FOREACH p200_azp01_cs INTO g_plant_new
  #1.抓出货单资料
   LET l_wc1= cl_replace_str(l_wc1,'occ01','oga03') 
   LET l_wc1= cl_replace_str(l_wc1,'ima01','ogb04')
   LET g_sql= " SELECT * ",
              " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",
                       cl_get_target_table(g_plant_new,'ogb_file'),
              " WHERE  ogaplant ='",g_plant_new,"'", 
              "   AND  oga01 = ogb01 ",
              "   AND  ogaconf='Y' ",
              "   AND  oga00 IN ('1','4','5','6','8') ",
            # "   AND  oga09 NOT IN ('1','9') AND ogapost='Y' ",
              "   AND  oga09 NOT IN ('1','9','5','8') AND ogapost='Y' ",
              "   AND  oga65='N' AND YEAR(oga02)='",tm.yy,"' AND MONTH(oga02)='",tm.mm,"' ",
            #  " AND ogb09 not in (select distinct jce02 from jce_file )",  #150706wudj          #mark by xujw161114
              "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = ogb09)",  #MOD-F70172 add  #add by xujw161114
              "   AND  ",l_wc1 CLIPPED
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE p200_oga_pre FROM g_sql
   DECLARE p200_oga_cs CURSOR FOR p200_oga_pre 

   #查看当前条件下oga,ogb表有没有资料，如果没资料则报错，返回
    LET l_i=0
    LET g_sql= " SELECT COUNT(*) ",
              " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",
                       cl_get_target_table(g_plant_new,'ogb_file'),
              " WHERE  ogaplant ='",g_plant_new,"'",
              "   AND  oga01 = ogb01 ",
              "   AND  ogaconf='Y' ",
              "   AND  oga00 IN ('1','4','5','6','8') ",
            # "   AND  oga09 NOT IN ('1','9') AND ogapost='Y' ",
              "   AND  oga09 NOT IN ('1','9','5','8') AND ogapost='Y' ",
              "   AND  oga65='N' AND YEAR(oga02)='",tm.yy,"' AND MONTH(oga02)='",tm.mm,"' ",
            #  " AND ogb09 not in (select distinct jce02 from jce_file )",  #150706wudj          #mark by xujw161114
              "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = ogb09)",  #MOD-F70172 add  #add by xujw161114   
              "   AND ",l_wc1 CLIPPED
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p200_oga_pre1 FROM g_sql 
   EXECUTE p200_oga_pre1 INTO l_i_1
   #2.抓销退单资料
   LET l_wc2= cl_replace_str(l_wc2,'occ01','oha03') 
   LET l_wc2= cl_replace_str(l_wc2,'ima01','ohb04')
   LET g_sql= " SELECT * ",   
              " FROM ",cl_get_target_table(g_plant_new,'oha_file'),",",
                       cl_get_target_table(g_plant_new,'ohb_file'),
              " WHERE ", l_wc2 CLIPPED, 
              " AND ohaplant='",g_plant_new,"'  AND oha01=ohb01  AND ohaconf='Y' ",
              " AND oha09 IN ('1','4','5') AND ohapost='Y' ",  
            # " AND ohb09 not in (select distinct jce02 from jce_file )",  #150706wudj           #mark by xujw161114
              " AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = ohb09)",  #MOD-F70172 add    #add by xujw16111 4
              " AND YEAR(oha02)='",tm.yy,"' AND MONTH(oha02)='",tm.mm,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
    PREPARE p200_oha_pre FROM g_sql
    DECLARE p200_oha_cs CURSOR FOR p200_oha_pre 
    #檢查當前條件銷退單有沒有資料，沒有則報錯返回
    LET g_sql=" SELECT COUNT(*) ",
              " FROM ",cl_get_target_table(g_plant_new,'oha_file'),",",
                       cl_get_target_table(g_plant_new,'ohb_file'),
              " WHERE ", l_wc2 CLIPPED,
              " AND ohaplant='",g_plant_new,"'  AND oha01=ohb01  AND ohaconf='Y' ",
              " AND oha09 IN ('1','4','5') AND ohapost='Y' ",
            # " AND ohb09 not in (select distinct jce02 from jce_file )",  #150706wudj            #mark by xujw161114
              " AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = ohb09)",  #MOD-F70172 add     #add by xujw161114
              " AND YEAR(oha02)='",tm.yy,"' AND MONTH(oha02)='",tm.mm,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
    PREPARE p200_oha_pre1 FROM g_sql
    EXECUTE p200_oha_pre1 INTO l_i_2
 
    #3.抓签收单资料
    LET l_wc3= cl_replace_str(l_wc3,'occ01','omf05') 
    LET l_wc3= cl_replace_str(l_wc3,'ima01','omf13')  
    LET g_sql=" SELECT * FROM omf_file ",
              " WHERE omf08='Y' AND YEAR(omf03)='",tm.yy,"' AND MONTH(omf03)='",tm.mm,"' ",
              "   AND omf10 !='9' ",#FUN-C60033 add bu xuxz
              "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = omf20)",  #MOD-F70172 add   #add by xujw161114
              " AND ",l_wc3 CLIPPED 
              
    PREPARE p200_omf_pre FROM g_sql
    DECLARE p200_omf_cs CURSOR FOR p200_omf_pre  
    #檢查當前條件下簽收單有無資料，若無資料則返回報錯
    LET g_sql=" SELECT count(*) FROM omf_file ",
              " WHERE omf08='Y' AND YEAR(omf03)='",tm.yy,"' AND MONTH(omf03)='",tm.mm,"' ",
              "   AND omf10 !='9' ",#FUN-C60033 add bu xuxz
              "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = omf20)",  #MOD-F70172 add   #add by xujw161114
              " AND ",l_wc3 CLIPPED

    PREPARE p200_omf_pre1 FROM g_sql   
    EXECUTE p200_omf_pre1 INTO l_i_3

    IF l_i_1+l_i_2+l_i_3 =0 THEN
         CALL s_errmsg('','','','aic-024',1)
         LET g_success = 'N'
         RETURN
     END IF
    #资料处理
    LET l_n=0
    LET l_wc4= cl_replace_str(l_wc4,'occ01','cfb07') 
    LET l_wc4= cl_replace_str(l_wc4,'ima01','cfb11')
    LET l_sql =" SELECT COUNT(*) FROM cfb_file ",
               "  WHERE cfb03='",g_plant_new,"'",
               "   AND YEAR(cfb06)='",tm.yy,"'",
               "   AND MONTH(cfb06)='",tm.mm,"'",
               "   AND ",l_wc4 CLIPPED 
    PREPARE sel_cfb_pre FROM l_sql
    EXECUTE sel_cfb_pre INTO l_n    
        #判断资料在cfb_file中是否存在，若不存在则直接插入，若存在则询问是否重新产生
       IF l_n>0 THEN 
          IF cl_confirm ('agl-400') THEN
             LET l_sql=" DELETE FROM cfb_file ",
                       "  WHERE YEAR(cfb06)= '",tm.yy,"'",
                       "  AND MONTH(cfb06)='",tm.mm,"'",
                       "  AND cfb01='1' ",  #150810wudj
                       "  AND cfb03= '",g_plant_new,"'",
                       "  AND ",l_wc4 CLIPPED
             PREPARE del_cfb_pre FROM l_sql
             EXECUTE  del_cfb_pre
#150810wudj-str
             LET l_sql=" DELETE FROM cfb_file ",

                       "  WHERE YEAR(cfb061)= '",tm.yy,"'",

                       "  AND MONTH(cfb061)='",tm.mm,"'",

                       "  AND cfb01='-1' ",  #150810wudj

                       "  AND cfb03= '",g_plant_new,"'",

                       "  AND ",l_wc4 CLIPPED

             PREPARE del_cfb_pre1 FROM l_sql

             EXECUTE  del_cfb_pre1

#150810wudj-end             
             FOREACH p200_oga_cs INTO g_oga.*,g_ogb.*
                CALL  p200_ins_oga() 
             END FOREACH
             IF g_success='Y' THEN 
                FOREACH p200_oha_cs INTO g_oha.*,g_ohb.*        
                   CALL  p200_ins_oha()
                END FOREACH
             END IF   
             IF g_success='Y' THEN 
                FOREACH p200_omf_cs INTO g_omf.*        
                   CALL  p200_ins_omf()
                END FOREACH 
              END IF   
#No.MOD-CC0218 --begin
          ELSE 
            LET g_success = 'N'
#No.MOD-CC0218 --end
          END IF 
        ELSE 
            FOREACH p200_oga_cs INTO g_oga.*,g_ogb.*
               CALL  p200_ins_oga() 
            END FOREACH
            IF g_success='Y' THEN 
               FOREACH p200_oha_cs INTO g_oha.*,g_ohb.*        
                  CALL  p200_ins_oha()
               END FOREACH
            END IF 
            IF g_success='Y' THEN    
               FOREACH p200_omf_cs INTO g_omf.*        
                  CALL  p200_ins_omf()
               END FOREACH
             END IF   
        END IF 
   END FOREACH
     
      CALL s_showmsg()
      IF g_success='Y' then
         commit WORK
#No.MOD-CC0218 --begin
        #4. 运行发出商品档月统计作业='Y'时，call axcp201
        IF tm.more='Y' THEN 
           LET g_wc2= cl_replace_str(g_wc2,'occ01','cfb07') 
           LET g_wc2= cl_replace_str(g_wc2,'ima01','cfb11')
           LET l_sql =" SELECT DISTINCT cfb07,cfb11 FROM cfb_file ",
                      "  WHERE cfb03='",g_plant_new,"'",
                      "   AND  YEAR(cfb06)='",tm.yy,"'",
                      "   AND MONTH(cfb06)='",tm.mm,"'",
                      "   AND  ",g_wc2 CLIPPED
          PREPARE sel_cfb_pre1 FROM l_sql
          DECLARE sel_cfb_cs1 CURSOR FOR sel_cfb_pre1
          FOREACH sel_cfb_cs1 INTO l_cfb07,l_cfb11      
           LET l_wc = 'cfb07="',l_cfb07,'" AND cfb11="',l_cfb11,'"'
           LET l_str="axcp201 '",l_wc,"' '",tm.yy,"' '",tm.mm,"' 'Y' "
           CALL cl_cmdrun_wait(l_str)
          END FOREACH
        END IF
#No.MOD-CC0218 --end
      ELSE
         ROLLBACK WORK
      END IF 
#No.MOD-CC0218 --begin
      #4. 运行发出商品档月统计作业='Y'时，call axcp201
#      IF tm.more='Y' THEN 
#         LET g_wc2= cl_replace_str(g_wc2,'occ01','cfb07') 
#         LET g_wc2= cl_replace_str(g_wc2,'ima01','cfb11')
#         LET l_sql =" SELECT DISTINCT cfb07,cfb11 FROM cfb_file ",
#                    "  WHERE cfb03='",g_plant_new,"'",
#                    "   AND  YEAR(cfb06)='",tm.yy,"'",
#                    "   AND MONTH(cfb06)='",tm.mm,"'",
#                    "   AND  ",g_wc2 CLIPPED
#        PREPARE sel_cfb_pre1 FROM l_sql
#        DECLARE sel_cfb_cs1 CURSOR FOR sel_cfb_pre1
#        FOREACH sel_cfb_cs1 INTO l_cfb07,l_cfb11      
#         LET l_wc = 'cfb07="',l_cfb07,'" AND cfb11="',l_cfb11,'"'
#         LET l_str="axcp201 '",l_wc,"' '",tm.yy,"' '",tm.mm,"' 'Y' "
#         CALL cl_cmdrun_wait(l_str)
#        END FOREACH
#      END IF
#No.MOD-CC0218 --end
END FUNCTION
   
FUNCTION p200_ins_oga()
DEFINE l_cfb     RECORD LIKE cfb_file.*

   IF g_oga.oga09='8' THEN 
      LET l_cfb.cfb00='2'
    ELSE
      LET l_cfb.cfb00='1'
    END IF 
    LET l_cfb.cfb01 =1
    LET l_cfb.cfb02 ='UNINVOICE' 
    LET l_cfb.cfb03 =g_oga.ogaplant
    LET l_cfb.cfb04 =g_oga.oga01 
    LET l_cfb.cfb05 =g_ogb.ogb03
    LET l_cfb.cfb06 =g_oga.oga02
    LET l_cfb.cfb07 =g_oga.oga03
    LET l_cfb.cfb08 =g_oga.oga032
    LET l_cfb.cfb09 =g_oga.oga14
    LET l_cfb.cfb10 =g_oga.oga15
    LET l_cfb.cfb11 =g_ogb.ogb04
    LET l_cfb.cfb12 =g_ogb.ogb05
    LET l_cfb.cfb13 =g_ogb.ogb06
    LET l_cfb.cfb14 =g_ogb.ogb09
    LET l_cfb.cfb141=g_ogb.ogb091
    LET l_cfb.cfb142=g_ogb.ogb092
    LET l_cfb.cfb15 =g_ogb.ogb12
    LET l_cfb.cfb16 = ' '
    #FUN-D70058--add--str--
    LET l_cfb.cfb061=NULL
    LET l_cfb.cfb17 =g_ogb.ogb15
    LET l_cfb.cfb18 =g_ogb.ogb15_fac
    CALL p200_get_cfb19(l_cfb.cfb11,l_cfb.cfb14,l_cfb.cfb141) RETURNING l_cfb.cfb19
    IF NOT cl_null(g_oga.oga99) THEN
       LET l_cfb.cfb20='Y'
    ELSE
       LET l_cfb.cfb20='N'
    END IF
    #FUN-D70058--add--end
    INSERT INTO cfb_file VALUES (l_cfb.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
          CALL s_errmsg('oga_file','insert',g_oga.oga01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF    
   #FUN-D70058--add--str--
   IF l_cfb.cfb20='Y' THEN
      LET l_cfb.cfb01='-1'
      LET l_cfb.cfb061=l_cfb.cfb06
      INSERT INTO cfb_file VALUES (l_cfb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
         CALL s_errmsg('oga_file','insert',g_oga.oga01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #FUN-D70058--add--end
END FUNCTION

FUNCTION p200_ins_oha()
DEFINE l_cfb    RECORD LIKE cfb_file.*

    LET l_cfb.cfb00='3'
    LET l_cfb.cfb01=1
    LET l_cfb.cfb02='UNINVOICE'
    LET l_cfb.cfb03=g_oha.ohaplant
    LET l_cfb.cfb04=g_oha.oha01
    LET l_cfb.cfb05=g_ohb.ohb03
    LET l_cfb.cfb06=g_oha.oha02
    LET l_cfb.cfb07=g_oha.oha03
    LET l_cfb.cfb08=g_oha.oha032
    LET l_cfb.cfb09=g_oha.oha14
    LET l_cfb.cfb10=g_oha.oha15
    LET l_cfb.cfb11=g_ohb.ohb04
    LET l_cfb.cfb12=g_ohb.ohb05
    LET l_cfb.cfb13=g_ohb.ohb06
    LET l_cfb.cfb14=g_ohb.ohb09
    LET l_cfb.cfb141=g_ohb.ohb091
    LET l_cfb.cfb142=g_ohb.ohb092
    LET l_cfb.cfb15=g_ohb.ohb12*(-1)
    LET l_cfb.cfb16 = ' '
     #FUN-D70058--add--str--
    LET l_cfb.cfb061=NULL
    LET l_cfb.cfb17 =g_ohb.ohb15
    LET l_cfb.cfb18 =g_ohb.ohb15_fac
    CALL p200_get_cfb19(l_cfb.cfb11,l_cfb.cfb14,l_cfb.cfb141) RETURNING l_cfb.cfb19
    IF NOT cl_null(g_oha.oha99) THEN
       LET l_cfb.cfb20='Y'
    ELSE
       LET l_cfb.cfb20='N'
    END IF
    #FUN-D70058--add--end
    INSERT INTO cfb_file VALUES (l_cfb.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
          CALL s_errmsg('oha_file','insert',g_oha.oha01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
    #FUN-D70058--add--str--
   IF l_cfb.cfb20='Y' THEN
      LET l_cfb.cfb01='-1'
      LET l_cfb.cfb061=l_cfb.cfb06
      INSERT INTO cfb_file VALUES (l_cfb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
         CALL s_errmsg('oha_file','insert',g_oha.oha01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #FUN-D70058--add--end      
END FUNCTION

FUNCTION p200_ins_omf()   
 DEFINE l_sql   STRING    
 DEFINE l_cfb   RECORD LIKE cfb_file.*
 DEFINE l_oga14        LIKE oga_file.oga14
 DEFINE l_oga15        LIKE oga_file.oga15
 DEFINE l_ogb04        LIKE ogb_file.ogb04
 DEFINE l_ogb05        LIKE ogb_file.ogb05
 DEFINE l_ogb092       LIKE ogb_file.ogb092
 DEFINE l_oha14        LIKE oha_file.oha14
 DEFINE l_oha15        LIKE oha_file.oha15
 DEFINE l_ohb04        LIKE ohb_file.ohb04
 DEFINE l_ohb05        LIKE ohb_file.ohb05
 DEFINE l_ohb092       LIKE ohb_file.ohb092
 DEFINE l_oga99        LIKE oga_file.oga99  #FUN-D70058
 DEFINE l_oha99        LIKE oha_file.oha99  #FUN-D70058
 DEFINE l_oga02        LIKE oga_file.oga02  #CHI-E40001 140401 add
 DEFINE l_oha02        LIKE oha_file.oha02  #CHI-E40001 140401 add
 
 
   IF g_omf.omf10='1' THEN 
      IF g_oga.oga09='8' THEN 
         LET l_cfb.cfb00='2' 
      ELSE 
         LET l_cfb.cfb00='1' 
      END IF 
    END IF 

    IF g_omf.omf10='2' THEN LET l_cfb.cfb00='3' END IF 

    LET  l_cfb.cfb01= -1 
    LET  l_cfb.cfb02=g_omf.omf01
    LET  l_cfb.cfb03=g_omf.omf09
    LET  l_cfb.cfb04=g_omf.omf11
    LET  l_cfb.cfb05=g_omf.omf12
    LET  l_cfb.cfb07=g_omf.omf05
    #LET  l_cfb.cfb06=g_omf.omf03  #CHI-E40001 mark
    LET  l_cfb.cfb08=g_omf.omf051
    LET  l_cfb.cfb061=g_omf.omf03 #FUN-D70058

    IF l_cfb.cfb00='3' THEN
       LET l_sql=" SELECT oha14,oha15,ohb04,ohb05,ohb092,ohb15,ohb15_fac,oha99,oha02 ", #FUN-D70058 add ohb15,ohb15_fac,oha99 #CHI-E40001 add oha02
                 " FROM ",cl_get_target_table(g_plant_new,'oha_file'),",",
                          cl_get_target_table(g_plant_new,'ohb_file'),
                 " WHERE oha01='",l_cfb.cfb04,"' AND ohb03='",l_cfb.cfb05,"' AND oha01=ohb01 "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
        PREPARE p200_oha_pre2 FROM l_sql
        EXECUTE p200_oha_pre2 INTO l_oha14,l_oha15,l_ohb04,l_ohb05,l_ohb092
        													,l_cfb.cfb17,l_cfb.cfb18,l_oha99,l_oha02  #FUN-D70058 #CHI-E40001 add oha02
        LET  l_cfb.cfb09=l_oha14
        LET  l_cfb.cfb10=l_oha15
        LET  l_cfb.cfb11=l_ohb04
        LET  l_cfb.cfb12=l_ohb05
        LET  l_cfb.cfb06 = l_oha02  #CHI-E40001 add        
        LET  l_cfb.cfb142=l_ohb092
        #FUN-D70058--add--str--
        IF NOT cl_null(l_oha99) THEN
           LET l_cfb.cfb20='Y'
        ELSE
           LET l_cfb.cfb20='N'
        END IF
        #FUN-D70058--add--end
     ELSE  
         LET l_sql=" SELECT oga14,oga15,ogb04,ogb05,ogb092,ogb15,ogb15_fac,oga99,oga02 ", #FUN-D70058 add ogb15,ogb15_fac,oga99
                  " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",
                          cl_get_target_table(g_plant_new,'ogb_file'),
                  " WHERE oga01='",l_cfb.cfb04,"' AND ogb03='",l_cfb.cfb05,"'AND oga01=ogb01 "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
        PREPARE p200_oga_pre2 FROM l_sql
        EXECUTE p200_oga_pre2 INTO l_oga14,l_oga15,l_ogb04,l_ogb05,l_ogb092
        													,l_cfb.cfb17,l_cfb.cfb18,l_oga99,l_oga02  #FUN-D70058
        LET  l_cfb.cfb09=l_oga14
        LET  l_cfb.cfb10=l_oga15
        LET  l_cfb.cfb11=l_ogb04
        LET  l_cfb.cfb12=l_ogb05
        LET  l_cfb.cfb06 = l_oga02  #CHI-E40001 add        
        LET  l_cfb.cfb142=l_ogb092
         #FUN-D70058--add--str--
        IF NOT cl_null(l_oga99) THEN
           LET l_cfb.cfb20='Y'
        ELSE
           LET l_cfb.cfb20='N'
        END IF
        #FUN-D70058--add--end         
     END IF  
    
    LET l_cfb.cfb13=g_omf.omf14
    LET l_cfb.cfb14=g_omf.omf20
    LET l_cfb.cfb141=g_omf.omf201
    LET l_cfb.cfb15=g_omf.omf16    
    LET l_cfb.cfb16 = g_omf.omf02
    IF cl_null(g_omf.omf01) THEN LET l_cfb.cfb02 = g_omf.omf00 END IF #TQC-C80008
    IF cl_null(g_omf.omf02) THEN LET l_cfb.cfb16 = ' ' END IF #TQC-C80008
    CALL p200_get_cfb19(l_cfb.cfb11,l_cfb.cfb14,l_cfb.cfb141) RETURNING l_cfb.cfb19 #FUN-D70058
    
    INSERT INTO cfb_file VALUES (l_cfb.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
          CALL s_errmsg('omf_file','insert',g_omf.omf01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
END FUNCTION
#FUN-C60033
   
#抓取科目編號
#FUN-D70058--add--str--
FUNCTION p200_get_cfb19(p_cfb11,p_cfb14,p_cfb141)
   DEFINE p_cfb11  LIKE cfb_file.cfb11
   DEFINE p_cfb14  LIKE cfb_file.cfb14
   DEFINE p_cfb141 LIKE cfb_file.cfb141
   DEFINE l_actno  LIKE aag_file.aag01
   DEFINE l_sql    STRING
   
   CASE 
      WHEN g_ccz.ccz07='1' 
         LET l_sql = "SELECT ima163 FROM ",cl_get_target_table(g_plant_new,'ima_file'),  #150706wudj mod ima149 to ima163
                     " WHERE ima01='",p_cfb11,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_ima39_pre1 FROM l_sql
         EXECUTE sel_ima39_pre1 INTO l_actno
      WHEN g_ccz.ccz07='2' 
         LET l_sql = "SELECT imz73 ",
                     "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                     "      ,",cl_get_target_table(g_plant_new,'imz_file'),
                     " WHERE ima01='",p_cfb11,"' AND ima06=imz01"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_imz39_pre FROM l_sql
         EXECUTE sel_imz39_pre INTO l_actno           
      WHEN g_ccz.ccz07='3' 
         LET l_sql = "SELECT imd21 FROM ",cl_get_target_table(g_plant_new,'imd_file'),
                     " WHERE imd01='",p_cfb14,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_imd08_pre FROM l_sql
         EXECUTE sel_imd08_pre INTO l_actno
      WHEN g_ccz.ccz07='4'
         LET l_sql = "SELECT ime13 FROM ",cl_get_target_table(g_plant_new,'ime_file'),
                     " WHERE ime01='",p_cfb14,"' ",
                     "   AND ime02='",p_cfb141,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_ime09_pre FROM l_sql
         EXECUTE sel_ime09_pre INTO l_actno      
      OTHERWISE        LET l_actno='STOCK'
   END CASE
   RETURN l_actno
END FUNCTION

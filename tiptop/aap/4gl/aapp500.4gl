# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp500.4gl
# Descriptions...: 關帳作業 
# Date & Author..: 97/05/08 By Danny
# Modify.........: No.MOD-610036 06/01/11 By Smapmin 已有評價資料就不可再執行關帳
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-830034 08/03/05 By Smapmin 加上系統類型來判斷是否有重評資料
# Modify.........: No.MOD-860333 08/07/08 By Sarah 判斷若已存在的重評價年月資料大於輸入的apz57的年月則顯示aap-916訊息
# Modify.........: No.MOD-950134 09/05/17 By Sarah 顯示關帳日期時，應重新擷取目前關帳日
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40011 10/04/09 By Summer 檢查若有入庫或倉退單無發票者,且未產生至aapt160/aapt260則不允許關帳
# Modify.........: No.FUN-A60056 10/06/21 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:MOD-A80054 10/08/06 By Dido 檢核調整排除作廢;存在入庫若暫估其一即可;單價為0 
# Modify.........: No:MOD-A90017 10/09/03 By Dido 倉退單檢核應排除 apb11 IS NULL 條件 
# Modify.........: No:MOD-B30632 11/03/22 By Dido 排除樣品資料 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:MOD-B70142 11/07/15 By lilingyu 若應付系統採用計價數量(採購),若計價數量為0的時候,應付賬款無法立賬,而在aapp500中無此邏輯,導致無法關帳
# Modify.........: No:MOD-BA0135 11/10/19 By Polly 增加sma116 = '3'的條件判斷關帳限制
# Modify.........: No:MOD-C10069 12/01/10 By Polly 檢核入庫單需排除VIM的入庫單
# Modify.........: No:MOD-C20148 12/02/16 By yinhy 判斷是否立賬時，需要考慮數據庫
# Modify.........: No:MOD-C80121 12/08/15 By yinhy mark MOD-610036
# Modify.........: No:FUN-D40111 13/05/09 By lujh 程序優化
# Modify.........: No:MOD-D40132 13/05/24 By SunLM  關帳日期不可小於等於主帳別總賬關帳日期
# Modify.........: No:yinhy130717 13/0731 By yinhy MISC料件给出提示，可以不影响关账

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
               aaa04  LIKE aaa_file.aaa04,
               aaa05  LIKE aaa_file.aaa05,
               apz57  LIKE apz_file.apz57 
               END RECORD,
     g_change_lang   LIKE type_file.chr1,                 #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
     g_aaa04   LIKE type_file.num5,        # No.FUN-690028 SMALLINT                 #現行會計年度
     g_aaa05   LIKE type_file.num5,        # No.FUN-690028 SMALLINT		 #現行期別
     g_apz57   LIKE type_file.dat          # No.FUN-690028 DATE                      #現行關帳年度
DEFINE g_azw01 LIKE azw_file.azw01         # No.FUN-A60056 
DEFINE g_sql   STRING                      # No.FUN-A60056 

MAIN
    DEFINE ls_date         STRING,                #->No.FUN-570112
           l_flag          LIKE type_file.chr1    #->No.FUN-570112  #No.FUN-690028 VARCHAR(1)
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.aaa04 = ARG_VAL(1)             #現行會計年度
   LET tm.aaa05 = ARG_VAL(2)             #期別
   LET ls_date  = ARG_VAL(3)
   LET tm.apz57 = cl_batch_bg_date_convert(ls_date)   #關帳日期
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0055

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL aapp500_tm()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            UPDATE apz_file SET apz57 = tm.apz57
            IF STATUS THEN LET g_success = 'N' END IF
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aapp500_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW aapp500_w
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         UPDATE apz_file SET apz57 = tm.apz57
         IF STATUS THEN LET g_success = 'N' END IF
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-6A0055
END MAIN
 
FUNCTION aapp500_tm()
   DEFINE l_str     LIKE occ_file.occ02,    #No.FUN-690028 VARCHAR(30)
          l_year    LIKE oox_file.oox01,    #MOD-610036
          l_month   LIKE oox_file.oox02,    #MOD-610036
          l_year1   LIKE oox_file.oox01,    #MOD-860333 add
          l_month1  LIKE oox_file.oox02,    #MOD-860333 add
         #l_flag    LIKE type_file.chr1     #No.FUN-570112  #No.FUN-690028 VARCHAR(1)
          lc_cmd    LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(500)      #No.FUN-570112
   #No.CHI-A40011 add --start--
   DEFINE l_rvu00   LIKE rvu_file.rvu00,
          l_rvu01   LIKE rvu_file.rvu01
   DEFINE l_bdate   LIKE type_file.dat,
          l_edate   LIKE type_file.dat
   DEFINE l_cnt1    LIKE type_file.num10,
          l_cnt2    LIKE type_file.num10
   #No.CHI-A40011 add --end--
   DEFINE l_rvv87   LIKE rvv_file.rvv87      #MOD-B70142
   DEFINE l_sql     STRING                   #MOD-B70142
   DEFINE l_chr     LIKE type_file.chr1      #MOD-B70142
   DEFINE l_aaa07   LIKE aaa_file.aaa07      #MOD-D40132 add]
   DEFINE l_rvu01_t LIKE rvu_file.rvu01      #yinhy130717
   DEFINE l_count   LIKE type_file.num5      #yinhy130717
   DEFINE l_rvv31   LIKE rvv_file.rvv31      #yinhy130717
   DEFINE l_flag    LIKE type_file.chr1      #yinhy130717
    
   LET l_year = 0   LET l_month = 0    #MOD-830034
   LET l_year1= 0   LET l_month1= 0    #MOD-860333 add
 
   OPEN WINDOW aapp500_w WITH FORM "aap/42f/aapp500"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF s_aapshut(0) THEN RETURN END IF
   INITIALIZE tm.* TO NULL			# Defaealt condition
   SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file 
    WHERE aaa01 = g_apz.apz02b
   SELECT * INTO g_apz.* FROM apz_file   #MOD-950134 add
   LET tm.aaa04 = g_aaa04
   LET tm.aaa05 = g_aaa05
   LET tm.apz57 = g_apz.apz57
 
#->No.FUN-570112 --start--
   LET g_bgjob = "N"
#->No.FUN-570112 ---end---
 
 #FUN-D40111--add--str--
   DROP TABLE aapp500_tmp;
   CREATE TEMP TABLE aapp500_tmp(
                rvu01     LIKE rvu_file.rvu01,
                rvv31     LIKE rvv_file.rvv31)        #yinhy130717
   #FUN-D40111--add--end--
 
WHILE TRUE
   LET g_action_choice = ""
 
   CLEAR FORM 
   DISPLAY BY NAME tm.aaa04,tm.aaa05 
 #  INPUT BY NAME tm.apz57 WITHOUT DEFAULTS   #NO.FUN-570112 MARK
   INPUT BY NAME tm.apz57,g_bgjob WITHOUT DEFAULTS
 
      AFTER FIELD apz57
         IF cl_null(tm.apz57) THEN 
            NEXT FIELD apz57 
         END IF
         #MOD-D40132 add beg-----
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
         IF tm.apz57 <=l_aaa07 THEN 
            CALL cl_err(l_aaa07,'asm-994',1)
            NEXT FIELD apz57
         END IF     
         #MOD-D40132 add end-----           
        #No.MOD-C80121  --Mark Begin
        #-----MOD-610036---------
        #IF g_aza.aza26 = '2' THEN
        #   LET l_year1  = YEAR(tm.apz57)    #MOD-860333 add
        #   LET l_month1 = MONTH(tm.apz57)   #MOD-860333 add
        #   DECLARE oox_cs CURSOR FOR
        #      #SELECT oox01,oox02 FROM oox_file   #MOD-830034
        #      SELECT oox01,oox02 FROM oox_file WHERE oox00='AP'  #MOD-830034
        #       ORDER BY oox01,oox02   #MOD-860333 add
        #   FOREACH oox_cs INTO l_year,l_month  
        #     #IF l_year=YEAR(tm.apz57) AND l_month=MONTH(tm.apz57) THEN   #MOD-860333 mark
        #      IF (l_year*12+l_month) > (l_year1*12+l_month1) THEN         #MOD-860333
        #         CALL cl_err('','aap-916',1)
        #         NEXT FIELD apz57
        #      END IF
        #   END FOREACH
        #END IF
        #-----END MOD-610036-----
        #No.MOD-C80121  --Mark End
 
      #No.CHI-A40011 add --start--
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         CALL s_mothck(tm.apz57) RETURNING l_bdate,l_edate
         CALL s_showmsg_init()
         LET g_success = 'Y'
        #FUN-A60056--mod--str--
        #DECLARE rvu_cs CURSOR FOR
        #   SELECT rvu00,rvu01 FROM rvu_file
        #     WHERE rvu03 BETWEEN l_bdate AND l_edate 
         LET g_sql = "SELECT azw01 FROM azw_file ",
                     " WHERE azwacti = 'Y'",
                     "   AND azw02 = '",g_legal,"'"
         PREPARE sel_azw FROM g_sql
         DECLARE sel_azw01 CURSOR FOR sel_azw
         FOREACH sel_azw01 INTO g_azw01 
          #FUN-D40111--add--str-- 
            DELETE FROM aapp500_tmp
            LET g_sql = "INSERT INTO aapp500_tmp ",
                        "SELECT rvu01,rvv31 ",
                        "  FROM ",cl_get_target_table(g_azw01,'rvu_file')," a,",       
                        "       ",cl_get_target_table(g_azw01,'rvv_file'),            
                        " WHERE rvu03 BETWEEN '",l_bdate,"'" ," AND '",l_edate,"'", 
                        "   AND rvu01 = rvv01 AND rvv38 > 0 AND rvuconf <> 'X' ",     
                        "   AND rvv25 = 'N' ",                                         
                        "   AND rvv89 != 'Y' ",
                        "   AND NOT EXISTS (SELECT 1 FROM ( ",
                        "   SELECT DISTINCT rvu01",
                        "  FROM ",cl_get_target_table(g_azw01,'apa_file'),",",
                        "       ",cl_get_target_table(g_azw01,'apb_file'),",",
                        "       ",cl_get_target_table(g_azw01,'rvv_file'),",",
                        cl_get_target_table(g_azw01,'rvu_file'),            
                        " WHERE rvv38 > 0  AND rvuconf <> 'X'",
                        "   AND rvu03 BETWEEN '",l_bdate,"'" ," AND '",l_edate,"'", 
                        "   AND rvu01 = rvv01 ",
                        "   AND rvv25 = 'N' ",                                         
                        "   AND rvv89 != 'Y' ",
                        "   AND apa01 = apb01 AND apa00 IN ('11','16') ",     
                        "   AND rvu01 = apb21 AND rvu00 = '1') b WHERE a.rvu01 = b.rvu01 )",
                        "   AND rvu00 = '1'"
            IF g_sma.sma116 = '1'OR g_sma.sma116 = '3'  THEN
               LET g_sql = g_sql," AND rvv87 != 0"
            END IF            
            LET g_sql = g_sql,"  ORDER BY rvu01"        #yinhy130717
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
            PREPARE p500_ins_1 FROM g_sql
            EXECUTE p500_ins_1
     
            LET g_sql = "SELECT rvu01,rvv31 FROM aapp500_tmp"       #yinhy130717 add rvv31
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
            PREPARE p500_rvu01_pre_1 FROM g_sql 
            DECLARE p500_rvu01_cs_1 CURSOR FOR p500_rvu01_pre_1
            LET l_count = 0   #yinhy130717 
            LET l_flag = 'N'  #yinhy130717 
            FOREACH p500_rvu01_cs_1 INTO l_rvu01,l_rvv31            #yinhy130717 add rvv31                     
               #No.yinhy130717  --Begin
               LET l_count = l_count + 1 
               IF l_count = 1 THEN
               	  LET l_rvu01_t = l_rvu01
               END IF  
               IF l_rvu01_t <> l_rvu01 OR l_count = 1 THEN 
               	  LET l_cnt1 = 0
               	  LET l_cnt2 = 0
                  SELECT COUNT(*) INTO l_cnt1 FROM  aapp500_tmp WHERE rvu01=l_rvu01 AND rvv31 LIKE 'MISC%'
                  SELECT COUNT(*) INTO l_cnt2 FROM  aapp500_tmp WHERE rvu01=l_rvu01
                  IF l_cnt1 = l_cnt2 THEN      
                  	 IF l_flag = 'N' THEN
                        IF cl_confirm('aap-241') THEN 
               	           LET l_flag = 'Y'
               	        ELSE
               	           LET g_success = 'N'
               	           CALL s_errmsg('apb21',l_rvu01,'','aap-346',1) 
               	        END IF
               	     END IF 
               	  ELSE
               	     LET g_success = 'N'
                     CALL s_errmsg('apb21',l_rvu01,'','aap-506',1) 
               	  END IF
               #ELSE                                   
               #   LET g_success = 'N'
               #   CALL s_errmsg('apb21',l_rvu01,'','aap-506',1)
               END IF
               LET l_rvu01_t = l_rvu01
               #No.yinhy130717  --End
            END FOREACH 
            
            DELETE FROM aapp500_tmp
            LET g_sql = "INSERT INTO aapp500_tmp ",
                        "SELECT rvu01,rvv31 ",
                        "  FROM ",cl_get_target_table(g_azw01,'rvu_file')," a,",        
                        "       ",cl_get_target_table(g_azw01,'rvv_file'),            
                        " WHERE rvu03 BETWEEN '",l_bdate,"'" ," AND '",l_edate,"'", 
                        "   AND rvu01 = rvv01 AND rvv38 > 0 AND rvuconf <> 'X' ",     
                        "   AND rvv25 = 'N' ",                                        
                        "   AND rvv89 != 'Y' ",
                        "   AND NOT EXISTS (SELECT 1 FROM ( ",
                        "   SELECT DISTINCT rvu01",
                        "  FROM ",cl_get_target_table(g_azw01,'apa_file'),",",
                        "       ",cl_get_target_table(g_azw01,'apb_file'),",",
                        "       ",cl_get_target_table(g_azw01,'rvv_file'),",", 
                        cl_get_target_table(g_azw01,'rvu_file'),            
                        " WHERE rvv38 > 0  AND rvuconf <> 'X'",
                        "   AND rvu03 BETWEEN '",l_bdate,"'" ," AND '",l_edate,"'", 
                        "   AND rvu01 = rvv01 ",
                        "   AND rvv25 = 'N' ",                                         
                        "   AND rvv89 != 'Y' ",
                       #"   AND apa01 = apb01 AND apa00 IN ('11','16') ",                     #MOD-D50188 mark
                        "   AND apa01 = apb01 AND apa00 IN ('11','21','26') ",                #MOD-D50188 add
                       # "   AND rvu01 = apb21 AND rvu00 = '1') b WHERE a.rvu01 = b.rvu01 )",
                       "   AND rvu01 = apb21 AND rvu00 ='3') b WHERE a.rvu01 = b.rvu01 )",  #yinhy130717
                        "   AND rvu00 = '3'" 
            LET g_sql = g_sql,"  ORDER BY rvu01"        #yinhy130717            
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
            PREPARE p500_ins_2 FROM g_sql
            EXECUTE p500_ins_2

            LET g_sql = "SELECT rvu01,rvv31 FROM aapp500_tmp"        #yinhy130717
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
            PREPARE p500_rvu01_pre_2 FROM g_sql 
            DECLARE p500_rvu01_cs_2 CURSOR FOR p500_rvu01_pre_2
            LET l_count = 0   #yinhy130717 
            LET l_flag = 'N'  #yinhy130717 
            FOREACH p500_rvu01_cs_2 INTO l_rvu01,l_rvv31            #yinhy130717
               #No.yinhy130717  --Begin
               LET l_count = l_count + 1 
               IF l_count = 1 THEN
               	  LET l_rvu01_t = l_rvu01
               END IF  
               IF l_rvu01_t <> l_rvu01 OR l_count = 1 THEN 
               	  LET l_cnt1 = 0
               	  LET l_cnt2 = 0
                  SELECT COUNT(*) INTO l_cnt1 FROM  aapp500_tmp WHERE rvu01=l_rvu01 AND rvv31 LIKE 'MISC%'
                  SELECT COUNT(*) INTO l_cnt2 FROM  aapp500_tmp WHERE rvu01=l_rvu01
                  IF l_cnt1 = l_cnt2 THEN      
                  	 IF l_flag = 'N' THEN
                        IF cl_confirm('aap-347') THEN 
               	           LET l_flag = 'Y'
               	        ELSE
               	           LET g_success = 'N'
               	           CALL s_errmsg('apb21',l_rvu01,'','aap-299',1) 
               	        END IF
               	     END IF 
               	  ELSE
               	     LET g_success = 'N'
                     CALL s_errmsg('apb21',l_rvu01,'','aap-507',1) 
               	  END IF
               #ELSE                                   
               #   LET g_success = 'N'
               #   CALL s_errmsg('apb21',l_rvu01,'','aap-507',1)
               END IF
               LET l_rvu01_t = l_rvu01
               #No.yinhy130717  --End
            END FOREACH 
            #FUN-D40111--add--end-- 
                         
#FUN-D40111--mark--str--            
#           LET g_sql = "SELECT rvu00,rvu01 ",
#                       "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),",",        #MOD-A80054
#                       "       ",cl_get_target_table(g_azw01,'rvv_file'),            #MOD-A80054
#                       " WHERE rvu03 BETWEEN '",l_bdate,"'" ," AND '",l_edate,"'", 
#                       "   AND rvu01 = rvv01 AND rvv38 > 0 AND rvuconf <> 'X' ",     #MOD-A80054
#                       "   AND rvv25 = 'N' ",                                        #MOD-B30632 
#                       "   AND rvv89 != 'Y' "                                        #MOD-C10069 add
#           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#           CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
#           PREPARE sel_rvu00_pre FROM g_sql 
#           DECLARE rvu_cs CURSOR FOR sel_rvu00_pre
#       #FUN-A60056--mod--end
#           FOREACH rvu_cs INTO l_rvu00,l_rvu01
#              CASE l_rvu00
#                WHEN '1' #入庫部分
#                 #FUN-A60056--mod--str--
#                 #SELECT count(*) INTO l_cnt1 FROM apb_file,apa_file,rvu_file
#                 #  WHERE apb21 = l_rvu01
#                 #    AND apa01 = apb01
#                 #    AND apa00 <> '16' 
#                 #    AND rvu01 = apb21
#                 #    AND rvu00 = '1'
#                 #No.MOD-C20148  --Begin
#                 #LET g_sql = "SELECT count(*) FROM apb_file,apa_file,",
#                 LET g_sql = "SELECT count(*) ",
#                             "  FROM ",cl_get_target_table(g_azw01,'apa_file'),",",
#                             "       ",cl_get_target_table(g_azw01,'apb_file'),",",
#                 #No.MOD-C20148  --End
#                             cl_get_target_table(g_azw01,'rvu_file'),            
#                             " WHERE apb21 = '",l_rvu01,"'",
#                            #"   AND apa01 = apb01 AND apa00 <> '16'",             #MOD-A80054 mark
#                             "   AND apa01 = apb01 AND apa00 IN ('11','16') ",     #MOD-A80054
#                             "   AND rvu01 = apb21 AND rvu00 = '1'"
#                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#                 CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
#                 PREPARE sel_cou_apb FROM g_sql
#                 EXECUTE sel_cou_apb INTO l_cnt1
##MOD-B70142--begin--
#                #IF g_sma.sma116 = '1' THEN                                                    #MOD-BA0135 mark
#                 IF g_sma.sma116 = '1'OR g_sma.sma116 = '3'  THEN                              #MOD-BA0135 add
#                   #LET l_sql = "SELECT rvv87 FROM cl_get_target_table(g_azw01,'rvv_file')",   #MOD-BA0135 mark
#                   #            " WHERE rvv01 = l_rvu01"                                       #MOD-BA0135 mark
#                    LET l_sql = "SELECT rvv87 FROM ",                                          #MOD-BA0135 add
#                                 cl_get_target_table(g_azw01,'rvv_file'),                      #MOD-BA0135 add
#                                " WHERE rvv01 = '",l_rvu01,"'"                                 #MOD-BA0135 add
#                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#                    CALL cl_parse_qry_sql(l_sql,g_azw01) RETURNING l_sql

#                    PREPARE rvv87_p1 FROM l_sql
#                    DECLARE rvv87_cs CURSOR WITH HOLD FOR rvv87_p1
#                    
#                    LET l_chr = 'N'
#                    FOREACH rvv87_cs INTO l_rvv87
#                       IF l_rvv87 != 0 THEN 
#                          LET l_chr = 'Y'
#                          EXIT FOREACH 
#                       END IF                         
#                    END FOREACH        
#                    
#                    IF l_chr = 'Y' AND l_cnt1 = 0 THEN 
#                       LET g_success = 'N'
#                       CALL s_errmsg('apb21',l_rvu01,'','aap-506',1)
#                    END IF            
#                 ELSE 
##MOD-B70142--end--                        
#                 #FUN-A60056--mod--end 
#                  IF l_cnt1 = 0 THEN
#                     #CALL cl_err('aapp500','aap-506',1)
#                     LET g_success = 'N'
#                     CALL s_errmsg('apb21',l_rvu01,'','aap-506',1)
#                  END IF
#              END IF       #MOD-B70142 
#                                     
#                WHEN '3' #倉退部分
#                 #FUN-A60056--mod--str--
#                 #SELECT count(*) INTO l_cnt2 FROM apb_file,apa_file,rvu_file
#                 #  WHERE apb21 = l_rvu01
#                 #    AND apa01 = apb01
#                 #    AND apa00 <> '26'
#                 #    AND apb11 is null
#                 #    AND rvu01 = apb21
#                 #    AND rvu00 = '3'
#                 #No.MOD-C20148  --Begin
#                 #LET g_sql = "SELECT count(*) FROM apb_file,apa_file,",
#                 LET g_sql = "SELECT count(*) ",
#                             "  FROM ",cl_get_target_table(g_azw01,'apa_file'),",",      
#                             "       ",cl_get_target_table(g_azw01,'apb_file'),",",
#                 #No.MOD-C20148  --End
#                               cl_get_target_table(g_azw01,'rvu_file'),
#                              " WHERE apb21 = '",l_rvu01,"'",
#                             #"   AND apa01 = apb01 AND apa00 <> '26' ",             #MOD-A90017 mark
#                              "   AND apa01 = apb01 AND apa00 IN ('11','21','26') ", #MOD-A90017
#                             #"   AND apb11 is null AND rvu01 = apb21 ",             #MOD-A90017 mark
#                              "   AND rvu01 = apb21 ",                               #MOD-A90017
#                              "   AND rvu00 = '3'"
#                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#                  CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
#                  PREPARE sel_cou_apb1 FROM g_sql
#                  EXECUTE sel_cou_apb1 INTO l_cnt2
#                 #FUN-A60056--mod--end
#                  IF l_cnt2 = 0 THEN
#                     #CALL cl_err('aapp500','aap-507',1)
#                     LET g_success = 'N'
#                     CALL s_errmsg('apb21',l_rvu01,'','aap-507',1)
#                  END IF
#              END CASE
#           END FOREACH
#FUN-D40111--mark--end--
         END FOREACH    #FUN-A60056
         IF g_success ='N' THEN
            CALL s_showmsg()
            NEXT FIELD apz57
         END IF
         #No.CHI-A40011 add --end--
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
        #->No.FUN-570112 --start--
        #LET g_action_choice='locale'
        #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE
        #->No.FUN-570112 ---end---
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570112 MARK---
#   IF INT_FLAG THEN 
#      LET INT_FLAG = 0
#      EXIT PROGRAM 
#   END IF
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#   IF cl_sure(17,21) THEN
#      CALL cl_wait()
#      LET g_success = 'Y'
#      BEGIN WORK
#      UPDATE apz_file SET apz57 = tm.apz57
#      IF STATUS THEN LET g_success = 'N' END IF
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
#   ERROR ""
#NO.FUN-570112 MARK
#NO.FUN-570112 START---
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aapp500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp500"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp500','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.aaa04 CLIPPED,"'",
                      " '",tm.aaa05 CLIPPED,"'",
                      " '",tm.apz57 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp500',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW aapp500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
  #->No.FUN-570112 ---end---
END WHILE
END FUNCTION

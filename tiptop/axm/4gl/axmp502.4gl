# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp502.4gl
# Descriptions...: 訂單分配拋轉作業
# Date & Author..: No.FUN-630006 06/03/08 By Nicola
# Modify.........: No.FUN-640025 06/04/08 By Nicola 取消欄位oaz19的判斷
# Modify.........: No.MOD-640030 06/04/08 By Nicola 取價修改
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modfiy.........: No.CHI-690043 06/11/21 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modify.........: NO.FUN-670007 06/11/28 by Yiting poz_file相關資料應修改
# Modify.........: No.FUN-710046 07/01/18 By Carrier 錯誤訊息匯整
# Modify.........: No.TQC-740036 07/04/09 By Ray 增加'語言'轉換功能
# Modify.........: No.MOD-750018 07/05/08 By claire 分配後的第0站PO的單價要依原CO及該站PO的幣別做轉換
# Modify.........: No.MOD-770086 07/07/18 By claire 匯率取不到當日應取最近一日
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.FUN-810045 08/02/14 By rainy 轉採購單將項目相關欄位帶入
# Modify.........: No.FUN-7B0018 08/03/07 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-8A0161 08/10/17 By claire 採購變更要可以變更數量
# Modify.........：No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980010 09/08/27 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/10/31 By post no
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:FUN-A30056 10/04/13 By Carrier call p801时,给是否IN TRANSACTION标志位
# Modify.........: No:TQC-A40113 10/04/22 By lilingyu 訂單多次分配時,會重復產生采購單
# Modify.........: No:TQC-A50014 10/05/04 By lilingyu "資料拋轉"時,報錯-391:無法將NULL插入欄
# Modify.........: No:TQC-A50056 10/05/17 By lilingyu 訂單分配作業拋轉多筆資料後,生成的單價項次重複 
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行製程
# Modify.........: No.FUN-B70015 11/07/07 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No.FUN-BB0084 11/11/23 By lixh1 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oee   DYNAMIC ARRAY OF RECORD LIKE oee_file.* 
DEFINE g_oee_t RECORD LIKE oee_file.* 
DEFINE g_wc,g_sql     STRING                       #NO.FUN-9B0016 
DEFINE g_rec_b        LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_ac           LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE li_result      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_argv1        LIKE oee_file.oee01
DEFINE g_argv2        LIKE oee_file.oee02
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
  #-----No.FUN-640025 Mark-----
  #IF g_oaz.oaz19 = "N" THEN
  #   EXIT PROGRAM
  #END IF
  #-----No.FUN-640025 Mark END-----
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0094
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_msg = ""
   
   IF cl_null(g_argv1) THEN
      CALL p502_p1()
   ELSE 
      LET g_wc = "oee01 ='",g_argv1,"' AND oee02 =",g_argv2
      CALL p502_p2()
 
      IF g_success = "Y" THEN
         COMMIT WORK
         IF NOT cl_null(g_msg) THEN
            LET g_msg = " pmm01 in (",g_msg CLIPPED,")"
           #CALL p801(g_msg,"A")          #No.FUN-A30056                        
            CALL p801(g_msg,"A",FALSE)    #No.FUN-A30056
         END IF
         CALL cl_err("","abm-019",1)
      ELSE
         ROLLBACK WORK
         CALL cl_err("","abm-020",1)
      END IF
   END IF
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0094
 
END MAIN
 
FUNCTION p502_p1()
   DEFINE l_flag   LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPEN WINDOW p502_w WITH FORM "axm/42f/axmp502"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON oee01,oee02,oee03,oee04,oee05 
      
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oee01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oea11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oee01
                  NEXT FIELD oee01
               WHEN INFIELD(oee03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_poz"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oee03
                  NEXT FIELD oee03
               WHEN INFIELD(oee04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oee04
                  NEXT FIELD oee04
         END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         #No.TQC-740036 --begin
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         #No.TQC-740036 --end
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #No.TQC-740036 --begin
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE 
      END IF
      #No.TQC-740036 --end
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         CALL p502_p2()
         IF g_success = 'Y' THEN
            COMMIT WORK
            IF NOT cl_null(g_msg) THEN
               LET g_msg = " pmm01 in (",g_msg CLIPPED,")"
              #CALL p801(g_msg,"A")          #No.FUN-A30056                        
               CALL p801(g_msg,"A",FALSE)    #No.FUN-A30056
            END IF
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
     
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p502_w
 
END FUNCTION
 
FUNCTION p502_p2()
   DEFINE l_pmm     RECORD LIKE pmm_file.*
   DEFINE l_pmn     RECORD LIKE pmn_file.*
   DEFINE o_oea     RECORD LIKE oea_file.*
   DEFINE o_oeb     RECORD LIKE oeb_file.*
#TQC-A50056 --begin--
#  DEFINE l_oee     RECORD LIKE oee_file.*  
   DEFINE l_oee     DYNAMIC ARRAY OF RECORD
          oee01     LIKE oee_file.oee01,
          oee02     LIKE oee_file.oee02,
          oee03     LIKE oee_file.oee03,
          oee04     LIKE oee_file.oee04,
          oee05     LIKE oee_file.oee05,                                        
          oee061    LIKE oee_file.oee061,   
          oee062    LIKE oee_file.oee062,   
          oee063    LIKE oee_file.oee063,   
          oee071    LIKE oee_file.oee071,   
          oee072    LIKE oee_file.oee072,   
          oee073    LIKE oee_file.oee073,   
          oee081    LIKE oee_file.oee081,   
          oee082    LIKE oee_file.oee082,   
          oee083    LIKE oee_file.oee083,   
          oee09     LIKE oee_file.oee09,   
          oee10     LIKE oee_file.oee10,   
          oee11     LIKE oee_file.oee11                                              
                    END RECORD 
#TQC-A50056 --end--
   DEFINE l_oee01   LIKE oee_file.oee01
   DEFINE l_oee03   LIKE oee_file.oee03
   DEFINE l_oee09   LIKE oee_file.oee09
   DEFINE l_i       LIKE type_file.chr1     #No.FUN-680137  VARCHAR(1)
   DEFINE p_pox03   LIKE pox_file.pox03,    #No.MOD-640030
          p_poy04   LIKE poy_file.poy04,    #No.MOD-640030
          p_pox05   LIKE pox_file.pox05,    #No.MOD-640030
          p_pox06   LIKE pox_file.pox06,    #No.MOD-640030
          p_cnt     LIKE type_file.num5,    #No.MOD-640030   #No.FUN-680137 SMALLINT
          g_sw      LIKE type_file.chr1     #No.MOD-640030   #No.FUN-680137 VARCHAR(1)
   DEFINE l_pmni    RECORD LIKE pmni_file.* #No.FUN-7B0018
   DEFINE l_cnt     LIKE type_file.num5     #TQC-A50056 
 
   LET g_sql = "SELECT oee01,oee03,oee09 FROM oee_file",
               " WHERE ",g_wc CLIPPED,
               "   AND oee10 IS NULL",
               " GROUP BY oee01,oee03,oee09"
 
   PREPARE p502_pbc1 FROM g_sql
   DECLARE oeec1_curs CURSOR FOR p502_pbc1
  
   BEGIN WORK
   LET g_success = "Y"
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOREACH oeec1_curs INTO l_oee01,l_oee03,l_oee09 
      IF STATUS THEN
         #No.FUN-710046  --Begin
         #CALL cl_err("oeec1_curs",STATUS,1)
         CALL s_errmsg("","","oeec1_curs",STATUS,0) 
         #No.FUN-710046  --End
         LET g_success = 'N'               #No.FUN-8A0086
         EXIT FOREACH
      END IF
      #No.FUN-710046  --Begin
      IF g_success = "N" THEN
         LET g_totsuccess = "N"
         LET g_success = "Y"
      END IF
      #No.FUN-710046  --End
 
      LET g_sql = "SELECT * FROM oee_file",
                  " WHERE oee01 ='",l_oee01,"'",
                  "   AND oee03 ='",l_oee03,"'",
                  "   AND oee09 ='",l_oee09,"'",
                  "   AND oee10 IS NULL ",         #TQC-A40113 
                  " ORDER BY oee01,oee02"
      
      PREPARE p502_pbc2 FROM g_sql
      DECLARE oeec2_curs CURSOR FOR p502_pbc2
  
      LET l_i = 0
 
       LET l_cnt = 1                             #TQC-A50056  
       FOREACH oeec2_curs INTO l_oee[l_cnt].*    #TQC-A50056 add l_cnt 
         IF STATUS THEN
            #No.FUN-710046  --Begin
            #CALL cl_err("oeec2_curs",STATUS,1)
            LET g_showmsg=l_oee01,"/",l_oee03,"/",l_oee09
            CALL s_errmsg("oee01,oee03,oee09",g_showmsg,"oeec2_curs",STATUS,0)
            #No.FUN-710046  --End
            EXIT FOREACH
         END IF
 
         #本廠訂單
         IF cl_null(l_oee[l_cnt].oee03) THEN                   #TQC-A50056 add l_cnt
            UPDATE oee_file SET oee10 = l_oee[l_cnt].oee01,    #TQC-A50056 add l_cnt
                                oee11 = l_oee[l_cnt].oee02     #TQC-A50056 add l_cnt
             WHERE oee01 = l_oee[l_cnt].oee01                  #TQC-A50056 add l_cnt
               AND oee02 = l_oee[l_cnt].oee02                  #TQC-A50056 add l_cnt
               AND oee03 = l_oee[l_cnt].oee03                  #TQC-A50056 add l_cnt
               AND oee05 = l_oee[l_cnt].oee05                  #TQC-A50056 add 
               AND oee09 = l_oee[l_cnt].oee09                  #TQC-A50056 add l_cnt
            IF STATUS THEN
#              CALL cl_err("upd oee1 err",STATUS,0)   #No.FUN-660167
               #No.FUN-710046  --Begin
               #CALL cl_err3("upd","oee_file",l_oee.oee01,l_oee.oee02,STATUS,"","upd oee1 err",0)   #No.FUN-660167
               LET g_showmsg=l_oee[l_cnt].oee01,"/",l_oee[l_cnt].oee02,"/",l_oee[l_cnt].oee03,"/",l_oee[l_cnt].oee09    #TQC-A50056 add l_cnt
               CALL s_errmsg("oee01,oee02,oee03,oee09",g_showmsg,"upd oee1 err",SQLCA.sqlcode,1)
               #No.FUN-710046  --End  
               LET g_success = "N"
            END IF
 
            UPDATE oeb_file SET oeb920 = oeb920+l_oee[l_cnt].oee083       #TQC-A50056 add l_cnt
             WHERE oeb01 = l_oee[l_cnt].oee01                             #TQC-A50056 add l_cnt
               AND oeb03 = l_oee[l_cnt].oee02                             #TQC-A50056 add l_cnt
            IF STATUS THEN
#              CALL cl_err("upd oeb1 err",STATUS,0)   #No.FUN-660167
               #No.FUN-710046  --Begin
               #CALL cl_err3("upd","oeb_file",l_oee.oee01,l_oee.oee02,STATUS,"","upd oeb1 err",0)   #No.FUN-660167
               LET g_showmsg=l_oee[l_cnt].oee01,"/",l_oee[l_cnt].oee02         #TQC-A50056 add l_cnt
               CALL s_errmsg("oeb01,oeb03",g_showmsg,"upd oeb1 err",SQLCA.sqlcode,1)
               #No.FUN-710046  --End  
               LET g_success = "N"
            END IF
 
            CONTINUE FOREACH
         END IF
 
         #多角訂單
         IF l_i = 0 THEN
            LET l_i = 1
            SELECT * INTO o_oea.* FROM oea_file
             WHERE oea01 = l_oee[l_cnt].oee01                     #TQC-A50056 add l_cnt
            CALL s_auto_assign_no("apm",l_oee[l_cnt].oee09,o_oea.oea02,"",     #TQC-A50056 add l_cnt
                                  "pmm_file","pmm01","","","")
                        RETURNING li_result,l_pmm.pmm01
            LET l_pmm.pmm02 = "TAP"
            LET l_pmm.pmm03 = 0
            LET l_pmm.pmm04 = g_today
#NO.FUN-670007 start--
            SELECT poy03 INTO l_pmm.pmm09
              FROM poy_file
             WHERE poy01 = l_oee[l_cnt].oee03             #TQC-A50056 add l_cnt
               AND poy02 = 1 
#            SELECT poz04 INTO l_pmm.pmm09
#              FROM poz_file
#             WHERE poz01 = l_oee.oee03
#NO.FUN-670007 end----
            SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
              INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,
                   l_pmm.pmm21,l_pmm.pmm22,l_pmm.pmm41
              FROM pmc_file
             WHERE pmc01 = l_pmm.pmm09
            LET l_pmm.pmm12 = o_oea.oea14
            LET l_pmm.pmm13 = o_oea.oea15
            LET l_pmm.pmm18 = "Y"     #確
            LET l_pmm.pmm25 = "2"     #狀
            LET l_pmm.pmm30 = "N"
            LET l_pmm.pmm31 = YEAR(g_today)
            LET l_pmm.pmm32 = MONTH(g_today)
            LET l_pmm.pmm40 = 0
            LET l_pmm.pmm40t = 0
            #MOD-770086-begin-add
            #CALL s_curr(l_pmm.pmm22,g_today) RETURNING l_pmm.pmm42
            IF g_aza.aza17 = l_pmm.pmm22 THEN   #本幣
               LET l_pmm.pmm42 = 1
            ELSE 
               CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,g_sma.sma904) 
               RETURNING l_pmm.pmm42
            END IF
            #MOD-770086-end-add
            SELECT gec04 INTO l_pmm.pmm43
              FROM gec_file
             WHERE gec01 = l_pmm.pmm21
            LET l_pmm.pmm44 = "1"
            LET l_pmm.pmm45 = "Y"
            LET l_pmm.pmm46 = 0
            LET l_pmm.pmm47 = 0
            LET l_pmm.pmm48 = 0
            LET l_pmm.pmm49 = "N"
            LET l_pmm.pmm50 = ""
            LET l_pmm.pmm901 = "Y"
            LET l_pmm.pmm902 = "N"
            LET l_pmm.pmm903 = o_oea.oea903
            LET l_pmm.pmm904 = l_oee[l_cnt].oee03         #TQC-A50056 add l_cnt
            LET l_pmm.pmm905 = "N"
            LET l_pmm.pmm906 = "Y"
            LET l_pmm.pmm909 = "3"
            LET l_pmm.pmmprsw = "Y"
            LET l_pmm.pmmprno = 0
            SELECT smyapr,smysign,smyprint 
              INTO l_pmm.pmmmksg,l_pmm.pmmsign,l_pmm.pmmprit
              FROM smy_file
             WHERE smyslip = l_oee[l_cnt].oee09           #TQC-A50056 add l_cnt  
            LET l_pmm.pmmdays = 0 
            LET l_pmm.pmmsseq = 0 
            LET l_pmm.pmmsmax = 0 
            LET l_pmm.pmmacti = "Y"
            LET l_pmm.pmmuser = g_user
            LET l_pmm.pmmgrup = g_grup
            LET l_pmm.pmmdate = g_today
#           LET l_pmm.pmm51 = ' '   #NO.FUN-960130   #FUN-B70015  mark
            LET l_pmm.pmm51 = '1'   #FUN-B70015
            LET l_pmm.pmmpos = 'N'   #NO.FUN-960130
            #FUN-980010 add plant & legal 
            LET l_pmm.pmmplant = g_plant 
            LET l_pmm.pmmlegal = g_legal 
            #FUN-980010 end plant & legal 
            LET l_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
            LET l_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO pmm_file VALUES(l_pmm.*)
            IF STATUS THEN
#              CALL cl_err("ins pmm error","",0)   #No.FUN-660167
               #No.FUN-710046  --Begin
               #CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","ins pmm error",0)   #No.FUN-660167
               CALL s_errmsg("pmm01",l_pmm.pmm01,"ins pmm error",SQLCA.sqlcode,1)
               #No.FUN-710046  --End  
               LET g_success = "N"
            END IF
 
            IF cl_null(g_msg) THEN
               LET g_msg = "'",l_pmm.pmm01 CLIPPED,"'"
            ELSE
               LET g_msg = g_msg CLIPPED,",'",l_pmm.pmm01,"'"
            END IF
         END IF
 
         #-----單身-----
         SELECT * INTO o_oeb.* FROM oeb_file
          WHERE oeb01 = l_oee[l_cnt].oee01           #TQC-A50056 add l_cnt
            AND oeb03 = l_oee[l_cnt].oee02            #TQC-A50056 add l_cnt
 
         LET l_pmn.pmn01 = l_pmm.pmm01
         LET l_pmn.pmn011 = l_pmm.pmm02
 
         SELECT MAX(pmn02)+1 INTO l_pmn.pmn02
           FROM pmn_file
          WHERE pmn01 = l_pmm.pmm01
         IF cl_null(l_pmn.pmn02) THEN
            LET l_pmn.pmn02 = 1
         END IF
 
         LET l_pmn.pmn04 = o_oeb.oeb04
         SELECT ima02 INTO l_pmn.pmn041
           FROM ima_file
          WHERE ima01 = l_pmn.pmn04
         LET l_pmn.pmn07 = o_oeb.oeb05
         SELECT ima25 INTO l_pmn.pmn08
           FROM ima_file
          WHERE ima01 = l_pmn.pmn04
         LET l_pmn.pmn09 = o_oeb.oeb05_fac
         LET l_pmn.pmn11 = "N"
         LET l_pmn.pmn13 = 0 
         LET l_pmn.pmn14 = "Y"
         LET l_pmn.pmn15 = "Y"
         LET l_pmn.pmn16 = "2"   #狀 
         LET l_pmn.pmn20 = l_oee[l_cnt].oee083               #TQC-A50056 add l_cnt
         LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07) #FUN-BB0084 
         LET l_pmn.pmn24 = l_oee[l_cnt].oee01             #TQC-A50056 add l_cnt
         LET l_pmn.pmn25 = l_oee[l_cnt].oee02             #TQC-A50056 add l_cnt
         LET l_pmn.pmn30 = 0 
         #-----No.FUN-640030-----
         SELECT poy04 INTO p_poy04 FROM poy_file
          WHERE poy01 = l_oee[l_cnt].oee03               #TQC-A50056 add l_cnt
            AND poy02 = 1
         CALL s_pox(l_oee[l_cnt].oee03,1,g_today)         #TQC-A50056 add l_cnt
           RETURNING p_pox03,p_pox05,p_pox06,p_cnt
         CASE p_pox05
            WHEN "1"
               LET l_pmn.pmn31 = o_oeb.oeb13 * p_pox06/100
            WHEN "2"
               CALL s_pow(l_pmm.pmm904,l_pmn.pmn04,p_poy04,o_oeb.oeb15)
                RETURNING g_sw,l_pmn.pmn31
               IF g_sw = 'N' THEN
                  LET l_pmn.pmn31 = 0
               END IF
            WHEN '3'
                IF o_oeb.oeb13 <> 0 THEN
                   CALL s_pow(l_pmm.pmm904,l_pmn.pmn04,p_poy04,o_oeb.oeb15)
                     RETURNING g_sw,l_pmn.pmn31
                   IF g_sw = 'N' THEN
                      LET l_pmn.pmn31 = 0
                   END IF
                ELSE
                   LET l_pmn.pmn31 = 0
                END IF
         END CASE
         #-----No.FUN-640030 END-----
         #MOD-750018-begin
         #考慮採購單頭幣別及來源訂單單頭幣別的換算
          LET l_pmn.pmn31 = (l_pmn.pmn31 * o_oea.oea24) / l_pmm.pmm42
         #MOD-750018-end
         LET l_pmn.pmn31t = l_pmn.pmn31 * (1+l_pmm.pmm43/100) 
         LET l_pmn.pmn33 = o_oeb.oeb15
         LET l_pmn.pmn34 = o_oeb.oeb15
         LET l_pmn.pmn35 = o_oeb.oeb15
       #FUN-810045 begin
         LET l_pmn.pmn122 = o_oeb.oeb41  #專案代號
         LET l_pmn.pmn96 = o_oeb.oeb42   #WBS
         LET l_pmn.pmn97 = o_oeb.oeb43   #活動
         LET l_pmn.pmn98 = o_oeb.oeb1001 #費用原因
       #FUN-810045 end
         LET l_pmn.pmn38 = "Y"
         LET l_pmn.pmn42 = 0
         LET l_pmn.pmn44 = l_pmn.pmn30 * l_pmm.pmm42 
         LET l_pmn.pmn50 = 0
         LET l_pmn.pmn51 = 0
         LET l_pmn.pmn53 = 0
         LET l_pmn.pmn55 = 0
         LET l_pmn.pmn57 = 0
         LET l_pmn.pmn58 = 0
         LET l_pmn.pmn61 = l_pmn.pmn04
         LET l_pmn.pmn62 = 1
         LET l_pmn.pmn63 = "N"
         LET l_pmn.pmn64 = "N"
        #LET l_pmn.pmn65 = "2"   #MOD-8A0161 mark
         LET l_pmn.pmn65 = "1"   #MOD-8A0161
         LET l_pmn.pmn80 = l_oee[l_cnt].oee061      #TQC-A50056 add l_cnt
         LET l_pmn.pmn81 = l_oee[l_cnt].oee062      #TQC-A50056 add l_cnt
         LET l_pmn.pmn82 = l_oee[l_cnt].oee063      #TQC-A50056 add l_cnt
         LET l_pmn.pmn83 = l_oee[l_cnt].oee071      #TQC-A50056 add l_cnt
         LET l_pmn.pmn84 = l_oee[l_cnt].oee072      #TQC-A50056 add l_cnt
         LET l_pmn.pmn85 = l_oee[l_cnt].oee073      #TQC-A50056 add l_cnt
         LET l_pmn.pmn86 = l_oee[l_cnt].oee081      #TQC-A50056 add l_cnt
         LET l_pmn.pmn87 = l_oee[l_cnt].oee083      #TQC-A50056 add l_cnt
         LET l_pmn.pmn88 = l_pmn.pmn87 * l_pmn.pmn31 
         CALL cl_digcut(l_pmn.pmn88,g_azi04) RETURNING l_pmn.pmn88
         LET l_pmn.pmn88t = l_pmn.pmn87 * l_pmn.pmn31t 
         CALL cl_digcut(l_pmn.pmn88t,g_azi04) RETURNING l_pmn.pmn88t
         LET l_pmn.pmn90 = l_pmn.pmn31   #CHI-690043 add
         #FUN-670061...............begin
         IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
            SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                           WHERE pml01=l_pmn.pmn24
                                             AND pml02=l_pmn.pmn25
            IF SQLCA.sqlcode THEN
               LET l_pmn.pmn930=NULL
            END IF
         ELSE
            LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
         END IF
         #FUN-670061...............end
         IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
         LET l_pmn.pmn73 = ' '   #NO.FUN-960130
         #FUN-980010 add plant & legal 
         LET l_pmn.pmnplant = g_plant 
         LET l_pmn.pmnlegal = g_legal 
         #FUN-980010 end plant & legal 
         IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF   #TQC-9B0203
         IF cl_null(l_pmn.pmn31) THEN LET l_pmn.pmn31 = 0 END IF   #TQC-A50014
         IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012 = ' ' END IF   #FUN-A60076
         INSERT INTO pmn_file VALUES(l_pmn.*)
         IF STATUS THEN
#           CALL cl_err("ins pmn error","",0)   #No.FUN-660167
            #No.FUN-710046  --Begin
            #CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,"SQLCA.sqlcode","","ins pmn error",0)   #No.FUN-660167
            LET g_showmsg=l_pmn.pmn01,"/",l_pmn.pmn02
            CALL s_errmsg("pmm01,pmn02",g_showmsg,"ins pmn error",SQLCA.sqlcode,1)
            #No.FUN-710046  --End  
            LET g_success = "N"
         #NO.FUN-7B0018 08/03/07 add --begin
         ELSE 
            IF NOT s_industry('std') THEN
               INITIALIZE l_pmni.* TO NULL
               LET l_pmni.pmni01 = l_pmn.pmn01
               LET l_pmni.pmni02 = l_pmn.pmn02
               IF NOT s_ins_pmni(l_pmni.*,'') THEN
                  LET g_success = 'N'
               END IF
            END IF
         #NO.FUN-7B0018 08/03/07 add --end
         END IF
 
         UPDATE oee_file SET oee10 = l_pmn.pmn01,
                             oee11 = l_pmn.pmn02
          WHERE oee01 = l_oee[l_cnt].oee01   #TQC-A50056 add l_cnt
            AND oee02 = l_oee[l_cnt].oee02   #TQC-A50056 add l_cnt
            AND oee03 = l_oee[l_cnt].oee03   #TQC-A50056 add l_cnt
            AND oee05 = l_oee[l_cnt].oee05   #TQC-A50056 add 
            AND oee09 = l_oee[l_cnt].oee09   #TQC-A50056 add l_cnt
            AND oee10 IS NULL             #TQC-A40113
         IF STATUS THEN
#           CALL cl_err("upd oee2 err",STATUS,0)   #No.FUN-660167
            #No.FUN-710046  --Begin
            #CALL cl_err3("upd","oee_file",l_oee.oee01,l_oee.oee02,STATUS,"","upd oee2 err",0)   #No.FUN-660167
            LET g_showmsg=l_oee[l_cnt].oee01,"/",l_oee[l_cnt].oee02,"/",l_oee[l_cnt].oee03,"/",l_oee[l_cnt].oee09   #TQC-A50056 add l_cnt
            CALL s_errmsg("oee01,oee02,oee03,oee09",g_showmsg,"upd oee2 err",SQLCA.sqlcode,1)
            #No.FUN-710046  --End  
            LET g_success = "N"
         END IF
 
         UPDATE oeb_file SET oeb920 = oeb920+l_oee[l_cnt].oee083   #TQC-A50056 add l_cnt
          WHERE oeb01 = l_oee[l_cnt].oee01                         #TQC-A50056 add l_cnt
            AND oeb03 = l_oee[l_cnt].oee02                         #TQC-A50056 add l_cnt
         IF STATUS THEN
#           CALL cl_err("upd oeb2 err",STATUS,0)   #No.FUN-660167
            #No.FUN-710046  --Begin
            #CALL cl_err3("upd","oeb_file",l_oee.oee01,l_oee.oee02,STATUS,"","upd oeb2 err",0)   #No.FUN-660167
            LET g_showmsg=l_oee[l_cnt].oee01,"/",l_oee[l_cnt].oee02              #TQC-A50056 add l_cnt
            CALL s_errmsg("oeb01,oeb03",g_showmsg,"upd oeb2 err",SQLCA.sqlcode,1)
            #No.FUN-710046  --End  
            LET g_success = "N"
         END IF
#TQC-A50056 --begin--
         LET l_cnt = l_cnt + 1 
         IF l_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
         END IF
#TQC-A50056 --end--   
      END FOREACH
 
      SELECT SUM(pmn88),SUM(pmn88t) INTO l_pmm.pmm40,l_pmm.pmm40t
        FROM pmn_file
       WHERE pmn01 = l_pmm.pmm01
      IF cl_null(l_pmm.pmm40) THEN
         LET l_pmm.pmm40 = 0 
      END IF
      IF cl_null(l_pmm.pmm40t) THEN
         LET l_pmm.pmm40t = 0 
      END IF
      CALL cl_digcut(l_pmm.pmm40,g_azi04) RETURNING l_pmm.pmm40
      CALL cl_digcut(l_pmm.pmm40t,g_azi04) RETURNING l_pmm.pmm40t
      UPDATE pmm_file SET pmm40 = l_pmm.pmm40,
                          pmm40t = l_pmm.pmm40t
       WHERE pmm01 = l_pmm.pmm01
 
   END FOREACH 
   #No.FUN-710046  --Begin
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   CALL s_showmsg()
   #No.FUN-710046  --End  
 
END FUNCTION
 
 

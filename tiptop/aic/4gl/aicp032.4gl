# Prog. Version..: '5.30.06-13.04.01(00004)'     #
#
# Pattern name...: acip032.4gl
# Descriptions...: ICD 庫存Hold lot批維護作業
# Date & Author..: 07/12/04 By destiny No.FUN-7B0074
# Modify.........: No.FUN-830130 By destiny 修改單身查詢條件
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980004 09/08/13 By TSD.danny2000 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.CHI-B70027 13/01/21 By Alberti icz_file新增一個欄位：項次 icz11，並加入key值。
#                                                    在做icz_file寫入的時候抓項次最大值加一。 

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
               wc        STRING,                        #NO.FUN-910082
               hold_yn   LIKE type_file.chr1,          #Hold否
               qty0_yn   LIKE type_file.chr1,          #包括庫存為零否
               date      LIKE type_file.dat,           #Hold/Release日期
               reason    LIKE type_file.chr1000,       #Hold/Release原因
               user      LIKE gen_file.gen01           #維護人員
               END RECORD,
       g_idc       DYNAMIC ARRAY OF RECORD 
                   sure        LIKE type_file.chr1,    #勾選:若勾選,則表示需處理該筆庫存數據
                   idc01_b     LIKE idc_file.idc01,         #料件編號
                   ima02       LIKE ima_file.ima02,         #品名
                   ima021      LIKE ima_file.ima021,        #規格
                   idc09_b     LIKE idc_file.idc09,         #母體料號
                   ima06       LIKE ima_file.ima06,         #分群碼
                   ima08       LIKE ima_file.ima08,         #來源碼
                   idc07       LIKE idc_file.idc07,         #庫存單位
                   ima131_b    LIKE ima_file.ima131,        #產品分類
                   oba02       LIKE oba_file.oba02,         #分類名稱
                   idc02       LIKE idc_file.idc02,         #倉庫
                   idc03       LIKE idc_file.idc03,         #儲位
                   idc04_b     LIKE idc_file.idc04,         #批號
                   idc08       LIKE idc_file.idc08,         #數量
                   idc12       LIKE idc_file.idc12,         #參考數量
                   idc17       LIKE idc_file.idc17,         #Hold批否
                   user_old    LIKE gen_file.gen01,         #維護人員
                   user_name1  LIKE gen_file.gen02,         #人員名稱
                   date_old    LIKE type_file.dat,          #最近異動日期
                   reason_old  LIKE type_file.chr1000,      #最近理由
                   user_b      LIKE gen_file.gen01,         #維護人員
                   user_name2  LIKE gen_file.gen02,         #人員名稱
                   date_b      LIKE type_file.dat,          #異動日期
                   reason_b    LIKE type_file.chr1000       #理由
                   END RECORD,
       b_idc       RECORD
                   sure        LIKE type_file.chr1,    #勾選:若勾選,則表示需處理該筆庫存數據
                   idc01_b     LIKE idc_file.idc01,         #料件編號
                   ima02       LIKE ima_file.ima02,         #品名
                   ima021      LIKE ima_file.ima021,        #規格
                   idc09_b     LIKE idc_file.idc09,         #母體料號
                   ima06       LIKE ima_file.ima06,         #分群碼
                   ima08       LIKE ima_file.ima08,         #來源碼
                   idc07       LIKE idc_file.idc07,         #庫存單位
                   ima131_b    LIKE ima_file.ima131,        #產品分類
                   oba02       LIKE oba_file.oba02,         #分類名稱
                   idc02       LIKE idc_file.idc02,         #倉庫
                   idc03       LIKE idc_file.idc03,         #儲位
                   idc04_b     LIKE idc_file.idc04,         #批號
                   idc08       LIKE idc_file.idc08,         #數量
                   idc12       LIKE idc_file.idc12,         #參考數量
                   idc17       LIKE idc_file.idc17,         #Hold批否
                   user_old    LIKE gen_file.gen01,         #維護人員
                   user_name1  LIKE gen_file.gen02,         #人員名稱
                   date_old    LIKE type_file.dat,          #最近異動日期
                   reason_old  LIKE type_file.chr1000,      #最近理由
                   user_b      LIKE gen_file.gen01,         #維護人員
                   user_name2  LIKE gen_file.gen02,         #人員名稱
                   date_b      LIKE type_file.dat,          #異動日期
                   reason_b    LIKE type_file.chr1000       #理由
                   END RECORD
DEFINE g_change_lang,g_flag    LIKE type_file.chr1          #是否有做語言切換 
DEFINE g_sql           STRING
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5
 
MAIN
   DEFINE   l_flag   LIKE type_file.chr1
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM  
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p032_w AT 2,2 WITH FORM "aic/42f/aicp032"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL p032_tm()

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p032_tm()
   DEFINE c       LIKE type_file.chr10
   DEFINE lc_cmd  LIKE type_file.chr1000 
   DEFINE l_gen02 LIKE gen_file.gen02
   
   CLEAR FORM                       #清除畫面
   CALL g_idc.clear()
 
   WHILE TRUE
      CALL cl_opmsg('q')
 
      #                              料號,母體編號,產品分類,批號
      CONSTRUCT BY NAME tm.wc ON idc01,idc09,ima131,idc04
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION  CONTROLP
            CASE
               WHEN INFIELD(idc01)                  #料件編號
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.state = 'c'
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO idc01
                    NEXT FIELD idc01
               WHEN INFIELD(idc09)                  #母體料號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_idc"
                    LET g_qryparam.arg1 = "0"       #母體料號
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO idc09
                    NEXT FIELD idc09
               WHEN INFIELD(ima131)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oba"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima131
                    NEXT FIELD ima131
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
  
         ON ACTION locale
            LET g_change_lang = TRUE 
            EXIT CONSTRUCT
 
         ON ACTION exit       
            LET g_action_choice='exit'
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF  
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p032_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      LET tm.hold_yn = 'N'       #Hold 否: default值設為'N'
      LET tm.qty0_yn = 'N'       #包括庫存為零: default值設為'N'
      LET tm.date = g_today      #Hold/Release日期: default 當天
      LET tm.reason = ''         #Hold/Release原因: 由user自行輸入
      LET tm.user = g_user       #維護人員: default login
      #維護人員姓名
      LET l_gen02 = ''
      SELECT gen02 INTO l_gen02 FROM gen_file
         WHERE gen01 = tm.user
 
      INPUT BY NAME tm.hold_yn,tm.qty0_yn,tm.date,tm.reason,tm.user
            WITHOUT DEFAULTS
 
         AFTER FIELD hold_yn
            IF NOT cl_null(tm.hold_yn) THEN
               IF tm.hold_yn NOT MATCHES '[YN]' THEN
                  NEXT FIELD hold_yn
               END IF
            END IF
 
         AFTER FIELD qty0_yn
            IF NOT cl_null(tm.qty0_yn) THEN
               IF tm.qty0_yn NOT MATCHES '[YN]' THEN
                  NEXT FIELD qty0_yn
               END IF
            END IF
 
         AFTER FIELD user
            IF NOT cl_null(tm.user) THEN
               CALL p032_peo('a',tm.user) RETURNING l_gen02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('select gen',g_errno,0)
                  NEXT FIELD user
               END IF
               DISPLAY l_gen02 TO user_name
            END IF
 
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(user)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = tm.user
                    CALL cl_create_qry() RETURNING tm.user
                    DISPLAY BY NAME tm.user
                    NEXT FIELD user
            END CASE
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about    
            CALL cl_about() 
 
         ON ACTION help    
            CALL cl_show_help()
   
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT      
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p032_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      
      ## 依QBE 產生單身數據
      LET g_success = 'Y'
      CALL p032_b_fill()
      
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CONTINUE WHILE
      END IF
     
      IF g_success = 'Y' THEN 
         IF cl_sure(0,0) THEN
            BEGIN WORK
            LET g_success='Y'
            CALL cl_wait()
            CALL p032_upd_idc()
         END IF   
      END IF   
      
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF    
 
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF  
      
   END WHILE
 
   ERROR ""
END FUNCTION
 
FUNCTION p032_b_fill()
DEFINE    l_allow_insert  LIKE type_file.num5,     #可新增否
          l_allow_delete  LIKE type_file.num5      #可刪除否
DEFINE    l_cnt,l_i       LIKE type_file.num5
 
   LET g_sql = "SELECT 'N',idc01,ima02,ima021,idc09,ima06,",
               "       ima08,idc07,ima131,' ',idc02,idc03, ",
               "       idc04,SUM(idc08),SUM(idc12),idc17,",
               "       ' ',' ',' ',' ',' ',' ',' ',' '",
               "   FROM idc_file,ima_file      ",                  
#              "   WHERE idc17 = '",tm.hold_yn,"'",                #No.FUN-830130  
#              "     AND idc01 = ima01 ",                          #No.FUN-830130 
               "   WHERE idc01 = ima01 ",                          #No.FUN-830130  
               "     AND ",tm.wc,
               "   GROUP BY idc01,ima02,ima021,idc09,ima06,",
               "            ima08,idc07,ima131,idc02,",
               "            idc03,idc04,idc17"
 
   PREPARE p032_pre FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p032_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p032_dec CURSOR FOR p032_pre
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p032_dec',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_ac = 1
 
   FOREACH p032_dec INTO g_idc[l_ac].*
 
      #包括庫存為零否,若為N則排除庫存量為零的資料
      IF tm.qty0_yn = 'N' THEN
         IF g_idc[l_ac].idc08 = 0 THEN 
            CONTINUE FOREACH
         END IF
      END IF
 
      #取得產品分類說明
      SELECT oba02 INTO g_idc[l_ac].oba02
         FROM oba_file
        WHERE oba01 = g_idc[l_ac].ima131_b
      
      #取得最近一次異動日期,理由,維護人員
      DECLARE icz_dec CURSOR FOR 
#         SELECT icz060,icz070,iczuser                    #No.FUN-830130
         SELECT icz06,icz07,iczuser                       #No.FUN-830130
           FROM icz_file
           #CHI-B70027 --- modify --- start ---
          #WHERE icz010 = g_idc[l_ac].idc01_b
          #  AND icz020 = g_idc[l_ac].idc02
          #  AND icz030 = g_idc[l_ac].idc03
          #  AND icz040 = g_idc[l_ac].idc04_b
          #ORDER BY icz070 DESC
           WHERE icz01 = g_idc[l_ac].idc01_b
            AND icz02 = g_idc[l_ac].idc02
            AND icz03 = g_idc[l_ac].idc03
            AND icz04 = g_idc[l_ac].idc04_b
          ORDER BY icz11 DESC
      #CHI-B70027 --- modify ---  end  ---
      OPEN icz_dec 
      FETCH icz_dec INTO g_idc[l_ac].reason_old,
                            g_idc[l_ac].date_old,
                            g_idc[l_ac].user_old
      #人員姓名
      SELECT gen02 INTO g_idc[l_ac].user_name1
         FROM gen_file
        WHERE gen01 = g_idc[l_ac].user_old 
 
      #default本次異動日期,理由,維護人員
      LET g_idc[l_ac].idc17 = tm.hold_yn
      LET g_idc[l_ac].user_b = tm.user
      LET g_idc[l_ac].date_b = tm.date
      LET g_idc[l_ac].reason_b = tm.reason
 
      #人員姓名
      SELECT gen02 INTO g_idc[l_ac].user_name2
         FROM gen_file
        WHERE gen01 = g_idc[l_ac].user_b
 
      LET l_ac = l_ac + 1
   END FOREACH
   CALL g_idc.deleteElement(l_ac)
   LET g_rec_b = l_ac-1
   
   #表示無單身資料
   IF g_rec_b = 0 THEN
      CALL cl_err(g_idc[l_ac].idc01_b,'aic-024',1)
      LET g_success = "N"
      RETURN
   END IF  
   
   DISPLAY g_rec_b TO FORMONLY.cn2  
   
   LET l_allow_insert = FALSE  #可新增否
   LET l_allow_delete = FALSE  #可刪除否
 
   INPUT ARRAY g_idc WITHOUT DEFAULTS FROM s_idc.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        #將所有的設為選擇
        FOR l_i = 1 TO g_rec_b     
            LET g_idc[l_i].sure="Y"
        END FOR
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         
      AFTER FIELD sure
        IF NOT cl_null(g_idc[l_ac].sure) THEN    
	   IF g_idc[l_ac].sure NOT MATCHES "[YN]" THEN
              NEXT FIELD sure
           END IF
        END IF
      
      AFTER FIELD user_b
         IF NOT cl_null(g_idc[l_ac].user_b) THEN
            CALL p032_peo('a',g_idc[l_ac].user_b) 
                 RETURNING g_idc[l_ac].user_name2
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('select gen',g_errno,0)
               NEXT FIELD user_b
            END IF
            DISPLAY BY NAME g_idc[l_ac].user_name2
         END IF
         
      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
             LET g_idc[l_i].sure="Y"
         END FOR
         LET l_cnt = g_rec_b
         DISPLAY g_rec_b TO FORMONLY.cn3
 
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b      #將所有的設為取消
             LET g_idc[l_i].sure="N"
         END FOR
         LET l_cnt = 0
         DISPLAY 0 TO FORMONLY.cn3       
 
      AFTER INPUT
         LET l_cnt = 0
         FOR l_i =1 TO g_rec_b
            IF g_idc[l_i].sure = 'Y' THEN
               LET l_cnt = l_cnt + 1
            END IF
         END FOR
         DISPLAY l_cnt TO FORMONLY.cn3    
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(user_b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_idc[l_ac].user_b
                 CALL cl_create_qry() RETURNING g_idc[l_ac].user_b
                 DISPLAY BY NAME g_idc[l_ac].user_b
                 NEXT FIELD user_b
         END CASE
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   END INPUT   
   
END FUNCTION 
 
FUNCTION p032_upd_idc()
   DEFINE l_upd   LIKE type_file.chr1
   DEFINE i       LIKE type_file.num5
 
   #若勾選,則表示需處理該筆庫存數據
   #Hold 否 = 'Y',表示要將批號作Hold
   #Hold 否 = 'N',表示要將批號作Release
   #更新idc17
   #寫庫存Hold批log檔
   FOR i = 1 TO g_rec_b
       IF g_idc[i].sure = 'Y' THEN
          LET b_idc.* = g_idc[i].*
          IF tm.hold_yn = 'Y' THEN LET l_upd = 'Y' END IF
          IF tm.hold_yn = 'N' THEN LET l_upd = 'N' END IF
          UPDATE idc_file SET idc17 = l_upd
             WHERE idc01 = b_idc.idc01_b
               AND idc02 = b_idc.idc02
               AND idc03 = b_idc.idc03
               AND idc04 = b_idc.idc04_b
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd idc17',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             RETURN
          ELSE
             CALL p032_ins_icz()
             IF g_success = 'N' THEN
                RETURN
             END IF
          END IF
       END IF
   END FOR
END FUNCTION
 
#insert 庫存Hold批log檔(icz_file)
FUNCTION p032_ins_icz()
   DEFINE l_icz   RECORD LIKE icz_file.*
   DEFINE l_grup     LIKE gem_file.gem01
 
   INITIALIZE l_icz.* TO NULL
 
   #取得數據所有者所屬部門
   LET l_grup = ''
   SELECT gen03 INTO l_grup FROM gen_file
    WHERE gen01 = b_idc.user_b
 
   LET l_icz.icz01 = b_idc.idc01_b                         #料件編號
   LET l_icz.icz09 = b_idc.idc09_b                         #母體料號
   LET l_icz.icz02 = b_idc.idc02                           #倉庫
   LET l_icz.icz03 = b_idc.idc03                           #儲位
   LET l_icz.icz04 = b_idc.idc04_b                         #批號
   IF tm.hold_yn = 'Y' THEN LET l_icz.icz05 = '1' END IF   #hold
   IF tm.hold_yn = 'N' THEN LET l_icz.icz05 = '2' END IF   #relase
   LET l_icz.icz07 = b_idc.date_b                          #異動日期
   LET l_icz.icz06 = b_idc.reason_b                        #理由
   LET l_icz.iczuser = b_idc.user_b                        #數據所有者
   LET l_icz.iczgrup = l_grup                              #數據所有部門
   LET l_icz.iczmodu = ' '                                 #數據修改者
   LET l_icz.iczdate = b_idc.date_b                        #最近修改日
 
   LET l_icz.iczplant = g_plant    #FUN-980004
   LET l_icz.iczlegal = g_legal    #FUN-980004
 
   LET l_icz.iczoriu = g_user      #No.FUN-980030 10/01/04
   LET l_icz.iczorig = g_grup      #No.FUN-980030 10/01/04

   #CHI-B70027 --- modify --- start ---
   SELECT icz11 INTO l_icz.icz11 FROM icz_file
    WHERE icz01 = l_icz.icz01 
      AND icz02 = l_icz.icz02 
      AND icz03 = l_icz.icz03 
      AND icz04 = l_icz.icz04 
    ORDER BY icz11 DESC
    
   IF cl_null(l_icz.icz11) THEN
      LET l_icz.icz11 = 1
   ELSE
      LET l_icz.icz11 = l_icz.icz11 + 1
   END IF
   #CHI-B70027 --- modify ---  end  ---
   
   INSERT INTO icz_file VALUES(l_icz.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('ins icz',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 
 
FUNCTION p032_peo(p_cmd,p_key)    #人員
   DEFINE p_cmd       LIKE type_file.chr1,
          p_key       LIKE gen_file.gen01,
          l_gen02     LIKE gen_file.gen02,
          l_gen03     LIKE gen_file.gen03,
          l_genacti   LIKE gen_file.genacti
 
   LET g_errno = ' '
   LET l_gen02 = ''
   LET l_genacti = ''
   LET l_gen03 = ''
   SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
      FROM gen_file WHERE gen01 = p_key
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                  LET l_gen02 = NULL
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   RETURN l_gen02
END FUNCTION
#No.FUN-7B0074--end--

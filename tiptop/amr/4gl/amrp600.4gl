# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp600.4gl
# Descriptions...: 多工廠MRP匯總模擬作業
# Date & Author..: 05/11/08 By Carrier
# Modify.........: No.TQC-650087 06/06/01 By Rayven mss_g_file和mst_g_file命名                                                      
#                  不規範，mss_g_file現使用msu_file，mst_g_file現使用msv_file，                                                     
#                  相關欄位做相應更改：mss_gv改為msu000，mss_g06_fz改為msu066，                                                     
#                  mst_gv改為msv000，mst_gplant改為msv031，mst_gplantv改為msv032，                                                    
#                  mst_g06_fz改為msv066
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.CHI-6B0015 07/02/01 By Elva msv12,msv13計算錯誤
# Modify.........: No.FUN-740234 07/06/06 By chenl   增加版本記錄函數。
# Modify.........: No.MOD-930256 09/03/27 By Smapmin 無法重覆拋轉
# Modify.........: No.MOD-950203 09/05/27 By Smapmin 營運中心欄位應依使用者的權限設定做開窗與卡關
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980020 09/09/28 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.TQC-970277 09/10/14 By baofei 修改開窗輸入單身資料，msv031,msv032為空  
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# MODIFY.........: NO:TQC-AC0061 10/12/07 By zhangweib 刪除p600_comp_msu()中SQL語句重複撈取資料

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE msr              RECORD LIKE msr_file.*
DEFINE mss              RECORD LIKE mss_file.*
DEFINE msu              RECORD LIKE mst_file.*
DEFINE msv              RECORD LIKE msa_file.*
DEFINE msw              RECORD LIKE msw_file.*   #FUN-740234
DEFINE g_msu000         LIKE msu_file.msu000
DEFINE g_po_days        LIKE ima_file.ima72      # Reschedule days  #NO.FUN-680082  
DEFINE g_msv            DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
                        msv031     LIKE msv_file.msv031,
                        plantname  LIKE azp_file.azp02,
                        msv032     LIKE msv_file.msv032
                        END RECORD
DEFINE g_body           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                        msv031     LIKE msv_file.msv031,
                        azp03      LIKE azp_file.azp03,
                        msv032     LIKE msv_file.msv032
                        END RECORD
DEFINE g_msw000       LIKE msw_file.msw000           #No.FUN-740234 
DEFINE g_msw02        LIKE msw_file.msw02            #No.FUN-740234  
DEFINE g_msw          DYNAMIC ARRAY OF RECORD        #No.FUN-740234
                      msw08   LIKE msw_file.msw08,   #No.FUN-740234
                      azp02   LIKE azp_file.azp02,   #No.FUN-740234  
                      msw10   LIKE msw_file.msw10    #No.FUN-740234  
                      END RECORD                     #No.FUN-740234   
DEFINE gg_msv         RECORD LIKE msv_file.*
DEFINE g_atot           LIKE type_file.num10     #記錄單身筆數  #NO.FUN-680082 SMALLINT 
DEFINE g_bdate,g_edate  LIKE type_file.dat       #NO.FUN-680082 DATE
DEFINE g_buk_type       LIKE msr_file.buk_type
DEFINE g_sql            STRING
DEFINE g_i              LIKE type_file.num5      #NO.FUN-680082 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(72)
DEFINE g_no             LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE g_flag           LIKE type_file.chr1      #NO.FUN-680082  VARCHAR(1)
DEFINE l_ac             LIKE type_file.num5      #NO.FUN-680082 SMALLINT
DEFINE needdate         LIKE type_file.dat       # MRP Need Date   #NO.FUN-680082 DATE
DEFINE l_dbs_tra        LIKE type_file.chr21   #FUN-980092


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0076

   OPEN WINDOW p600_w WITH FORM "amr/42f/amrp600"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_msu000 =''
   LET g_po_days =0
   WHILE TRUE
      CALL p600_ask()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p600_mrp()
      ERROR ''
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CALL cl_end(0,0)
      EXIT WHILE
   END WHILE
   CLOSE WINDOW p600_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0076
END MAIN
 
FUNCTION p600_ask()
  DEFINE l_n,l_i          LIKE type_file.num5     #NO.FUN-680082 SMALLINT
  DEFINE l_azp03          LIKE azp_file.azp03
  DEFINE l_bdate,l_edate  LIKE type_file.dat      #NO.FUN-680082 DATE
  DEFINE l_buk_type       LIKE msr_file.buk_type
  DEFINE l_cnt            LIKE type_file.num5   #MOD-950203  
 
  
  LET g_bdate   =NULL     #No.FUN-740234
  LET g_edate   =NULL     #No.FUN-740234
  LET g_buk_type=NULL     #No.FUN-740234
  CALL g_msv.clear()
   CALL SET_COUNT(0)    # initial array argument
 
   
  INPUT g_msu000,g_po_days WITHOUT DEFAULTS
        FROM FORMONLY.msu000,FORMONLY.po_days
 
      AFTER FIELD msu000
         IF cl_null(g_msu000) THEN NEXT FIELD msu000 END IF
         IF NOT cl_null(g_msu000) THEN
            #-----MOD-930256---------
            #SELECT COUNT(*) INTO g_i FROM msu_file
            # WHERE msu000 = g_msu000
            #IF g_i > 0 THEN
            #   CALL cl_err(g_msu000,'amr-301',1)
            #   NEXT FIELD msu000
            #END IF
            #-----END MOD-930256-----
            CALL p600_wc_default()   #No.FUN-740234
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN RETURN END IF
         IF cl_null(g_po_days) THEN LET g_po_days=0 END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
   END INPUT
   IF INT_FLAG THEN RETURN END IF
 
   #----- 單身 -B---#
   #LET g_bdate   =NULL     #No.FUN-740234
   #LET g_edate   =NULL     #No.FUN-740234
   #LET g_buk_type=NULL     #No.FUN-740234
  
 
   INPUT ARRAY g_msv WITHOUT DEFAULTS FROM s_msv.*
         ATTRIBUTE(UNBUFFERED)
   
 
      BEFORE FIELD msv031
         LET l_ac = ARR_CURR()
 
      AFTER FIELD msv031
         IF NOT cl_null(g_msv[l_ac].msv031) THEN
           #No.FUN-740234--begin-- mark
           # #檢查該用戶是否有權限access此db
           # IF NOT s_chkdbs(g_user,g_msv[l_ac].msv031,g_rlang) THEN
           #    NEXT FIELD msv031
           # END IF
           #No.FUN-740234--end-- mark
            SELECT azp02,azp03 INTO g_msv[l_ac].plantname,l_azp03
              FROM azp_file
             WHERE azp01 = g_msv[l_ac].msv031
            IF STATUS THEN
               CALL cl_err(g_msv[l_ac].msv031,'aap-025',1)
               NEXT FIELD msv031
            END IF
            #-----MOD-950203---------
            SELECT COUNT(*) INTO l_cnt FROM zxy_file
             WHERE zxy03 = g_msv[l_ac].msv031
               AND zxy01 = g_user
            IF l_cnt = 0 THEN
               CALL cl_err(g_msv[l_ac].msv031,'sub-188',1)
               NEXT FIELD msv031
            END IF
            #-----END MOD-950203-----
 
            #--(1)begin FUN-980092 add-----check User是否有此plant的權限
             IF NOT s_chk_plant(g_msv[l_ac].msv031) THEN
                NEXT FIELD msv031
             END IF
            #--end FUN-980092 add ---------------------------------
 
         END IF
 
      AFTER FIELD msv032
         IF  NOT cl_null(g_msv[l_ac].msv032) THEN       #No.FUN-740234 
             LET g_sql = "SELECT bdate,edate,buk_type ",
                         #" FROM ",s_dbstring(l_azp03) CLIPPED,"msr_file ", 
                         " FROM ",cl_get_target_table(g_msv[l_ac].msv031,'msr_file'), #FUN-A50102    
                         " WHERE msr_v='",g_msv[l_ac].msv032,"'"
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		     CALL cl_parse_qry_sql(g_sql,g_msv[l_ac].msv031) RETURNING g_sql #FUN-A50102	            
             PREPARE p600_prepare1 FROM g_sql
             DECLARE p600_sel_ver CURSOR FOR p600_prepare1
             OPEN p600_sel_ver
             IF SQLCA.sqlcode THEN
                IF SQLCA.sqlcode = 100 THEN
                   CALL cl_err(g_msv[l_ac].msv032,'amr-302',1)
                   NEXT FIELD msv032
                ELSE
                   CALL cl_err(g_msv[l_ac].msv032,SQLCA.sqlcode,1)
                   NEXT FIELD msv031
                END IF
             END IF
             FETCH p600_sel_ver INTO l_bdate,l_edate,l_buk_type
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_msv[l_ac].msv032,'amr-305',1)
                NEXT FIELD msv032
             END IF
             CLOSE p600_sel_ver
             IF l_ac <> 1 THEN
                IF l_bdate    <> g_bdate OR
                   l_edate    <> g_edate OR
                   l_buk_type <> g_buk_type THEN
                   CALL cl_err(g_msv[l_ac].msv032,'amr-302',1)
                   NEXT FIELD msv032
                END IF
             ELSE
                LET g_bdate   = l_bdate
                LET g_edate   = l_edate
                LET g_buk_type= l_buk_type
             END IF
             FOR l_i = 1 TO l_ac-1      # 檢查工廠及版本是否重覆
                IF g_msv[l_i].msv031 = g_msv[l_ac].msv031 THEN
                  #g_msv[l_i].msv032 = g_msv[l_ac].msv032 THEN
                   CALL cl_err('','amr-303',1)
                   NEXT FIELD msv031
                END IF
             END FOR
         END IF     #No.FUN-740234
 
      AFTER ROW
         IF NOT cl_null(g_msv[l_ac].msv031 ) AND
            NOT cl_null(g_msv[l_ac].msv032) THEN
            LET g_body[l_ac].msv031  = g_msv[l_ac].msv031
            LET g_body[l_ac].msv032 = g_msv[l_ac].msv032
            LET g_body[l_ac].azp03  = l_azp03
         END IF
 
      AFTER INPUT                    # 檢查至少輸入一個工廠
         IF INT_FLAG THEN EXIT INPUT END IF
         LET g_atot = ARR_COUNT()
         FOR l_i = 1 TO g_atot
            IF NOT cl_null(g_msv[l_i].msv031) THEN
               EXIT INPUT
            END IF
         END FOR
         IF l_i = g_atot+1 THEN
            CALL cl_err('','aom-304',1)
            NEXT FIELD msv031
         END IF
 
       ON ACTION CONTROLP    #MOD-490330
         CASE
            WHEN INFIELD(msv031)
               CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_azp"    #MOD-950203 mark
               LET g_qryparam.form = "q_zxy"   #MOD-950203
               LET g_qryparam.arg1 = g_user    #MOD-950203
               LET g_qryparam.default1 = g_msv[l_ac].msv031
               CALL cl_create_qry() RETURNING g_msv[l_ac].msv031
               DISPLAY BY NAME g_msv[l_ac].msv031   #TQC-970277 取消MARK  
               NEXT FIELD msv031
            WHEN INFIELD(msv032)
#              CALL q_mrp(FALSE,TRUE,g_msv[l_ac].msv032,l_azp03,                #FUN-980020 mark
               CALL q_mrp(FALSE,TRUE,g_msv[l_ac].msv032,g_msv[l_ac].msv031,     #FUN-980020 
                          g_bdate,g_edate,g_buk_type) 
                          RETURNING g_msv[l_ac].msv032
               DISPLAY BY NAME g_msv[l_ac].msv032   #TQC-970277 取消MARK  
               NEXT FIELD msv032
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
END FUNCTION
 
FUNCTION p600_mrp()
   CALL p600_ins_msw()        #No.FUN-740234  
   CALL p600_del()            #No.FUN-740234
   CALL p600_ins_msv()        # 將單身工廠的MRP匯總資料插入當前工廠的msv_file中
   CALL p600_mend_msv()       # 補全msv_file中的資料,為了資料的連續性
   #CALL p600_set_mst_bal()      # 重算結余數量
   CALL p600_ins_msu()        # 將msv_file的資料匯總插入msu_file中
   CALL p600_comp_msu()       # 重計msu_file的交期重排減少量/交期重排增加量/預計結存/PLP量
   CALL p600_comp_msv()       # 重計msv_file的建議撥出量/建議撥入量
  # CALL p600_mst_apportion()    # msu_file中的建議重排減少量/增加量/PLP量要由msv_file來吸收
   CALL p600_upd_msw()        #No.FUN-740234
END FUNCTION
 
#處理一: 將單身工廠的MRP匯總資料插入當前工廠的msv_file中
FUNCTION p600_ins_msv()
  DEFINE l_mss           RECORD LIKE mss_file.*
  DEFINE l_msv           RECORD LIKE msv_file.*
  DEFINE l_i             LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
  LET g_no = 0
  INITIALIZE l_msv.* TO NULL
  LET l_msv.msv000 = g_msu000
  FOR l_i=1 TO g_body.getLength()
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     IF cl_null(g_msv[l_i].msv031) THEN EXIT FOR END IF
     LET g_plant_new = g_msv[l_i].msv031
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
     #LET g_sql = "SELECT ",s_dbstring(g_body[l_i].azp03 CLIPPED),"mss_file.* ",
                 #"  FROM ",s_dbstring(g_body[l_i].azp03 CLIPPED),"mss_file,",
      #LET g_sql = "SELECT ",s_dbstring(l_dbs_tra) CLIPPED,"mss_file.* ",    #FUN-980092
      #            "  FROM ",s_dbstring(l_dbs_tra) CLIPPED,"mss_file,",     
      #                      s_dbstring(g_body[l_i].azp03) CLIPPED,"ima_file",
      LET g_sql = "SELECT ",cl_get_target_table(g_msv[l_i].msv031,'mss_file'),".* ", #FUN-A50102
                  "  FROM ",cl_get_target_table(g_msv[l_i].msv031,'mss_file')," , ", #FUN-A50102  
                            cl_get_target_table(g_msv[l_i].msv031,'ima_file'),       #FUN-A50102
                  " WHERE mss_v = '",g_body[l_i].msv032,"'",
                  "   AND ima01 = mss01",
                  "   AND ima08 = 'P'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102	            
      CALL cl_parse_qry_sql(g_sql,g_msv[l_i].msv031) RETURNING g_sql #FUN-980092
      PREPARE p600_pre_ins_msv_1 FROM g_sql
      DECLARE p600_ins_msv_1 CURSOR FOR p600_pre_ins_msv_1
      FOREACH p600_ins_msv_1 INTO l_mss.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach ins_msv_1',SQLCA.sqlcode,1)
         END IF
         CALL ui.Interface.refresh()
         CALL cl_getmsg('amr-306',g_lang) RETURNING g_msg
         ERROR g_msg CLIPPED,g_body[l_i].msv031 CLIPPED,
                 " ",g_body[l_i].msv032," ",l_mss.mss01 CLIPPED
         #MESSAGE "Insert msv_file ","Db:",g_body[l_i].msv031 CLIPPED,
         #        " MRP Ver:",g_body[l_i].msv032," Item:",l_mss.mss01 CLIPPED
         IF cl_null(l_mss.mss051)   THEN LET l_mss.mss051  = 0 END IF
         IF cl_null(l_mss.mss052)   THEN LET l_mss.mss052  = 0 END IF
         IF cl_null(l_mss.mss053)   THEN LET l_mss.mss053  = 0 END IF
         IF cl_null(l_mss.mss061)   THEN LET l_mss.mss061  = 0 END IF
         IF cl_null(l_mss.mss062)   THEN LET l_mss.mss062  = 0 END IF
         IF cl_null(l_mss.mss063)   THEN LET l_mss.mss063  = 0 END IF
         IF cl_null(l_mss.mss064)   THEN LET l_mss.mss064  = 0 END IF
         IF cl_null(l_mss.mss065)   THEN LET l_mss.mss065  = 0 END IF
         IF cl_null(l_mss.mss041)   THEN LET l_mss.mss041  = 0 END IF
         IF cl_null(l_mss.mss043)   THEN LET l_mss.mss043  = 0 END IF
         IF cl_null(l_mss.mss044)   THEN LET l_mss.mss044  = 0 END IF
         IF cl_null(l_mss.mss06_fz) THEN LET l_mss.mss06_fz= 0 END IF
         LET g_no = g_no + 1
         LET l_msv.msv00    = g_no
         LET l_msv.msv031 = g_body[l_i].msv031
         LET l_msv.msv032= g_body[l_i].msv032
         LET l_msv.msv01    = l_mss.mss01
         LET l_msv.msv02    = l_mss.mss02
         LET l_msv.msv03    = l_mss.mss03
         LET l_msv.msv041   = l_mss.mss041
         LET l_msv.msv043   = l_mss.mss043
         LET l_msv.msv044   = l_mss.mss044
         LET l_msv.msv051   = l_mss.mss051
         LET l_msv.msv052   = l_mss.mss052
         LET l_msv.msv053   = l_mss.mss053
         LET l_msv.msv061   = l_mss.mss061
         LET l_msv.msv062   = l_mss.mss062
         LET l_msv.msv063   = l_mss.mss063
         LET l_msv.msv064   = l_mss.mss064
         LET l_msv.msv065   = l_mss.mss065
         LET l_msv.msv066   = l_mss.mss06_fz  
         LET l_msv.msv070   = l_msv.msv051 + l_msv.msv052 +
                                  l_msv.msv053 + l_msv.msv061 +
                                  l_msv.msv062 + l_msv.msv063 +
                                  l_msv.msv064 + l_msv.msv065 -
                                  l_msv.msv041 - l_msv.msv043 -
                                  l_msv.msv044
         LET l_msv.msv12    = 0
         LET l_msv.msv13    = 0
         LET l_msv.msv14    = 0
         LET l_msv.msv08    = 0
         LET l_msv.msv16    = 0
         INSERT INTO msv_file VALUES(l_msv.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err('insert msv_file',SQLCA.sqlcode,1)
         END IF
      END FOREACH
  END FOR
END FUNCTION
 
#處理一.1: 有些工廠可能在某些需求時距是沒有內容的,為了完整性,補上這些數據
FUNCTION p600_mend_msv()
  DEFINE l_i           LIKE type_file.num5    #NO.FUN-680082 SMALLINT
  DEFINE l_msv01       LIKE msv_file.msv01
  DEFINE l_msv02       LIKE msv_file.msv02
  DEFINE l_msv03       LIKE msv_file.msv03
# DEFINE l_rowid       LIKE type_file.chr18   
  DEFINE l_x_msv000    LIKE msv_file.msv000
  DEFINE l_x_msv01     LIKE msv_file.msv01
  DEFINE l_x_msv02     LIKE msv_file.msv02
  DEFINE l_x_msv03     LIKE msv_file.msv03
  DEFINE l_x_msv031    LIKE msv_file.msv031
 
    LET g_no = 0
    DECLARE sel_uni_msv CURSOR FOR
     SELECT UNIQUE msv01,msv02,msv03 FROM msv_file
      WHERE msv000 = g_msu000
      ORDER BY msv01,msv02,msv03
    FOREACH sel_uni_msv INTO l_msv01,l_msv02,l_msv03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach sel_uni_msv',SQLCA.sqlcode,1)
       END IF
       FOR l_i = 1 TO g_body.getLength()
#TQC-970277---begin                                                                                                                 
           IF cl_null(g_body[l_i].msv031) THEN                                                                                      
              EXIT FOR                                                                                                              
           END IF                                                                                                                   
#TQC-970277---end 
           LET g_no = g_no + 1
           SELECT msv000,msv01,msv02,msv03,msv031,msv_file.* INTO l_x_msv000,l_x_msv01,l_x_msv02,l_x_msv03,l_x_msv031,gg_msv.* 
             FROM msv_file
            WHERE msv000 = g_msu000 AND msv01 = l_msv01
              AND msv02 = l_msv02 AND msv03 = l_msv03
              AND msv031 = g_body[l_i].msv031
           IF SQLCA.sqlcode = 0 THEN
              LET gg_msv.msv00 = g_no
              UPDATE msv_file SET *=gg_msv.* WHERE msv000=l_x_msv000 AND msv01=l_x_msv01 AND msv02=l_x_msv02 AND msv03=l_x_msv03 AND msv031=l_x_msv031
              IF SQLCA.sqlcode THEN
                 CALL cl_err('update msv_file',SQLCA.sqlcode,1)
              END IF
           ELSE
              CALL p600_init_msv()
              LET gg_msv.msv00     = g_no
              LET gg_msv.msv01     = l_msv01
              LET gg_msv.msv02     = l_msv02
              LET gg_msv.msv03     = l_msv03
              LET gg_msv.msv031  = g_body[l_i].msv031
              LET gg_msv.msv032 = g_body[l_i].msv032
              INSERT INTO msv_file VALUES(gg_msv.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err('insert msv_file',SQLCA.sqlcode,1)
              END IF
           END IF
       END FOR
    END FOREACH
END FUNCTION
 
#處理二: 將msv_file的資料匯總至msu_file中
FUNCTION p600_ins_msu()
  DEFINE l_msu           RECORD LIKE msu_file.*
  DEFINE l_i             LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
    LET g_no = 0
    INITIALIZE l_msu.* TO NULL
    DECLARE msv_cur CURSOR FOR
     SELECT msv000,'',msv01,msv02,msv03,SUM(msv041),SUM(msv043),
            SUM(msv044),SUM(msv051),SUM(msv052),SUM(msv053),
            SUM(msv061),SUM(msv062),SUM(msv063),SUM(msv064),
            SUM(msv065),SUM(msv066),0,0,0,0,'','','','','','',''
       FROM msv_file
      WHERE msv000=g_msu000
      GROUP BY msv000,msv01,msv02,msv03
      ORDER BY msv000,msv01,msv02,msv03
 
    FOREACH msv_cur INTO l_msu.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach msv_cur',SQLCA.sqlcode,1)
       END IF
       CALL ui.Interface.refresh()
       CALL cl_getmsg('amr-307',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED ,l_msu.msu01 CLIPPED,
               " ",l_msu.msu02 CLIPPED,
               " ",l_msu.msu03 CLIPPED
       #MESSAGE "Insert msu_file ","Item:",l_msu.msu01 CLIPPED,
       #        " Vendor:",l_msu.msu02 CLIPPED,
       #        " Demand/Supply Date:",l_msu.msu03 CLIPPED
       LET g_no = g_no + 1
       LET l_msu.msu00 = g_no
       LET l_msu.msu12 = 'N'
       LET l_msu.msuacti = 'Y'
       LET l_msu.msuuser = g_user
       LET l_msu.msugrup = g_grup
       LET l_msu.msumodu = ''
       LET l_msu.msudate = g_today
       LET l_msu.msuoriu = g_user      #No.FUN-980030 10/01/04
       LET l_msu.msuorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO msu_file VALUES(l_msu.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err('insert msu_file',SQLCA.sqlcode,1)
       END IF
   END FOREACH
END FUNCTION
 
#處理三: 重計msu_file的交期重排減少量/交期重排增加量/預計結存/PLP量
FUNCTION p600_comp_msu()
# DEFINE l_x_rowid      LIKE type_file.chr18   
  DEFINE l_x_msu000     LIKE msu_file.msu000
  DEFINE l_x_msu01      LIKE msu_file.msu01
  DEFINE l_x_msu02      LIKE msu_file.msu02
  DEFINE l_x_msu03      LIKE msu_file.msu03
  DEFINE l_msu          RECORD LIKE msu_file.*
  DEFINE l_name         LIKE type_file.chr20   # External(Disk) file name   #NO.FUN-680082 VARCHAR(20)
  DEFINE l_cmd          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(30)
 
    CALL cl_outnam('amrp600') RETURNING l_name
 
    START REPORT p600_rep TO l_name
 
    LET g_no = 0
    DECLARE sel_msu_cur CURSOR FOR
#     SELECT msu000,msu01,msu02,msu03,msu_file.* FROM msu_file  #No.TQC-AC0061 重複撈取資料 去掉msu000,msu01~03
      SELECT msu_file.* FROM msu_file                           #No.TQC-AC0061 修改後的SQL
      WHERE msu000 = g_msu000
      ORDER BY msu01,msu02,msu03
#   FOREACH sel_msu_cur INTO l_x_msu000,l_x_msu01,l_x_msu02,l_x_msu03,l_msu.* #No.TQC-AC0061 去掉多餘傳入值
    FOREACH sel_msu_cur INTO l_msu.*                                          #No.TQC-AC0061 修改後的FOREACH
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach sel_msu_cur',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL ui.Interface.refresh()
       CALL cl_getmsg('amr-308',g_lang) RETURNING g_msg
       ERROR l_msu.msu01,' ',g_msg CLIPPED
#      OUTPUT TO REPORT p600_rep(l_x_msu000,l_x_msu01,l_x_msu02,l_x_msu03,l_msu.*) #No.TQC-AC0061更改前3個傳入值
       OUTPUT TO REPORT p600_rep(l_msu.msu000,l_msu.msu01,l_msu.msu02,l_msu.msu03,l_msu.*) #No.TQC-AC0061
    END FOREACH
    FINISH REPORT p600_rep
#   LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009 
#   RUN l_cmd                                          #No.FUN-9C0009
    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
 
REPORT p600_rep(p_msu000,p_msu01,p_msu02,p_msu03, msu)
# DEFINE p_rowid        LIKE type_file.chr18     
  DEFINE p_msu000       LIKE msu_file.msu000
  DEFINE p_msu01        LIKE msu_file.msu01
  DEFINE p_msu02        LIKE msu_file.msu02
  DEFINE p_msu03        LIKE msu_file.msu03
  DEFINE msu            RECORD LIKE msu_file.*
  DEFINE l_i,l_j,l_k    LIKE type_file.num10     #NO.FUN-680082 INTEGER
  DEFINE bal            LIKE mss_file.mss041
  DEFINE qty2           LIKE mss_file.mss041
  DEFINE l_ima08        LIKE ima_file.ima08
  DEFINE l_ima45        LIKE ima_file.ima05
  DEFINE l_ima46        LIKE ima_file.ima46
  DEFINE l_ima47        LIKE ima_file.ima47
  DEFINE l_ima50        LIKE ima_file.ima50
  DEFINE l_ima72        LIKE ima_file.ima72
DEFINE rrr            DYNAMIC ARRAY OF RECORD
x_msu000  LIKE msu_file.msu000,
x_msu01   LIKE msu_file.msu01,
x_msu02   LIKE msu_file.msu02,
x_msu03   LIKE msu_file.msu03
                        END RECORD
  DEFINE sss            DYNAMIC ARRAY OF RECORD LIKE msu_file.*

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY msu.msu01,msu.msu02,msu.msu03
  FORMAT
    BEFORE GROUP OF msu.msu01
       SELECT ima08,ima45,ima46,ima47,ima50+ima48+ima49+ima491,ima72
         INTO l_ima08,l_ima45,l_ima46,l_ima47,l_ima50,l_ima72
        FROM ima_file
       WHERE ima01=msu.msu01
       IF l_ima45 IS NULL THEN LET l_ima45=0 END IF
       IF l_ima46 IS NULL THEN LET l_ima46=0 END IF
       IF l_ima47 IS NULL THEN LET l_ima47=0 END IF
       IF l_ima50 IS NULL THEN LET l_ima50=0 END IF
       IF l_ima72 IS NULL THEN LET l_ima72=0 END IF
       IF STATUS THEN
          LET l_ima45=0 LET l_ima46=0 LET l_ima47=0 LET l_ima50=0
       END IF
       IF l_ima08='P' THEN
          CASE WHEN g_po_days>0 LET l_ima72=g_po_days
               WHEN g_po_days=0 LET l_ima72=g_po_days
               WHEN g_po_days<0 LET l_ima72=l_ima72
          END CASE
       END IF
 
    BEFORE GROUP OF msu.msu02
      FOR l_i = 1 TO 100
LET rrr[l_i].x_msu000=NULL
LET rrr[l_i].x_msu01 =NULL
LET rrr[l_i].x_msu02 =NULL
LET rrr[l_i].x_msu03 =NULL
          INITIALIZE sss[l_i].* TO NULL
      END FOR
      LET l_i = 0
    ON EVERY ROW
      LET g_no =g_no + 1
      LET l_i = l_i+1
LET rrr[l_i].x_msu000=p_msu000
LET rrr[l_i].x_msu01 =p_msu01
LET rrr[l_i].x_msu02 =p_msu02
LET rrr[l_i].x_msu03 =p_msu03
      LET sss[l_i].*      =msu.*
      LET sss[l_i].msu00=g_no
    AFTER GROUP OF msu.msu02
      LET bal=0
      FOR l_i = 1 TO 100
        IF sss[l_i].msu01 IS NULL THEN EXIT FOR END IF
        LET bal=bal
               +sss[l_i].msu051+sss[l_i].msu052+sss[l_i].msu053
               +sss[l_i].msu061+sss[l_i].msu062+sss[l_i].msu063
               +sss[l_i].msu064+sss[l_i].msu065
               -sss[l_i].msu041-sss[l_i].msu043-sss[l_i].msu044
               -sss[l_i].msu071+sss[l_i].msu072
        IF bal < 0 THEN
         #DISPLAY 'bal < 0 check-->',l_i   #CHI-A70049 mark
          FOR l_j = l_i+1 TO 100            # 請/采購交期, 工單完工日調整
            IF sss[l_j].msu01 IS NULL THEN EXIT FOR END IF
            IF sss[l_j].msu03 > sss[l_i].msu03+l_ima72 THEN EXIT FOR END IF
            LET qty2=sss[l_j].msu061+sss[l_j].msu062+sss[l_j].msu063
                    +sss[l_j].msu064
                    -sss[l_j].msu066                    # 扣除Frozen凍結量
                    -sss[l_j].msu071+sss[l_j].msu072
            IF qty2 <= 0 THEN CONTINUE FOR END IF
            IF qty2 >= bal*-1
               THEN LET sss[l_j].msu071=sss[l_j].msu071+bal*-1
                    LET sss[l_i].msu072=sss[l_i].msu072+bal*-1
                    LET bal=0
                    EXIT FOR
               ELSE LET sss[l_j].msu071=sss[l_j].msu071+qty2
                    LET sss[l_i].msu072=sss[l_i].msu072+qty2
                    LET bal=bal+qty2
            END IF
          END FOR
        END IF
        LET sss[l_i].msu08=bal
        IF sss[l_i].msu08 < 0 THEN                        #-> plan order
           LET sss[l_i].msu09=sss[l_i].msu08*-1
           IF l_ima47 != 0 THEN                         # 采購/制造損耗率
              LET sss[l_i].msu09 = sss[l_i].msu09 * (100+l_ima47)/100
           END IF
           IF l_ima45 != 0 THEN                         # 采購/制造倍量
              LET l_k = (sss[l_i].msu09 / l_ima45) + 0.999
              LET sss[l_i].msu09 = l_ima45 * l_k
           END IF
           IF sss[l_i].msu09 < l_ima46 THEN               # 最小采購/制造量
              LET sss[l_i].msu09 = l_ima46
           END IF
           LET needdate=NULL
           IF needdate IS NULL THEN LET needdate=sss[l_i].msu03 END IF
           LET sss[l_i].msu11=s_aday(needdate,-1,l_ima50)  # 減采購/制造前置日數
           IF sss[l_i].msu11 > sss[l_i].msu03 THEN
              LET sss[l_i].msu11=sss[l_i].msu03
           END IF
        END IF
        LET bal=sss[l_i].msu08+sss[l_i].msu09
        UPDATE msu_file SET *=sss[l_i].* 
         WHERE msu000  = sss[l_i].msu000
           AND msu01 = sss[l_i].msu01
           AND msu02 = sss[l_i].msu02
           AND msu03 = sss[l_i].msu03
        IF SQLCA.SQLCODE THEN
           CALL ui.Interface.refresh()
           ERROR sss[l_i].msu01,' ',sss[l_i].msu03
           CALL ui.Interface.refresh()
           CALL cl_err('plan:upd msu:',SQLCA.SQLCODE,1)
        END IF
      END FOR
END REPORT
 
#處理四: 重計msv_file的建議調撥出量/建議調撥入量/交期重排減少量/交期得排增加量量
FUNCTION p600_comp_msv()
#DEFINE l_x_rowid      LIKE type_file.chr18    #
DEFINE l_x_msv000      LIKE msv_file.msv000
DEFINE l_x_msv01       LIKE msv_file.msv01
DEFINE l_x_msv02       LIKE msv_file.msv02
DEFINE l_x_msv03       LIKE msv_file.msv03
DEFINE l_x_msv031      LIKE msv_file.msv031
  DEFINE l_msv          RECORD LIKE msv_file.*
  DEFINE l_name         LIKE type_file.chr20    # External(Disk) file name  #NO.FUN-680082 VARCHAR(20)
  DEFINE l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(30)
  #CHI-6B0015  --begin
  DEFINE l_msu01        LIKE msu_file.msu01
  DEFINE l_msu02        LIKE msu_file.msu02
  DEFINE l_msu03        LIKE msu_file.msu03
  #CHI-6B0015  --end
 
    CALL cl_outnam('amrp600') RETURNING l_name
 
    #CHI-6B0015   --begin
    DECLARE sel_msu_cr CURSOR FOR
     SELECT msu01,msu02,msu03
       FROM msu_file
      WHERE msu000 = g_msu000
      ORDER BY msu01,msu02,msu03
    FOREACH sel_msu_cr INTO l_msu01,l_msu02,l_msu03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach sel_msu_cur',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       START REPORT p600_rep1 TO l_name               #MODNO:5522
 
       LET g_no = 0
       DECLARE sel_msv_cur CURSOR FOR
        SELECT msv000,msv01,msv02,msv03,msv031,msv_file.* FROM msv_file
         WHERE msv000 = g_msu000
           AND msv01 = l_msu01 
           AND msv02 = l_msu02 
           AND msv03 = l_msu03 
         ORDER BY msv070
       FOREACH sel_msv_cur INTO l_x_msv000,l_x_msv01,l_x_msv02,l_x_msv03,l_x_msv031,l_msv.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach sel_msu_cur',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          CALL ui.Interface.refresh()
          CALL cl_getmsg('amr-309',g_lang) RETURNING g_msg
          #MESSAGE 'Item:',l_msv.msv01,' msv_file Suggested Trans-Out/In Qty'
          ERROR l_msv.msv01,' ',g_msg CLIPPED
          OUTPUT TO REPORT p600_rep1(l_x_msv000,l_x_msv01,l_x_msv02,l_x_msv03,l_x_msv031, l_msv.*)
       END FOREACH
       FINISH REPORT p600_rep1
    END FOREACH
    #CHI-6B0015   --end
#   LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009 
#   RUN l_cmd                                          #No.FUN-9C0009
    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
END FUNCTION
 
REPORT p600_rep1(x_msv000,x_msv01,x_msv02,x_msv03,x_msv031, msv)
# DEFINE x_rowid        LIKE type_file.chr18    
  DEFINE x_msv000       LIKE msv_file.msv000
  DEFINE x_msv01        LIKE msv_file.msv01
  DEFINE x_msv02        LIKE msv_file.msv02
  DEFINE x_msv03        LIKE msv_file.msv03
  DEFINE x_msv031       LIKE msv_file.msv031
  DEFINE msv            RECORD LIKE msv_file.*
  DEFINE l_msu          RECORD LIKE msu_file.*
  DEFINE i,j,k          LIKE type_file.num10     #NO.FUN-680082 INTEGER
  DEFINE bal            LIKE mss_file.mss041
  DEFINE qty2           LIKE mss_file.mss041
  DEFINE l_msu070       LIKE mss_file.mss041
  DEFINE l_msv03        LIKE msv_file.msv03
  DEFINE l_msv016       LIKE msv_file.msv16     #NO.FUN-680082 INTEGER
  DEFINE xxx            DYNAMIC ARRAY OF RECORD
#        x_rowid    LIKE type_file.chr18    #
         x_msv000   LIKE msv_file.msv000,
         x_msv01    LIKE msv_file.msv01,
         x_msv02    LIKE msv_file.msv02,
         x_msv03    LIKE msv_file.msv03,
         x_msv031   LIKE msv_file.msv031
                        END RECORD
  DEFINE ttt            DYNAMIC ARRAY OF RECORD LIKE msv_file.*

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY msv.msv01,msv.msv02,msv.msv03,msv.msv070
  FORMAT
    BEFORE GROUP OF msv.msv03
      #計算上層工廠的交期調整量
      SELECT * INTO l_msu.* FROM msu_file
       WHERE msu000 = g_msu000 AND msu01 = msv.msv01
         AND msu02 = msv.msv02 AND msu03 = msv.msv03
      LET l_msu070 = l_msu.msu072 - l_msu.msu071
      IF cl_null(l_msu070) THEN LET l_msu070 = 0 END IF
      FOR i = 1 TO 100
           LET xxx[i].x_msv000=NULL
           LET xxx[i].x_msv01 =NULL
           LET xxx[i].x_msv02 =NULL
           LET xxx[i].x_msv03 =NULL
           LET xxx[i].x_msv031=NULL
          INITIALIZE ttt[i].* TO NULL
      END FOR
      LET i = 0
    ON EVERY ROW
      LET i = i+1
LET xxx[i].x_msv000=x_msv000
LET xxx[i].x_msv01 =x_msv01
LET xxx[i].x_msv02 =x_msv02
LET xxx[i].x_msv03 =x_msv03
LET xxx[i].x_msv031=x_msv031
 
      LET ttt[i].*      =msv.*
      #refresh
      SELECT msv070 INTO ttt[i].msv070 FROM msv_file
       WHERE msv000   = g_msu000  
         AND msv01    = ttt[i].msv01
         AND msv02    = ttt[i].msv02 
         AND msv03    = ttt[i].msv03 
         AND msv031 = ttt[i].msv031
    AFTER GROUP OF msv.msv03
      LET bal=0
      FOR i = 1 TO 100
          #計算下層工廠的調撥出/入量
          IF ttt[i].msv01 IS NULL THEN EXIT FOR END IF
   #      IF ttt[i].msv01 = 'PG01-B' THEN #CHI-6B0015
   #         ERROR 1                      #CHI-6B0015
   #      END IF                          #CHI-6B0015
          LET bal=ttt[i].msv070
          IF bal < 0 THEN
             FOR j = i+1 TO 100            # 請/采購交期, 工單完工日調整
               IF ttt[j].msv01 IS NULL THEN EXIT FOR END IF
               LET qty2=ttt[j].msv070-ttt[j].msv12+ttt[j].msv13  #CHI-6B0015
               IF qty2 <= 0 THEN CONTINUE FOR END IF
               IF qty2 >= bal*-1
                  THEN LET ttt[j].msv12=ttt[j].msv12+bal*-1
                       LET ttt[i].msv13=ttt[i].msv13+bal*-1
                       LET bal=0
                       EXIT FOR
                  ELSE LET ttt[j].msv12=ttt[j].msv12+qty2
                       LET ttt[i].msv13=ttt[i].msv13+qty2
                       LET bal=bal+qty2
               END IF
             END FOR
           END IF
 
           #上層工廠的交期重排導致供給增加量要分攤至msv_file
           IF l_msu070 <> 0 THEN
              IF l_msu070 > 0 THEN   
                 #計算下層工廠的交期減少/增加量
                 LET bal = ttt[i].msv070 + ttt[i].msv13 - ttt[i].msv12
                 IF bal < 0 THEN
                    IF l_msu070 > = bal * - 1 THEN
                       LET ttt[i].msv14 = ttt[i].msv14 + bal * - 1
                       LET l_msu070 = l_msu070 + bal
                    ELSE
                       LET ttt[i].msv14 = ttt[i].msv14 + l_msu070
                       LET l_msu070 = 0
                    END IF
                 END IF
              #上層工廠的交期重排導致供給減少量要分攤至msv_file
              ELSE  
                 #計算下層工廠的交期減少/增加量
                 LET bal =ttt[i].msv061+ttt[i].msv062+ttt[i].msv063
                         +ttt[i].msv064-ttt[i].msv066 
                         +ttt[i].msv14
                 IF bal > 0 THEN
                    IF bal >= l_msu070 * - 1 THEN
                       LET ttt[i].msv14 = ttt[i].msv14 - l_msu070 * - 1
                       LET l_msu070 = 0
                    ELSE
                       LET ttt[i].msv14 = ttt[i].msv14 - bal
                       LET l_msu070 = l_msu070 + bal
                    END IF
                 END IF
              END IF
           END IF
           LET ttt[i].msv08 = ttt[i].msv070+ttt[i].msv13 -
                                ttt[i].msv12 +ttt[i].msv14
           #計算PLP
           IF ttt[i].msv08 < 0 THEN
           #  LET l_msv016 = ttt[i].msv08/l_msu.msu08*l_msu.msu09 #CHI-6B0015
              LET l_msv016=ttt[i].msv08*(l_msu.msu09/l_msu.msu08) #CHI-6B0015
              LET ttt[i].msv16 = l_msv016
           END IF
           UPDATE msv_file SET *=ttt[i].* WHERE msv000=xxx[i].x_msv000 AND msv01=xxx[i].x_msv01 AND msv02=xxx[i].x_msv02 AND msv03=xxx[i].x_msv03 AND msv031=xxx[i].x_msv031
           IF SQLCA.SQLCODE THEN
              CALL ui.Interface.refresh()
              ERROR ttt[i].msv01,' ',ttt[i].msv03
              CALL ui.Interface.refresh()
              CALL cl_err('plan:upd msv:',SQLCA.SQLCODE,1)
           END IF
           LET l_msv03 = NULL
           SELECT MIN(msv03) INTO l_msv03 FROM msv_file
            WHERE msv000 = g_msu000  
              AND msv01 = ttt[i].msv01
              AND msv02 = ttt[i].msv02 
              AND msv031 = ttt[i].msv031
              AND msv03 > ttt[i].msv03
           IF NOT cl_null(l_msv03) AND l_msv03 > ttt[i].msv03 THEN
              UPDATE msv_file SET msv070 = msv070 + ttt[i].msv08
                                             + ttt[i].msv16
               WHERE msv000 = g_msu000  
                 AND msv01 = ttt[i].msv01
                 AND msv02 = ttt[i].msv02 
                 AND msv031 = ttt[i].msv031
                 AND msv03 = l_msv03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err('update msv070',SQLCA.sqlcode,1)
              END IF
           END IF
       END FOR
END REPORT
 
#Initialize mstg_file
FUNCTION p600_init_msv()
 
   INITIALIZE gg_msv.* TO NULL
   LET gg_msv.msv000    = g_msu000
   LET gg_msv.msv00     = 0
   LET gg_msv.msv01     = NULL
   LET gg_msv.msv02     = NULL
   LET gg_msv.msv03     = NULL
   LET gg_msv.msv031    = NULL
   LET gg_msv.msv032    = NULL
   LET gg_msv.msv041    = 0
   LET gg_msv.msv043    = 0
   LET gg_msv.msv044    = 0
   LET gg_msv.msv051    = 0
   LET gg_msv.msv052    = 0
   LET gg_msv.msv053    = 0
   LET gg_msv.msv061    = 0
   LET gg_msv.msv062    = 0
   LET gg_msv.msv063    = 0
   LET gg_msv.msv064    = 0
   LET gg_msv.msv065    = 0
   LET gg_msv.msv066    = 0
   LET gg_msv.msv070    = 0
   LET gg_msv.msv12     = 0
   LET gg_msv.msv13     = 0
   LET gg_msv.msv14     = 0
   LET gg_msv.msv08     = 0
   LET gg_msv.msv16     = 0
 
END FUNCTION
 
#No.FUN-740234--begin-- 
FUNCTION p600_wc_default()
DEFINE l_sql     STRING 
DEFINE i         LIKE type_file.num5
DEFINE l_azp03   LIKE azp_file.azp03
 
 
    LET g_atot = 0
    LET i=1
    LET l_sql = "SELECT * FROM msw_file WHERE msw000='",g_msu000,"'"
    PREPARE p600_prep  FROM l_sql
    DECLARE p600_cs CURSOR FOR p600_prep
    FOREACH p600_cs INTO msw.*
        LET g_po_days = msw.msw02
        LET g_msv[i].msv031 = msw.msw08
        IF NOT cl_null(g_msv[i].msv031) THEN 
           SELECT azp02,azp03 INTO g_msv[i].plantname,l_azp03 FROM azp_file 
            WHERE azp01 = msw.msw08
           IF SQLCA.sqlcode THEN 
              CALL cl_err3('sel','azp_file',msw.msw08,'',SQLCA.sqlcode,'','',1)
              LET g_msv[i].plantname = NULL
              LET l_azp03 = NULL 
              EXIT FOREACH 
           END IF 
        END IF 
        LET g_msv[i].msv032 = msw.msw10
        #CALL p600_chk(i,l_azp03) RETURNING g_success
        CALL p600_chk(i,msw.msw08) RETURNING g_success   #FUN-A50102
        IF g_success = 'N' THEN 
           LET g_msv[i].msv031 = NULL
           LET g_msv[i].msv032 = NULL 
        ELSE 
        	 LET g_body[i].msv031 = g_msv[i].msv031
           LET g_body[i].msv032 = g_msv[i].msv032
           LET g_body[i].azp03  = l_azp03
           LET i = i+1
        END IF
        DISPLAY g_po_days TO po_days
    END FOREACH  
    CALL g_msv.deleteElement(i)
    LET g_atot = i - 1   
    
     
END FUNCTION 
 
#FUNCTION p600_chk(p_i,p_azp03)
FUNCTION p600_chk(p_i,p_azp01)   #FUN-A50102
DEFINE   p_i              LIKE type_file.num5
DEFINE   l_success        LIKE type_file.chr1
#DEFINE   p_azp03          LIKE azp_file.azp03
DEFINE   p_azp01          LIKE azp_file.azp01   #FUN-A50102 
DEFINE   l_bdate,l_edate  LIKE type_file.dat      
DEFINE   l_buk_type       LIKE msr_file.buk_type
 
    LET l_success = 'Y' 
    
  # LET g_sql = "SELECT bdate,edate,buk_type FROM ",
  #              s_dbstring(p_azp03 CLIPPED),"msr_file",
  #             " WHERE msr_v='",g_msv[p_i].msv032,"'"
 
    LET g_sql = "SELECT bdate,edate,buk_type ",
                #" FROM ",s_dbstring(p_azp03) CLIPPED,"msr_file ",
                " FROM ",cl_get_target_table(p_azp01,'msr_file'), #FUN-A50102       
                " WHERE msr_v='",g_msv[p_i].msv032,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql #FUN-A50102
    PREPARE p600_prepare2 FROM g_sql
    DECLARE p600_sel_ver1 CURSOR FOR p600_prepare2
    OPEN p600_sel_ver1
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode = 100 THEN
          CALL cl_err(g_msv[p_i].msv032,'amr-302',1)
          LET l_success ='N'
          RETURN l_success 
       ELSE
          CALL cl_err(g_msv[p_i].msv032,SQLCA.sqlcode,1)
          LET l_success = 'N'
          RETURN l_success
       END IF
    END IF
    FETCH p600_sel_ver1 INTO l_bdate,l_edate,l_buk_type
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_msv[p_i].msv032,'amr-305',1)
       LET l_success ='N'
       RETURN l_success 
    END IF
    CLOSE p600_sel_ver
    IF p_i <> 1 THEN
       IF l_bdate    <> g_bdate OR
          l_edate    <> g_edate OR
          l_buk_type <> g_buk_type THEN
          CALL cl_err(g_msv[p_i].msv032,'amr-302',1)
          LET l_success = 'N'
          RETURN l_success 
       END IF
    ELSE
       LET g_bdate   = l_bdate
       LET g_edate   = l_edate
       LET g_buk_type= l_buk_type
    END IF
    
    RETURN l_success 
         
END FUNCTION 
 
FUNCTION p600_del()
    CALL p600_del_msu()
    CALL p600_del_msv()
END FUNCTION 
 
FUNCTION p600_del_msu() 
    DELETE FROM msu_file WHERE msu000=g_msu000
    IF SQLCA.sqlcode THEN CALL cl_err3('del','msu_file',g_msu000,'',SQLCA.sqlcode,'','',1) END IF 
END FUNCTION 
 
FUNCTION p600_del_msv()
    DELETE FROM msv_file WHERE msv000=g_msu000
    IF SQLCA.sqlcode THEN CALL cl_err3('del','msv_file',g_msu000,'',SQLCA.sqlcode,'','',1) END IF 
END FUNCTION 
 
FUNCTION p600_ins_msw()
DEFINE   i             LIKE type_file.num5 
 
     DELETE FROM msw_file WHERE msw000=g_msu000
     IF SQLCA.sqlcode THEN CALL cl_err3('del','msw_file',g_msu000,'',SQLCA.sqlcode,'','',1) END IF 
     FOR i =1 TO g_atot
         LET msw.msw000 = g_msu000
         LET msw.msw02  = g_po_days
         LET msw.msw03  = TODAY
         LET msw.msw04  = TIME
         LET msw.msw05  = NULL
         LET msw.msw07  = g_user
         LET msw.msw08  = g_msv[i].msv031
         LET msw.msw10  = g_msv[i].msv032
         IF (NOT cl_null(g_msu000)) AND (NOT cl_null(g_msv[i].msv031)) THEN 
            INSERT INTO msw_file VALUES(msw.*)
            IF SQLCA.sqlcode THEN CALL cl_err3('ins','msw_file',g_msu000,'',SQLCA.sqlcode,'','',1) END IF          
         END IF 
     END FOR     
 
END FUNCTION 
 
FUNCTION p600_upd_msw()
 
    MESSAGE " End ....."
    LET msw.msw05 =  TIME
    UPDATE msw_file SET msw05 = msw.msw05
     WHERE msw000=g_msu000
    IF SQLCA.sqlcode  THEN CALL cl_err3('upd','msw_file',g_msw000,'',SQLCA.sqlcode,'','',1) END IF 
 
END FUNCTION 
#No.FUN-740234--end--

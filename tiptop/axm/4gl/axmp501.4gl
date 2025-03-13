# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmp501.4gl
# Descriptions...: 訂單分配作業
# Date & Author..: No.FUN-630006 06/03/07 By Nicola
# Modify.........: No.FUN-640025 06/04/08 By Nicola 取消欄位oaz19的判斷
# Modify.........: No.MOD-640030 06/04/08 By Nicola 輸入單身內部流程時, 需check流程(apmi000)來源工廠=現行工廠
# Modify.........: No.MOD-640060 06/04/08 By Nicola 加入"出貨營運中心"開窗功能
# Modify.........: No.MOD-640040 06/04/09 By Nicola 訂單為需分配時，才帶出資料
# Modify.........: No.MOD-640098 06/04/09 By Nicola 分配預設後..未enter不會insert
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE   
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-670007 06/11/27 by Yiting 3.5版之後，poz05不使用，來源站拉到單身處理
# Modify.........: No.TQC-710033 07/03/29 By Mandy 多單位畫面標準寫法調整
# Modify.........: No.TQC-740036 07/04/09 By Ray "內部流程代碼"開窗和after field段條件不一致
# Modify.........: No.MOD-840577 08/04/28 By mike 置光標
# Modify.........: No.MOD-8A0026 08/10/02 By Smapmin 輸入完單身後回到單頭應該回到原來的那一筆
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40060 10/04/14 By Smapmin 出貨營運中心改為noentry
# Modify.........: No:TQC-A40119 10/04/23 By houlia 單身欄位全部noentry時,點擊"分配作業"按鈕,程式自動當出
# Modify.........: No:TQC-A50038 10/05/13 By lilingyu 1.p501_b_fill()函數sql,當oeb03為空時,出現語法錯誤 2.拋轉一筆資料後,不退出,繼續分配,此時分配量出現異常
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No:MOD-B80201 11/08/19 By suncx 帶出接單流程時加入考慮客戶編號為*而產品編號不為*的情況
# Modify.........: No:FUN-BB0087 11/11/17 By wangning 增加數量欄位小數取位
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   DYNAMIC ARRAY OF RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oea_t RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oee   DYNAMIC ARRAY OF RECORD
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_oee_t RECORD
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       g_rec_b1       LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac1          LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac1_t        LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac           LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_ima906       LIKE ima_file.ima906
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_edit         LIKE type_file.chr1          #TQC-A40119 
 
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
 
   OPEN WINDOW p501_w WITH FORM "axm/42f/axmp501"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
  #TQC-710033 mark 將此段移至p501_def_form()內
  #IF g_sma.sma115 = "N" THEN
  #   CALL cl_set_comp_visible("oeb910,oeb912",FALSE)
  #   CALL cl_set_comp_visible("oeb913,oeb915",FALSE)
  #   CALL cl_set_comp_visible("oee061,oee062,oee063",FALSE)
  #   CALL cl_set_comp_visible("oee071,oee072,oee073",FALSE)
  #   CALL cl_set_comp_visible("oee081,oee082",FALSE)
  #   CALL cl_set_comp_entry("oee063,oee073",FALSE)
  #ELSE
  #   CALL cl_set_comp_entry("oee083",FALSE)
  #   CALL cl_set_comp_visible("oee062,oee072,oee082",FALSE)
  #END IF
   CALL p501_def_form()   #TQC-710033 add
 
   CALL p501_menu()
 
   CLOSE WINDOW p501_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0094
 
END MAIN
 
FUNCTION p501_menu()
 
   WHILE TRUE
      CALL p501_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p501_q()
            END IF
         WHEN "distributed_detail"
            IF cl_chk_act_auth() THEN
               CALL p501_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               LET g_msg="axmp502 '",g_oea_t.oea01,"' ",g_oea_t.oeb03
               CALL cl_cmdrun_wait(g_msg CLIPPED)
               CALL p501_b_fill()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p501_q()
 
   CALL p501_b_askkey()
 
END FUNCTION
 
FUNCTION p501_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否         #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態           #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否            #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否            #No.FUN-680137 SMALLINT
   DEFINE l_oee09         LIKE oee_file.oee09
   DEFINE l_sumoee083     LIKE oee_file.oee083
   DEFINE l_poy03         LIKE poy_file.poy03                 #FUN-670007
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg("b")
 
   IF cl_null(g_oea_t.oea01) THEN
      RETURN
   END IF
 
   LET g_forupd_sql = "SELECT oee03,oee04,'',oee05,oee071,oee072,",
                      "       oee073,oee061,oee062,oee063,oee081,",
                      "       oee082,oee083,oee09,oee10,oee11",
                      "  FROM oee_file",
                      "  WHERE oee01 = ? AND oee02=?",
                      "   AND oee03=? AND oee05=?",
                      "   AND oee09=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p501_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_oee WITHOUT DEFAULTS FROM s_oee.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ""
         LET l_ac = ARR_CURR()
         LET l_lock_sw = "N"
         LET l_n  = ARR_COUNT()
         BEGIN WORK     #MOD-8A0026
         IF g_rec_b >= l_ac THEN
            LET g_oee_t.* = g_oee[l_ac].*
            LET p_cmd = "u"
            #BEGIN WORK     #MOD-8A0026
            OPEN p501_bcl USING g_oea_t.oea01,g_oea_t.oeb03, 
                                g_oee_t.oee03,g_oee_t.oee05,g_oee_t.oee09
            IF STATUS THEN
               CALL cl_err("OPEN p501_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p501_bcl INTO g_oee[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_oee_t.oee03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT azp02 INTO g_oee[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_oee[l_ac].oee04
               END IF
            END IF
         END IF
         CALL p501_set_entry()
         CALL p501_set_no_entry()
#------TQC-A40119------add
         IF g_edit = 'N' THEN
            LET l_ac= l_ac + 1
            CALL fgl_set_arr_curr(l_ac)
         END IF
#------TQC-A40119------end
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = "a"
         INITIALIZE g_oee[l_ac].* TO NULL
         LET g_oee_t.* = g_oee[l_ac].*
         CALL p501_set_entry()
         CALL p501_set_no_entry()
         LET g_oee_t.oee083 = 0
 
         SELECT poe04,poe05 INTO g_oee[l_ac].oee03,g_oee[l_ac].oee09
           FROM poe_file
          WHERE poe01 = g_oea[l_ac1].oea03
            AND poe03 = g_oea[l_ac1].oeb04
         IF STATUS THEN
            SELECT poe04,poe05 INTO g_oee[l_ac].oee03,g_oee[l_ac].oee09
              FROM poe_file
             WHERE poe01 = g_oea[l_ac1].oea03
               AND poe03 = "*"
            IF STATUS THEN
               #MOD-B80201  add begin--------------------
               SELECT poe04,poe05 INTO g_oee[l_ac].oee03,g_oee[l_ac].oee09
                 FROM poe_file
                WHERE poe01 = "*"
                  AND poe03 = g_oea[l_ac1].oeb04
               IF STATUS THEN
               #MOD-B80201  add end ---------------------
                  SELECT poe04,poe05 INTO g_oee[l_ac].oee03,g_oee[l_ac].oee09
                    FROM poe_file
                   WHERE poe01 = "*"
                     AND poe03 = "*"
               END IF  #MOD-B80201  add
            END IF
         END IF
 
         SELECT poy04 INTO g_oee[l_ac].oee04 FROM poy_file
          WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                          WHERE poy01 = g_oee[l_ac].oee03
                          GROUP BY poy01)
            AND poy01 = g_oee[l_ac].oee03
 
         SELECT azp02 INTO g_oee[l_ac].azp02 FROM azp_file
          WHERE azp01 = g_oee[l_ac].oee04
 
         LET g_oee[l_ac].oee05 = g_today
 
         SELECT SUM(oee083) INTO l_sumoee083
           FROM oee_file
          WHERE oee01 = g_oea_t.oea01
            AND oee02 = g_oea_t.oeb03
 
         IF cl_null(l_sumoee083) THEN
            LET l_sumoee083 = 0
         END IF
 
         IF g_sma.sma115 = "Y" THEN
            SELECT oeb910,oeb911,oeb913,oeb914,oeb05,oeb05_fac 
              INTO g_oee[l_ac].oee061,g_oee[l_ac].oee062,
                   g_oee[l_ac].oee071,g_oee[l_ac].oee072,
                   g_oee[l_ac].oee081,g_oee[l_ac].oee082
              FROM oeb_file
             WHERE oeb01 = g_oea_t.oea01
               AND oeb03 = g_oea_t.oeb03
 
            IF g_ima906 = "1" THEN
               LET g_oee[l_ac].oee083 = g_oea_t.oeb12-l_sumoee083
               LET g_oee[l_ac].oee083 = s_digqty(g_oee[l_ac].oee083,g_oee[l_ac].oee081)  #FUN-BB0087 add
               LET g_oee[l_ac].oee063 = g_oee[l_ac].oee083 / g_oee[l_ac].oee062
               LET g_oee[l_ac].oee063 = s_digqty(g_oee[l_ac].oee063,g_oee[l_ac].oee061)  #FUN-BB0087 add
            ELSE
               LET g_oee[l_ac].oee063 = 0 
               LET g_oee[l_ac].oee073 = 0 
               LET g_oee[l_ac].oee083 = 0 
            END IF
         ELSE
            SELECT oeb05,oeb05_fac 
              INTO g_oee[l_ac].oee081,g_oee[l_ac].oee082
              FROM oeb_file
             WHERE oeb01 = g_oea_t.oea01
               AND oeb03 = g_oea_t.oeb03
 
            LET g_oee[l_ac].oee083 = g_oea_t.oeb12-l_sumoee083
            LET g_oee[l_ac].oee083 = s_digqty(g_oee[l_ac].oee083,g_oee[l_ac].oee081)  #FUN-BB0087 add
         END IF
         DISPLAY BY NAME g_oee[l_ac].*  #No.MOD-640098
         NEXT FIELD oee03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         CALL p501_keychk()
         IF g_cnt > 0 THEN
            CANCEL INSERT
            NEXT FIELD oee03
         END IF
         INSERT INTO oee_file(oee01,oee02,oee03,oee04,oee05,oee061,
                              oee062,oee063,oee071,oee072,oee073,
                              oee081,oee082,oee083,oee09,oee10,oee11,
                              oeeplant,oeelegal)   #FUN-980010 add plant & legal 
                       VALUES(g_oea_t.oea01,g_oea_t.oeb03,
                              g_oee[l_ac].oee03,g_oee[l_ac].oee04,
                              g_oee[l_ac].oee05,g_oee[l_ac].oee061,
                              g_oee[l_ac].oee062,g_oee[l_ac].oee063,
                              g_oee[l_ac].oee071,g_oee[l_ac].oee072,
                              g_oee[l_ac].oee073,g_oee[l_ac].oee081,
                              g_oee[l_ac].oee082,g_oee[l_ac].oee083,
                              g_oee[l_ac].oee09,g_oee[l_ac].oee10,
                              g_oee[l_ac].oee11,
                              g_plant,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oee[l_ac].oee03,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","oee_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660167
            CANCEL INSERT
         ELSE
            MESSAGE "INSERT O.K"
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD oee03
         IF g_oee[l_ac].oee03 != g_oee_t.oee03 OR cl_null(g_oee_t.oee03) THEN
            IF NOT cl_null(g_oee[l_ac].oee03) THEN
               CALL p501_keychk()
               #---FUN-670007 start--
               SELECT poy03 INTO l_poy03 
                 FROM poy_file
                WHERE poy01 = g_oee[l_ac].oee03
                  AND poy04 = g_plant
                  AND poy02 = '0'
               IF STATUS THEN
#                 CALL cl_err3("sel","poy_file",g_oee[l_ac].oee03,"","tri-006","","",0)   #No.FUN-660167      #No.TQC-740036
                  CALL cl_err3("sel","poy_file",g_oee[l_ac].oee03,"","tri-006","","",1)   #No.FUN-660167      #No.TQC-740036
                  NEXT FIELD oee03
               END IF
               #---FUN-670007 end----
#FUN-670007 mark----
               #-----No.MOD-640030-----
#               SELECT poz04
#                 FROM poz_file
#                WHERE poz00 = "2"
#                  AND poz05 = g_plant
#                  AND poz01 = g_oee[l_ac].oee03
#               IF STATUS THEN
##                 CALL cl_err(g_oee[l_ac].oee03,"tri-006",0)   #No.FUN-660167
#                  CALL cl_err3("sel","poz_file",g_oee[l_ac].oee03,"","tri-006","","",0)   #No.FUN-660167
#                  NEXT FIELD oee03
#               END IF
               #-----No.MOD-640030 END-----
#FUN-670007 mark----
               SELECT poy04 INTO g_oee[l_ac].oee04 FROM poy_file
                WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
                                WHERE poy01 = g_oee[l_ac].oee03
                                GROUP BY poy01)
                  AND poy01 = g_oee[l_ac].oee03
               IF STATUS THEN
#                 CALL cl_err("","tri-006",0)   #No.FUN-660167
#                 CALL cl_err3("sel","poy_file",g_oee[l_ac].oee03,"","tri-006","","",0)   #No.FUN-660167      #No.TQC-740036
                  CALL cl_err3("sel","poy_file",g_oee[l_ac].oee03,"","tri-006","","",1)   #No.FUN-660167      #No.TQC-740036
                  LET g_oee[l_ac].oee03 = g_oee_t.oee03
                  NEXT FIELD oee03
               ELSE
                  SELECT azp02 INTO g_oee[l_ac].azp02 FROM azp_file
                   WHERE azp01 = g_oee[l_ac].oee04
                  DISPLAY BY NAME g_oee[l_ac].oee04,g_oee[l_ac].azp02
               END IF
            ELSE
               LET g_oee[l_ac].oee03 = " "
               LET g_oee[l_ac].oee09 = " "
               LET g_oee[l_ac].oee04 = g_plant
               SELECT azp02 INTO g_oee[l_ac].azp02 FROM azp_file
                WHERE azp01 = g_oee[l_ac].oee04
               DISPLAY BY NAME g_oee[l_ac].oee04,g_oee[l_ac].azp02
            END IF
#TQC-A50038 --begin--
         ELSE 
         	   IF l_ac > 1  THEN
         	      IF g_oee[l_ac].oee03 = g_oee[l_ac-1].oee03 THEN 
         	         LET g_oee[l_ac].oee04 = g_oee[l_ac-1].oee04
         	         LET g_oee[l_ac].azp02 = g_oee[l_ac-1].azp02
         	         DISPLAY BY NAME g_oee[l_ac].oee04,g_oee[l_ac].azp02
         	      END IF 
         	   END IF          	  
#TQC-A50038 --end--             
         END IF
         CALL p501_set_no_entry()
 
      AFTER FIELD oee05
         IF NOT cl_null(g_oee[l_ac].oee05) THEN
            IF g_oee[l_ac].oee05 != g_oee_t.oee05 OR cl_null(g_oee_t.oee05) THEN
               CALL p501_keychk()
            END IF
         END IF
 
      AFTER FIELD oee063
         #FUN-BB0087--add--start--
         IF NOT cl_null(g_oee[l_ac].oee061) AND NOT cl_null(g_oee[l_ac].oee063) THEN 
            IF cl_null(g_oee_t.oee063) OR g_oee_t.oee063 != g_oee[l_ac].oee063 THEN 
               LET g_oee[l_ac].oee063 = s_digqty(g_oee[l_ac].oee063,g_oee[l_ac].oee061)
               DISPLAY BY NAME g_oee[l_ac].oee063
            END IF 
         END IF 
         #FUN-BB0087--add---end---
         IF cl_null(g_oee[l_ac].oee063) OR g_oee[l_ac].oee063 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD oee063
         ELSE
            IF g_ima906 = "2" THEN
               LET g_oee[l_ac].oee083 = g_oee[l_ac].oee063 * g_oee[l_ac].oee062
                                      + g_oee[l_ac].oee073 * g_oee[l_ac].oee072
            ELSE
               LET g_oee[l_ac].oee083 = g_oee[l_ac].oee063 * g_oee[l_ac].oee062
            END IF
            LET g_oee[l_ac].oee083 = s_digqty(g_oee[l_ac].oee083,g_oee[l_ac].oee081)  #FUN-BB0087 add
            DISPLAY BY NAME g_oee[l_ac].oee083
            SELECT SUM(oee083) INTO l_sumoee083
              FROM oee_file
             WHERE oee01 = g_oea_t.oea01
               AND oee02 = g_oea_t.oeb03
            IF cl_null(l_sumoee083) THEN
               LET l_sumoee083 = 0
            END IF
            IF g_oee[l_ac].oee083 > (g_oea_t.oeb12
                                     -l_sumoee083+g_oee_t.oee083) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD oee063
            END IF
         END IF
 
      AFTER FIELD oee073
         #FUN-BB0087--add--start--
         IF NOT cl_null(g_oee[l_ac].oee071) AND NOT cl_null(g_oee[l_ac].oee073) THEN 
            IF cl_null(g_oee_t.oee073) OR g_oee_t.oee073 != g_oee[l_ac].oee073 THEN 
               LET g_oee[l_ac].oee073 = s_digqty(g_oee[l_ac].oee073,g_oee[l_ac].oee071)
               DISPLAY BY NAME g_oee[l_ac].oee073
            END IF 
         END IF 
         #FUN-BB0087--add---end---
         IF cl_null(g_oee[l_ac].oee073) OR g_oee[l_ac].oee073 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD oee073
         ELSE
            IF g_ima906 = "2" THEN
               LET g_oee[l_ac].oee083 = g_oee[l_ac].oee063 * g_oee[l_ac].oee062
                                      + g_oee[l_ac].oee073 * g_oee[l_ac].oee072
            ELSE
               LET g_oee[l_ac].oee083 = g_oee[l_ac].oee063 * g_oee[l_ac].oee062
            END IF
            LET g_oee[l_ac].oee083 = s_digqty(g_oee[l_ac].oee083,g_oee[l_ac].oee081)  #FUN-BB0087 add
            DISPLAY BY NAME g_oee[l_ac].oee083
            SELECT SUM(oee083) INTO l_sumoee083
              FROM oee_file
             WHERE oee01 = g_oea_t.oea01
               AND oee02 = g_oea_t.oeb03
            IF cl_null(l_sumoee083) THEN
               LET l_sumoee083 = 0
            END IF
            IF g_oee[l_ac].oee083 > (g_oea_t.oeb12
                                     -l_sumoee083+g_oee_t.oee083) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD oee073
            END IF
         END IF
 
      AFTER FIELD oee083
         #FUN-BB0087--add--start--
         IF NOT cl_null(g_oee[l_ac].oee081) AND NOT cl_null(g_oee[l_ac].oee083) THEN 
            IF cl_null(g_oee_t.oee083) OR g_oee_t.oee083 != g_oee[l_ac].oee083 THEN 
               LET g_oee[l_ac].oee083 = s_digqty(g_oee[l_ac].oee083,g_oee[l_ac].oee081)
               DISPLAY BY NAME g_oee[l_ac].oee083
            END IF 
         END IF 
         #FUN-BB0087--add---end---
         IF cl_null(g_oee[l_ac].oee083) OR g_oee[l_ac].oee083 <= 0 THEN
            CALL cl_err("","aap-022",0)
            NEXT FIELD oee083
         ELSE
            SELECT SUM(oee083) INTO l_sumoee083
              FROM oee_file
             WHERE oee01 = g_oea_t.oea01
               AND oee02 = g_oea_t.oeb03
            IF cl_null(l_sumoee083) THEN
               LET l_sumoee083 = 0
            END IF
            IF g_oee[l_ac].oee083 > (g_oea_t.oeb12
                                     -l_sumoee083+g_oee_t.oee083) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD oee083
            END IF
         END IF
 
      AFTER FIELD oee09
         IF NOT cl_null(g_oee[l_ac].oee09) THEN
            IF g_oee[l_ac].oee09 != g_oee_t.oee09 OR cl_null(g_oee_t.oee09) THEN
               CALL s_check_no("apm",g_oee[l_ac].oee09,"g_oee_t.oee09","2",
                               "oee_file","oee09","")
                     RETURNING li_result,l_oee09
               IF NOT li_result THEN
                  CALL cl_err("","mfg3046",0)
                  LET g_oee[l_ac].oee09 = g_oee_t.oee09
                  NEXT FIELD oee09
               END IF
               CALL p501_keychk()
            END IF
         END IF
 
      BEFORE DELETE
         IF g_oee_t.oee04 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM oee_file
             WHERE oee01 = g_oea_t.oea01
               AND oee02 = g_oea_t.oeb03
               AND oee03 = g_oee_t.oee03
               AND oee05 = g_oee_t.oee05
               AND oee09 = g_oee_t.oee09
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_oee_t.oee03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","oee_file",g_oea_t.oea01,g_oea_t.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE "Delete OK"
            CLOSE p501_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            LET g_oee[l_ac].* = g_oee_t.*
            CLOSE p501_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_oee[l_ac].oee03,-263,1)
            LET g_oee[l_ac].* = g_oee_t.*
         ELSE
            UPDATE oee_file SET oee03 = g_oee[l_ac].oee03,
                                oee04 = g_oee[l_ac].oee04,
                                oee05 = g_oee[l_ac].oee05,
                                oee061 = g_oee[l_ac].oee061,
                                oee062 = g_oee[l_ac].oee062,
                                oee063 = g_oee[l_ac].oee063,
                                oee071 = g_oee[l_ac].oee071,
                                oee072 = g_oee[l_ac].oee072,
                                oee073 = g_oee[l_ac].oee073,
                                oee081 = g_oee[l_ac].oee081,
                                oee082 = g_oee[l_ac].oee082,
                                oee083 = g_oee[l_ac].oee083,
                                oee09 = g_oee[l_ac].oee09
             WHERE oee01 = g_oea_t.oea01
               AND oee02 = g_oea_t.oeb03
               AND oee03 = g_oee_t.oee03
               AND oee05 = g_oee_t.oee05
               AND oee09 = g_oee_t.oee09
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_oee[l_ac].oee04,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("upd","oee_file",g_oea_t.oea01,g_oea_t.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
               LET g_oee[l_ac].* = g_oee_t.*
            ELSE
               MESSAGE "UPDATE O.K"
               CLOSE p501_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            IF p_cmd = "u" THEN
               LET g_oee[l_ac].* = g_oee_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_oee.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "distributed_detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p501_bcl
            ROLLBACK WORK  
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30034 Add
         CLOSE p501_bcl
         COMMIT WORK  
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oee03)
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_poz2"      #No.TQC-740036
               LET g_qryparam.form ="q_poy2"      #No.TQC-740036
               LET g_qryparam.default1 = g_oee[l_ac].oee03
#              LET g_qryparam.arg1 = "2"          #No.TQC-740036
#              LET g_qryparam.arg2 = g_plant      #No.TQC-740036
               LET g_qryparam.arg1 = g_plant      #No.TQC-740036
               CALL cl_create_qry() RETURNING g_oee[l_ac].oee03
               DISPLAY BY NAME g_oee[l_ac].oee03
               NEXT FIELD oee03
            #-----No.MOD-640060-----
            WHEN INFIELD(oee04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_oee[l_ac].oee04
               CALL cl_create_qry() RETURNING g_oee[l_ac].oee04
               DISPLAY BY NAME g_oee[l_ac].oee04
               NEXT FIELD oee04
            #-----No.MOD-640060 END-----
            WHEN INFIELD(oee09)
              #CALL q_smy(FALSE,FALSE,g_oee[l_ac].oee09,"apm","2")  #TQC-670008 
               CALL q_smy(FALSE,FALSE,g_oee[l_ac].oee09,"APM","2")  #TQC-670008
                RETURNING g_oee[l_ac].oee09
               DISPLAY BY NAME g_oee[l_ac].oee09
               NEXT FIELD oee09
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   CLOSE p501_bcl
   COMMIT WORK  
 
END FUNCTION
 
FUNCTION p501_keychk()
 
   SELECT COUNT(*) INTO g_cnt FROM oee_file
    WHERE oee01 = g_oea_t.oea01
      AND oee02 = g_oea_t.oeb03
      AND oee03 = g_oee[l_ac].oee03
      AND oee05 = g_oee[l_ac].oee05
      AND oee09 = g_oee[l_ac].oee09
   IF g_cnt > 0 THEN
      CALL cl_err("","axm-298",0)
   END IF
 
END FUNCTION
 
FUNCTION p501_b_askkey()
 
   CLEAR FORM
   CALL g_oea.clear()
 
   CONSTRUCT g_wc2 ON oea03,oea01,oea02,oeb03,oeb04,oeb06,oeb15
                 FROM s_oea[1].oea03,s_oea[1].oea01,s_oea[1].oea02,
                      s_oea[1].oeb03,s_oea[1].oeb04,s_oea[1].oeb06,
                      s_oea[1].oeb15
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               WHEN INFIELD(oea01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oea11"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oeb04)
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state = "c"
#                    LET g_qryparam.form ="q_ima"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                    DISPLAY g_qryparam.multiret TO oeb04
                    NEXT FIELD oeb04
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
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p501_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea_t.* = g_oea[l_ac1].*
   SELECT ima906 INTO g_ima906 
     FROM ima_file
    WHERE ima01 = g_oea_t.oeb04
 
   CALL p501_b_fill()
 
END FUNCTION
 
FUNCTION p501_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT oea03,'',oea01,oea02,oeb03,oeb04,oeb06,",
               "       oeb913,oeb915,oeb910,oeb912,oeb12,oeb13,oeb15,oeb920", 
               "  FROM oea_file,oeb_file",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea01 = oeb01",
               "   AND oea00 = '1'",
               "   AND oea37 = 'Y'",
               "   AND (oeb12-oeb920) > 0",
               "   AND oeaconf = 'Y'",
               " ORDER BY oea03,oea01"
 
   PREPARE p501_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR p501_pb1
  
   CALL g_oea.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   #No.FUN-660167
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO g_oea[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oea[g_cnt].oea03
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oea.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p501_b_fill()
 
 #TQC-A50038 --begin--
   IF cl_null(g_oea_t.oeb03) THEN 
   LET g_sql = "SELECT oee03,oee04,'',oee05,oee071,oee072,oee073,",
               "       oee061,oee062,oee063,oee081,oee082,oee083,",
               "       oee09,oee10,oee11",
               "  FROM oee_file",
               " WHERE oee01 = '",g_oea_t.oea01 CLIPPED,"'",
               " ORDER BY oee03"
   ELSE 
#TQC-A50038 --end-- 
   LET g_sql = "SELECT oee03,oee04,'',oee05,oee071,oee072,oee073,",
               "       oee061,oee062,oee063,oee081,oee082,oee083,",
               "       oee09,oee10,oee11",
               "  FROM oee_file",
               " WHERE oee01 = '",g_oea_t.oea01 CLIPPED,"'",
               "   AND oee02 = ",g_oea_t.oeb03, 
               " ORDER BY oee03"
   END IF           #TQC-A50038                
  #DISPLAY g_sql                      #CHI-A70049 mark
 
   PREPARE p501_pb FROM g_sql
   DECLARE oee_curs CURSOR FOR p501_pb
  
   CALL g_oee.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oee_curs INTO g_oee[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_oee[g_cnt].azp02 FROM azp_file
       WHERE azp01 = g_oee[g_cnt].oee04
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oee.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p501_bp2()
 
   DISPLAY ARRAY g_oee TO s_oee.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION p501_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)
 
      #-----MOD-8A0026---------
      BEFORE DISPLAY 
         CALL fgl_set_arr_curr(l_ac1)
      #-----END MOD-8A0026----- 
 
      BEFORE ROW
         #LET l_ac1 = ARR_CURR()           #No.MOD-840577
         IF l_ac1_t = 0 THEN
            #LET l_ac1 = 1                 #No.MOD-840577
            LET l_ac1 = ARR_CURR()         #No.MOD-840577
            IF l_ac1=0 THEN                #No.MOD-840577
               LET l_ac1=1                 #No.MOD-840577
            END IF                         #No.MOD-840577
            CALL FGL_SET_ARR_CURR(l_ac1)   #No.MOD-840577
         ELSE                              #No.MOD-840577 
            LET l_ac1 = l_ac1_t            #No.MOD-840577 
            CALL FGL_SET_ARR_CURR(l_ac1)   #No.MOD-840577 
         END IF
         CALL cl_show_fld_cont()
         #LET l_ac1_t = l_ac1              #No.MOD-840577
         LET l_ac1_t = 0                   #No.MOD-840577
         LET g_oea_t.* = g_oea[l_ac1].*
         SELECT ima906 INTO g_ima906 
           FROM ima_file
          WHERE ima01 = g_oea_t.oeb04                                                                                               
         CALL p501_b_fill()                                                                                                         
         CALL p501_bp2()   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION distributed_detail
         LET g_action_choice="distributed_detail"
         LET l_ac1_t = l_ac1               #No.MOD-840577
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice="carry"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p501_def_form()   #TQC-710033 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
     #ON ACTION accept
     #   LET g_action_choice="distributed_detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p501_set_entry()
 
   IF g_sma.sma115 = "N" THEN
      CALL cl_set_comp_entry("oee03,oee05,oee083,oee09",TRUE)   #MOD-A40060 del oee04
   ELSE  
      CALL cl_set_comp_entry("oee03,oee05,oee073,oee063,oee09",TRUE)   #MOD-A40060 del oee04
   END IF
 
END FUNCTION
 
FUNCTION p501_set_no_entry()
 
   IF g_oee[l_ac].oee03 = " " THEN
      CALL cl_set_comp_entry("oee09",FALSE)
   ELSE
      CALL cl_set_comp_entry("oee09",TRUE)
   END IF

   LET g_edit = 'Y'        #TQC-A40119  ---add          
   IF NOT cl_null(g_oee[l_ac].oee10) THEN
      CALL cl_set_comp_entry("oee03,oee05,oee073",FALSE)   #MOD-A40060  del oee04
      CALL cl_set_comp_entry("oee063,oee083,oee09",FALSE)
      LET g_edit = 'N'     #TQC-A40119 ---add
   END IF
 
   IF g_ima906 = "1" THEN
      CALL cl_set_comp_entry("oee073",FALSE)
   END IF
 
END FUNCTION
 
#-----TQC-710033---------add----str---
FUNCTION p501_def_form()   
    IF g_sma.sma115 = "N" THEN
       CALL cl_set_comp_visible("oeb910,oeb912",FALSE)
       CALL cl_set_comp_visible("oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("oee061,oee062,oee063",FALSE)
       CALL cl_set_comp_visible("oee071,oee072,oee073",FALSE)
       CALL cl_set_comp_visible("oee081,oee082",FALSE)
       CALL cl_set_comp_entry("oee063,oee073",FALSE)
    ELSE
       CALL cl_set_comp_entry("oee083",FALSE)
       CALL cl_set_comp_visible("oee062,oee072,oee082",FALSE)
    END IF
    #使用多單位的單位管制方式-母子單位
    IF g_sma.sma122 ='1' THEN 
       #--單頭
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end
 
    END IF
 
    #使用多單位的單位管制方式-參考單位
    IF g_sma.sma122 ='2' THEN 
       #--單頭
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg #銷售單位
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg #銷售數量
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg #異動單位
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg #異動數量
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end
    END IF
END FUNCTION
#-----TQC-710033---------add----end---
 
 

# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: axrp601.4gl
# Descriptions...: 費用單整批生成應收作業
# Date & Author..: FUN-C20004 12/02/02 By zhangweib
# Modify.........: NO:TQC-C20163 12/02/14 By zhangweib axrp601畫面上的賬款單別,當選擇了費用類型時,應該開放錄入
# Modify.........: NO:TQC-C20204 12/02/15 By xuxz 背景作業執行時候 添加rollback前錯誤匯總顯示
# Modify.........: NO:TQC-C20290 12/02/20 By xuxz 產生財務的條件修改
# Modify.........: NO:TQC-C20375 12/02/22 By xuxz 交款單立賬時溢收科目修改為ool25,ool251
# Modify.........: NO:TQC-C20437 12/02/23 By xuxz 拋轉財務 報錯 無借方科目
# Modify.........: NO:TQC-C20430 12/02/23 By wangrr 產生應收單時,單據來源類型oma70為'2'手工錄入,產生收款單時，設置ooa35為'1'交款單
# Modify.........: NO:MOD-C30114 12/03/09 By zhangweib 透過artt610所有自動產生的單據,確認後,狀態碼oma64應為1.已核准
# Modify.........: NO:TQC-C30177 12/03/09 By zhangweib 支票收款將rxy06維護的支票號碼寫到oob14和nmh31
# Modify.........: NO:MOD-C30179 12/03/09 By zhangweib 修改CASE  WHEN "01" OR "02" OR "08" 這一區塊語
#                                                      oma02立賬日期取單身lub10的值
#                                                      沒有滿足條件的資料時顯示:無合乎條件的資料
# Modify.........: NO:TQC-C30182 12/03/10 By zhangweib 給單據性質為15 OR 17 的但劇中的oma212 oma59 oma59x oma59t賦值
# Modify.........: NO:MOD-C30607 12/03/12 By zhangweib 自動編號時若未在營收參數設定作業(axrs020)中找到對應單別,需要給與正確的報錯訊息
# Modify.........: NO:MOD-C30636 12/03/12 By zhangweib 修改g_wc段的BEFORE CONSTRUCT語句,使之只會在初始狀態下賦默認值
# Modify.........: NO:TQC-C30188 12/03/14 By zhangweib 1.產生的axrt300,axrt400的資料根據單別的判斷是否拋轉總帳
#                                                      2.拋轉總帳拿到批次的事物結束后再做拋轉
# Modify.........: NO:FUN-C30029 12/03/20 By zhangweib 1.修改oma70的賦值,由2(手工錄入)修改為1(系統產生)
#                                                      2.修改ooa38的賦值,由2(手工錄入)修改為1(系統產生)
# Modify.........: NO:FUN-C30038 12/03/27 By minpp INSERT INTO nmh_file赋值修改.nmh06 = rxy11，nmh04 = 单据日期
# Modify.........: NO:TQC-C30343 12/03/30 By zhangll azp01再次執行時也能默認值
# Modify.........: NO:TQC-C30350 12/04/01 By zhangweib axrp601產生單據時,人員和部門的賦值修改成費用單單頭的人員和部門
# Modify.........: NO:TQC-C40058 12/04/01 By zhangweib 新增字段,記錄拋轉傳票時的立帳日期
#                                                      費用單中本幣原幣幣種相同,修改幣種和匯率取值
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc          STRING                    #QBE_1的條件
DEFINE g_wc1         STRING                    #QBE_2的條件
DEFINE g_sql         STRING                    #組SQL
DEFINE tm            RECORD                    #條件選項
          lub09         LIKE lub_file.lub09,   #費用類型
          ar_slip       LIKE oow_file.oow02,   #賬款單別
          yy            LIKE type_file.num5,   #立賬年度
          mm            LIKE type_file.num5    #立賬月份
                     END RECORD
DEFINE g_oma00       LIKE oma_file.oma00       #單據性質
DEFINE g_oma         RECORD LIKE oma_file.*    #應收/待抵帳款單頭檔
DEFINE g_omb         RECORD LIKE omb_file.*    #應收/待抵帳款單身檔
DEFINE g_omc         RECORD LIKE omc_file.*    #應收/待抵帳款單身檔
DEFINE g_ooa         RECORD LIKE ooa_file.*
DEFINE g_oob         RECORD LIKE oob_file.*
DEFINE g_oow         RECORD LIKE oow_file.*
DEFINE g_nmh         RECORD LIKE nmh_file.*
DEFINE g_nmg         RECORD LIKE nmg_file.*
DEFINE g_nms         RECORD LIKE nms_file.*
DEFINE g_lui         RECORD LIKE lui_file.*
DEFINE g_lua         RECORD
          lua01         LIKE lua_file.lua01,
          lua06         LIKE lua_file.lua06,
          lub09         LIKE lub_file.lub09,
          #lua09         LIKE lua_file.lua01,  #TQC-C20163
          lua09         LIKE lua_file.lua09,   #TQC-C20163
          lua061        LIKE lua_file.lua061,
          lua21         LIKE lua_file.lua21,
          lua22         LIKE lua_file.lua22,
          lua23         LIKE lua_file.lua23,
          luaplant      LIKE lua_file.luaplant,
          lub10         LIKE lub_file.lub10,   #No.MOD-C30179   Add
          lua08         LIKE lua_file.lua08,
          lua08t        LIKE lua_file.lua08t,
          lub04         LIKE lub_file.lub04,
          lub04t        LIKE lub_file.lub04t
                     END RECORD
DEFINE g_lub         DYNAMIC ARRAY OF RECORD
          lub01         LIKE lub_file.lub01,
          lub02         LIKE lub_file.lub02,
          lua06         LIKE lub_file.lub06,
          lub09         LIKE lub_file.lub09,
          lub10         LIKE lub_file.lub10,   #No.MOD-C30179   Add
          lub04         LIKE lub_file.lub04,
          lub04t        LIKE lub_file.lub04t
                     END RECORD
DEFINE g_oob06       LIKE lui_file.lui14
DEFINE g_luj03       LIKE luj_file.luj03
DEFINE g_luj04       LIKE luj_file.luj04
#TQC-C20290--add--str
DEFINE g_oob06_1       LIKE lui_file.lui14
DEFINE g_luj03_1       LIKE luj_file.luj03
DEFINE g_luj04_1       LIKE luj_file.luj04
#TQC-C20290--add--end
DEFINE g_t1          LIKE ooy_file.ooyslip
DEFINE g_plant_new   LIKE type_file.chr21      #營運中心
DEFINE g_bookno1     LIKE type_file.chr20
DEFINE g_bookno2     LIKE type_file.chr20
DEFINE g_bookno3     LIKE type_file.chr20
DEFINE g_flag        LIKE type_file.chr1
DEFINE li_result     LIKE type_file.num5
DEFINE g_net         LIKE type_file.num5
DEFINE b_oob         RECORD LIKE oob_file.*
DEFINE g_forupd_sql  STRING
DEFINE g_str         STRING
DEFINE g_wc_gl       STRING
DEFINE g_wc_gl2      STRING                    #No.TQC-C30188   Add
DEFINE g_wc_gl3      STRING                    #No.FUN-C30029   Add
DEFINE tot           LIKE type_file.num20_6
DEFINE tot1          LIKE type_file.num20_6
DEFINE tot2          LIKE type_file.num20_6
DEFINE tot3          LIKE type_file.num20_6
DEFINE un_pay1       LIKE type_file.num20_6
DEFINE un_pay2       LIKE type_file.num20_6
DEFINE g_lui03       LIKE lui_file.lui03    #No.MOD-C30179   Add
DEFINE g_lua38       LIKE lua_file.lua38    #No.TQC-C30350
DEFINE g_lua39       LIKE lua_file.lua38    #No.TQC-C30350
DEFINE g_oma02       LIKE oma_file.oma02    #No.TQC-C40058   Add
DEFINE g_ooa02       LIKE ooa_file.ooa02    #No.TQC-C40058   Add

MAIN
   DEFINE l_flag     LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
#  SELECT * INTO g_oow.* FROM oow_file     #TQC-C20163   Mark
   LET g_wc       = ARG_VAL(1)             #QBE參數一
   LET g_wc       = cl_replace_str(g_wc, "\\\"", "'")  #TQC-C20163
   LET g_wc1      = ARG_VAL(2)             #QBE參數二
   LET g_wc1      = cl_replace_str(g_wc1, "\\\"", "'") #TQC-C20163
   LET tm.lub09   = ARG_VAL(3)             #費用類型
   LET tm.ar_slip = ARG_VAL(4)             #賬款單別
   LET tm.yy      = ARG_VAL(5)             #立賬年度
   LET tm.mm      = ARG_VAL(6)             #立賬月份
   LET g_bgjob    = ARG_VAL(7)

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT * INTO g_oow.* FROM oow_file     #TQC-C20163   Add

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p601()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p601_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL p601_axrp590()               #No.TQC-C30188   Add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL s_showmsg()
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p601
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p601_1()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL p601_axrp590()               #No.TQC-C30188   Add
            CALL cl_err('','lib-284',1) #TQC-C20430
         ELSE
            CALL s_showmsg()#TQC-C20204--add
            ROLLBACK WORK
            CALL cl_err('','abm-020',1) #TQC-C20430
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p601()
   DEFINE l_ooyacti   LIKE ooy_file.ooyacti
   DEFINE l_ar_slip   LIKE ooy_file.ooyslip
   DEFINE l_azp01     LIKE azp_file.azp01  #TQC-C30343 add

   OPEN WINDOW p601 WITH FORM "axr/42f/axrp601"
      ATTRIBUTE (STYLE = g_win_style)

      CALL cl_ui_init()

      CLEAR FORM

      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON azp01

            BEFORE CONSTRUCT
              #TQC-C30343 mod
              #IF cl_null(g_wc) THEN    #No.MOD-C30636   Add
              #   DISPLAY g_plant TO azp01
              #END IF                   #No.MOD-C30636   Add
               LET l_azp01 = GET_FLDBUF(azp01)
               IF cl_null(l_azp01) THEN
                  DISPLAY g_plant TO azp01
               END IF
              #TQC-C30343 mod--end
               IF cl_null(tm.lub09) THEN#No.MOD-C30636   Add
                  CALL cl_set_comp_entry("ar_slip",FALSE)
               END IF                   #No.MOD-C30636   Add
              #LET tm.yy = YEAR(g_today)#No.MOD-C30636   Mark
              #LET tm.mm = MONTH(g_today)#No.MOD-C30636  Mark
              #No.MOD-C30636   ---start---   Add
               IF cl_null(tm.yy) THEN LET tm.yy = YEAR(g_today) END IF
               IF cl_null(tm.mm) THEN LET tm.mm = MONTH(g_today) END IF
              #No.MOD-C30636   ---end---     Add

         END CONSTRUCT

         CONSTRUCT BY NAME g_wc1 ON lua01,lua06,lua09

            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT

         INPUT BY NAME tm.lub09,tm.ar_slip,tm.yy,tm.mm

            ON CHANGE lub09
               IF NOT cl_null(tm.lub09) THEN
                  IF tm.lub09 = '01' THEN
                     LET g_oma00 = '15'
                     LET tm.ar_slip = g_oow.oow02
                   END IF
                  IF tm.lub09 = '02' THEN
                     LET g_oma00 = '17'
                     LET tm.ar_slip = g_oow.oow03
                  END IF
                  DISPLAY BY NAME tm.ar_slip
                  CALL cl_set_comp_entry("ar_slip",TRUE)   #TQC-C20163    Add
               ELSE
                  CALL cl_set_comp_entry("ar_slip",FALSE)
                  LET g_oma00 = NULL
                  LET tm.ar_slip = NULL
                  DISPLAY BY NAME tm.ar_slip
               END IF
              #No.MOD-C30607   ---start---   Add
               IF cl_null(tm.ar_slip) THEN
                  CALL cl_err('','axr-149',1)
                  NEXT FIELD lub09
               END IF
              #No.MOD-C30607   ---end---     Add

            AFTER FIELD ar_slip
               IF NOT cl_null(tm.ar_slip) THEN
                  LET l_ooyacti = NULL
                  SELECT ooyacti INTO l_ooyacti FROM ooy_file
                   WHERE ooyslip = ar_slip
                  IF l_ooyacti <> 'Y' THEN
                     CALL cl_err(tm.ar_slip,'axr-956',1)
                     NEXT FIELD ar_slip
                  END IF
                  IF NOT cl_null(tm.lub09) THEN
                     CALL s_check_no("axr",tm.ar_slip,"",g_oma00,"","","")
                          RETURNING li_result,tm.ar_slip
                     IF (NOT li_result) THEN
                       LET g_success='N'
                       NEXT FIELD ar_slip
                     END IF
                  ELSE
                     LET g_success = 'N'
                     CALL s_check_no("axr",tm.ar_slip,"",'15',"","","")
                          RETURNING li_result,l_ar_slip
                     IF (li_result) THEN
                        LET g_success = 'Y'
                        LET tm.ar_slip = l_ar_slip
                     END IF
                     CALL s_check_no("axr",tm.ar_slip,"",'15',"","","")
                          RETURNING li_result,l_ar_slip
                     IF (li_result) THEN
                        LET g_success = 'Y'
                        LET tm.ar_slip = l_ar_slip
                     END IF
                     IF g_success = 'N' THEN
                        NEXT FIELD ar_slip
                     END IF
                  END IF
                  DISPLAY BY NAME tm.ar_slip
               END IF

         END INPUT

         ON ACTION controlp
            CASE
               WHEN INFIELD(azp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azw"
                  LET g_qryparam.where ="azw02 = '",g_legal,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01
               WHEN INFIELD(lua01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_lua01"
                  LET g_qryparam.where = "lua15 = 'Y'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lua01
                  NEXT FIELD lua01    #No.MOD-C30636   Add
               WHEN INFIELD(lua06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_occ"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lua06
                  NEXT FIELD lua06    #No.MOD-C30636   Add
               WHEN INFIELD(ar_slip)
                  CALL q_ooy( FALSE, TRUE, tm.ar_slip,g_oma00,'AXR') RETURNING g_t1
                  LET tm.ar_slip = g_t1
                  DISPLAY BY NAME tm.ar_slip
                  NEXT FIELD ar_slip    #No.MOD-C30636   Add
               OTHERWISE EXIT CASE
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
            EXIT DIALOG
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

      END DIALOG
      IF INT_FLAG THEN
         CLOSE WINDOW p601
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

END FUNCTION

FUNCTION p601_1()
   DEFINE l_lua01      LIKE lua_file.lua01
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_lua37      LIKE lua_file.lua37
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_lui14      LIKE lui_file.lui04
   DEFINE l_luj03      LIKE luj_file.luj03
   DEFINE l_luj04      LIKE luj_file.luj04
   DEFINE l_sum        LIKE type_file.num20_6
   DEFINE l_lub14      LIKE lub_file.lub14
   #TQC-C20290 --add--str
   DEFINE li_count     LIKE type_file.num10
   DEFINE li_lub01     LIKE lub_file.lub01
   DEFINE li_lub02     LIKE lub_file.lub02
   DEFINE li_oob06     LIKE oob_file.oob06
   DEFINE li_sum1      LIKE type_file.num20_6
   DEFINE li_sum2      LIKE type_file.num20_6
   #TQC-C20290 --add--end

   #抓取符合用戶QBE1條件的當前法人下的所有營運中心
   LET g_sql = "SELECT azw01 FROM azw_file,azp_file WHERE azp01 = azw01 AND azw02 = '",g_legal,"' AND ",g_wc CLIPPED
   PREPARE p601_sel_azw FROM g_sql
   DECLARE p601_azw_curs CURSOR FOR p601_sel_azw

   INITIALIZE g_lua.* TO NULL
   LET g_wc_gl   = NULL  #No.FUN-C30029   Add
   LET g_wc_gl2  = NULL  #No.FUN-C30029   Add
   LET g_wc_gl3  = NULL  #No.FUN-C30029   Add
   LET g_oob06   = NULL  #No.FUN-C30029   Add
   LET g_oob06_1 = NULL  #No.FUN-C30029   Add
   INITIALIZE g_nmg.* TO NULL   #No.FUN-C30029   Add
   LET g_oma02   = NULL #No.TQC-C40058   Add
   LET g_ooa02   = NULL #No.TQC-C40058   Add
   CALL g_lub.clear()
   LET l_lua01 = NULL
   CALL s_showmsg_init()

   BEGIN WORK

   FOREACH p601_azw_curs INTO g_plant_new

      LET g_sql = "SELECT DISTINCT lua01,lua06,lua09,lua061,lua21,lua22,lua23,luaplant,lua08,lua08t,lua37,lua38,lua39,lub14 ",   #No.TQC-C30350   Add ,lua38,lua39
               "  FROM ",cl_get_target_table(g_plant_new,'lua_file'),",",cl_get_target_table(g_plant_new,'lub_file'),
               " WHERE lua01 = lub01 ",
               "   AND lua15 = 'Y' ",
               "   AND YEAR(lub10) = '",tm.yy,"'",
               "   AND MONTH(lub10) = '",tm.mm,"'",
               #"   AND lua32 <> '6' ",#TQC-C20290 mark
               "   AND lua05 <> 'Y' ", #TQC-C20290 add
               "   AND lub04t > 0 "
      IF NOT cl_null(tm.lub09) THEN
         LET g_sql = g_sql,"   AND lub09 = '",tm.lub09,"' AND ",g_wc1
      ELSE
         LET g_sql = g_sql,"   AND lub09 != '10' AND ",g_wc1
      END IF
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p601_sel_lua FROM g_sql
      DECLARE p601_lua_curs1 CURSOR FOR p601_sel_lua

      FOREACH p601_lua_curs1 INTO g_lua.lua01,g_lua.lua06,g_lua.lua09,g_lua.lua061,
                                  g_lua.lua21,g_lua.lua22,g_lua.lua23,g_lua.luaplant,
                                  g_lua.lua08,g_lua.lua08t,l_lua37#,l_lub14#TQC-C20290 mark lub14
                                 ,g_lua38,g_lua39
         #TQC-C20290--add--str
         LET li_count = 0
         SELECT COUNT(*) INTO li_count FROM lub_file
          WHERE lub01 = g_lua.lua01
            AND lub14 IS NOT NULL
         #TQC-C20290--add-end
        #逐个抓取对应营运中心下的费用单资料
         LET g_sql = "SELECT lub09,lub10,SUM(lub04),SUM(lub04t) ",   #No.MOD-C30179   Add lub10
                     "  FROM ",cl_get_target_table(g_plant_new,'lua_file'),",",cl_get_target_table(g_plant_new,'lub_file'),
                     " WHERE lua01 = lub01 ",
                     "   AND lua15 = 'Y' ",
                     "   AND lub14 IS NULL ",
                     "   AND YEAR(lub10) = '",tm.yy,"'",
                     "   AND MONTH(lub10) = '",tm.mm,"'",
                    #"   AND lua32 <> '6' ",#TQC-C20290 mark
                     "   AND lua05 <> 'Y' ", #TQC-C20290 add
                     "   AND lub04t > 0 ",
                     "   AND lub01 = '",g_lua.lua01,"'"
         IF NOT cl_null(tm.lub09) THEN
            LET g_sql = g_sql,"   AND lub09 = '",tm.lub09,"' AND ",g_wc1
         ELSE
            LET g_sql = g_sql,"   AND lub09 != '10' AND ",g_wc1
         END IF
         LET g_sql = g_sql," GROUP BY lub09,lub10"     #No.MOD-C30179   Add lub10
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p601_sel_lub3 FROM g_sql
         DECLARE p601_lub_curs1 CURSOR FOR p601_sel_lub3

        #No.MOD-C30179   ---start---   Add
         LET g_lui03 = NULL
        #抓取費用單對應繳款單的立帳日期
         LET g_sql = "SELECT lui03 FROM ",cl_get_target_table(g_plant_new,'lui_file'),
                     " WHERE lui04 = '",g_lua.lua01,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p601_sel_lui03 FROM g_sql
         EXECUTE p601_sel_lui03 INTO g_lui03
        #No.MOD-C30179   ---end---     Add

         FOREACH p601_lub_curs1 INTO g_lua.lub09,g_lua.lub10,g_lua.lub04,g_lua.lub04t      #No.MOD-C30179
            IF cl_null(tm.lub09) THEN
               IF g_lua.lub09 = "01" THEN
                  LET tm.ar_slip = g_oow.oow02
                 #No.MOD-C30607   ---start---   Add
                  IF cl_null(tm.ar_slip) THEN
                     CALL s_errmsg('oow02','','','axr-149',1)
                     LET g_success = 'N'
                  END IF
                 #No.MOD-C30607   ---end---     Add
                  LET g_oma00 = '15'
               END IF
               IF g_lua.lub09 = "02" THEN
                  LET tm.ar_slip = g_oow.oow03
                 #No.MOD-C30607   ---start---   Add
                  IF cl_null(tm.ar_slip) THEN
                     CALL s_errmsg('oow03','','','axr-149',1)
                     LET g_success = 'N'
                  END IF
                 #No.MOD-C30607   ---end---     Add
                  LET g_oma00 = '17'
               END IF
            END IF
            CALL p601_ins_oma()

            IF g_success = 'Y' THEN
               CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING l_flag,g_bookno1,g_bookno2
               IF l_flag =  '1' THEN
                  CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
                  LET g_success = 'N'
               END IF
               LET g_bookno3 = g_bookno1
            END IF

            IF g_success = 'Y' THEN
               CALL p601_ins_omb()
            END IF

            IF g_success = 'Y' THEN
               CALL p601_ins_omc()
            END IF

            IF g_ooy.ooydmy1='Y' AND g_success = 'Y' THEN
               CALL s_t300_gl(g_oma.oma01,'0')
               IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                  CALL s_t300_gl(g_oma.oma01,'1')
               END IF
               #CALL s_ar_y_chk()
               #TQC-C20290--add--str
               CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING g_flag, g_bookno1,g_bookno2
               CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1)     
               IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                  CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2)     
                END IF
               #TQC-C20290--add--end
               #No.TQC-C30188   ---start---   Add
                IF g_ooy.ooyglcr = 'Y' THEN
                  LET g_oma02 = g_oma.oma02   #No.TQC-C40058   Add
                  IF g_oma.oma00 = '15' THEN
                  IF cl_null(g_wc_gl) THEN
                     LET g_wc_gl = ' npp011 = 1 AND npp01 IN ("',g_oma.oma01,'"'
                  ELSE
                     LET g_wc_gl = g_wc_gl,',"',g_oma.oma01,'"'
                  END IF
                 #No.FUN-C30029   ---start---   Add
                  ELSE
                  IF cl_null(g_wc_gl3) THEN
                     LET g_wc_gl3 = ' npp011 = 1 AND npp01 IN ("',g_oma.oma01,'"'
                  ELSE
                     LET g_wc_gl3 = g_wc_gl3,',"',g_oma.oma01,'"'
                  END IF
                  END IF 
                 #No.FUN-C30029   ---end---     Add
                END IF
               #No.TQC-C30188   ---start---   Add
            END IF

            IF g_success = "Y" THEN
               LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'lub_file')," SET lub14 = '",g_oma.oma01,"'",
                           " WHERE lub01 = '",g_lua.lua01,"' AND lub09 = '",g_lua.lub09,"'",
                           "   AND lub10 = '",g_lua.lub10,"'"      #No.MOD-C30179   Add
                          #"   AND YEAR(lub10) = '",tm.yy,"'",     #No.MOD-C30179   Mark
                          #"   AND MONTH(lub10) = '",tm.mm,"'"     #No.MOD-C30179   Mark
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p601_upd_lub FROM g_sql
               EXECUTE p601_upd_lub
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF

            IF g_success = "Y" AND g_oma.oma00 = '15' THEN
               CALL p601_ins_slip26('+')
            END IF

            LET l_lua01 = g_lua.lua01
         END FOREACH
        #No.MOD-C30179   ---start---   Add
         IF cl_null(g_lua.lub09) THEN
            CALL s_errmsg('','','','mfg2601',1)
            LET g_success = 'N'
         END IF     
        #No.MOD-C30179   ---end---     Add

         #TQC-C20290--add--str
         IF li_count = 0  AND l_lua37 = 'Y' THEN  #TQC-C20437 add
         #TQC-C20290--add--end
         #IF l_lua37 = 'Y' AND cl_null(l_lub14) THEN#TQC-C20290 mark
            IF g_success = 'Y' THEN
               CALL p601_ins_oob()
               CALL p601_ins_ooa()
            END IF
            IF g_success = 'Y' THEN
               IF g_ooy.ooydmy1='Y' AND g_success = 'Y' THEN
                  CALL s_t400_gl(g_ooa.ooa01,'0')
                  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                     CALL s_t400_gl(g_ooa.ooa01,'1')#TQC-C20290 mod 300->400
                  END IF
                  #CALL s_ar_y_chk()
                  #--TQC-C20290--add--str--
                  CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
                  CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
                 IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
                    CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
                 END IF
              #--TQC-C20290--add--end--
               END IF
            END IF
            IF g_success = 'Y' THEN
               LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'lui_file')," SET lui14 = '",g_ooa.ooa01,"'",
                           " WHERE lui04 =  '",g_lua.lua01,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p601_upd_lui FROM g_sql
               EXECUTE p601_upd_lui
               IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL s_errmsg('upd lui',g_ooa.ooa01,'',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF
           #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_oow.oow04#TQC-C20290 mark
           #IF g_ooy.ooyconf = "Y" THEN #TQC-C20290 mark
               CALL p601_y_chk()
               IF g_success = "Y" THEN
                  CALL p601_y_upd()
               END IF
           #END IF #TQC-C20290 mark
         ELSE
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'lui_file'),",",cl_get_target_table(g_plant_new,'luj_file'),
                        " WHERE lui01 = luj01 ",
                        "   AND luj03 = '",g_lua.lua01,"' ",
                        "   AND lui14 IS NOT NULL"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
            PREPARE p601_sel_lui FROM g_sql
            EXECUTE p601_sel_lui INTO l_cnt
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
           #按费用单项次
               #TQC-C20290--add--str
                LET g_sql = "SELECT lub01,lub02 FROM ",cl_get_target_table(g_plant_new,'lub_file'),
                           " WHERE lub01 = '",g_lua.lua01,"'",
                           "   AND year(lub10) = '",tm.yy,"'",
                           "   AND month(lub10)= '",tm.mm,"'"
               IF g_bgjob = 'N' AND NOT cl_null(tm.lub09) THEN LET g_sql = g_sql,"   AND lub09 = '",tm.lub09,"'" END IF   #No.FUN-C30029   Add
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p601_sel_lub22 FROM g_sql
               DECLARE p601_lub22_curs CURSOR FOR p601_sel_lub22
               FOREACH p601_lub22_curs INTO li_lub01,li_lub02
              #TQC-C20290--add--end
               LET g_sql = "SELECT lui14,luj03,luj04,sum(luj06) FROM ",cl_get_target_table(g_plant_new,'lui_file'),",",cl_get_target_table(g_plant_new,'luj_file'),
                           " WHERE lui01 = luj01 ",
                           "   AND luj03 = '",g_lua.lua01,"' ",
                           "   AND luj04 = '",li_lub02,"'", #TQC-C20290 add
                           "   AND lui04 IS NOT NULL ",
                           " GROUP BY lui14,luj03,luj04 "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p601_sel_lui1 FROM g_sql
               DECLARE p601_lui_curs CURSOR FOR p601_sel_lui1

              #CALL s_auto_assign_no("AXR",g_oow.oow14,g_lua.lua09,'30',"ooa_file","ooa01","","","")    #No.MOD-C30179   Mark
                 #No.MOD-C30607   ---start---   Add
                  IF cl_null(g_oow.oow14) THEN
                     CALL s_errmsg('oow14','','','axr-149',1)
                     LET g_success = 'N'
                  END IF
                 #No.MOD-C30607   ---end---     Add
               CALL s_auto_assign_no("AXR",g_oow.oow14,g_lua.lub10,'30',"ooa_file","ooa01","","","")    #No.MOD-C30179   Add
                  RETURNING li_result,g_oob.oob01
               IF (NOT li_result) THEN
                  LET g_success = 'N'
                  RETURN
               END IF
              #---TQC-C20209--mark--str
              #LET g_oob06 = ' '
              #LET g_luj03 = ' '
              #LET g_luj04 = ' '
              #---TQC-C20290--mark--end
               FOREACH p601_lui_curs INTO l_lui14,l_luj03,l_luj04,l_sum #根据交款单金额冲预收
                  CALL p601_ins_oob_13(l_lui14,l_luj03,l_luj04,l_sum) #借方 预收账款
                  CALL p601_ins_oob_21(l_luj03,l_luj04,l_sum)         #贷方 应收账款
               END FOREACH
              #No.MOD-C30179   ---start---   Add
               IF cl_null(l_lui14) THEN
                  CALL s_errmsg('','','','mfg2601',1)
                  LET g_success = 'N'
               END IF
              #No.MOD-C30179   ---end---     Add

               END FOREACH #TQC-C20290 add
              #No.MOD-C30179   ---start---   Add
               IF cl_null(li_lub01) THEN
                  CALL s_errmsg('','','','mfg2601',1)
                  LET g_success = 'N'
               END IF
              #No.MOD-C30179   ---end---     Add

               CALL p601_ins_ooa_1('2')
                #TQC-C20290--add-str
               SELECT oob06,sum(oob09),sum(oob10) INTO li_oob06,li_sum1,li_sum2
                 FROM oob_file
                WHERE oob01 = g_ooa.ooa01
                  AND oob03 = '1'
                GROUP BY oob06
               IF g_success = 'Y' THEN
                  UPDATE oma_file SET oma55 = oma55+li_sum1,oma57 = oma57+li_sum2
                   WHERE oma01 =  li_oob06
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                     CALL s_errmsg('upd oma',li_oob06,'',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF              
               END IF
               #TQC-C20290--add-end

            END IF
         END IF
      END FOREACH
     #No.MOD-C30179   ---start---   Add
      IF cl_null(g_lua.lua01) THEN
         CALL s_errmsg('','','','mfg2601',1)
         LET g_success = 'N'
      END IF     
     #No.MOD-C30179   ---end---     Add
   END FOREACH
  #No.MOD-C30179   ---start---   Add
   IF cl_null(g_plant_new) THEN
      CALL s_errmsg('','','','mfg2601',1)
      LET g_success = 'N'
   END IF
  #No.MOD-C30179   ---end---     Add

END FUNCTION

FUNCTION p601_ins_oma()
   DEFINE  l_sum        LIKE type_file.num20_6
   DEFINE l_occ         RECORD LIKE occ_file.*
   DEFINE l_ool         RECORD LIKE ool_file.*

   INITIALIZE g_oma.* TO NULL

   SELECT SUM(COALESCE(rxx04,0)) + SUM(COALESCE(rxx05,0))
     INTO l_sum FROM rxx_file
    WHERE rxx01 = g_lua.lua01 AND rxxplant = g_lua.luaplant AND rxx00 = '07'

   IF cl_null(l_sum) THEN LET l_sum=0 END IF

  #--TQC-C20290--mark--str
  #IF l_sum > 0 THEN
  #   LET g_flag = '1'
  #   LET g_oma.oma65 = '2'
  #ELSE
  #--TQC-C20290--mark--end
      LET g_flag = '0'
      LET g_oma.oma65 = '1'
  # END IF#TQC-C20290--mark

   SELECT * INTO g_oow.* FROM oow_file
    WHERE oow00 = '0'
   IF STATUS THEN
      CALL s_errmsg('','','err','alm-998',1)
      LET g_success = 'N'
      RETURN
   END IF

   CASE g_lua.lub09
      WHEN '01'
         LET g_oma.oma00 = '15'
      WHEN '02'
         LET g_oma.oma00 = '17'
   END CASE

  #自動編號
  #CALL s_auto_assign_no("AXR",tm.ar_slip,g_lua.lua09,g_oma.oma00,"oma_file","oma01","","","")    #No.MOD-C30179   Mark
   CALL s_auto_assign_no("AXR",tm.ar_slip,g_lua.lub10,g_oma.oma00,"oma_file","oma01","","","")    #No.MOD-C30179   Add
      RETURNING li_result,g_oma.oma01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF

  #No.TQC-C30350   ---start---   Mark
  #LET g_oma.oma14 = g_user

  #SELECT gem01 INTO g_oma.oma15 FROM gen_file,gem_file
  # WHERE gen01 = g_oma.oma14
  #   AND gen03 = gem01
  #No.TQC-C30350   ---end---     Mark

  LET g_oma.oma14 = g_lua38 #No.TQC-C30350   Add
  LET g_oma.oma15 = g_lua39 #No.TQC-C30350   Add

  #LET g_oma.oma02 = g_lua.lua09   #No.MOD-C30179   Mark
   LET g_oma.oma02 = g_lua.lub10   #No.MOD-C30179   Add
   LET g_oma.oma03 = g_lua.lua06
   LET g_oma.oma032 = g_lua.lua061
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
   LET g_oma.oma68 = l_occ.occ07

   IF g_oma.oma03 = 'MISC' THEN
      LET g_oma.oma69 = g_oma.oma032
   ELSE
      SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
   END IF

  #No.TQC-C30350   ---start---   Mark
  #LET g_oma.oma14 = g_user

  #SELECT gem01 INTO g_oma.oma15 FROM gen_file,gem_file
  # WHERE gen01 = g_oma.oma14
  #   AND gen03 = gem01
  #No.TQC-C30350   ---end---     Mark

   LET g_oma.oma04 = g_oma.oma03
   LET g_oma.oma05 = l_occ.occ08
   LET g_oma.oma21 = g_lua.lua21
   LET g_oma.oma211 = g_lua.lua22
   LET g_oma.oma213 = g_lua.lua23
  #LET g_oma.oma23 = l_occ.occ42                                     #No.TQC-C40058   Mark
  #IF cl_null(g_oma.oma23) THEN LET g_oma.oma23 = g_aza.aza17 END IF #No.TQC-C40058   Mark
   LET g_oma.oma23 = g_aza.aza17                                     #No.TQC-C40058   Add
   LET g_oma.oma40 = l_occ.occ37
   LET g_oma.oma25 = l_occ.occ43
   LET g_oma.oma32 = l_occ.occ45
   LET g_oma.oma042= l_occ.occ11
   LET g_oma.oma043= l_occ.occ18
   LET g_oma.oma044= l_occ.occ231
   LET g_oma.oma51f = 0
   LET g_oma.oma51 = 0
   LET g_oma.oma66 = g_plant_new

   CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant)
      RETURNING g_oma.oma11,g_oma.oma12

   LET g_oma.oma08  = '1'
   IF cl_null(g_oma.oma211) THEN LET g_oma.oma211=0 END IF
  #No.TQC-C40058   ---start---   Mark
  #IF g_oma.oma23=g_aza.aza17 THEN
  #   LET g_oma.oma24=1
  #   LET g_oma.oma58=1
  #ELSE
  #   CALL s_curr3(g_oma.oma23,g_oma.oma02,g_ooz.ooz17) RETURNING g_oma.oma24
  #   CALL s_curr3(g_oma.oma23,g_oma.oma09,g_ooz.ooz17) RETURNING g_oma.oma58
  #END IF
  #No.TQC-C40058   ---end---     Mark
   LET g_oma.oma24 = 1   #No.TQC-C40058   Add
   LET g_oma.oma58 = 1   #No.TQC-C40058   Add

   SELECT occ67 INTO g_oma.oma13 FROM occ_file
    WHERE occ01 = g_oma.oma03

   IF cl_null(g_oma.oma13) THEN
      LET g_oma.oma13 = g_ooz.ooz08
   END IF

   LET g_oma.oma16 = g_lua.lua01
   LET g_oma.oma66 = g_lua.luaplant
   #LET g_oma.oma70 = '1'#TQC-C20430 mark--
  #No.FUN-C30029   ---start---   Mark
  ##TQC-C20430--add--begin
  #IF g_oma.oma00='26' THEN
  #   LET g_oma.oma70 = '1'
  #ELSE
  #   LET g_oma.oma70 = '2'
  #END IF
  ##TQC-C20430--add--end
  #No.FUN-C30029   ---end---     Mark
   LET g_oma.oma70 = '1'   #No.FUN-C30029   Add
   LET g_oma.oma50 = 0
   LET g_oma.oma50t = 0
   LET g_oma.oma52 = 0
   LET g_oma.oma53 = 0
   CALL cl_digcut(g_oma.oma50,t_azi04) RETURNING g_oma.oma50
   CALL cl_digcut(g_oma.oma50t,t_azi04) RETURNING g_oma.oma50t
   CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52
   CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
   IF g_flag ! = '1' THEN
      LET l_sum = g_lua.lua08
   END IF

   IF cl_null(g_lua.lua08) THEN
      LET g_lua.lua08 =0
   END IF

   IF cl_null(g_lua.lua08t) THEN
      LET g_lua.lua08t =0
   END IF

   LET g_oma.oma54 = g_lua.lub04
   LET g_oma.oma56 = g_oma.oma54 * g_oma.oma24
   LET g_oma.oma54t= g_lua.lub04t
   LET g_oma.oma56t= g_oma.oma54t * g_oma.oma24
   LET g_oma.oma54x= g_oma.oma54t - g_oma.oma54
   LET g_oma.oma56x= g_oma.oma56t - g_oma.oma56
   LET g_oma.oma57 = 0
   LET g_oma.oma61 = g_oma.oma56t - g_oma.oma57
   CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
   CALL cl_digcut(g_oma.oma61,g_azi04) RETURNING g_oma.oma61
   CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
   CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
   CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
   CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
   CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
   CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x

   SELECT * INTO l_ool.* FROM ool_file
    WHERE ool01 = g_oma.oma13

   LET g_oma.oma18 = l_ool.ool11
   LET g_oma.oma181 = l_ool.ool111

   LET g_oma.oma55 = 0
   LET g_oma.oma57 = 0
   LET g_oma.omaconf = 'Y'
   LET g_oma.omavoid = 'N'
   LET g_oma.omauser = g_user
   LET g_oma.omaoriu = g_user
   LET g_oma.omaorig = g_grup
   LET g_oma.omagrup = g_grup
   LET g_oma.omamksg='N'
  #LET g_oma.oma64 = '0'   #No.MOD-C30114   Mark
   LET g_oma.oma64 = '1'   #No.MOD-C30114   Add
   LET g_oma.omalegal = g_legal
   CALL cl_digcut(g_oma.oma55,t_azi04) RETURNING g_oma.oma55
   IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
   IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
   IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
  #No.TQC-C30182   ---start---   Add
   LET g_oma.oma59 = g_oma.oma56   
   LET g_oma.oma59x= g_oma.oma56  
   LET g_oma.oma59t= g_oma.oma56t
   LET g_sql = "SELECT gec05 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
               " WHERE gec01 = '",g_oma.oma21,"'",
               "   AND gec011 = 2 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_gec FROM g_sql
   EXECUTE p601_sel_gec INTO g_oma.oma212
  #No.TQC-C30182   ---end---     Add
   INSERT INTO oma_file VALUES(g_oma.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oma01',g_oma.oma01,'ins oma_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

END FUNCTION

FUNCTION p601_ins_omb()
   DEFINE i LIKE type_file.num5

   LET i = 1
   INITIALIZE g_omb.* TO NULL

   LET g_sql = "SELECT lub01,lub02,lua06,lub09,lub10,SUM(lub04),SUM(lub04t) ",    #No.MOD-C30179   Add lub10
               "  FROM ",cl_get_target_table(g_plant_new,'lua_file'),",",cl_get_target_table(g_plant_new,'lub_file'),
               " WHERE lua01 = lub01 ",
               "   AND lua01 = '",g_lua.lua01,"'",
               "   AND lub09 = '",g_lua.lub09,"'",
               "   AND lub10 = '",g_lua.lub10,"'",   #No.MOD-C30179   Add
              #"   AND YEAR(lub10) = '",tm.yy,"'",   #No.MOD-C30179   Mark
              #"   AND MONTH(lub10) = '",tm.mm,"'",  #No.MOD-C30179   Mark
               " GROUP BY lub01,lub02,lua06,lub09,lub10",                         #No.MOD-C30179   Add lub10
               " ORDER BY lub01,lub02 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lub FROM g_sql
   DECLARE p601_lub_curs CURSOR FOR p601_sel_lub
   LET i = '1'
   FOREACH p601_lub_curs INTO g_lub[i].* 　
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_omb.omb00 = g_oma.oma00
      LET g_omb.omb01 = g_oma.oma01
      LET g_omb.omb03 = i
      LET g_omb.omb04 = 'MISC'
      LET g_omb.omb12 = 1
      LET g_omb.omb44 = g_plant_new

      IF cl_null(g_lub[i].lub04) THEN
         LET g_lub[i].lub04 = 0
      END IF
      IF cl_null(g_lub[i].lub04t) THEN
         LET g_lub[i].lub04t = 0
      END IF
      IF g_lua.lua23 = 'Y' THEN
         LET g_omb.omb13 = g_lub[i].lub04t
      ELSE
         LET g_omb.omb13 = g_lub[i].lub04
      END IF

      CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13

      LET g_omb.omb14 = g_lub[i].lub04
      LET g_omb.omb14t = g_lub[i].lub04t

      LET g_omb.omb15 = g_omb.omb13 * g_oma.oma24
      CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15

      LET g_omb.omb16 = g_omb.omb14 * g_oma.oma24
      CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16

      LET g_omb.omb16t= g_omb.omb14t*g_oma.oma24
      CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t

      LET g_omb.omb17 = g_omb.omb13*g_oma.oma58
      CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17

      LET g_omb.omb18 = g_omb.omb14*g_oma.oma58
      CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18

      LET g_omb.omb18t= g_omb.omb14t*g_oma.oma58
      CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t

      LET g_omb.omb31 = g_lub[i].lub01
      LET g_omb.omb32 = g_lub[i].lub02

      LET g_sql = "SELECT oaj04,oaj041 FROM ",cl_get_target_table(g_plant_new,'oaj_file'),",",cl_get_target_table(g_plant_new,'lub_file'),
                  " WHERE oaj01 = lub03",
                  "   AND lub01 = '",g_lub[i].lub01,"'",
                  "   AND lub02 = '",g_lub[i].lub02,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p601_sel_oaj FROM g_sql
      EXECUTE p601_sel_oaj INTO g_omb.omb33,g_omb.omb331

      LET  g_omb.omb34 = 0
      CALL cl_digcut(g_omb.omb34,g_azi04) RETURNING g_omb.omb34

      LET g_omb.omb35 = 0
      CALL cl_digcut(g_omb.omb35,g_azi04) RETURNING g_omb.omb35

      LET g_omb.omb36 = 0
      LET g_omb.omb37 = 0
      CALL cl_digcut(g_omb.omb37,g_azi04) RETURNING g_omb.omb37

      LET g_omb.omb38 = '06'
      LET g_omb.omb39 = 'N'
      LET g_omb.omblegal = g_legal
      LET g_omb.omb48 = 0   #FUN-D10101 add
      INSERT INTO omb_file VALUES(g_omb.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('omb01',g_omb.omb01,'ins omb_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET i = i+1
   END FOREACH
END FUNCTION

FUNCTION p601_ins_omc()

   CALL s_ar_oox03(g_oma.oma01) RETURNING g_net

   LET g_omc.omc01 = g_oma.oma01
   LET g_omc.omc02 = 1
   LET g_omc.omc03 = g_oma.oma32
   LET g_omc.omc04 = g_oma.oma11
   LET g_omc.omc05 = g_oma.oma12
   LET g_omc.omc06 = g_oma.oma24
   LET g_omc.omc07 = g_oma.oma60
   LET g_omc.omc08 = g_oma.oma54t
   CALL cl_digcut(g_omc.omc08,t_azi04) RETURNING g_omc.omc08
   LET g_omc.omc09 = g_oma.oma56t
   CALL cl_digcut(g_omc.omc09,g_azi04) RETURNING g_omc.omc09
   LET g_omc.omc10 = 0
   CALL cl_digcut(g_omc.omc10,t_azi04) RETURNING g_omc.omc10
   LET g_omc.omc11 = 0
   CALL cl_digcut(g_omc.omc11,g_azi04) RETURNING g_omc.omc11
   LET g_omc.omc12 = g_oma.oma10
   LET g_omc.omc13 = g_omc.omc09-g_omc.omc11+g_net
   CALL cl_digcut(g_omc.omc13,g_azi04) RETURNING g_omc.omc13
   LET g_omc.omc14 = 0
   CALL cl_digcut(g_omc.omc14,t_azi04) RETURNING g_omc.omc14
   LET g_omc.omc15 = 0
   CALL cl_digcut(g_omc.omc15,g_azi04) RETURNING g_omc.omc15

   LET g_omc.omclegal = g_legal
   INSERT INTO omc_file VALUES(g_omc.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('omc01',g_omc.omc01,'ins omc_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION p601_ins_slip26(p_sw)
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE p_sw	      	 LIKE type_file.chr1
   DEFINE l_oma01        LIKE oma_file.oma01
   DEFINE l_oma		       RECORD LIKE oma_file.*
   DEFINE g_omc	 	       RECORD LIKE omc_file.*
   DEFINE l_buf          LIKE type_file.chr3
   DEFINE l_str          LIKE type_file.chr1000
   DEFINE l_lua37        LIKE lua_file.lua37

   LET g_sql = "SELECT lua37 FROM ",cl_get_target_table(g_plant_new,'lua_file'),
               " WHERE lua01 = '",g_lua.lua01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lua37 FROM g_sql

   EXECUTE p601_sel_lua37 INTO l_lua37

   IF l_lua37 != 'Y' THEN
      RETURN
   END IF

   LET l_str = "bu_22:",g_oma.oma01 CLIPPED,' ',g_oma.oma02 CLIPPED
   CALL cl_msg(l_str)

   INITIALIZE l_oma.* TO NULL

   LET l_oma.* = g_oma.*

   IF p_sw = '+' THEN
      LET l_oma.* = g_oma.*
      IF cl_null(g_oma.oma19) THEN
         IF cl_null(g_oow.oow19) THEN
            CALL s_errmsg('oow19',g_oow.oow19,'','axr-149',1)
            LET g_success = 'N'
         ELSE
            LET l_oma.oma01 = g_oow.oow19,'-'
         END IF
      ELSE
         LET l_oma.oma01 = g_oma.oma19
      END IF

     #CALL s_auto_assign_no("axr",l_oma.oma01,g_lua.lua09,"26","oma_file","oma01","","","")    #No.MOD-C30179   Mark
      CALL s_auto_assign_no("axr",l_oma.oma01,g_lua.lub10,"26","oma_file","oma01","","","")    #No.MOD-C30179   Add
         RETURNING li_result,l_oma.oma01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF

      CALL cl_msg(l_oma.oma01)

      LET l_oma.oma00 = '26'
      LET l_oma.oma18 = NULL
      SELECT ool21 INTO l_oma.oma18 FROM ool_file
       WHERE ool01 = g_oma.oma13
      IF g_aza.aza63 = 'Y' THEN
         SELECT ool211 INTO l_oma.oma181 FROM ool_file
          WHERE ool01 = g_oma.oma13
      END IF
      LET l_oma.oma21=NULL
      LET l_oma.oma211=0
      LET l_oma.oma213='N'
      LET l_oma.oma54x=0
      LET l_oma.oma56x=0
      LET l_oma.oma54=g_oma.oma54t
      LET l_oma.oma56=g_oma.oma56t
      LET l_oma.oma55=0
      LET l_oma.oma57=0
      LET l_oma.oma60=l_oma.oma24
      LET l_oma.oma61=l_oma.oma56t-l_oma.oma57
      LET l_oma.omaconf='Y'
      LET l_oma.omavoid='N'
      LET l_oma.omauser=g_user
      LET l_oma.omadate=g_today
      LET l_oma.omamksg='N'
      LET l_oma.oma65 = '1'
      LET l_oma.oma66= g_oma.oma66
      LET l_oma.oma67 = NULL
      LET l_oma.oma16 = g_lua.lua01

      IF g_aaz.aaz90='Y' THEN
         IF cl_null(l_oma.oma15) THEN
            LET l_oma.oma15=g_grup
         END IF
         LET l_oma.oma66 = s_costcenter(l_oma.oma15)
      END IF

      LET l_oma.omaoriu = g_user
      LET l_oma.omaorig = g_grup
      LET l_oma.omalegal = g_legal
      IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
      IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
      IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
      LET l_oma.oma70='1'   #TQC-C20430

      INSERT INTO oma_file VALUES(l_oma.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
        LET g_success = 'N'
        RETURN
      END IF

      LET g_omc.omc01 = l_oma.oma01
      LET g_omc.omc02 = 1
      LET g_omc.omc03 = l_oma.oma32
      LET g_omc.omc04 = l_oma.oma11
      LET g_omc.omc05 = l_oma.oma12
      LET g_omc.omc06 = l_oma.oma24
      LET g_omc.omc07 = l_oma.oma60
      LET g_omc.omc08 = l_oma.oma54t
      LET g_omc.omc09 = l_oma.oma56t
      LET g_omc.omc10 = 0
      LET g_omc.omc11 = 0
      LET g_omc.omc12 = l_oma.oma10
      LET g_omc.omc13 = g_omc.omc09 - g_omc.omc11
      LET g_omc.omc14 = 0
      LET g_omc.omc15 = 0

      LET g_omc.omclegal = g_legal
      INSERT INTO omc_file VALUES(g_omc.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_showmsg=g_omc.omc01,"/",g_omc.omc02
         LET g_success = 'N'
         RETURN
      END IF

      UPDATE oma_file SET oma19=l_oma.oma01 WHERE oma01=g_oma.oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('upd oma',l_oma.oma01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      ELSE
         LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'luk_file')," SET luk16 = '",l_oma.oma01,"'",
                     " WHERE luk05 = (SELECT lui01 FROM ",cl_get_target_table(g_plant_new,'lui_file')," WHERE lui04 = '",g_lua.lua01,"')"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p601_upd_luk FROM g_sql
         EXECUTE p601_upd_luk
      END IF
   END IF
END FUNCTION

FUNCTION p601_ins_ooa()
   DEFINE l_cnt      LIKE type_file.num5

   INITIALIZE g_ooa.* TO NULL

   LET g_ooa.ooa00 = '1'
   LET g_ooa.ooa01 = g_oob.oob01
  #LET g_ooa.ooa02 = g_oma.oma02           #No.MOD-C30179   Mark
   LET g_ooa.ooa02 = g_lui03               #No.MOD-C30179   Add
   LET g_ooa.ooa021= g_today
   LET g_ooa.ooa03 = g_oma.oma03
   LET g_ooa.ooa032= g_oma.oma032
   LET g_ooa.ooa13 = g_oma.oma13
  #LET g_ooa.ooa14 = g_user     #No.TQC-C30350  Mark 
  #LET g_ooa.ooa15 = g_grup     #No.TQC-C30350  Mark 
   LET g_ooa.ooa14 = g_lua38    #No.TQC-C30350  Add 
   LET g_ooa.ooa15 = g_lua39    #No.TQC-C30350  Add 
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = g_oma.oma23
   LET g_ooa.ooa24 = g_oma.oma24
   LET g_ooa.ooa40 = ' '
   LET g_ooa.ooamksg= 'N'

   SELECT SUM(oob09),SUM(oob10)
     INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file
    WHERE oob01=g_oob.oob01
      AND oob03='1'  AND oob02>0

   SELECT SUM(oob09),SUM(oob10)
     INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file
    WHERE oob01=g_oob.oob01
      AND oob03='2' AND oob02 > 0

   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF

   IF cl_null(g_ooa.ooa31c) THEN
      LET g_ooa.ooa31c=g_oma.oma54t
   ELSE
      LET g_ooa.ooa31c=g_oma.oma54t + g_ooa.ooa31c
   END IF

   IF cl_null(g_ooa.ooa32c) THEN
      LET g_ooa.ooa32c=g_oma.oma56t
   ELSE
      LET g_ooa.ooa32c=g_oma.oma56t + g_ooa.ooa32c
   END IF

   IF g_ooa.ooa31d < g_ooa.ooa31c THEN
      LET g_ooa.ooa31c=g_ooa.ooa31d
      LET g_ooa.ooa32c=g_ooa.ooa32d
   END IF

   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,t_azi04)
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,t_azi04)
   LET g_ooa.ooa33d = 0

   LET g_ooa.ooaconf = 'N'
   LET g_ooa.ooa34   = '0'
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   LET g_ooa.ooa37 = '1'
   LET g_ooa.ooaoriu = g_user
   LET g_ooa.ooaorig = g_grup
   LET g_ooa.ooalegal = g_legal
   LET g_ooa.ooa35='1'          #TQC-C20430
   LET g_ooa.ooa36=g_lui.lui01  #TQC-C20430
   LET g_ooa.ooa38 = '1'        #No.FUN-C30029   Add
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ooa_file
    WHERE ooa01 = g_ooa.ooa01

   IF l_cnt = 0 THEN

      INSERT INTO ooa_file values(g_ooa.*)

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins ooa',g_ooa.ooa01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION

FUNCTION p601_ins_oob()
DEFINE l_ooe02      LIKE ooe_file.ooe02,
       l_ac         LIKE type_file.num5,
       l_amt        LIKE oma_file.oma55,
       l_amt1       LIKE type_file.num20_6,
       l_amt2       LIKE type_file.num20_6,
       l_amt3       LIKE type_file.num20_6,
       l_sum        LIKE type_file.num20_6,
       l_wc         LIKE oma_file.oma55,
       l_oma01      LIKE oma_file.oma01,
       l_oma23      LIKE oma_file.oma23,
       l_luk16      LIKE luk_file.luk16,
       l_oma RECORD LIKE oma_file.*,
       l_rxx RECORD LIKE rxx_file.*,
       l_rxy RECORD LIKE rxy_file.*,
       l_ooa RECORD LIKE ooa_file.*,
       l_oob RECORD LIKE oob_file.*,
       l_ool RECORD LIKE ool_file.*,
       l_nmg RECORD LIKE nmg_file.*,
       l_rxy05      LIKE rxy_file.rxy05,
       l_rxy12      LIKE rxy_file.rxy12,
       l_rxy17      LIKE rxy_file.rxy17,
       l_sql_q      LIKE type_file.chr1000,
       l_sql_k      LIKE type_file.chr1000,
       l_ooe02_1    LIKE ooe_file.ooe02
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_dept       LIKE type_file.chr10

   INITIALIZE g_oob.*   TO NULL
   INITIALIZE l_oob.*   TO NULL
  #自動編號
  #No.MOD-C30607   ---start---   Add
   IF cl_null(g_oow.oow14) THEN
      CALL s_errmsg('oow14','','','axr-149',1)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_oow.oow14    #No.TQC-C30188   Add
  #No.MOD-C30607   ---end---     Add
   CALL s_auto_assign_no("AXR",g_oow.oow14,g_lua.lua09,'30',"ooa_file","ooa01","","","")
      RETURNING li_result,g_oob.oob01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF

#a:借方明細單身  (根據不同的付款方式)
   LET l_ac = 1
   LET g_sql = "SELECT * FROM rxx_file ",
               " WHERE rxx01 = '",g_lua.lua01,"'",
               "   AND rxxplant ='",g_lua.luaplant,"' AND rxx00 = '07' AND rxx04 > 0"
   PREPARE p601_sel_rxx FROM g_sql
   DECLARE p601_rxx_curs SCROLL CURSOR WITH HOLD FOR p601_sel_rxx
   FOREACH p601_rxx_curs INTO l_rxx.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   IF cl_null(l_rxx.rxx04) THEN LET l_rxx.rxx04 = 0 END IF
   IF cl_null(l_rxx.rxx05) THEN LET l_rxx.rxx05 = 0 END IF

   SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02
   SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
   IF cl_null(g_oob.oob02) THEN
      LET g_oob.oob02 = 1
   END IF
   LET g_oob.oob03 = '1'
  #No.FUN-C30029   ---start---   Mark
  #CASE l_rxx.rxx02
  #   WHEN '03'                 #支票
  #      LET g_oob.oob04 = '1'
  #   WHEN "01" OR "02" OR "08" #T/T
  #      LET g_oob.oob04 = '2'
  #   WHEN "07"                 #沖賬
  #      LET g_oob.oob04 = '3'
  #END CASE
  #No.FUN-C30029   ---end---     Mark
  #No.FUN-C30029   ---start---   Add
   CASE 
      WHEN l_rxx.rxx02 = '03'                 #支票
         LET g_oob.oob04 = '1'
      WHEN l_rxx.rxx02 = '01' OR l_rxx.rxx02 = '02' OR l_rxx.rxx02 = '08' #T/T
         LET g_oob.oob04 = '2'
      WHEN l_rxx.rxx02 = '07'                 #沖賬
         LET g_oob.oob04 = '3'
   END CASE
  #No.FUN-C30029   ---end---     Add

   LET g_oob.oob08 =g_oma.oma24
   IF cl_null(g_oob.oob08) THEN
      LET g_oob.oob08 = 1
   END IF
   LET g_oob.oob13 = g_oma.oma15
   LET g_oob.oob17 = l_ooe02
   IF cl_null(g_oow.oow01) THEN
      CALL s_errmsg('oow01',g_oow.oow01,'','axr-149',1)
      LET g_success = 'N'
   END IF
   LET g_oob.oob18 = g_oow.oow01
   LET g_oob.oob19 = 1

   IF cl_null(g_oob.oob17) THEN
      IF l_rxx.rxx02='02' THEN  #銀聯卡
        #若是銀聯卡,直接報錯
         CALL s_errmsg('rxx02',l_rxx.rxx02,'','axr-077',1)
         LET g_success = 'N'
      END IF
   ELSE
      SELECT nma05,nma051,nma10 INTO g_oob.oob11,g_oob.oob111,g_oob.oob07
        FROM nma_file
       WHERE nma01 = g_oob.oob17
      IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
   END IF


  #CASE l_rxx.rxx02                         #No.MOD-C30179   Mark
     #WHEN "03"                     #支票   #No.MOD-C30179   Mark
   CASE                                     #No.MOD-C30179   Add
      WHEN l_rxx.rxx02 = "03"       #支票   #No.MOD-C30179   Add
         LET g_sql = "SELECT * FROM rxy_file",
                     " WHERE rxy01 ='", g_lua.lua01,"' AND rxyplant='",g_lua.luaplant,"' AND rxy00 = '07'",
                     " AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
         PREPARE p601_sel_rxy FROM g_sql
         DECLARE p601_rxy_curs SCROLL CURSOR FOR p601_sel_rxy
         FOREACH p601_rxy_curs INTO l_rxy.*
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(l_rxy.rxy05) THEN LET l_rxy.rxy05=0 END IF
            IF cl_null(l_rxy.rxy07) THEN LET l_rxy.rxy07=0 END IF
            IF cl_null(l_rxy.rxy08) THEN LET l_rxy.rxy08=0 END IF
            IF cl_null(l_rxy.rxy09) THEN LET l_rxy.rxy09=0 END IF
            IF cl_null(l_rxy.rxy16) THEN LET l_rxy.rxy16=0 END IF
            IF cl_null(l_rxy.rxy17) THEN LET l_rxy.rxy17=0 END IF
           #產生anmt200的資料
            IF cl_null(g_oow.oow22) THEN
               CALL s_errmsg('oow22',g_oow.oow22,'','axr-149',1)
               LET g_success = 'N'
            END IF
            CALL s_auto_assign_no("ANM",g_oow.oow22,l_rxy.rxy10,"2","nmh_file","nmh01","","","")
               RETURNING li_result,g_nmh.nmh01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF
            LET g_nmh.nmh02 = l_rxy.rxy09
            LET g_nmh.nmh32 = l_rxy.rxy09
            IF cl_null(g_oow.oow25) THEN
               CALL s_errmsg('oow25',g_oow.oow25,'','axr-149',1)
               LET g_success = 'N'
            END IF
            LET g_nmh.nmh03 = g_oow.oow25
           #LET g_nmh.nmh04 = l_rxy.rxy10 #FUN-C30038  MARK
            LET g_nmh.nmh04 = g_lua.lua09 #FUN-C30038  add
            LET g_nmh.nmh06 = l_rxy.rxy11 #FUN-C30038  add
            LET g_nmh.nmh05 = l_rxy.rxy10
            LET g_nmh.nmh07 = l_rxy.rxy06
            LET g_nmh.nmh31 = l_rxy.rxy06    #No.TQC-C30177   Add
            LET g_nmh.nmh08 = 0
            LET g_nmh.nmh11 = g_lua.lua06
            IF cl_null(g_oow.oow23) THEN
               CALL s_errmsg('oow23',g_oow.oow23,'','axr-149',1)
               LET g_success = 'N'
            END IF
            LET g_nmh.nmh12 = g_oow.oow23
            LET g_nmh.nmh13 = 'N'
            IF cl_null(g_oow.oow24) THEN
               CALL s_errmsg('oow24',g_oow.oow24,'','axr-149',1)
            END IF
            LET g_nmh.nmh15 = g_oow.oow24
            #LET g_nmh.nmh17 = l_rxy.rxy09#TQC-C20375 mark
            LET g_nmh.nmh17 = 0 #TQC-C20375 add
            LET l_ooe02_1 = ' '
            SELECT ooe02 INTO l_ooe02_1 FROM ooe_file WHERE ooe_file = '03'
            LET g_nmh.nmh21 = l_ooe02_1
            LET g_nmh.nmh24 = '1'
            LET g_nmh.nmh25 = TODAY
            LET g_nmh.nmh28 = 1
            LET g_nmh.nmh38 = 'Y'
            LET g_nmh.nmh39 = 0
            LET g_nmh.nmh40 = 0
            CALL cl_digcut(g_nmh.nmh40,g_azi04) RETURNING g_nmh.nmh40

            IF g_nmz.nmz11 = 'Y' THEN LET l_dept = g_nmh.nmh15 ELSE LET l_dept = ' ' END IF
            SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = l_dept
            LET g_nmh.nmh26  = g_nms.nms22
            LET g_nmh.nmh261 = g_nms.nms22
            LET g_nmh.nmh27  = g_nms.nms21
            LET g_nmh.nmh271 = g_nms.nms21
            LET g_nmh.nmh41 = 'N'
            LET g_nmh.nmhoriu = g_user
            LET g_nmh.nmhorig = g_grup
            LET g_nmh.nmhlegal = g_legal #No.FUN-A70118
            IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF   #No.FUN-B40011
            INSERT INTO nmh_file VALUES(g_nmh.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL s_errmsg('ina nmh',g_nmh.nmh01,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
           #oob的資料
            LET g_oob.oob04 = '1'
            LET g_oob.oob14 = l_rxy.rxy06   #No.TQC-C30177   Add
            LET g_oob.oob17 = NULL
            LET g_oob.oob18 = NULL
            LET g_oob.oob06 = g_nmh.nmh01
            SELECT ool12,ool121 INTO g_oob.oob11,g_oob.oob111 FROM ool_file
             WHERE ool01 = g_oma.oma13

            LET g_oob.oob09 = l_rxy.rxy09
            CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09

            LET g_oob.oob22 = g_oob.oob09
            LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
            CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10

            IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
               CALL s_errmsg('','','','axr-076',1)
               LET g_success = 'N'
            END IF

            IF cl_null(g_oob.oob11) THEN
               CALL s_errmsg('','','','axr-076',1)
               LET g_success = 'N'
            END IF

            LET g_oob.ooblegal = g_legal
            INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL s_errmsg('ins oob',g_oob.oob01,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            LET l_ac = l_ac + 1
         END FOREACH
     #WHEN "01" OR "02" OR "08"                                             #No.MOD-C30179   Mark
      WHEN l_rxx.rxx02 = "01" OR l_rxx.rxx02 = "02" OR l_rxx.rxx02 = "08"   #No.MOD-C30179   Add
         IF cl_null(g_nmg.nmg00) THEN   #No.FUN-C30029   Add

        #No.MOD-C30607   ---start---   Add
         IF cl_null(g_oow.oow06) THEN
            CALL s_errmsg('oow06','','','axr-149',1)
            LET g_success = 'N'
         END IF
        #No.MOD-C30607   ---end---     Add
         LET l_nmg.nmg00 = g_oow.oow06
         CALL s_auto_assign_no("anm",l_nmg.nmg00,g_today,"3","nmg_file","nmg00","","","")
            RETURNING li_result,l_nmg.nmg00
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         ELSE
            CALL p601_ins_anmt302(l_nmg.nmg00)
            LET g_nmg.nmg00 = l_nmg.nmg00
         END IF
         END IF                       #No.FUN-C30029   Add
         LET l_ac = l_ac + 1
     #WHEN "07"                       #No.MOD-C30179   Mark
      WHEN l_rxx.rxx02 = "07"         #No.MOD-C30179   Add
         LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'rxy_file'),
                     " WHERE rxy00 = '07' AND rxy01 = '",g_lua.lua01,"' ",
                     "   AND rxyplant ='",g_lua.luaplant,"' ",
                     "   AND rxy03 = '07' AND rxy04 = '1' AND rxy05 > 0"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p601_sel_rxy1 FROM g_sql
         DECLARE p601_rxy_curs1 CURSOR FOR p601_sel_rxy1

         LET g_sql = "SELECT luk16 FROM ",cl_get_target_table(g_plant_new,'luk_file'),
                     " WHERE luk01 = ?",
                     "   AND lukconf = 'Y' AND luk04 = '1' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p601_sel_luk FROM g_sql
         FOREACH p601_rxy_curs1 INTO l_rxy.*
           #待抵單沒有立賬則報錯
            EXECUTE p601_sel_luk USING l_rxy.rxy06 INTO l_luk16
            IF cl_null(l_luk16) THEN
               CALL s_errmsg('lub16','','','axr-969',1)
               LET g_success = "N"
            END IF
           #財務待抵單未收金额（应收-已收）<本次冲抵金额rxy05
            SELECT oma23,oma01,oma54t - oma55,oma56t - oma57 INTO l_oma23,l_oma01,l_amt,l_amt1
              FROM oma_file
             WHERE oma01 = l_luk16
               AND oma54t - oma55 > 0

            LET g_oob.oob06 = l_luk16
            LET g_oob.oob09 = l_rxy.rxy05
            LET g_oob.oob10 = g_oob.oob09 * g_oma.oma24
            LET g_oob.oob14 = NULL   #No.FUN-C30029   Add

            IF status = 100 THEN
               CALL s_errmsg('oma_file','','',STATUS,1)
               LET g_success= 'N'
            END IF

            LET g_oob.ooblegal=g_legal

            INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL s_errmsg('ins oob',g_oob.oob01,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF

         END FOREACH

      END CASE
   END FOREACH

  # b:貸方資料
   INITIALIZE l_oob.* TO NULL
   INITIALIZE l_ooa.* TO NULL
   DECLARE p601_oma_curs1 CURSOR FOR
      SELECT * FROM oma_file
       WHERE oma16 = g_lua.lua01
         AND oma00 IN ('15','17')
         AND year(oma02)=tm.yy AND month(oma02)=tm.mm #TQC-C20290 add
   FOREACH p601_oma_curs1 INTO l_oma.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_oob.oob01 = g_oob.oob01
      SELECT MAX(oob02) + 1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
      IF cl_null(l_oob.oob02) THEN LET l_oob.oob02 = 1 END IF
      LET g_oob.oob02 = l_oob.oob02
      LET l_oob.oob03 = '2'
      LET l_oob.oob04 = '1'
      LET l_oob.oob19 = '1'
      LET l_oob.oob06 = l_oma.oma01
      LET l_oob.oob07 = l_oma.oma23
      LET l_oob.oob08 = l_oma.oma24
      LET l_oob.oob09 = l_oma.oma54t
      LET l_oob.oob10 = l_oma.oma56t
      LET l_oob.oob11 = l_oma.oma18
      LET l_oob.oob111= l_oma.oma181
      LET l_oob.ooblegal = g_legal
      INSERT INTO oob_file VALUES (l_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins oob',l_oob.oob01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      UPDATE oma_file SET oma55 = l_oob.oob09,
                          oma57 = l_oob.oob10,
                          oma64 = '1',     #No.MOD-C30114   Add
                          omaconf = 'Y'
       WHERE oma01 = l_oob.oob06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('upd oma',l_oob.oob06,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END FOREACH

  #若直接收款的金额>本次立账的金额产生一笔贷方资料
   LET g_sql = "SELECT SUM(lub04t) FROM ",cl_get_target_table(g_plant_new,'lub_file'),
               " WHERE lub01 = '",g_lua.lua01,"'",
               "   AND YEAR(lub10) = '",tm.yy,"'",
               "   AND MONTH(lub10) = '",tm.mm,"'"
   IF cl_null(tm.lub09) THEN
      LET g_sql = g_sql," AND lub09 != '10'"
   ELSE
      LET g_sql = g_sql," AND lub09 = '",tm.lub09,"'"
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lub1 FROM g_sql
   EXECUTE p601_sel_lub1 INTO l_amt1   #立帳金額

   LET g_sql = "SELECT SUM(lub04t),SUM(lub04) FROM ",cl_get_target_table(g_plant_new,'lub_file'),
               " WHERE lub01 = '",g_lua.lua01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lub2 FROM g_sql
   EXECUTE p601_sel_lub2 INTO l_amt2,l_amt3   #直接付款金額

   IF l_amt2 > l_amt1 THEN
      LET l_oob.oob01 = g_oob.oob01
      SELECT MAX(oob02) + 1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
      IF cl_null(l_oob.oob02) THEN LET l_oob.oob02 = 1 END IF
      LET g_oob.oob02 = l_oob.oob02
      LET l_oob.oob07 = g_oma.oma23
      LET l_oob.oob08 = g_oma.oma24
      LET l_oob.oob03 = '2'
      LET l_oob.oob04 = '2'
      SELECT ool25,ool251 INTO l_oob.oob11,l_oob.oob111 FROM ool_file WHERE ool01 = g_oma.oma13
      LET l_oob.oob09 = l_amt2 - l_amt1
      LET l_oob.oob10 = l_oob.oob09 * g_oma.oma24
      LET l_oob.ooblegal = g_legal
      LET l_oob.oob06 = ' '
      LET l_oob.oob19 = ' '
      INSERT INTO oob_file VALUES (l_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins oob',l_oob.oob01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   LET g_oob.* = l_oob.*

   LET l_amt3 = 0
   SELECT rxy17 INTO l_amt3 FROM rxy_file WHERE rxy01 = g_lua.lua01 AND rxyplant = g_lua.luaplant AND rxy00 = '07' AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0
   IF cl_null(l_amt3) THEN LET l_amt3 = '0' END IF
   IF l_amt3 > 0 THEN
      SELECT MAX(oob02) + 1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
      IF cl_null(l_oob.oob02) THEN LET l_oob.oob02 = 1 END IF
      LET g_oob.oob02 = l_oob.oob02
      LET l_oob.oob04 = 'B'
      #LET l_oob.oob06 = l_oob.oob01#TQC-C20375 mark
      LET l_oob.oob06 = '' #TQC-C20375 add
      SELECT ool35,ool351 INTO l_oob.oob11,l_oob.oob111 FROM ool_file WHERE ool01 = g_oma.oma13
      LET l_oob.oob09 = l_amt3
      LET l_oob.oob10 = l_oob.oob09 * g_oma.oma24
      INSERT INTO oob_file VALUES (l_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins oob',l_oob.oob01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION

FUNCTION p601_ins_anmt302(p_slip)
   DEFINE p_slip       LIKE nmg_file.nmg00
   DEFINE l_ooe02      LIKE ooe_file.ooe02
   DEFINE l_occ02      LIKE occ_file.occ02
   DEFINE l_npk08      LIKE npk_file.npk08
   DEFINE l_npk09      LIKE npk_file.npk09
   DEFINE l_nmg        RECORD LIKE nmg_file.*
   DEFINE l_rxx        RECORD LIKE rxx_file.*
   DEFINE l_npk        RECORD LIKE npk_file.*
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_nma05      LIKE nma_file.nma05
   DEFINE l_nma051     LIKE nma_file.nma051
   DEFINE l_ac         LIKE type_file.num5

  #No.MOD-C30607   ---start---   Add
   IF cl_null(g_oow.oow08) THEN
      CALL s_errmsg('oow08','','','axr-149',1)
      LET g_success = 'N'
      RETURN
   END IF
  #No.MOD-C30607   ---end---     Add

   SELECT * INTO g_lui.* FROM lui_file WHERE lui04 = g_lua.lua01
   LET l_npk.npk00 = p_slip
   LET l_npk.npk02 = g_oow.oow08
   LET l_npk.npk03 = 1
   LET l_npk08 = 0
   LET l_npk09 = 0
   LET l_ac = 1
   DECLARE p601_rxx_curs1 CURSOR FOR
      SELECT * FROM rxx_file WHERE rxx00 = '11' AND rxx01 = g_lui.lui01 AND rxx02 IN ('01','02','08')
   FOREACH p601_rxx_curs1 INTO l_rxx.*
      SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02
      LET l_npk.npk01 = l_ac
      LET l_npk.npk04 = l_ooe02
      LET l_npk.npk05 = g_aza.aza17
      LET l_npk.npk06 = 1
      SELECT nma05 INTO l_nma05 FROM nma_file WHERE nma01 = l_npk.npk04 AND nmaacti = 'Y'
      LET l_npk.npk07 = l_nma05
      IF g_aza.aza63='Y' THEN
         SELECT nma051 INTO l_nma051 FROM nma_file WHERE nma01 = l_npk.npk04 AND nmaacti = 'Y'
         LET l_npk.npk072 = l_nma051
      END IF
      LET l_npk.npk08 = l_rxx.rxx04
      LET l_npk.npk09 = l_rxx.rxx04
      LET l_npk.npklegal = g_legal
      INSERT INTO npk_file VALUES (l_npk.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins npk',l_npk.npk01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET g_oob.oob06 = p_slip
     #LET g_oob.oob02 = l_npk.npk01     #No.FUN-C30029   Mark
     #NO.FUN-C30029   ---start---   Add
      SELECT MAX(oob02) +1 INTO g_oob.oob02 FROM oob_file
       WHERE oob01 = g_oob.oob01
      IF cl_null(g_oob.oob02) THEN
         LET g_oob.oob02 = 1
      END IF
     #NO.FUN-C30029   ---start---   Add
      LET g_oob.oob15 = l_npk.npk01
      LET g_oob.oob09 = l_rxx.rxx04
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
      LET g_oob.oob22 = g_oob.oob09
      LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
      CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
      LET g_oob.oob14 = NULL     #No.FUN-C30029   Add

      IF cl_null(g_oob.oob17) THEN
         CALL s_errmsg('','','','axr-077',1)
         LET g_success = 'N'
      END IF

      IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF

      IF cl_null(g_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
      LET g_oob.ooblegal = g_legal #No.FUN-A70118

     #No.FUN-C30029   ---start---   Mark
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01 = g_oob.oob01
         AND oob02 = g_oob.oob02
         AND oob04 = g_oob.oob04    #No.FUN-C30029   Add
         AND oob11 = g_oob.oob11    #No.FUN-C30029   Add
      IF l_cnt = 0 THEN
         INSERT INTO oob_file VALUES(g_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
     #No.FUN-C30029   ---start---   Add

     #NO.FUN-C30029   ---start---   Add
     #SELECT MAX(oob02) +1 INTO g_oob.oob02 FROM oob_file
     # WHERE oob01 = g_oob.oob01
     #IF cl_null(g_oob.oob02) THEN
     #   LET g_oob.oob02 = 1
     #END IF
     #INSERT INTO oob_file VALUES(g_oob.*)
     #IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
     #   CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
     #   LET g_success = 'N'
     #   EXIT FOREACH
     #END IF
     #No.FUN-C30029   ---end---     Add

      IF g_success = "Y" THEN
         CALL p601_ins_nme()
      END IF

      LET l_ac = l_ac + 1
      LET l_npk08 = l_npk08 + l_npk.npk08
      LET l_npk09 = l_npk09 + l_npk.npk09
   END FOREACH

   IF g_success = 'Y' THEN
      LET l_nmg.nmg00 = p_slip
      LET l_nmg.nmg01 = g_lui.lui03
      LET l_nmg.nmg11 = g_lui.lui12
      LET l_nmg.nmg20 = '21'
      LET l_nmg.nmg18 = g_lui.lui05
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = l_nmg.nmg18
      LET l_nmg.nmg19 = l_occ02
      LET l_nmg.nmg29 = 'N'
      LET l_nmg.nmg30 = NULL
      LET l_nmg.nmg301 = NULL
      LET l_nmg.nmg24 = 0
      LET l_nmg.nmg05 = 0
      LET l_nmg.nmg06 = 0
      LET l_nmg.nmg09 = 0
      LET l_nmg.nmg23 = l_npk08
      LET l_nmg.nmg25 = l_npk09
      LET l_nmg.nmglegal = g_legal
      LET l_nmg.nmgconf = 'Y'
      INSERT INTO nmg_file VALUES (l_nmg.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('ins nmg',l_nmg.nmg01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION

FUNCTION p601_ins_nme()
   DEFINE l_nme        RECORD LIKE nme_file.*
   DEFINE l_oob        RECORD LIKE oob_file.*
   DEFINE l_ooa        RECORD LIKE ooa_file.*
   DEFINE l_year       LIKE type_file.chr4
   DEFINE l_month      LIKE type_file.chr4
   DEFINE l_day        LIKE type_file.chr4
   DEFINE l_dt         LIKE type_file.chr20
   DEFINE l_date1      LIKE type_file.chr20
   DEFINE l_time       LIKE type_file.chr20
   DEFINE l_nme27      LIKE nme_file.nme27
   DEFINE l_rxxplant   LIKE rxx_file.rxxplant
   DEFINE l_luk16      LIKE luk_file.luk16

   LET l_ooa.* = g_ooa.*
   LET l_oob.* = g_oob.*
   IF l_oob.oob03='1' AND l_oob.oob04='2' THEN

   INITIALIZE l_nme.* TO NULL
   DISPLAY "INS_NME NOW...."

   LET l_nme.nme00 = 0
   LET l_nme.nme01 = l_oob.oob17
   LET l_nme.nme02 = l_ooa.ooa02
   LET l_nme.nme03 = l_oob.oob18
   LET l_nme.nme04 = l_oob.oob09
   LET l_nme.nme07 = l_oob.oob08
   LET l_nme.nme08 = l_oob.oob10
   LET l_nme.nme10 = l_ooa.ooa33
   IF cl_null(l_nme.nme10) THEN LET l_nme.nme10 = ' ' END IF
   LET l_nme.nme11 = ' '
   LET l_nme.nme12 = l_oob.oob06
   LET l_nme.nme13 = l_ooa.ooa032
   SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
    WHERE nmc01 = l_nme.nme03
   LET l_nme.nme15 = l_ooa.ooa15
   LET l_nme.nme16 = l_ooa.ooa02
   LET l_nme.nme17 = g_oma.oma01
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21 = l_oob.oob02
   LET l_nme.nme22 = '08'           #直接收款
   LET l_nme.nme24 = '9'            #未轉
   LET l_nme.nme25 = l_ooa.ooa03    #客戶編號
   LET l_nme.nmeoriu = g_user
   LET l_nme.nmeorig = g_grup
   LET l_nme.nmelegal = g_legal

   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END IF

   INSERT INTO nme_file VALUES(l_nme.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('ins nme',l_nme.nme01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)
   END IF

END FUNCTION

FUNCTION p601_y_chk()                # when g_ooa.ooaconf='N' (Turn to 'Y')
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_oma00    LIKE oma_file.oma00
   DEFINE l_apa00    LIKE apa_file.apa00
   DEFINE l_sql      STRING
   DEFINE l_oob      RECORD
             oob03      LIKE oob_file.oob03,
             oob04      LIKE oob_file.oob04,
             oob06      LIKE oob_file.oob06
                     END RECORD

   #LET g_success = 'Y'#TQC-C20375

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF g_ooa.ooaconf = 'X' THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','9024',1) #CHI-A80031
      LET g_success = 'N'
   END IF

   IF g_ooa.ooaconf = 'Y' THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-101',1) #CHI-A80031
      LET g_success = 'N'
   END IF

   IF cl_null(g_ooa.ooa33d) THEN
      LET g_ooa.ooa33d = 0
   END IF
   IF g_ooa.ooa32d != g_ooa.ooa32c - g_ooa.ooa33d THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-203',1) #CHI-A80031
      LET g_success = 'N'
   END IF
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1) #CHI-A80031
      LET g_success = 'N'
   END IF

   IF g_ooa.ooaconf = 'Y' THEN
      LET g_success = 'N'

   END IF

   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','mfg-009',1)
      LET g_success = 'N'
   END IF

   LET l_cnt = 0
   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' ' OR oob15 IS NULL OR oob15 <= 0 )

      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

      IF l_cnt > 0 THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-900',1)
         LET g_success = 'N'
      END IF
   END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE oma02 > g_ooa.ooa02
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01

   IF l_cnt >0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-371',1)
      LET g_success = 'N'
   END IF

   LET l_sql = "SELECT oob03,oob04,oob06 FROM oob_file",
               " WHERE oob01 = '",g_ooa.ooa01,"'",
               "   AND ((oob03 = '1' AND (oob04='3' OR oob04='9'))",
               "    OR  (oob03 = '2' AND (oob04='1' OR oob04='9')))"
   PREPARE oob06_pb FROM l_sql
   DECLARE oob06_cl CURSOR FOR oob06_pb

   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   FOREACH oob06_cl INTO l_oob.*
      IF STATUS THEN
         CALL s_errmsg('','','','Foreach',1) #CHI-A80031
         LET g_success = 'N'
      END IF

      IF l_oob.oob03='1' THEN
         IF l_oob.oob04 = '3' THEN
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 != '21') AND (l_oma00 != '22') AND (l_oma00 != '23') AND
               (l_oma00 != '24') AND (l_oma00 != '25') AND (l_oma00 != '26') AND
               (l_oma00 != '27') AND (l_oma00 != '28') THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-992',1) #CHI-A80031
               LET g_success = 'N'
            END IF
         END IF
         IF l_oob.oob04 = '9' THEN
            IF g_ooa.ooa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL s_errmsg(g_ooa.ooa02,'','','axr-084',1)
               LET g_errno='N'
            END IF
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06
               AND apa02 <= g_ooa.ooa02
            IF (l_apa00 != '11') AND (l_apa00 != '12') AND (l_apa00 != '15') AND (l_apa00 != '13') THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-993',1)
               LET g_success = 'N'
            END IF
         END IF
      END IF

      IF l_oob.oob03='2' THEN
         IF l_oob.oob04 = '1' THEN
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 !='11') AND (l_oma00 !='12') AND
               (l_oma00 !='13') AND (l_oma00 !='14') AND (l_oma00 !='15') AND (l_oma00 !='17') THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-994',1)
               LET g_success = 'N'
            END IF
         END IF
         IF l_oob.oob04 = '9' THEN
            IF g_ooa.ooa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL s_errmsg(g_ooa.ooa02,'','','axr-084',1)
               LET g_errno='N'
            END IF
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06
               AND apa02 <= g_ooa.ooa02
             IF l_apa00 NOT MATCHES '2*' THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-995',1) #CHI-A80031
               LET g_success = 'N'
            END IF
         END IF
      END IF
   END FOREACH

   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p601_y_upd()
   DEFINE l_cnt LIKE type_file.num5
   LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p601_cl CURSOR FROM g_forupd_sql
   LET g_sql = " SELECT * FROM ooa_file ",
               "  WHERE ooa01 = '",g_ooa.ooa01,"'",
               "    AND ooaconf = 'N' "
   PREPARE p601_400_pre FROM g_sql
   DECLARE p601_400_cs CURSOR WITH HOLD FOR p601_400_pre
   OPEN p601_cl USING g_ooa.ooa01
   FETCH p601_cl INTO g_ooa.*

   FOREACH p601_400_cs INTO g_ooa.*
      CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
     #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip    #No.TQC-C30188   Mark
      LET g_ooa.ooa34 = '1'
      UPDATE ooa_file SET ooa34 = g_ooa.ooa34 WHERE ooa01 = g_ooa.ooa01
      IF STATUS THEN
         LET g_success = 'N'
         LET g_totsuccess='N'
      END IF

      CALL p601_y1()

      IF g_success = 'N' THEN
         LET g_totsuccess='N'
         LET g_success = 'Y'
      END IF

      CALL p601_axrt400_oma()

      IF g_ooy.ooydmy1 = 'Y' THEN
         SELECT count(*) INTO l_cnt FROM npq_file
          WHERE npq01 = g_ooa.ooa01
            AND npq00 = 3
            AND npqsys = 'AR'
            AND npq011 = 1
         IF l_cnt = 0 THEN

            CALL p601_gen_glcr(g_ooa.*,g_ooy.*)

         END IF
         IF g_success = 'Y' THEN
            CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
            END IF
         END IF
         IF g_success = 'N' THEN
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH

   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_ooa.ooa34 = '1'
      LET g_ooa.ooaconf = 'Y'

      CALL cl_flow_notify(g_ooa.ooa01,'Y')
   ELSE
      LET g_ooa.ooaconf = 'N'
      LET g_success = 'N'
      LET g_totsuccess = 'N'
   END IF

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
  #No.TQC-C30188   ---start---   Add
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_ooa02 = g_ooa.ooa02    #No.TQC-C40058    Add
      IF cl_null(g_wc_gl2) THEN
         LET g_wc_gl2 = ' npp011 = 1 AND npp01 IN ("',g_ooa.ooa01,'"'
      ELSE
         LET g_wc_gl2 = g_wc_gl2,',"',g_ooa.ooa01,'"'
      END IF
   END IF
  #No.TQC-C30188   ---start---   Add

  #No.TQC-C30188   ---start---   Mark    將拋轉總帳部分移到事物結束之後
  #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
  #   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
  #   CALL cl_cmdrun_wait(g_str)
  #END IF
  #No.TQC-C30188   ---start---   Mark
END FUNCTION

FUNCTION p601_y1()
   DEFINE n       LIKE type_file.num5
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_flag  LIKE type_file.chr1

   UPDATE ooa_file SET ooaconf = 'Y',ooa34 = '1' WHERE ooa01 = g_ooa.ooa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooa_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   CALL p601_hu2()

   IF g_success = 'N' THEN
      RETURN
   END IF

   DECLARE p601_y1_c CURSOR FOR SELECT * FROM oob_file
                                 WHERE oob01 = g_ooa.ooa01
                                 ORDER BY oob02

   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH p601_y1_c INTO b_oob.*
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'y1 foreach',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF

      IF l_flag = '0' THEN
         LET l_flag = b_oob.oob03
      END IF

      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '1' THEN
         CALL p601_bu_11('+')
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '2' THEN
         CALL p601_bu_12('+')
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL p601_bu_13('+')
      END IF

      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN
         CALL p601_bu_21('+')
      END IF

      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
         CALL p601_bu_22('+',l_cnt)
      END IF

      LET l_cnt = l_cnt + 1

   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
END FUNCTION

FUNCTION p601_axrt400_oma()
   DEFINE  i     LIKE  type_file.num5
   DEFINE  l_oma RECORD LIKE oma_file.*
   DEFINE  l_occ RECORD LIKE occ_file.*
   DEFINE  l_oof RECORD LIKE oof_file.*
   DEFINE  li_result    LIKE type_file.num5

   IF g_success ='N' THEN RETURN END IF
   DECLARE p601_sel_oof CURSOR  FOR
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01


   FOREACH p601_sel_oof INTO l_oof.*
      IF STATUS THEN
         CALL s_errmsg('foreach','','',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_oma.oma00  = '14'
      CALL s_auto_assign_no("axr",l_oof.oof05,l_oof.oof06,"14","oma_file","oma01","","","")
         RETURNING li_result,l_oof.oof05
      IF li_result THEN
         LET l_oma.oma01  = l_oof.oof05
         UPDATE oof_file SET oof05 = l_oof.oof05
          WHERE oof01 = g_ooa.ooa01
            AND oof02 = l_oof.oof02
      ELSE
         CALL s_errmsg('','',l_oma.oma01,'mfg-059',1)     #MOD-BC0248 add
         LET g_success = 'N'
         RETURN
      END IF

      LET l_oma.oma02   = l_oof.oof06
      LET l_oma.oma03   = l_oof.oof03
      LET l_oma.oma032  = l_oof.oof032
      LET l_oma.oma68   = l_oof.oof04
      LET l_oma.oma69   = l_oof.oof042
      LET l_oma.oma18   = l_oof.oof10
      LET l_oma.oma181  = l_oof.oof101

      SELECT * INTO l_occ.*
        FROM occ_file
       WHERE occ01 = l_oof.oof03

      LET l_oma.oma05   = l_occ.occ08
      LET l_oma.oma14   = g_ooa.ooa14
      LET l_oma.oma15   = g_ooa.ooa15
      LET l_oma.oma930  = s_costcenter(g_ooa.ooa15)
      LET l_oma.oma21   = l_occ.occ41
      LET l_oma.oma23   = l_oof.oof07
      LET l_oma.oma24   = l_oof.oof08
      LET l_oma.oma25   = l_occ.occ43
      LET l_oma.oma32   = l_occ.occ45
      LET l_oma.oma042  = l_occ.occ11
      LET l_oma.oma043  = l_occ.occ18
      LET l_oma.oma044  = l_occ.occ231
      LET l_oma.oma09   = l_oma.oma02

      CALL s_rdatem(l_oma.oma03,l_oma.oma32,l_oma.oma02,l_oma.oma09,l_oma.oma02,g_plant)
         RETURNING l_oma.oma11,l_oma.oma12

      SELECT gec04,gec05,gec07
        INTO l_oma.oma211,l_oma.oma212,l_oma.oma213
        FROM gec_file
       WHERE gec01=l_oma.oma21
         AND gec011='2'

      SELECT occ67 INTO l_oma.oma13 FROM occ_file
       WHERE occ01 = l_oof.oof03
      IF cl_null(l_oma.oma13) THEN
         LET l_oma.oma13 = g_ooz.ooz08
      END IF

      LET l_oma.oma66  = g_plant
      LET l_oma.omalegal = g_legal
      LET l_oma.omaconf = 'Y'
      LET l_oma.omavoid = 'N'
      LET l_oma.omaprsw = 0
      LET l_oma.omauser = g_user
      LET l_oma.omagrup = g_grup
      LET l_oma.omadate = g_today
      LET l_oma.omamksg = 'N'
     #LET l_oma.oma64 = '0'   #No.MOD-C30114   Mark
      LET l_oma.oma64 = '1'   #No.MOD-C30114   Add
      LET l_oma.oma70 = '1'
      LET l_oma.oma65 = '1'
      LET l_oma.oma54t = l_oof.oof09f
      LET l_oma.oma56t = l_oof.oof09

      IF cl_null(l_oma.oma50) THEN
         LET l_oma.oma50 = 0
      END IF
      IF cl_null(l_oma.oma50t) THEN
         LET l_oma.oma50t = 0
      END IF
      IF cl_null(l_oma.oma51) THEN
         LET l_oma.oma51 = 0
      END IF
      IF cl_null(l_oma.oma51f) THEN
         LET l_oma.oma51f = 0
      END IF
      IF cl_null(l_oma.oma52) THEN
         LET l_oma.oma52 = 0
      END IF
      IF cl_null(l_oma.oma53) THEN
         LET l_oma.oma53 = 0
      END IF
      IF cl_null(l_oma.oma54) THEN
         LET l_oma.oma54 = 0
      END IF
      IF cl_null(l_oma.oma54x) THEN
         LET l_oma.oma54x = 0
      END IF
      IF cl_null(l_oma.oma54t) THEN
         LET l_oma.oma54t = 0
      END IF
      IF cl_null(l_oma.oma55) THEN
         LET l_oma.oma55 = 0
      END IF
      IF cl_null(l_oma.oma56) THEN
         LET l_oma.oma56 = 0
      END IF
      IF cl_null(l_oma.oma56x) THEN
         LET l_oma.oma56x = 0
      END IF
      IF cl_null(l_oma.oma56t) THEN
         LET l_oma.oma56t = 0
      END IF
      IF cl_null(l_oma.oma57) THEN
         LET l_oma.oma57 = 0
      END IF

      IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
      IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
      IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF

      INSERT INTO oma_file VALUES(l_oma.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oma01',l_oma.oma01,'ins oma_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      ELSE
         LET g_success ='Y'
      END IF
   END FOREACH
END FUNCTION

FUNCTION p601_gen_glcr(p_ooa,p_ooy)
    DEFINE p_ooa     RECORD LIKE ooa_file.*
    DEFINE p_ooy     RECORD LIKE ooy_file.*

    IF cl_null(p_ooy.ooygslp) THEN
       CALL s_errmsg(p_ooa.ooa01,'','','axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF
    CALL s_t400_gl(p_ooa.ooa01,'0')
    IF g_aza.aza63='Y' THEN
       CALL s_t400_gl(p_ooa.ooa01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p601_hu2()            #最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*

   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN
      CALL s_errmsg('occ01',g_ooa.ooa03,'sel occ_file',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
   IF STATUS THEN
      CALL s_errmsg('occ01',g_ooa.ooa03,'upd occ_file',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

FUNCTION p601_bu_11(p_sw)                   #更新應收票據檔 (nmh_file)
   DEFINE p_sw          LIKE type_file.chr1                   # +:更新
   DEFINE l_nmh17       LIKE nmh_file.nmh17
   DEFINE l_nmh38       LIKE nmh_file.nmh38
   DEFINE l_nmz59       LIKE nmz_file.nmz59
   DEFINE l_amt1        LIKE nmg_file.nmg25
   DEFINE l_amt2        LIKE nmg_file.nmg25

  #判斷此參考單號之單據是否已確認
   SELECT nmh17,nmh38 INTO l_nmh17,l_nmh38 FROM nmh_file WHERE nmh01=b_oob.oob06
   IF STATUS THEN LET l_nmh38 = 'N' END IF
   IF l_nmh38 != 'Y' THEN
      CALL s_errmsg('nmh01',b_oob.oob06,' ','axr-194',1)
   END IF
   SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
   IF l_nmz59 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
      CALL s_g_np('4','1',b_oob.oob06,b_oob.oob15) RETURNING tot3
   ELSE
      SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = b_oob.oob06
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1
      SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
       WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '1'
         AND oob06 = b_oob.oob06
      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      LET tot3 = l_amt1 - l_amt2
      IF cl_null(tot3) THEN LET tot3 = 0 END IF
   END IF

   IF p_sw = '+' THEN
      UPDATE nmh_file SET nmh17=nmh17+b_oob.oob09 ,nmh40 = tot3
       WHERE nmh01= b_oob.oob06
      IF STATUS THEN
         CALL s_errmsg('nmh01',b_oob.oob06,'unp nmh17',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17','axr-198',1)  LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION p601_bu_12(p_sw)             #更新TT檔 (nmg_file)
   DEFINE p_sw           LIKE type_file.chr1                    # +:更新
   DEFINE l_nmg23        LIKE nmg_file.nmg23
   DEFINE l_nmg24        LIKE nmg_file.nmg24
   DEFINE l_nmg25        LIKE nmg_file.nmg25
   DEFINE l_nmgconf      LIKE nmg_file.nmgconf
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE tot1           LIKE type_file.num20_6
   DEFINE tot2           LIKE type_file.num20_6
   DEFINE tot3           LIKE type_file.num20_6
   DEFINE l_nmz20        LIKE nmz_file.nmz20
   DEFINE l_str          STRING

   LET l_str = "bu_12:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
   CALL cl_msg(l_str)

  #確認時,判斷此參考單號之單據是否已確認
   LET l_nmgconf = ' '
   SELECT nmg25,nmgconf INTO l_nmg25,l_nmgconf
     FROM nmg_file WHERE nmg00= b_oob.oob06
   IF STATUS THEN LET l_nmgconf= 'N' END IF
   IF l_nmgconf != 'Y' THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'','axr-194',1)  LET g_success = 'N' RETURN
   END IF
   IF cl_null(l_nmg25) THEN LET l_nmg25=0 END IF   #bug NO:A053 by plum
  # 同參考單號若有一筆以上僅沖款一次即可 --------------
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01=b_oob.oob01
       AND oob02<b_oob.oob02
       AND oob03='1'
       AND oob04='2'
       AND oob06=b_oob.oob06
   IF l_cnt>0 THEN RETURN END IF

   LET tot1 = 0 LET tot2 = 0
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06
      AND oob01=ooa01
      AND ooaconf='Y'
      AND oob03='1'
      AND oob04 = '2'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
   SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
   IF l_nmz20 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
      CALL s_g_np('3','',b_oob.oob06,b_oob.oob15) RETURNING tot3
   ELSE
      LET tot3 = 0
   END IF

   LET l_nmg24 =0
   SELECT nmg23,nmg23-nmg24 INTO l_nmg23,l_nmg24
     FROM nmg_file WHERE nmg00= b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'sel nmg24',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_nmg24 = 0  THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'nmg24=0','axr-185',1) LET g_success='N' RETURN
   END IF
  # check 是否沖過頭了 ------------
   IF tot1>l_nmg23  THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'','axr-258',1) LET g_success='N' RETURN
   END IF
   UPDATE nmg_file SET nmg24=tot1, nmg10 = tot3
    WHERE nmg00= b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24','axr-198',1) LET g_success = 'N' RETURN
   END IF
END FUNCTION

FUNCTION p601_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
   DEFINE p_sw            LIKE type_file.chr1                       # +:產生
   DEFINE p_cnt           LIKE type_file.num5
   DEFINE l_oma            RECORD LIKE oma_file.*
   DEFINE l_omc            RECORD LIKE omc_file.*
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5

   INITIALIZE l_oma.* TO NULL
   IF p_sw = '+' THEN
      IF cl_null(b_oob.oob06)
         THEN LET l_oma.oma01 = g_ooz.ooz22
         ELSE LET l_oma.oma01 = b_oob.oob06
      END IF
      CALL s_auto_assign_no("axr",l_oma.oma01,g_ooa.ooa02,"24","","","","","")
      RETURNING li_result,l_oma.oma01
      IF (NOT li_result) THEN
         CALL s_errmsg('','',l_oma.oma01,'mfg-059',1)
         LET g_success='N'
         RETURN
      END IF
      CALL cl_msg(l_oma.oma01)

     #轉預收時(oma00='24'),重新讀取g_ooa.*變數
      SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01=b_oob.oob01

      LET l_oma.oma00 = '24'
      LET l_oma.oma08 = '1'    #No.TQC-C40058   Add
      LET l_oma.oma02 = g_ooa.ooa02
      LET l_oma.oma03 = g_ooa.ooa03
      LET l_oma.oma032= g_ooa.ooa032
      LET l_oma.oma13 = g_ooa.ooa13
      LET l_oma.oma14 = g_ooa.ooa14
      LET l_oma.oma15 = g_ooa.ooa15
      LET l_oma.oma16 = g_ooa.ooa01
      LET l_oma.oma18 = b_oob.oob11
      IF g_aza.aza63='Y' THEN
         LET l_oma.oma181 = b_oob.oob111
      END IF
      LET l_oma.oma211= 0
      LET l_oma.oma23 = b_oob.oob07
      LET l_oma.oma24 = b_oob.oob08
      SELECT occ43 INTO l_oma.oma25  FROM occ_file WHERE occ01 = l_oma.oma03
      LET l_oma.oma50 = 0
      LET l_oma.oma50t= 0
      LET l_oma.oma52 = 0
      LET l_oma.oma53 = 0
      LET l_oma.oma54 = b_oob.oob09
      LET l_oma.oma54t= b_oob.oob09
      LET l_oma.oma56 = b_oob.oob10
      LET l_oma.oma56t= b_oob.oob10
      LET l_oma.oma54x= 0
      LET l_oma.oma55 = 0
      LET l_oma.oma56x= 0
      LET l_oma.oma57 = 0
      LET l_oma.oma58 = 0
      LET l_oma.oma59 = 0
      LET l_oma.oma59x= 0
      LET l_oma.oma59t= 0
      LET l_oma.oma60 = b_oob.oob08
      LET l_oma.oma61 = b_oob.oob10
      LET l_oma.omaconf='Y'
      LET l_oma.oma64 = '1'
      LET l_oma.omavoid='N'
      LET l_oma.omauser=g_user
      LET l_oma.omagrup=g_grup
      LET l_oma.omadate=g_today
      LET l_oma.oma12 = l_oma.oma02
      LET l_oma.oma11 = l_oma.oma02
      LET l_oma.oma65 = '1'
      LET l_oma.oma66 = g_plant

      LET l_oma.oma68 = g_ooa.ooa03
      LET l_oma.oma69 = g_ooa.ooa032
      LET l_omc.omc01=l_oma.oma01
      LET l_omc.omc02=1
      SELECT occ45 INTO l_oma.oma32 FROM occ_file WHERE occ01=g_ooa.ooa03
      IF cl_null(l_oma.oma32) THEN LET l_oma.oma32 = ' ' END IF
      LET l_omc.omc03=l_oma.oma32
      LET l_omc.omc04=l_oma.oma11
      LET l_omc.omc05=l_oma.oma12
      LET l_omc.omc06=l_oma.oma24
      LET l_omc.omc07=l_oma.oma60
      LET l_omc.omc08=l_oma.oma54t
      LET l_omc.omc09=l_oma.oma56t
      LET l_omc.omc10=l_oma.oma55
      LET l_omc.omc11=l_oma.oma57
      LET l_omc.omc12=l_oma.oma10
      LET l_omc.omc13=l_omc.omc09-l_omc.omc11
      LET l_omc.omc14=l_oma.oma51f
      LET l_omc.omc15=l_oma.oma51
      LET l_oma.oma70='1'
      LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(l_oma.oma66,'oga_file'),
                  " WHERE oga01='",l_oma.oma16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_oma.oma66) RETURNING g_sql
      PREPARE sel_oga271 FROM g_sql
      EXECUTE sel_oga271 INTO l_oma.oma67
      LET l_oma.oma930=s_costcenter(l_oma.oma15)
      LET l_oma.omalegal = g_ooa.ooalegal
      LET l_omc.omclegal = g_ooa.ooalegal
      LET l_oma.omaoriu = g_user
      LET l_oma.omaorig = g_grup

      IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
      IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
      IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF

      INSERT INTO oma_file VALUES(l_oma.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('oma02','g_ooa.ooa02','ins oma',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF

      INSERT INTO omc_file VALUES(l_omc.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('omc01','l_oma.oma01','ins omc',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF
      UPDATE oob_file SET oob06=l_oma.oma01,oob19=l_omc.omc02
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_showmsg=b_oob.oob01,"/",b_oob.oob02
         CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt
        FROM npq_file
       WHERE npq01 = b_oob.oob01 AND npq02 = b_oob.oob02
      IF l_cnt > 0 THEN
         UPDATE npq_file SET npq23=l_oma.oma01
          WHERE npq01=b_oob.oob01 AND npq02=b_oob.oob02
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_showmsg=b_oob.oob01,"/",b_oob.oob02
            CALL s_errmsg('npq01,npq02',g_showmsg,'upd npq23',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION p601_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
   DEFINE p_sw           LIKE type_file.chr1             # +:更新
   DEFINE l_omaconf      LIKE oma_file.omaconf
   DEFINE l_omavoid      LIKE oma_file.omavoid
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_oma00        LIKE oma_file.oma00
   DEFINE l_omc          RECORD LIKE omc_file.*
   DEFINE l_omc10        LIKE omc_file.omc10
   DEFINE l_omc11        LIKE omc_file.omc11
   DEFINE l_omc13        LIKE omc_file.omc13
   DEFINE l_oob10        LIKE oob_file.oob10
   DEFINE l_oob09        LIKE oob_file.oob09
   DEFINE tot4,tot4t     LIKE type_file.num20_6
   DEFINE tot5,tot6      LIKE type_file.num20_6

  # 同參考單號若有一筆以上僅沖款一次即可 --------------
   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01=b_oob.oob01
         AND oob02<b_oob.oob02
         AND oob03='2'
         AND oob04='1'
         AND oob06=b_oob.oob06
         AND oob15=b_oob.oob15
         AND oob19=b_oob.oob19
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01=b_oob.oob01
         AND oob02<b_oob.oob02
         AND oob03='2'
         AND oob04='1'
         AND oob19=b_oob.oob19
         AND oob06=b_oob.oob06
   END IF
   IF l_cnt>0 THEN
       LET g_showmsg=b_oob.oob06,"/",b_oob.oob01
       CALL s_errmsg('oob06,oob01',g_showmsg,b_oob.oob01,'axr-409',1)
       LET g_success = 'N'
       RETURN
   END IF

   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
      AND oob03='2'
      AND oob04='1'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF

   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2
   LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
             "  FROM oma_file ",
             " WHERE oma01=?"
   PREPARE t400_bu_21_p1 FROM g_sql
   DECLARE t400_bu_21_c1 CURSOR FOR t400_bu_21_p1
   OPEN t400_bu_21_c1 USING b_oob.oob06
   FETCH t400_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
   IF p_sw='+' AND l_omavoid='Y' THEN
      CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-103',1) LET g_success='N' RETURN
   END IF
   IF p_sw='+' AND l_omaconf='N' THEN
      CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN
   END IF
   IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
   IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
  #取得衝帳單的待扺金額
   CALL p601_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
  #期末調匯(A008)
   IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
      IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN
      CALL s_errmsg('oma01',b_oob.oob06,'un_pay<pay','axr-196',1) LET g_success='N' RETURN
      END IF
   END IF
   IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
      CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3

      IF tot3 <0 THEN
         CALL s_errmsg('','','','axr-185',1)
         LET g_success ='N'
         RETURN
      END IF
      LET tot3 = tot3 - tot4t
   ELSE
      LET tot3 = un_pay2 - tot2 - tot4t
   END IF
   LET g_sql="UPDATE oma_file ",
             " SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "
   PREPARE t400_bu_21_p2 FROM g_sql
   LET tot1 = tot1 + tot4
   LET tot2 = tot2 + tot4t
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2
   EXECUTE t400_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN
   END IF
   IF SQLCA.sqlcode = 0 THEN
      CALL p601_axrt400_omc(l_oma00,p_sw)
   END IF
  #若有指定沖帳項次, 則對項次再次檢查及更新已沖金額
   IF NOT cl_null(b_oob.oob15) AND g_ooz.ooz62='Y' THEN
      LET tot1 = 0 LET tot2 = 0
      SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
         AND oob03='2' AND oob15 = b_oob.oob15
         AND oob04='1'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      LET g_sql="SELECT oma00,omaconf,omb14t,omb16t ",
                "  FROM omb_file,oma_file ",
                " WHERE oma01=omb01 AND omb01=? AND omb03 = ? "
      PREPARE t400_bu_21_p1b FROM g_sql
      DECLARE t400_bu_21_c1b CURSOR FOR t400_bu_21_p1b
      OPEN t400_bu_21_c1b USING b_oob.oob06,b_oob.oob15
      FETCH t400_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2
      IF p_sw='+' AND l_omaconf='N' THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15
         CALL s_errmsg('omb01,omb03',g_showmsg,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN
      END IF
      IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
      IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
      IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
         IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15
         CALL s_errmsg('omb01,omb03',g_showmsg,'un_pay<pay','axr-196',1)  LET g_success='N' RETURN
         END IF
      END IF
      IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
        #取得未沖金額
         CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
      ELSE
         LET tot3 = un_pay2  - tot2
      END IF
      LET g_sql="UPDATE omb_file ",
                " SET omb34=?,omb35=?,omb37=? ",
                " WHERE omb01=? AND omb03=?"
      PREPARE t400_bu_21_p2b FROM g_sql
      EXECUTE t400_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
      IF STATUS THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15
         CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15
         CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1) LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION p601_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
   DEFINE p_sw           LIKE type_file.chr1                        # +:更新 -:還原
   DEFINE l_omaconf      LIKE oma_file.omaconf,
          l_omavoid      LIKE oma_file.omavoid,
          l_cnt          LIKE type_file.num5
   DEFINE l_oma00        LIKE oma_file.oma00,
          l_oma55        LIKE oma_file.oma55,
          l_oma57        LIKE oma_file.oma57
   DEFINE tot4,tot4t     LIKE type_file.num20_6
   DEFINE tot5,tot6      LIKE type_file.num20_6
   DEFINE tot8           LIKE type_file.num20_6
   DEFINE l_omc10        LIKE omc_file.omc10,
          l_omc11        LIKE omc_file.omc11,
          l_omc13        LIKE omc_file.omc13

  #同參考單號若有一筆以上僅沖款一次即可 --------------
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01=b_oob.oob01
      AND oob02<b_oob.oob02
      AND oob03='1'
      AND oob04='3'
      AND oob06=b_oob.oob06
   IF l_cnt>0 THEN RETURN END IF

  #預防在收款沖帳確認前,多沖待抵貨款
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01
      AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF

   IF p_sw='+' THEN
      SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
         AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
      IF cl_null(tot5) THEN LET tot5 = 0 END IF
      IF cl_null(tot6) THEN LET tot6 = 0 END IF
   END IF

   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2

   LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t,oma55,oma57 ",
             "  FROM oma_file ",
             " WHERE oma01=?"
   PREPARE p601_bu_13_p1 FROM g_sql
   DECLARE p601_bu_13_c1 CURSOR FOR p601_bu_13_p1
   OPEN p601_bu_13_c1 USING b_oob.oob06
   FETCH p601_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57
   IF p_sw='+' AND l_omavoid='Y' THEN
      CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN
   END IF
   IF p_sw='+' AND l_omaconf='N' THEN
      CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN
   END IF
   IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
   IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
  #取得衝帳單的待扺金額
   CALL p601_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t

   IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
      IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN
      CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN
      END IF
   END IF

   IF l_oma00 = '23' THEN
      SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf <> 'X'
         AND oob03='1'  AND oob04 = '3'
         AND ooa01=g_ooa.ooa01
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
   ELSE
      SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
         AND oob03='1'  AND oob04 = '3'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      LET l_oma55 = 0
      LET l_oma57 = 0
   END IF

   IF p_sw='+' THEN
      SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
         AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
      IF cl_null(tot5) THEN LET tot5 = 0 END IF
      IF cl_null(tot6) THEN LET tot6 = 0 END IF

      SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file
       WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
      IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
      IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
      IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
      LET tot1 = tot1 + l_oma55
      LET tot2 = tot2 + l_oma57
   ELSE
      IF l_oma00 = '23' THEN
         LET tot1 = un_pay1 - tot1
         LET tot2 = un_pay2 - tot2
      END IF
   END IF

   IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
      CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
      LET tot3 = tot3 - tot4t
   ELSE
      LET tot3 = un_pay2 - tot2 - tot4t
   END IF
   LET g_sql="UPDATE oma_file SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "

   PREPARE p601_bu_13_p2 FROM g_sql
   LET tot1 = tot1 + tot4
   LET tot2 = tot2 + tot4t
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2
   EXECUTE p601_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN
   END IF
   IF SQLCA.sqlcode = 0 THEN
      CALL p601_axrt400_omc(l_oma00,p_sw)
   END IF
END FUNCTION


FUNCTION p601_axrt400_omc(p_oma00,p_sw)
   DEFINE   l_omc10           LIKE omc_file.omc10
   DEFINE   l_omc11           LIKE omc_file.omc11
   DEFINE   l_omc13           LIKE omc_file.omc13
   DEFINE   l_oob09           LIKE oob_file.oob09
   DEFINE   l_oob10           LIKE oob_file.oob10
   DEFINE   l_oox10           LIKE oox_file.oox10
   DEFINE   p_oma00           LIKE oma_file.oma00
   DEFINE   tot4,tot4t        LIKE type_file.num20_6
   DEFINE   p_sw              LIKE type_file.chr1

   LET l_oox10 = 0
   SELECT SUM(oox10) INTO l_oox10 FROM oox_file
    WHERE oox00 = 'AR'
      AND oox03 = b_oob.oob06
      AND oox041 = b_oob.oob19
   IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF
   IF p_oma00 MATCHES '2*' THEN
      LET l_oox10 = l_oox10 * -1
   END IF

   IF p_oma00 = '23' THEN
      SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
         AND oob01=ooa01 AND ooa01=g_ooa.ooa01
         AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
      IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
      IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF

      SELECT omc10,omc11 INTO l_omc10,l_omc11 FROM omc_file
       WHERE omc01 = b_oob.oob06
         AND omc02 = b_oob.oob19

      IF p_sw='+' THEN
         LET l_oob09 = l_omc10 + l_oob09
         LET l_oob10 = l_omc11 + l_oob10
      ELSE
         LET l_oob09 = l_omc10 - l_oob09
         LET l_oob10 = l_omc11 - l_oob10
      END IF
   ELSE
      SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
         AND oob01=ooa01  AND ooaconf = 'Y'
         AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
      IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
      IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
   END IF

  #取得冲帐单的待抵金额
   CALL p601_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
   LET l_oob09 = l_oob09 +tot4
   LET l_oob10 = l_oob10 +tot4t

   LET g_sql=" UPDATE omc_file SET omc10=?,omc11=? ",
             " WHERE omc01=? AND omc02=? "

   PREPARE p601_bu_13_p3 FROM g_sql
   EXECUTE p601_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
      LET g_success = 'N' RETURN
   END IF
   LET g_sql=" UPDATE omc_file ",
             " SET omc13=omc09-omc11+ ",l_oox10,
             " WHERE omc01=? AND omc02=? "
   PREPARE p601_bu_13_p4 FROM g_sql
   EXECUTE p601_bu_13_p4 USING b_oob.oob06,b_oob.oob19
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
      LET g_success = 'N' RETURN
   END IF
END FUNCTION

FUNCTION p601_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t

   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION

FUNCTION p601_ins_oob_13(p_lui14,p_luj03,p_luj04,p_sum)
   DEFINE p_lui14  LIKE lui_file.lui14
   DEFINE p_luj03  LIKE luj_file.luj03
   DEFINE p_luj04  LIKE luj_file.luj04
   DEFINE p_sum    LIKE type_file.num20_6
   DEFINE l_oma01  LIKE oma_file.oma01
   DEFINE l_amt    LIKE type_file.num20_6
   DEFINE l_amt1   LIKE type_file.num20_6

   SELECT oma01,oma56t-oma57 INTO l_oma01,l_amt FROM oma_file WHERE oma16 = p_lui14 AND oma00 = '24'
   CALL s_up_money(l_oma01)  RETURNING l_amt1    # 已衝金額
   LET l_amt = l_amt - l_amt1     ##減去未審核的金額
   IF l_amt < p_sum THEN  #不可大于可冲金额
      CALL s_errmsg('',l_amt,p_sum,'axr-971',1)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT oma_file.* INTO g_oma.* FROM oma_file WHERE oma01 = l_oma01
  #借方增加预收账款
   SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
  #IF cl_null(g_oob.oob01) THEN LET g_oob.oob01 = '1' END IF    #TQC-C20163   Mark
   IF cl_null(g_oob.oob02) THEN LET g_oob.oob02 = '1' END IF    #TQC-C20163   Add
   LET g_oob.oob03 = '1'
   LET g_oob.oob04 = '3'
   LET g_oob.oob06 = l_oma01
   LET g_oob.oob08 = 1  
   LET g_oob.oob13 = g_oma.oma15
   LET g_oob.oob19 = 1
   LET g_oob.oob07 = g_aza.aza17
   LET g_oob.oob09 = p_sum
   LET g_oob.oob10 = p_sum  
   LET g_oob.oob22 = 0
   LET g_oob.oob11 = g_oma.oma18
   LET g_oob.ooblegal = g_legal

   IF g_oob06 = l_oma01 AND g_luj03 = p_luj03 THEN #AND g_luj04 = p_luj04 THEN #TQC-C20290 mark
      UPDATE oob_file SET oob09 = oob09 + g_oob.oob09,
                          oob10 = oob10 + g_oob.oob10
       WHERE oob01 = g_oob.oob01
         AND oob06 = g_oob.oob06#TQC-C20290 
         AND oob03 = '1'#TQC-C20290 
   ELSE
      INSERT INTO oob_file VALUES(g_oob.*)
   END IF
   LET g_oob06 = l_oma01
   LET g_luj03 = p_luj03
   LET g_luj04 = p_luj04

END FUNCTION

FUNCTION p601_ins_oob_21(p_luj03,p_luj04,p_sum)
   DEFINE p_luj03    LIKE luj_file.luj03
   DEFINE p_luj04    LIKE luj_file.luj04
   DEFINE p_sum      LIKE type_file.num20_6
   #TQC-C20437--add--str
   DEFINE l_oma15    LIKE oma_file.oma15
   DEFINE l_oma18    LIKE oma_file.oma18
   #TQC-C20437--add--end

   SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01 = g_oob.oob01
  #IF cl_null(g_oob.oob01) THEN LET g_oob.oob01 = '1' END IF    #TQC-C20163   Mark
   IF cl_null(g_oob.oob02) THEN LET g_oob.oob02 = '1' END IF    #TQC-C20163   Add
   LET g_oob.oob03 = '2'
   LET g_oob.oob04 = '1'
   LET g_sql = "SELECT lub14 FROM ",cl_get_target_table(g_plant_new,'lub_file'),
               " WHERE lub01 = '",p_luj03,"' AND lub02 = '",p_luj04,"'"
              ,"   AND YEAR(lub10) = '",tm.yy,"'",  #No.FUN-C30029   Add
               "   AND MONTH(lub10) = '",tm.mm,"'"  #No.FUN-C30029   Add
   IF g_bgjob = 'N' AND NOT cl_null(tm.lub09) THEN LET g_sql = g_sql,"   AND lub09 = '",tm.lub09,"'" END IF   #No.FUN-C30029   Add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lub14 FROM g_sql
   EXECUTE p601_sel_lub14 INTO g_oob.oob06
   LET g_oob.oob08 =1
 # LET g_oob.oob13 = g_oma.oma15
   LET g_oob.oob19 = 1
   LET g_oob.oob07 = g_aza.aza17
   LET g_oob.oob09 = p_sum
   LET g_oob.oob10 = p_sum
   LET g_oob.oob22 =0
  #LET g_oob.oob11 = g_oma.oma18
   #TQC-C20437--add--str
   SELECT oma15,oma18 INTO l_oma15,l_oma18 FROM oma_file
    WHERE oma01 = g_oob.oob06
   LET g_oob.oob13 = l_oma15
   LET g_oob.oob11 = l_oma18
   #TQC-C20437--add--end
   LET g_oob.ooblegal = g_legal

   IF g_oob06_1 = g_oob.oob06 AND g_luj03_1 = p_luj03 THEN # AND g_luj04 = p_luj04 THEN#TQC-C20290 mark
      UPDATE oob_file SET oob09 = oob09 + g_oob.oob09,
                          oob10 = oob10 + g_oob.oob10
       WHERE oob01 = g_oob.oob01
         AND oob06 = g_oob.oob06#TQC-C20290
         AND oob03 = '2'#TQC-C20290
   ELSE
      INSERT INTO oob_file VALUES(g_oob.*)
   END IF
   #TQC-C20290--add--str
   UPDATE oma_file SET oma55 = oma55 + g_oob.oob09,oma57 = oma57 + g_oob.oob10
    WHERE oma01 = g_oob.oob06
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('upd oma',g_oob.oob06,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
   #TQC-C20290--add--end
   LET g_oob06_1 = g_oob.oob06
   LET g_luj03_1 = p_luj03
   LET g_luj04_1 = p_luj04

END FUNCTION

FUNCTION p601_ins_ooa_1(p_flag)
   DEFINE p_flag     LIKE type_file.num5

   IF p_flag= '2' THEN
      LET g_ooa.ooa00 = '1'
      LET g_ooa.ooa01 = g_oob.oob01
   ELSE
      LET g_ooa.ooa00 = '2'
      LET g_ooa.ooa01 = g_oma.oma01
   END IF
   LET g_ooa.ooa02 = g_oma.oma02
   LET g_ooa.ooa021= g_today
   LET g_ooa.ooa03 = g_oma.oma03
   LET g_ooa.ooa032= g_oma.oma032
   LET g_ooa.ooa13 = g_oma.oma13
  #LET g_ooa.ooa14 = g_user    #No.TQC-C30350   Mark
  #LET g_ooa.ooa15 = g_grup    #No.TQC-C30350   Mark
   LET g_ooa.ooa14 = g_lua38   #No.TQC-C30350   Add
   LET g_ooa.ooa15 = g_lua39   #No.TQC-C30350   Add
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = g_oma.oma23
   LET g_ooa.ooa24 = g_oma.oma24
   LET g_ooa.ooa40 = ' '

   SELECT SUM(oob09),SUM(oob10)
     INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file
   #WHERE oob01=g_oma.oma01    #TQC-C20163   Mark
    WHERE oob01=g_oob.oob01    #TQC-C20163  Add
      AND oob03='1'  AND oob02>0

   SELECT SUM(oob09),SUM(oob10)
     INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file
   #WHERE oob01=g_oma.oma01   #TQC-C20163   Mark
    WHERE oob01=g_oob.oob01   #TQC-C20163   Add
      AND oob03='2' AND oob02 > 0

   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF

   IF cl_null(g_ooa.ooa31c) THEN
      LET g_ooa.ooa31c=g_oma.oma54t
   ELSE
      LET g_ooa.ooa31c=g_oma.oma54t + g_ooa.ooa31c
   END IF

   IF cl_null(g_ooa.ooa32c) THEN
      LET g_ooa.ooa32c=g_oma.oma56t
   ELSE
      LET g_ooa.ooa32c=g_oma.oma56t + g_ooa.ooa32c
   END IF

   IF g_ooa.ooa31d < g_ooa.ooa31c THEN
      LET g_ooa.ooa31c=g_ooa.ooa31d
      LET g_ooa.ooa32c=g_ooa.ooa32d
   END IF

   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,t_azi04)
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,t_azi04)
   LET g_ooa.ooa33d = 0

   LET g_ooa.ooaconf = 'Y'
   LET g_ooa.ooa34   = '1'
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   LET g_ooa.ooa37 = '1'
   LET g_ooa.ooaoriu = g_user
   LET g_ooa.ooaorig = g_grup
   LET g_ooa.ooalegal = g_legal
   LET g_ooa.ooa35='1'          #TQC-C20430
  #LET g_ooa.ooa36=g_lui.lui01  #TQC-C20430    #No.FUN-C30029   Mark
  #No.FUN-C30029   ---start---   Add
   LET g_sql = "SELECT lui01 FROM ",cl_get_target_table(g_plant_new,'lui_file'),
               " WHERE lui04 = '",g_lua.lua01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p601_sel_lui2 FROM g_sql
   EXECUTE p601_sel_lui2 INTO g_ooa.ooa36
  #No.FUN-C30029   ---end---     Add
   LET g_ooa.ooa38 = '1'        #No.FUN-C30029   Add
   INSERT INTO ooa_file values(g_ooa.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('ins ooa',g_ooa.ooa01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

END FUNCTION

#No.TQC-C30188   ---start---   Add
FUNCTION p601_axrp590()
  #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip   #No.FUN-C30029   Mark
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_oow.oow02  #No.FUN-C30029   Add
   IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
      LET g_wc_gl = g_wc_gl,')'
     #LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_oma.omauser,"' '",g_oma.omauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_oma.oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   #No.TQC-C40058   Mark
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_oma.omauser,"' '",g_oma.omauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"       #No.TQC-C40058   Add
      CALL cl_cmdrun_wait(g_str)
   END IF
  #No.FUN-C30029   ---start---   Add
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_oow.oow03
   IF NOT cl_null(g_wc_gl3) AND g_success = 'Y' THEN
      LET g_wc_gl3 = g_wc_gl3,')'
     #LET g_str="axrp590 '",g_wc_gl3 CLIPPED,"' '",g_oma.omauser,"' '",g_oma.omauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_oma.oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.TQC-C40058   Mark
      LET g_str="axrp590 '",g_wc_gl3 CLIPPED,"' '",g_oma.omauser,"' '",g_oma.omauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"      #No.TQC-C40058   Add
      CALL cl_cmdrun_wait(g_str)
   END IF
  #No.FUN-C30029   ---end---     Add
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_oow.oow14
   IF NOT cl_null(g_wc_gl2) AND g_success = 'Y' THEN
      LET g_wc_gl2 = g_wc_gl2,')'
     #LET g_str="axrp590 '",g_wc_gl2 CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.TQC-C40058   Mark
      LET g_str="axrp590 '",g_wc_gl2 CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"      #No.TQC-C40058   Add
      CALL cl_cmdrun_wait(g_str)
   END IF
END FUNCTION
#No.TQC-C30188   ---end---     Add

#FUN-C20004

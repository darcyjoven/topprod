# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp602.4gl
# Descriptions...: 交款單整批生成收款沖帳作業
# Date & Author..: FUN-C20007  12/02/02 By xuxz
# Modify.........: No.TQC-C20204 12/02/15 By xuxz 調整傳入參數的取值方法
# Modify.........: No.TQC-C20329 12/02/21 By xuxz occ67調整
# Modify.........: NO:TQC-C20375 12/02/22 By xuxz 交款單立賬時溢收科目修改為ool25,ool251
# Modify.........: NO:TQC-C20290 12/02/22 By xuxz 修改分錄check條件
# Modify.........: NO:TQC-C20430 12/02/23 By wangrr 產生收款單時，設置ooa35為’1'
# Modify.........: NO:TQC-C20437 12/02/24 By xuxz 拋轉財務 報錯 無借方科目
# Modify.........: NO:MOD-C30114 12/03/09 By zhangweib 透過artt610所有自動產生的單據,確認後,狀態碼oma64應為1.已核准
# Modify.........: NO:TQC-C30177 12/03/09 By zhangweib 支票收款將rxy06維護的支票號碼寫到oob14和nmh31
# Modify.........: No.MOD-C30179 12/03/10 By zhangweib oma02立賬日期取單身lui03的值
#                                                      沒有滿足條件的資料時顯示:無合乎條件的資料
# Modify.........: NO:MOD-C30607 12/03/12 By zhangweib 自動編號時若未在營收參數設定作業(axrs020)中找到對應單別,需要給與正確的報錯訊息
# Modify.........: NO:MOD-C30636 12/03/12 By zhangweib 修改g_wc段的BEFORE CONSTRUCT語句,使之只會在初始狀態下賦默認值
#                                                      新增AFTER FIELD ar_slip段資料有效性的判斷
# Modify.........: NO:TQC-C30188 12/03/14 By zhangweib 1.產生的axrt300,axrt400的資料根據單別的判斷是否拋轉總帳
#                                                      2.拋轉總帳拿到批次的事物結束后再做拋轉
# Modify.........: NO:FUN-C30029 12/03/20 By xuxz 添加ooa38 = ‘1’ ，oma70 = ‘1'
# Modify.........: NO:FUN-C30038 12/03/27 By minpp INSERT INTO nmh_file赋值修改.nmh06 = rxy11，nmh04 = 单据日期
# Modify.........: NO:FUN-C30029 12/04/01 By xuxz 產生財務單據都是已經審核
# Modify.........: NO:FUN-C30029 12/04/01 By zhangweib 產生的單據都為已審核狀態,去掉ooyconf = 'Y'的判斷
# Modify.........: No.TQC-C40173 12/04/19 By lutingting BUG修改
# Modify.........: No.TQC-C40058 12/04/24 By zhangweib 繳款單本幣原幣幣種應該一致,修改幣種和匯率取值

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_wc       STRING                   #QBE_1的條件
DEFINE g_wc2      STRING                   #QBE_2的條件
DEFINE g_sql      STRING                   #組sql

DEFINE tm         RECORD                   #條件選項
         ar_slip     LIKE oow_file.oow14,  #費用類型
         yy          LIKE type_file.num5,  #立賬年度
         mm          LIKE type_file.num5   #立賬月份
                  END RECORD
DEFINE g_t1          LIKE ooy_file.ooyslip
DEFINE p_row,p_col      LIKE type_file.num5 
DEFINE g_oow      RECORD LIKE oow_file.*
DEFINE li_result     LIKE type_file.num5
DEFINE l_ac          LIKE type_file.num5
DEFINE l_ac_a         LIKE type_file.num5
DEFINE g_change_lang    LIKE type_file.chr1 
DEFINE g_forupd_sql STRING 
DEFINE g_bookno1        LIKE aza_file.aza81               
DEFINE g_bookno2        LIKE aza_file.aza82               
DEFINE g_flag           LIKE type_file.chr1  
DEFINE g_str            STRING                             
DEFINE g_wc_gl          STRING,
        tot,tot1,tot2    LIKE type_file.num20_6,          
       tot3             LIKE type_file.num20_6,          
       un_pay1,un_pay2  LIKE type_file.num20_6                                                    
#QBE1條件sql賦值
DEFINE g_plant_l  LIKE type_file.chr21     #營運中心
#抓取費用單賦值
DEFINE g_lua   RECORD LIKE lua_file.*

DEFINE g_lub   RECORD LIKE lub_file.*
DEFINE g_lui   RECORD LIKE lui_file.*
DEFINE g_luj   RECORD LIKE luj_file.*
DEFINE g_rxx   RECORD LIKE rxx_file.*
DEFINE g_rxy   RECORD LIKE rxy_file.*
DEFINE g_nms   RECORD LIKE nms_file.*
DEFINE g_occ   RECORD LIKE occ_file.*
DEFINE b_oob   RECORD LIKE oob_file.*
DEFINE g_luj07 LIKE luj_file.luj07,
       g_luj03 LIKE luj_file.luj03
#insert操作
DEFINE g_nmh   RECORD LIKE nmh_file.*
DEFINE g_oob   RECORD LIKE oob_file.*
DEFINE g_ooa   RECORD LIKE ooa_file.*

MAIN 
   DEFINE l_flag  LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
   LET g_wc = ARG_VAL(1)
   LET g_wc       = cl_replace_str(g_wc, "\\\"", "'")  #TQC-C20204 add
   LET g_wc2 = ARG_VAL(2)
   LET g_wc2      = cl_replace_str(g_wc2, "\\\"", "'") #TQC-C20204 add
   LET tm.ar_slip = ARG_VAL(3)
   LET tm.yy = ARG_VAL(4)
   LET tm.mm = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   
  #SELECT * INTO g_oow.* FROM oow_file #TQC-C20204 mark
  # WHERE oow00 = '0' #TQC-C20204 mark
  #IF cl_null(tm.ar_slip) THEN #TQC-C20204 mark
  #   LET tm.ar_slip = g_oow.oow14#TQC-C20204 mark
  #END IF #TQC-C20204 mark
   IF cl_null(g_bgjob) THEN 
      LET g_bgjob ="N"
   END IF 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log 
   
   IF (NOT cl_setup("AXR")) THEN 
      EXIT PROGRAM 
   END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT * INTO g_oow.* FROM oow_file #TQC-C20204add
    WHERE oow00 = '0' #TQC-C20204  add
   IF cl_null(tm.ar_slip) THEN  #TQC-C20204add
      LET tm.ar_slip = g_oow.oow14#TQC-C20204add
   END IF#TQC-C20204add
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p602()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p602_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
              #No.TQC-C30188   ---start---   Add
               SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
               IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
                  LET g_wc_gl = g_wc_gl,')'
                  LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   
                  CALL cl_cmdrun_wait(g_str)
               END IF
              #No.TQC-C30188   ---start---   Add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p602_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p602_1()
         IF g_success = "Y" THEN
            COMMIT WORK
           #No.TQC-C30188   ---start---   Add
            SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
            IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
               LET g_wc_gl = g_wc_gl,')'
               LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   
               CALL cl_cmdrun_wait(g_str)
            END IF
           #No.TQC-C30188   ---start---   Add
            CALL cl_err('','lib-284',1) #TQC-C20430
         ELSE
            ROLLBACK WORK
            CALL cl_err('','abm-020',1) #TQC-C20430
         END IF
         #CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p602()
   DEFINE l_ooyacti   LIKE ooy_file.ooyacti    #No.MOD-C30636   Add

   LET p_row = 5 LET p_col = 28
   
   OPEN WINDOW p602_w AT p_row,p_col WITH FORM "axr/42f/axrp602"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM 

   
   DIALOG attributes(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
      
         BEFORE CONSTRUCT 
           #DISPLAY g_plant TO azp01   #No.MOD-C30636   Mark
            IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF    #No.MOD-C30636   Add
            IF cl_null(tm.ar_slip) THEN 
               #賦初值
               SELECT oow14 INTO tm.ar_slip FROM oow_file
               IF SQLCA.sqlcode THEN 
                  LET tm.ar_slip = ""
               END IF
               DISPLAY tm.ar_slip TO ar_slip
            END IF
           #LET tm.yy = YEAR(g_today)     #No.MOD-C30636   Mark
           #LET tm.mm = MONTH(g_today)    #No.MOD-C30636   Mark
           #No.MOD-C30636   ---start---   Add
            IF cl_null(tm.yy) THEN LET tm.yy = YEAR(g_today) END IF
            IF cl_null(tm.mm) THEN LET tm.mm = MONTH(g_today) END IF
           #No.MOD-C30636   ---end---     Add
         
      END CONSTRUCT 

      CONSTRUCT BY NAME g_wc2 ON lui01,lui05,lui02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      INPUT BY NAME tm.ar_slip,tm.yy,tm.mm
                     
         AFTER FIELD ar_slip
            IF NOT cl_null(tm.ar_slip) THEN 
           #No.MOD-C30636   ---start---   Add
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(tm.ar_slip,'axr-956',1)
                  NEXT FIELD ar_slip
               END IF
               CALL s_check_no("axr",tm.ar_slip,"","30","","","")
                  RETURNING li_result,tm.ar_slip
               IF (NOT li_result) THEN
                  NEXT FIELD ar_slip
               END IF
               DISPLAY BY NAME tm.ar_slip
           #No.MOD-C30636   ---end---     Add
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
            WHEN INFIELD(lui01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lui01"
               LET g_qryparam.where ="luiconf = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lui01
               NEXT FIELD lui01
            WHEN INFIELD(lui05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lui05
               NEXT FIELD lui05
            WHEN INFIELD(ar_slip)
               CALL q_ooy( FALSE, TRUE, tm.ar_slip,'30','AXR') RETURNING g_t1
               LET tm.ar_slip = g_t1
               DISPLAY BY NAME tm.ar_slip
               NEXT FIELD ar_slip    #No.MOD-C30636   Add
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
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION locale 
         LET g_change_lang = TRUE
         EXIT DIALOG
            
   END DIALOG

   IF INT_FLAG THEN
      CLOSE WINDOW p602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

         
END FUNCTION 

FUNCTION p602_1()
   DEFINE l_ooy RECORD LIKE ooy_file.*
   DEFINE l_lub09 LIKE lub_file.lub09
   BEGIN WORK 
   CALL s_showmsg_init() 

   #抓取QBE1條件中g_legal的營運中心sql
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p602_azp01_pre FROM g_sql
   DECLARE p602_azp01_cs CURSOR FOR p602_azp01_pre

   INITIALIZE g_lua TO NULL 
   INITIALIZE g_occ TO NULL 
   FOREACH p602_azp01_cs INTO g_plant_l
      #抓取符合qbe條件1的費用單單別等資料，且非直接付款lua37 = 'N',已經審核的lua15='Y'
      LET g_sql = " SELECT *  ",
               "   FROM ",cl_get_target_table(g_plant_l,'lua_file'),
               "  WHERE  luaplant = ? ",
               "    AND lua37 = 'N' ",
               "    AND lua15 = 'Y' ",
               "    AND lua32<>'6' ",
               "    AND lua01 = ? "
               
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p602_lua_pre FROM g_sql
      DECLARE p602_lua_cs CURSOR FOR p602_lua_pre

      #抓取符合qbe條件2,input條件的交款單的資料，且交款單已經交款審核 luiconf='Y'
      LET g_sql = " SELECT *  ",
               "   FROM ",cl_get_target_table(g_plant_l,'lui_file'),
               #"  WHERE lui04 = ? ",
               "  WHERE ",g_wc2,
               "    AND year(lui03) = ? AND month(lui03) =? ",    #年度+期別
               "    AND luiconf = 'Y' ",
               "    AND lui14 IS NULL"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p602_lui_pre FROM g_sql
      DECLARE p602_lui_cs CURSOR FOR p602_lui_pre    
        
      
      LET g_sql = " SELECT * ",
               "   FROM ",cl_get_target_table(g_plant_l,'luj_file'),
               "  WHERE luj01 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p602_luj_pre FROM g_sql
      DECLARE p602_luj_cs CURSOR FOR p602_luj_pre
      

      LET g_sql = " SELECT * ",
               "   FROM ",cl_get_target_table(g_plant_l,'rxx_file'),
               "  WHERE rxx01 = ? ",
               "    AND rxxplant = ? ",
               "    AND rxx00 = '11' ",
               "    AND rxx04 > 0 "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p602_rxx_pre FROM g_sql
      DECLARE p602_rxx_cs CURSOR FOR p602_rxx_pre
      
      #抓取符合qbe條件1的費用單單別等資料
      
         
         #抓取符合qbe條件2,input條件的交款單的資料，且交款單已經交款審核 luiconf='Y'
         FOREACH p602_lui_cs USING tm.yy,tm.mm INTO g_lui.*
            FOREACH p602_luj_cs USING g_lui.lui01 INTO  g_luj.*
               EXECUTE p602_lua_pre USING g_plant_l,g_luj.luj03 INTO g_lua.*
              #No.MOD-C30179   ---start---   Add
               IF cl_null(g_lua.lua01) THEN
                  CALL s_errmsg('','','','mfg2601',1)
                  LET g_success = 'N'
               END IF
              #No.MOD-C30179   ---end---     Add
            END FOREACH 
           #No.MOD-C30179   ---start---   Add
            IF cl_null(g_luj.luj01) THEN
               CALL s_errmsg('','','','mfg2601',1)
               LET g_success = 'N'
            END IF
           #No.MOD-C30179   ---end---     Add
            INITIALIZE g_luj.* TO NULL 
            LET g_sql = " SELECT *  FROM occ_file ",
                     "  WHERE occ01 = '",g_lui.lui05,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
            PREPARE p602_occ_pre FROM g_sql
            EXECUTE p602_occ_pre INTO g_occ.*
            #TQC-C20329--add--str
            IF cl_null(g_occ.occ67) THEN 
               LET g_occ.occ67 = g_ooz.ooz08
            END IF
            #TQC-C20329--add--end
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_occ.occ42#获取原币小数位数
            #ooa01自動編號，采單別tm.ar_slip
           #No.MOD-C30607   ---start---   Add
            IF cl_null(tm.ar_slip) THEN
               CALL s_errmsg('oow14','','','axr-149',1)
               LET g_success = 'N'
            END IF
           #No.MOD-C30607   ---end---     Add
            CALL s_auto_assign_no("AXR",tm.ar_slip,g_today,"30","ooa_file","ooa01","","","")
              RETURNING li_result,g_ooa.ooa01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF 
            LET l_ac=1 #for oob_file
            LET l_ac_a =1 #for npk_file
            LET g_sql = " SELECT DISTINCT luj03,luj07 ",
               "   FROM ",cl_get_target_table(g_plant_l,'luj_file'),
               "  WHERE luj01 =  '",g_lui.lui01,"'",
               "    AND luj07 IS NOT NULL "
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql
             CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
             PREPARE p602_1_pre FROM g_sql
             DECLARE p602_1_cs CURSOR FOR p602_1_pre
             FOREACH p602_1_cs INTO g_luj03,g_luj07
                CALL p602_gen_oma()
             END FOREACH 
          #No.MOD-C30607   ---start---   Add
          ##No.MOD-C30179   ---start---   Add
          # IF cl_null(g_luj03) THEN
          #    CALL s_errmsg('','','','mfg2601',1)
          #    LET g_success = 'N'
          # END IF
          ##No.MOD-C30179   ---end---     Add
          #No.MOD-C30607   ---start---   Add
            #借
            #抓取rxx_file資料
            FOREACH p602_rxx_cs USING g_lui.lui01,g_plant_l INTO g_rxx.*
               INITIALIZE g_nmh.* TO NULL 
               INITIALIZE g_oob.* TO NULL 
               CASE g_rxx.rxx02
                  WHEN "03"  #支票
                     CALL p602_gen_oob() #插入數據到 nmh_file，oob_file
                 #TQC-C20375 add str
                  WHEN "02" #刷卡
                     CALL p602_ins_anmt302() #插入數據到nmg_file，npk_file,oob_file,nme_file
                  WHEN  "08" #
                     CALL p602_ins_anmt302() #插入數據到nmg_file，npk_file,oob_file,nme_file
                 #TQC-C20375--add--end
                  WHEN "01"# OR "02" OR "08" #現金TT#TQC-C20375 mark 02,08
                     CALL p602_ins_anmt302() #插入數據到nmg_file，npk_file,oob_file,nme_file
                  WHEN "07"#沖預收款
                     CALL p602_oob_07()#插入數據到oob_file
               END CASE 
            END FOREACH 
           #No.MOD-C30179   ---start---   Add
            IF cl_null(g_rxx.rxx01) THEN
               CALL s_errmsg('','','','mfg2601',1)
               LET g_success = 'N'
            END IF
           #No.MOD-C30179   ---end---     Add
            #抓取artt611單身資料，判斷是否有負金額存在
            FOREACH p602_luj_cs USING g_lui.lui01 INTO  g_luj.*
               
               IF g_luj.luj06 < 0 THEN 
                  CALL p602_luj_oob()  #插入oob_file
               END IF
               #貸
               #抓取artt611單身資料，判斷費用單+項次是否立賬
               #lub14 is not null 
               CALL p602_lub_oob()
               
            END FOREACH 
           #No.MOD-C30179   ---start---   Add
            IF cl_null(g_luj.luj01) THEN
               CALL s_errmsg('','','','mfg2601',1)
               LET g_success = 'N'
            END IF
           #No.MOD-C30179   ---end---     Add
            CALL p602_lub_null()
            #产生ooa_file
            CALL p602_ooa()
            SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
            IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN 
               CALL s_t400_gl(g_ooa.ooa01,'0')
               IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
                  CALL s_t400_gl(g_ooa.ooa01,'1')
               END IF 
               #CALL s_ar_y_chk()
               #--TQC-C20290--add--str--
               CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
               CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
               IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
                  CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
               END IF
              #--TQC-C20290--add--end--
              #No.TQC-C30188   ---start---   Add
               IF g_ooy.ooyglcr = 'Y' THEN                             #No.MOD-C30607   Mark  #No.FUN-C30029   Unmark
              #IF g_ooy.ooyglcr = 'Y' AND g_ooy.ooyconf = 'Y' THEN     #No.MOD-C30607   Add   #No.FUN-C30029   Mark
                 IF cl_null(g_wc_gl) THEN
                     LET g_wc_gl = ' npp011 = 1 AND npp01 IN ("',g_ooa.ooa01,'"'
                  ELSE
                     LET g_wc_gl = g_wc_gl,',"',g_ooa.ooa01,'"'
                  END IF
               END IF
              #No.TQC-C30188   ---end---     Add
            END IF 
           #IF g_ooy.ooyconf = 'Y' THEN #FUN-C30029 mark
               CALL p602_axrt400_conf()
               IF g_success = 'Y' THEN 
                  CALL p602_axrt400_upd()
               END IF 
           #END IF #FUN-C30029 mark
         END FOREACH 
        #No.MOD-C30179   ---start---   Add
         IF cl_null(g_lui.lui01) THEN
            CALL s_errmsg('','','','mfg2601',1)
            LET g_success = 'N'
         END IF
        #No.MOD-C30179   ---end---     Add
      END FOREACH 
     #No.MOD-C30179   ---start---   Add
      IF cl_null(g_plant_l) THEN
         CALL s_errmsg('','','','mfg2601',1)
         LET g_success = 'N'
      END IF
     #No.MOD-C30179   ---end---     Add

   CALL s_showmsg()
END FUNCTION

FUNCTION p602_gen_oob() 
   DEFINE l_rxy RECORD LIKE rxy_file.*
   DEFINE l_dept       LIKE type_file.chr10
   INITIALIZE l_rxy.* TO NULL
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_l,'rxy_file'),
          " WHERE rxy01 = '",g_lui.lui01,"' AND rxyplant = '",g_lua.luaplant,"'",
	       "   AND rxy00 = '11' ",
	       "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql	      
   PREPARE p602_nmh_pre FROM g_sql
   DECLARE p602_nmh_cs CURSOR FOR p602_nmh_pre
   FOREACH p602_nmh_cs INTO l_rxy.*
      IF l_rxy.rxy09 > l_rxy.rxy05 THEN 
         #贷方
         CALL p602_2_rxy(l_rxy.*)
      END IF 
      
      IF cl_null(l_rxy.rxy05) THEN LET l_rxy.rxy05=0 END IF
      IF cl_null(l_rxy.rxy07) THEN LET l_rxy.rxy07=0 END IF
      IF cl_null(l_rxy.rxy08) THEN LET l_rxy.rxy08=0 END IF
      IF cl_null(l_rxy.rxy09) THEN LET l_rxy.rxy09=0 END IF
      IF cl_null(l_rxy.rxy16) THEN LET l_rxy.rxy16=0 END IF
      IF cl_null(l_rxy.rxy17) THEN LET l_rxy.rxy17=0 END IF
      #nmh_file
      IF cl_null(g_oow.oow22) THEN 
         CALL s_errmsg('oow22',g_oow.oow22,'','axr-149',1)
	     LET g_success = 'N'
      END IF
      #nmh01
      CALL s_auto_assign_no("ANM",g_oow.oow22,l_rxy.rxy10,"2","nmh_file","nmh01","","","")
          RETURNING li_result,g_nmh.nmh01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
      #nmh02--nmh11
      LET g_nmh.nmh02 = l_rxy.rxy09
      IF cl_null(g_oow.oow25) THEN                                                             
         CALL s_errmsg('oow25',g_oow.oow25,'','axr-149',1)                                                         
         LET g_success = 'N' 
      END IF 
      LET g_nmh.nmh03 = g_oow.oow25
     #LET g_nmh.nmh04 = l_rxy.rxy10   #FUN-C30038 mark
      LET g_nmh.nmh04 = g_lui.lui02   #FUN-C30038 add
      LET g_nmh.nmh05 = l_rxy.rxy10
      LET g_nmh.nmh06 = l_rxy.rxy11
      LET g_nmh.nmh07 = l_rxy.rxy06
      LET g_nmh.nmh31 = l_rxy.rxy06   #No.TQC-C30177   Add
      LET g_nmh.nmh08 = 0
      LET g_nmh.nmh09 = g_nmh.nmh04
      #LET g_nmh.nmh10 = ''
      LET g_nmh.nmh11 = g_lua.lua06
      IF cl_null(g_oow.oow23) THEN                                                                  
         CALL s_errmsg('oow23',g_oow.oow23,'','axr-149',1)                                                           
         LET g_success = 'N' 
      END IF 
      LET g_nmh.nmh12 = g_oow.oow23
      LET g_nmh.nmh13 = 'N'
      IF cl_null(g_oow.oow24) THEN                               
         CALL s_errmsg('oow24',g_oow.oow24,'','axr-149',1)                        
         LET g_success = 'N'                              
      END IF 
      LET g_nmh.nmh14 = ''
      LET g_nmh.nmh15 = g_oow.oow24
      #LET g_nmh.nmh17 = l_rxy.rxy09#TQC-C20375 mark
      LET g_nmh.nmh17 = 0 #TQC-C20375 add
      SELECT ooe02 INTO g_nmh.nmh21 FROM ooe_file WHERE ooe01 = '03'
      IF g_nmh.nmh21 IS NULL THEN LET g_nmh.nmh21 = ' ' END IF
      
      LET g_nmh.nmh24 = '1'
      LET g_nmh.nmh25 = TODAY
      LET g_nmh.nmh28 = 1
      LET g_nmh.nmh32 = g_nmh.nmh28 * g_nmh.nmh02
      LET g_nmh.nmh38 = 'Y'
      LET g_nmh.nmh39 = 0
      LET g_nmh.nmh40 = 0
      CALL cl_digcut(g_nmh.nmh40,g_azi04) RETURNING g_nmh.nmh40
      SELECT nmz11 INTO g_nmz.nmz11 FROM nmz_file
      IF g_nmz.nmz11 = 'Y' THEN LET l_dept = g_nmh.nmh15 ELSE LET l_dept = ' ' END IF
      LET g_sql = " SELECT *  FROM nms_file ", 
                  "  WHERE nms01 = '",l_dept,"' "
      PREPARE p602_nms_01 FROM g_sql
      EXECUTE p602_nms_01 INTO g_nms.*
      
      LET g_nmh.nmh26  = g_nms.nms22
      LET g_nmh.nmh261 = g_nms.nms22
      LET g_nmh.nmh27  = g_nms.nms21
      LET g_nmh.nmh271 = g_nms.nms21     
      LET g_nmh.nmh41 = 'N'      
      LET g_nmh.nmhuser = g_user
      LET g_nmh.nmhgrup = g_grup
      LET g_nmh.nmhoriu = g_user      
      LET g_nmh.nmhorig = g_grup      
      LET g_nmh.nmhlegal = g_legal 
      IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF   
      INSERT INTO nmh_file VALUES(g_nmh.*)

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         #CALL cl_err3("ins","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","ins nmh",1)
         CALL s_errmsg('nmg01',g_nmh.nmh01,'ins nmh_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      ###oob的資料
      INITIALIZE g_oob.* TO NULL 
      LET g_oob.oob01 = g_ooa.ooa01
      LET g_oob.oob02 = l_ac
      LET g_oob.oob03 = '1'
      LET g_oob.oob04 = '1' 
      SELECT gem01 INTO g_oob.oob13 FROM gen_file,gem_file
       WHERE gen01 = g_user
         AND gen03 = gem01
      LET g_oob.oob19 = 1
      LET g_oob.oob14 = l_rxy.rxy06   #No.TQC-C30177   Add
      LET g_oob.oob15 = l_rxy.rxy02
      LET g_oob.oob06 = g_nmh.nmh01
      LET g_oob.oob07 = g_aza.aza17   #No.TQC-C40058   Add
      LET g_oob.oob08 = 1             #No.TQC-C40058   Add
     #No.TQC-C40058   ---start---   Mark
     #LET g_oob.oob07 = g_occ.occ42
     ##oob07,08
     #IF g_occ.occ42 = g_aza.aza17 THEN 
     #   LET g_oob.oob08 = 1
     #ELSE
     #  #CALL s_curr3(g_occ.occ42,g_lua.lua09,g_ooz.ooz17) RETURNING g_oob.oob08    #No.MOD-C30179   Mark
     #   CALL s_curr3(g_occ.occ42,g_lui.lui03,g_ooz.ooz17) RETURNING g_oob.oob08    #No.MOD-C30179   Add
     #END IF
     #No.TQC-C40058   ---end---     Mark
      LET g_oob.oob09 = l_rxy.rxy09
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09

      LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
      CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10

      SELECT ool12,ool121 INTO g_oob.oob11,g_oob.oob111 FROM ool_file
       WHERE ool01 = g_occ.occ67 
      IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(g_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
      LET g_oob.oob17 = NULL
      LET g_oob.oob18 = NULL
      LET g_oob.oob22 = g_oob.oob09         
      LET g_oob.ooblegal = g_legal 
      INSERT INTO oob_file VALUES(g_oob.*)

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         #CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
         CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET l_ac = l_ac + 1
   END FOREACH 
END FUNCTION

FUNCTION p602_ins_anmt302()
   DEFINE l_nmg RECORD LIKE nmg_file.*
   DEFINE l_npk RECORD LIKE npk_file.*
   DEFINE l_rxx RECORD lIKE rxx_file.*
   DEFINE l_nme RECORD LIKE nme_file.*
   DEFINE l_ooe02 LIKE ooe_file.ooe02
   DEFINE l_nma05 LIKE nma_file.nma05
   DEFINE l_nma051 LIKE nma_file.nma051
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   INITIALIZE l_nmg.* TO NULL 
   INITIALIZE l_npk.* TO NULL 
   INITIALIZE l_nme.* TO NULL
   INITIALIZE l_rxx.* TO NULL 

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
      END IF
   LET l_npk.npk00 = l_nmg.nmg00
   
   LET l_npk.npk02 = g_oow.oow08
   LET l_npk.npk03 = 1
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_l,'rxx_file'),
               "  WHERE rxx00 = '11' ",
	       "    AND rxx01 = '",g_lui.lui01,"'",
	      # "    AND rxx02 IN ('01','02','08')"
               "    AND rxx02 = '",g_rxx.rxx02,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_rxx_pre2 FROM g_sql
   DECLARE p602_rxx_cs2 CURSOR FOR p602_rxx_pre2
   FOREACH p602_rxx_cs2 INTO l_rxx.*
      LET l_npk.npk01 = l_ac_a 
      SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02
      LET l_npk.npk04 = l_ooe02
      LET l_npk.npk05 = g_aza.aza17
      LET l_npk.npk06 = 1
      SELECT nma05,nma051 INTO l_nma05,l_nma051 FROM nma_file 
       WHERE nma01 = l_npk.npk04
         AND nmaacti = 'Y'
      LET l_npk.npk07 = l_nma05 
      IF g_aza.aza63 = 'Y' THEN 
         LET l_npk.npk072 = l_nma051
      END IF
      LET l_npk.npk08 = l_rxx.rxx04
      LET l_npk.npk09 = l_rxx.rxx04
      LET l_npk.npklegal = g_legal
      INSERT INTO npk_file VALUES(l_npk.*)

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         #CALL cl_err3("ins","npk_file",l_npk.npk00,l_npk.npk01,SQLCA.sqlcode,"","ins npk",1)
         CALL s_errmsg('npk00',l_npk.npk00,'ins npk_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET l_ac_a = l_ac_a+1
      #oob_file
      INITIALIZE g_oob.* TO NULL 
      LET g_oob.oob01 = g_ooa.ooa01
      LET g_oob.oob02 = l_ac
      LET g_oob.oob03 = '1'
      LET g_oob.oob04 = '2'
      LET g_oob.oob06 = l_nmg.nmg00
      LET g_oob.oob07 = g_aza.aza17   #No.TQC-C40058   Add
      LET g_oob.oob08 = 1             #No.TQC-C40058   Add
     #No.TQC-C40058   ---start---   Mark
     #LET g_oob.oob07 = g_occ.occ42
     #IF g_occ.occ42 = g_aza.aza17 THEN 
     #   LET g_oob.oob08 = 1
     #ELSE                      
     #  #CALL s_curr3(g_occ.occ42,g_lua.lua09,g_ooz.ooz17) RETURNING g_oob.oob08   #No.MOD-C30179   Mark
     #   CALL s_curr3(g_occ.occ42,g_lui.lui03,g_ooz.ooz17) RETURNING g_oob.oob08   #No.MOD-C30179   Add
     #END IF
     #No.TQC-C40058   ---end---     Mark
      LET g_oob.oob09 = l_rxx.rxx04
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
      LET g_oob.oob22 = g_oob.oob09
      LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
      SELECT gem01 INTO g_oob.oob13 FROM gen_file,gem_file
       WHERE gen01 = g_user
         AND gen03 = gem01
      SELECT ooe02 INTO g_oob.oob17 FROM ooe_file WHERE ooe01 = l_rxx.rxx02
      IF cl_null(g_oow.oow01) THEN 
         CALL s_errmsg('oow01',g_oow.oow01,'','axr-149',1)
	     LET g_success = 'N'
      END IF 
      LET g_oob.oob18 = g_oow.oow01
      LET g_oob.oob19 = 1
      SELECT nma05,nma051,nma10 INTO g_oob.oob11,g_oob.oob111,g_oob.oob07
        FROM nma_file
       WHERE nma01 = g_oob.oob17
      IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF 
      IF cl_null(g_oob.oob17) THEN 
         CALL s_errmsg('','','','axr-077',1)
	     LET g_success = 'N'
      END IF 
      IF cl_null(g_oob.oob11) THEN 
         CALL s_errmsg('','','','axr-076',1)
	     LET g_success = 'N'
      END IF 
      LET g_oob.ooblegal = g_legal
      LET g_oob.oob15 = l_npk.npk01
      INSERT INTO oob_file VALUES(g_oob.*)

        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
      LET l_ac = l_ac + 1
      #nme_file
      INITIALIZE l_nme.* TO NULL 
      LET l_nme.nme00 = 0
      LET l_nme.nme01 = g_oob.oob17
     #LET l_nme.nme02 = g_lua.lua09   #No.MOD-C30179   Mark
      LET l_nme.nme02 = g_lui.lui03   #No.MOD-C30179   Add
      LET l_nme.nme03 = g_oob.oob18
      LET l_nme.nme04 = g_oob.oob09
      LET l_nme.nme07 = g_oob.oob08
      LET l_nme.nme08 = g_oob.oob10
      LET l_nme.nme10 = ' '
      LET l_nme.nme11 = ' '
      LET l_nme.nme12 = l_nmg.nmg00
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
       WHERE nmc01 = l_nme.nme03
      LET l_nme.nme15 = g_grup
     #LET l_nme.nme16 = g_lua.lua09   #No.MOD-C30179   Mark
      LET l_nme.nme16 = g_lui.lui03   #No.MOD-C30179   Add
      LET l_nme.nme17 = g_ooa.ooa01
      LET l_nme.nmeacti = 'Y'
      LET l_nme.nmeuser = g_user
      LET l_nme.nmegrup = g_grup
      #LET l_nme.nmedate = TODAY 
      LET l_nme.nme21 = g_oob.oob02
      LET l_nme.nme22 = '08'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_lua.lua06
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
         CALL s_errmsg('nme01',l_nme.nme01,'ins nme_file',SQLCA.sqlcode,1)
         #CALL cl_err3("ins","nme_file",l_nme.nme01,l_nme.nme02,SQLCA.sqlcode,"","ins nme",1)
         LET g_success = 'N'
      END IF
      CALL s_flows_nme(l_nme.*,'1',g_plant) #No.FUN-B90062
   END FOREACH
   LET l_nmg.nmg01 = g_lui.lui03  #立账日期				
   LET l_nmg.nmg11 = g_lui.lui12  #部门				
   LET l_nmg.nmg20 = '21'  #入账类型				
   LET l_nmg.nmg18 = g_lui.lui05  #客户				
   SELECT occ02 INTO l_nmg.nmg19 FROM occ_file WHERE occ01 = l_nmg.nmg18				
   LET l_nmg.nmg29 = 'N'				
   LET l_nmg.nmg30 = NULL				
   LET l_nmg.nmg301 = NULL				
   LET l_nmg.nmg24 = 0				
   LET l_nmg.nmg05 = 0				
   LET l_nmg.nmg06 = 0				
   LET l_nmg.nmg09 = 0	
   LET l_nmg.nmgconf = 'Y'
   LET l_nmg.nmgacti ='Y'
   LET l_nmg.nmguser = g_user
   LET l_nmg.nmggrup = g_grup
   LET l_nmg.nmgoriu = g_user
   LET l_nmg.nmgorig = g_grup
   LET g_sql = " SELECT sum(npk08) FROM ",cl_get_target_table(g_plant_l,'npk_file '),
               "  WHERE npk00 = '",l_nmg.nmg00,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_nmg23_pre FROM g_sql
   EXECUTE p602_nmg23_pre INTO l_nmg.nmg23 
   
   LET g_sql = " SELECT sum(npk09) FROM ",cl_get_target_table(g_plant_l,'npk_file '),
               "  WHERE npk00 = '",l_nmg.nmg00,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_nmg23_pre1 FROM g_sql
   EXECUTE p602_nmg23_pre1 INTO l_nmg.nmg25 
   LET l_nmg.nmglegal = g_legal
   INSERT INTO nmg_file VALUES(l_nmg.*)
   
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('nmg00',l_nmg.nmg00,'ins nmg_file',SQLCA.sqlcode,1)
      #CALL cl_err3("ins","nmg_file",l_nmg.nmg00,l_nmg.nmg01,SQLCA.sqlcode,"","ins nmg",1)
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION p602_oob_07()
   DEFINE l_oob RECORD LIKE oob_file.*
   DEFINE  l_rxy RECORD LIKE rxy_file.*
   DEFINE l_oma RECORD LIKE oma_file.*
   DEFINE l_luk16 LIKE luk_file.luk16
   DEFINE l_oma23 LIKE oma_file.oma23
   DEFINE l_oma01 LIKE oma_file.oma01
   DEFINE l_amt LIKE type_file.num20_6
   DEFINE l_ooe02 LIKE ooe_file.ooe02
   INITIALIZE l_oob.* TO NULL 
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_l,'rxy_file'),
               "  WHERE rxy00 = '11' AND rxy01 = '",g_lui.lui01,"'",
	       "    AND rxyplant = '",g_lua.luaplant,"'",
	       "    AND rxy03 = '07' AND rxy04 = '1' AND rxy05 > 0 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_oob_pre03 FROM g_sql
   DECLARE p602_oob_cs3 CURSOR FOR p602_oob_pre03
   FOREACH p602_oob_cs3 INTO l_rxy.*
      
      LET g_sql = " SELECT luk16  FROM ",cl_get_target_table(g_plant_l,'luk_file'),
                   " WHERE luk01 = '",l_rxy.rxy06,"'",
                   " AND lukconf = 'Y' ",
	               " AND luk04 = '1' "
      PREPARE p602_2_cs2 FROM g_sql
      EXECUTE p602_2_cs2 INTO l_luk16
      IF cl_null(l_luk16) THEN 
         CALL s_errmsg('luk16',l_luk16,'ins nmg_file','axr116',1)
         #CALL cl_err(l_luk16,'axr116',0)  #報錯：待抵單沒有立賬，請檢查！
	     LET g_success = 'N'
         RETURN 
      END IF 
      SELECT oma23,oam01,oma54t-oma55 INTO l_oma23,l_oma01,l_amt
        FROM oma_file
       WHERE oma01 = l_luk16
	     AND oma54t-oma55 > 0
      IF STATUS = 100 THEN 
         CALL s_errmsg('luk16',l_luk16,'ins nmg_file','axr115',1)
         #CALL cl_err(l_luk16,'axr115',0) #報錯：待抵單已無可沖帳金額，請檢查！
	     LET g_success = 'N'
         RETURN 
      END IF 
      #need word value
      SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = l_luk16
      SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = g_rxx.rxx02
      
      #oob_file
      LET l_oob.oob01 = g_ooa.ooa01
      LET l_oob.oob02 = l_ac
      LET l_oob.oob03 = '1'
      LET l_oob.oob04 = '3'
      LET l_oob.oob06 = l_oma.oma01
      LET l_oob.oob07 = l_oma.oma23
      LET l_oob.oob08 = l_oma.oma24
      IF cl_null(l_oob.oob08) THEN 
         LET l_oob.oob08 = '1'
      END IF 
      LET l_oob.oob09 = l_rxy.rxy05	
      IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
      CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
      LET l_oob.oob10 = l_oob.oob08*l_oob.oob09	
      IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
      CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10 
      LET l_oma.oma13 = g_occ.occ67
      SELECT ool21,ool211 INTO l_oob.oob11,l_oob.oob111
        FROM ool_file WHERE ool01 = l_oma.oma13
      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(l_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
      IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF  
      LET l_oob.oob22 = l_oob.oob09
      LET l_oob.oob13 = l_oma.oma15
      LET l_oob.oob17 = l_ooe02
      #LET l_oob.oob18 = g_oow.oow08
      LET l_oob.ooblegal = l_oma.omalegal
      LET l_oob.oob19 = 1
      INSERT INTO oob_file VALUES(l_oob.*)

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
         #CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
         LET g_success = 'N'
      END IF  
      LET l_ac = l_ac + 1 
   END FOREACH
END FUNCTION  

FUNCTION p602_luj_oob()   ###負金額納入收款折扣
   DEFINE l_oob RECORD LIKE oob_file.*
   LET l_oob.oob01 = g_ooa.ooa01
   LET l_oob.oob02 = l_ac
   LET l_oob.oob03 = '1'
   #LET l_oob.oob04 = '2'   #TQC-C40173
   LET l_oob.oob04 = '6'    #TQC-C40173
   LET l_oob.oob06 = g_luj.luj03
   LET l_oob.oob07 = g_aza.aza17
   LET l_oob.oob08 = 1
   LET l_oob.oob09 = -1 * g_luj.luj06
   LET l_oob.oob10 = -1 * g_luj.luj06
   LET l_oob.ooblegal = g_legal
   #SELECT ool12,ool121 INTO l_oob.oob11,l_oob.oob111 FROM ool_file  #TQC-C40173
   SELECT ool51,ool511 INTO l_oob.oob11,l_oob.oob111 FROM ool_file   #TQC-C40173
       WHERE ool01 = g_occ.occ67 
      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(l_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
   INSERT INTO oob_file VALUES(l_oob.*)

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
      #CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
      LET g_success = 'N'
   END IF  
   LET l_ac = l_ac + 1 
END FUNCTION 

FUNCTION p602_lub_oob()  #lub14 IS NULL 匯總金額產生一筆oob，lub14 IS NOT NULL 不匯總
   DEFINE l_oob RECORD LIKE oob_file.*
   DEFINE l_lub01 LIKE lub_file.lub01
   DEFINE l_lub14 LIKE lub_file.lub14
   #lub14 is not null 
   LET g_sql = " SELECT lub01,lub14 FROM ",cl_get_target_table(g_plant_l,'lub_file') ,
	           "  WHERE lub01 = '",g_luj.luj03,"'",
	           "    AND lub02 = '",g_luj.luj04,"'",
	           "    AND lub14 IS NOT NULL "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
   PREPARE p602_lub_pre2 FROM g_sql	 
   DECLARE p602_lub_cs2 CURSOR FOR p602_lub_pre2
   FOREACH p602_lub_cs2 INTO l_lub01,l_lub14
      LET l_oob.oob01 = g_ooa.ooa01
      LET l_oob.oob02 = l_ac
      LET l_oob.oob03 = '2'
      #IF cl_null(l_lub14) THEN  
      #   LET l_oob.oob04 = '2'
      #   SELECT ool25,ool251 INTO l_oob.oob11,l_oob.oob111 
      #    FROM ool_file WHERE ool01 = g_occ.occ67
      #ELSE 
      LET l_oob.oob04 = '1'
      SELECT ool11,ool111 INTO l_oob.oob11,l_oob.oob111 
      FROM ool_file WHERE ool01 = g_occ.occ67
      #END IF 	
      LET l_oob.oob06 = l_lub14
      LET l_oob.oob07 = g_aza.aza17
      LET l_oob.oob19 = '1'
      LET l_oob.oob08 = 1             #No.TQC-C40058   Add
     #No.TQC-C40058   ---start---   Mark
     #IF g_occ.occ42 = g_aza.aza17 THEN
     #   LET l_oob.oob08 = 1
     #ELSE
     #  #CALL s_curr3(g_occ.occ42,g_lua.lua09,g_ooz.ooz17) RETURNING l_oob.oob08   #No.MOD-C30179   Mark
     #   CALL s_curr3(g_occ.occ42,g_lui.lui03,g_ooz.ooz17) RETURNING l_oob.oob08   #No.MOD-C30179   Add
     #END IF
     ##LET l_oob.oob08 = 1
     #No.TQC-C40058   ---start---   Mark
      LET l_oob.oob09 = g_luj.luj06
      LET l_oob.oob10 = g_luj.luj06*l_oob.oob08
      LET l_oob.ooblegal =g_legal 
      CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
      CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
     #TQC-C20437--mod--str
     #SELECT ool12,ool121 INTO l_oob.oob11,l_oob.oob111 FROM ool_file
     # WHERE ool01 = g_occ.occ67 
      SELECT oma15,oma18,oma181 INTO l_oob.oob13,l_oob.oob11,l_oob.oob111 FROM oma_file 
       WHERE oma01 = l_lub14
      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(l_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
      INSERT INTO oob_file VALUES(l_oob.*)
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
      LET l_ac = l_ac + 1
   END FOREACH
END FUNCTION 

FUNCTION p602_lub_null()
   DEFINE l_oob RECORD LIKE oob_file.*
   DEFINE l_cnt LIKE type_file.num10
   DEFINE l_sum LIKE type_file.num20_6
   DEFINE l_luj03 LIKE luj_file.luj03
   DEFINE l_luj04 LIKE luj_file.luj04
   DEFINE l_luj06 LIKE luj_file.luj06
   DEFINE l_lub14 LIKE lub_file.lub14
   INITIALIZE l_oob.* TO NULL 
   LET l_sum = 0 
   LET g_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_l,'lub_file') ,
	           #"  WHERE lub01 = '",g_lui.lui04,"'",
               "  WHERE lub01 IN (SELECT luj03 FROM ",cl_get_target_table(g_plant_l,'luj_file'),
               "                   WHERE luj01 = '",g_lui.lui01,"')",
	           "    AND lub14 IS NULL "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
   PREPARE p602_lub_null_pre FROM g_sql	 
   EXECUTE p602_lub_null_pre INTO l_cnt
   IF l_cnt = 0 THEN 
      RETURN 
   ELSE
      #LET g_sql = "SELECT  sum(luj06) FROM ", cl_get_target_table(g_plant_l,'luj_file') , 
      #            " WHERE  luj03 = '",g_lui.lui04,"'",
      #            "   AND luj01 = '",g_lui.lui01,"'",
      #            "   AND luj04 IN ( SELECT lub02 FROM ",cl_get_target_table(g_plant_l,'lub_file') , 
      #            "                   WHERE lub01 = '",g_lui.lui04,"' and lub14 is null) "
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      #CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
      #PREPARE p602_lub_null_pre1 FROM g_sql	
    
      #EXECUTE p602_lub_null_pre1 INTO l_sum
      LET g_sql = " SELECT luj03,luj04,luj06 FROM ",cl_get_target_table(g_plant_l,'luj_file') , 
                  "  WHERE luj01 = '",g_lui.lui01,"'"
                 ,"    AND luj06>0"   #TQC-C40173
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
      PREPARE p602_lub_null_pre1 FROM g_sql	
      DECLARE p602_lub_null_cs CURSOR FOR p602_lub_null_pre1
      FOREACH p602_lub_null_cs INTO l_luj03,l_luj04,l_luj06
         IF cl_null(l_luj06) THEN LET l_luj06 = 0 END IF 
            LET g_sql = " SELECT lub14 FROM ",cl_get_target_table(g_plant_l,'lub_file') , 
                        "  WHERE lub01 = '",l_luj03,"'",
                        "    AND lub02 = '",l_luj04,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
            PREPARE p602_lub_null_pre2 FROM g_sql	
            EXECUTE p602_lub_null_pre2 INTO l_lub14
            
         IF cl_null(l_lub14) THEN 
            LET l_sum = l_sum+l_luj06
         END IF 
      END FOREACH 
      LET l_oob.oob01 = g_ooa.ooa01
      LET l_oob.oob02 = l_ac
      LET l_oob.oob03 = '2'
      LET l_oob.oob04 = '2'
      SELECT ool25,ool251 INTO l_oob.oob11,l_oob.oob111 
        FROM ool_file WHERE ool01 = g_occ.occ67
	  IF cl_null(l_sum) THEN LET l_sum = 0 END IF 
      LET l_oob.oob06 = ' '
      LET l_oob.oob07 = g_aza.aza17
      LET l_oob.oob08 = 1             #No.TQC-C40058   Add
     #No.TQC-C40058   ---start---   Mark
     #IF g_occ.occ42 = g_aza.aza17 THEN
     #   LET l_oob.oob08 = 1
     #ELSE
     #  #CALL s_curr3(g_occ.occ42,g_lua.lua09,g_ooz.ooz17) RETURNING l_oob.oob08   #No.MOD-C30179   Mark
     #   CALL s_curr3(g_occ.occ42,g_lui.lui03,g_ooz.ooz17) RETURNING l_oob.oob08   #No.MOD-C30179   Add
     #END IF
     #No.TQC-C40058   ---end---     Mark
      #LET l_oob.oob08 = 1
      LET l_oob.oob09 = l_sum
      LET l_oob.oob10 = l_sum*l_oob.oob08
      LET l_oob.ooblegal =g_legal 
      CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
      CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
      #SELECT ool12,ool121 INTO l_oob.oob11,l_oob.oob111 FROM ool_file#TQC-C20375 mark
      # WHERE ool01 = g_occ.occ67 #TQC-C20375 mark
      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(l_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
      INSERT INTO oob_file VALUES(l_oob.*)
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
      LET l_ac = l_ac + 1
   END IF 
END FUNCTION  
FUNCTION p602_2_rxy(p_rxy)
   DEFINE p_rxy RECORD LIKE rxy_file.*
   DEFINE l_oob RECORD LIKE oob_file.*
   INITIALIZE l_oob.* TO NULL 
   #oob_file
   LET l_oob.oob01 = g_ooa.ooa01
   LET l_oob.oob02 = l_ac
   LET l_oob.oob03 = '2'
   LET l_oob.oob04 = 'B'
   #LET l_oob.oob06 = p_rxy.rxy01#TQC-C20375 mark
   LET l_oob.oob15 = p_rxy.rxy02
   #LET l_oob.oob19 = '1'
   LET l_oob.oob07 = g_aza.aza17
   LET l_oob.oob08 = 1
   LET l_oob.oob09 = p_rxy.rxy09-p_rxy.rxy05
   LET l_oob.oob10 = p_rxy.rxy09-p_rxy.rxy05
   SELECT ool35,ool351 INTO l_oob.oob11,l_oob.oob111 FROM ool_file 
    WHERE ool01 = g_occ.occ67
   LET l_oob.ooblegal = g_legal

      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
 
      IF cl_null(l_oob.oob11) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'
      END IF
   INSERT INTO oob_file VALUES(l_oob.*)

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   LET l_ac = l_ac + 1
END FUNCTION 

FUNCTION p602_ooa() #ooa
   DEFINE l_ooa RECORD LIKE ooa_file.*
   INITIALIZE l_ooa.* TO NULL 
   LET l_ooa.ooa00 = '1'
   LET l_ooa.ooa01 = g_ooa.ooa01
  #LET l_ooa.ooa02 = g_lua.lua09    #No.MOD-C30179   Mark
   LET l_ooa.ooa02 = g_lui.lui03    #No.MOD-C30179   Add
   LET l_ooa.ooa021 = g_today
   LET l_ooa.ooa03 = g_lua.lua06
   LET l_ooa.ooa032 = g_lua.lua061
   SELECT occ67,occ42 INTO l_ooa.ooa13,l_ooa.ooa23 FROM occ_file
    WHERE occ01 = g_lua.lua06
   #TQC-C20375--add--str
   IF cl_null(l_ooa.ooa13) THEN 
      LET l_ooa.ooa13 = g_ooz.ooz08
   END IF
   #TQC-C20375--add--end
   LET l_ooa.ooa14 = g_user
   LET l_ooa.ooa15 = g_grup
   LET l_ooa.ooa20 = 'Y'
   IF l_ooa.ooa23 = g_aza.aza17 THEN 
      LET l_ooa.ooa24 = 1
   ELSE  
     #CALL s_curr3(l_ooa.ooa23,g_lua.lua09,g_ooz.ooz17) RETURNING l_ooa.ooa24   #No.MOD-C30179   Mark
      CALL s_curr3(l_ooa.ooa23,g_lui.lui03,g_ooz.ooz17) RETURNING l_ooa.ooa24   #No.MOD-C30179   Add
   END IF 
   LET l_ooa.ooa31d = 0
   LET l_ooa.ooa31c = 0
   LET l_ooa.ooa32d = 0 
   LET l_ooa.ooa32c = 0
   SELECT SUM (oob09),sum(oob10) 
     INTO l_ooa.ooa31d,l_ooa.ooa32d
     FROM oob_file
    WHERE oob01 =l_ooa.ooa01
      AND oob03 = '1' AND oob02 >0
   SELECT SUM (oob09),sum(oob10) 
     INTO l_ooa.ooa31c,l_ooa.ooa32c
     FROM oob_file
    WHERE oob01 =l_ooa.ooa01
      AND oob03 = '2' AND oob02 >0
    LET l_ooa.ooaconf = 'N' 
   LET l_ooa.ooa33d = 0
   LET l_ooa.ooa34   = '0' 
   LET l_ooa.ooaprsw = 0
   LET l_ooa.ooamksg ='N'
   LET l_ooa.ooauser = g_user
   LET l_ooa.ooagrup = g_grup
   #LET l_ooa.ooadate = g_today 
   LET l_ooa.ooa37 = '1'   
   LET l_ooa.ooaoriu = g_user      
   LET l_ooa.ooaorig = g_grup     
   LET l_ooa.ooalegal = g_legal 
   LET l_ooa.ooa40 = ' '
   LET l_ooa.ooa35='1'          #TQC-C20430
   LET l_ooa.ooa36=g_lui.lui01  #TQC-C20430
   LET l_ooa.ooa38 = '1'#FUN-C30029
   INSERT INTO ooa_file values(l_ooa.*)

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('ooa01',l_ooa.ooa01,'ins ooa_file',SQLCA.sqlcode,1)
      #CALL cl_err3("ins","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
   ELSE
      LET g_ooa.* = l_ooa.*
   END IF
   
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'lui_file'),
               " SET lui14 ='", l_ooa.ooa01,"' WHERE lui01 = '",g_lui.lui01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_up_lui FROM g_sql
   EXECUTE p602_up_lui
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('lui14',l_ooa.ooa01,"upd lui",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
    END IF
END FUNCTION

FUNCTION p602_axrt400_conf() #axrt400 審核
   DEFINE l_oob RECORD LIKE oob_file.*
   DEFINE l_oma00 LIKE oma_file.oma00
   DEFINE l_apa00 LIKE apa_file.apa00
   DEFINE l_cnt LIKE type_file.num5
   IF g_ooa.ooaconf = 'X' THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','9024',1)
      LET g_success = 'N'
   END IF 
   IF g_ooa.ooaconf = 'X' THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-101',1)
      LET g_success = 'N'
   END IF 
   IF cl_null(g_ooa.ooa33d) THEN 
      LET g_ooa.ooa33d = 0 
   END IF 
   IF g_ooa.ooa32d != g_ooa.ooa32c - g_ooa.ooa33d THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-203',1)
      LET g_success = 'N'
   END IF 
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz0 = '0'
   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1)
      LET g_success = 'N'
   END IF 
   IF g_ooa.ooaconf = 'Y' THEN 
      LET g_success = 'Y'
   END IF 
   SELECT count(*) INTO l_cnt FROM oob_file
    WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','mfg-009',1)
      LET g_success = 'N'
   END IF 

   LET l_cnt = 0 
   IF g_ooz.ooz62 = 'Y' THEN 
      SELECT count(*) INTO l_cnt FROM  oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' '  OR oob15 IS NULL OR oob15 <= 0)
      IF cl_null(l_cnt) THEN 
         LET l_cnt = 0 
      END IF 
      IF l_cnt >0 THEN 
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-900',1)
         LET g_success = 'N'
      END IF 
   END IF
   LET l_cnt = 0 
   SELECT count(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE oma02 > g_ooa.ooa02
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01

   IF l_cnt > 0 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-371',1)
      LET g_success = 'N'
   END IF
   LET g_sql = "SELECT oob03,oob04,oob06 FROM oob_file ",
               " WHERE oob01 = '",g_ooa.ooa01,"'",
               "   AND ((oob03 = '1' AND (oob04 = '3' OR oob04 = '9'))",
               "    OR  (oob03 = '2' AND (oob04 = '1' OR oob04 = '9')))"
   PREPARE p602_oob06_pre FROM g_sql
   DECLARE p602_oob06_cs CURSOR FOR p602_oob06_pre

   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00= '0'
   FOREACH p602_oob06_cs INTO l_oob.*
      IF STATUS THEN 
         CALL s_errmsg('','','','Foreach',1)
         LET g_success = 'N'
      END IF 
      IF l_oob.oob03 = '1' THEN 
         IF l_oob.oob04 = '3' THEN 
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 != '21') AND (l_oma00 != '22') AND (l_oma00 != '23') AND
               (l_oma00 != '24') AND (l_oma00 != '25') AND (l_oma00 != '26') AND    
               (l_oma00 != '27') AND (l_oma00 != '28') THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-992',1) 
               LET g_success = 'N'
            END IF 
         END IF 
         IF l_oob.oob04 = '9' THEN 
            IF g_ooa.ooa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL cl_err('','axr-084',1)
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
               CALL cl_err('','axr-084',1)
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
END FUNCTION 

FUNCTION p602_gen_oma() #oma,omc  #g_luj07
   DEFINE l_oma RECORD LIKE oma_file.*
   DEFINE l_omc RECORD LIKE omc_file.*
   DEFINE l_occ RECORD LIKE occ_file.*
   DEFINE l_ool RECORD LIKE ool_file.*
   DEFINE l_lub RECORD LIKE lub_file.*


   
  #CALL s_auto_assign_no("axr",g_oow.oow19,g_lua.lua09,"26","oma_file","oma01","","","")   #No.MOD-C30179   Mark
  #No.MOD-C30607   ---start---   Add
   IF cl_null(g_oow.oow19) THEN
      CALL s_errmsg('oow19','','','axr-149',1)
      LET g_success = 'N'
   END IF
  #No.MOD-C30607   ---end---     Add
   CALL s_auto_assign_no("axr",g_oow.oow19,g_lui.lui03,"26","oma_file","oma01","","","")   #No.MOD-C30179   Add
      RETURNING li_result,l_oma.oma01
   IF (NOT li_result) THEN 
      LET g_success = 'N'
      RETURN 
   END IF 

   CALL cl_msg(l_oma.oma01)
   LET l_oma.oma00 = '26'
  #LET l_oma.oma02 = g_lua.lua09   #No.MOD-C30179   Mark
   LET l_oma.oma02 = g_lui.lui03   #No.MOD-C30179   Add
   LET l_oma.oma03 = g_lua.lua06
   LET l_oma.oma032 = g_lua.lua061
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = l_oma.oma03
   LET l_oma.oma68 = l_occ.occ07
   IF l_oma.oma03 = 'MISC' THEN 
      LET l_oma.oma69 = l_oma.oma032
   ELSE 
      SELECT occ02 INTO l_oma.oma69 FROM occ_file WHERE occ01 = l_oma.oma68
   END IF 
   LET l_oma.oma14 = g_user
   SELECT gem01 INTO l_oma.oma15 FROM gen_file,gem_file 
    WHERE gen01 = l_oma.oma14 
      AND gen03 = gem01
   LET l_oma.oma04 = l_oma.oma03
   LET l_oma.oma05 = l_occ.occ08
   LET l_oma.oma18 = NULL 
   LET l_oma.oma13 = g_occ.occ67
   SELECT ool21 INTO l_oma.oma18 FROM ool_file
    WHERE ool01 = l_oma.oma13
   IF g_aza.aza63 = 'Y' THEN 
      SELECT ool211 INTO l_oma.oma181 FROM ool_file
       WHERE ool01 = l_oma.oma13
   END IF 
   LET l_oma.oma08  = '1'
   LET l_oma.oma09 = l_oma.oma02
   IF cl_null(l_oma.oma211) THEN LET l_oma.oma211=0 END IF
   LET l_oma.oma24=1   #No.TQC-C40058   Add
   LET l_oma.oma58=1   #No.TQC-C40058   Add
  #No.TQC-C40058   ---start---   Mark
  #IF l_oma.oma23=g_aza.aza17 THEN
  #   LET l_oma.oma24=1
  #   LET l_oma.oma58=1
  #ELSE
  #   CALL s_curr3(l_oma.oma23,l_oma.oma02,g_ooz.ooz17) RETURNING l_oma.oma24
  #   CALL s_curr3(l_oma.oma23,l_oma.oma09,g_ooz.ooz17) RETURNING l_oma.oma58
  #END IF
  #No.TQC-C40058   ---end---     Mark
   LET l_oma.oma21=NULL
   LET l_oma.oma211=0
   LET l_oma.oma213='N'
   LET l_oma.oma23 = g_aza.aza17                                         #No.TQC-C40058   Add
  #LET l_oma.oma23 = l_occ.occ42                                         #No.TQC-C40058   Mark
  #IF cl_null(l_oma.oma23) THEN LET l_oma.oma23 = g_aza.aza17 END IF     #No.TQC-C40058   Mark
   LET l_oma.oma40 = l_occ.occ37
   LET l_oma.oma25 = l_occ.occ43
   LET l_oma.oma32 = l_occ.occ45 
   LET l_oma.oma042= l_occ.occ11
   LET l_oma.oma043= l_occ.occ18 
   LET l_oma.oma044= l_occ.occ231
   LET l_oma.oma70 = '1'
   LET l_oma.oma50 = 0 
   LET l_oma.oma50t = 0
   LET l_oma.oma52 = 0
   LET l_oma.oma53 = 0
   CALL cl_digcut(l_oma.oma50,t_azi04) RETURNING l_oma.oma50
   CALL cl_digcut(l_oma.oma50t,t_azi04) RETURNING l_oma.oma50t
   CALL cl_digcut(l_oma.oma52,t_azi04) RETURNING l_oma.oma52
   CALL cl_digcut(l_oma.oma53,g_azi04) RETURNING l_oma.oma53
   LET l_oma.oma51f = 0 
   LET l_oma.oma51 = 0 
   LET l_oma.oma54x=0     
   LET l_oma.oma56x=0
   LET g_sql =" SELECT sum(lub04),sum(lub04t) FROM ",cl_get_target_table(g_plant_l,'lub_file'),
              "  WHERE lub01 IN (SELECT luj03 FROM ",cl_get_target_table(g_plant_l,'luj_file'),"  WHERE luj07 = '",g_luj07,"') ",
              "    AND lub02 IN (SELECT luj04 FROM ",cl_get_target_table(g_plant_l,'luj_file'),"  WHERE luj07 = '",g_luj07,"') "
	          #"    AND lub14 IS NOT NULL"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql   
   PREPARE p602_lub_pre3 FROM g_sql	 
   EXECUTE p602_lub_pre3 INTO l_lub.lub04,l_lub.lub04t
  #TQC-C20430--mark--str--
  #LET l_oma.oma54=l_lub.lub04 
  #LET l_oma.oma56 = l_oma.oma54 * l_oma.oma24
  #TQC-C20430--mark--end
   LET l_oma.oma54t= l_lub.lub04t
   LET l_oma.oma56t= l_oma.oma54t * l_oma.oma24
  #TQC-C20430--add--str--
   LET l_oma.oma54=l_oma.oma54t
   LET l_oma.oma56=l_oma.oma56t
  #TQC-C20430--add--end
   LET l_oma.oma55=0
   LET l_oma.oma57=0
   LET l_oma.oma60=l_oma.oma24
   LET l_oma.oma61=l_oma.oma56t-l_oma.oma57
   LET l_oma.omaconf='Y' 
   LET l_oma.omavoid='N'
   LET l_oma.omauser=g_user
   LET l_oma.omadate=g_today
   LET l_oma.omamksg='N'
   LET l_oma.oma64 = '1' 
   LET l_oma.oma65 = '1'
   LET l_oma.oma66= l_oma.oma66
   LET l_oma.oma67 = NULL
  #LET l_oma.oma16 = g_lua.lua01   #No.FUN-C30029   Mark
   LET l_oma.oma16 = g_lui.lui01   #No.FUN-C30029   Add
   IF g_aaz.aaz90 = 'Y' THEN 
      IF cl_null(l_oma.oma15) THEN 
         LET l_oma.oma15 = g_grup
      END IF 
      LET l_oma.oma66 = s_costcenter(l_oma.oma15)
   END IF
   LET l_oma.omaoriu = g_user      
   LET l_oma.omaorig = g_grup      
   LET l_oma.omalegal = g_legal   
   IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
   IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
   IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
   CALL cl_digcut(l_oma.oma56,g_azi04) RETURNING l_oma.oma56
   CALL cl_digcut(l_oma.oma61,g_azi04) RETURNING l_oma.oma61
   CALL cl_digcut(l_oma.oma54x,t_azi04) RETURNING l_oma.oma54x
   CALL cl_digcut(l_oma.oma54,t_azi04) RETURNING l_oma.oma54
   CALL cl_digcut(l_oma.oma56,g_azi04) RETURNING l_oma.oma56
   CALL cl_digcut(l_oma.oma54t,t_azi04) RETURNING l_oma.oma54t
   CALL cl_digcut(l_oma.oma56t,g_azi04) RETURNING l_oma.oma56t
   CALL cl_digcut(l_oma.oma56x,g_azi04) RETURNING l_oma.oma56x
   SELECT * INTO l_ool.* FROM ool_file
    WHERE ool01 = l_oma.oma13
   LET l_oma.oma18 = l_ool.ool11
   LET l_oma.oma181 = l_ool.ool111
   CALL s_rdatem(l_oma.oma03,l_oma.oma32,l_oma.oma02,l_oma.oma09,l_oma.oma02,g_plant_l) 
        RETURNING l_oma.oma11,l_oma.oma12
   INSERT INTO oma_file VALUES(l_oma.*)

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF  
   LET l_omc.omc01 = l_oma.oma01
   SELECT MAX(omc02) INTO l_omc.omc02 FROM omc_file 
    WHERE omc01 = l_oma.oma01
   IF cl_null(l_omc.omc02) THEN 
      LET l_omc.omc02 = 1
   ELSE
      LET l_omc.omc02 = l_omc.omc02 +1
   END IF 

   LET l_omc.omc03 = l_oma.oma32
   LET l_omc.omc04 = l_oma.oma11
   LET l_omc.omc05 = l_oma.oma12
   LET l_omc.omc06 = l_oma.oma24
   LET l_omc.omc07 = l_oma.oma60
   LET l_omc.omc08 = l_oma.oma54t
   LET l_omc.omc09 = l_oma.oma56t
   LET l_omc.omc10 = 0
   LET l_omc.omc11 = 0
   LET l_omc.omc12 = l_oma.oma10
   LET l_omc.omc13 = l_omc.omc09 - l_omc.omc11
   LET l_omc.omc14 = 0
   LET l_omc.omc15 = 0
   LET l_omc.omclegal = g_legal   
   INSERT INTO omc_file VALUES(l_omc.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
      CALL s_errmsg('omc01,omc02',g_showmsg,"ins omc",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
    END IF
   UPDATE oma_file SET oma19=l_oma.oma01 WHERE oma01=l_oma.oma01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oma01',l_oma.oma01,'upd oma19',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF   
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luk_file'),
               " SET luk16 ='", l_oma.oma01,"' WHERE luk01 = '",g_luj07,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p602_up_luk FROM g_sql
   EXECUTE p602_up_luk
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('luk06',l_oma.oma01,"upd luk",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
    END IF
END FUNCTION 

FUNCTION p602_axrt400_upd()
   DEFINE l_cnt LIKE type_file.num5
   LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p602_cl CURSOR FROM g_forupd_sql
   LET g_sql = " SELECT * FROM ooa_file ",
               "  WHERE ooa01 = '",g_ooa.ooa01,"'",
               "    AND ooaconf = 'N' "
   PREPARE p602_400_pre FROM g_sql
   DECLARE p602_400_cs CURSOR WITH HOLD FOR p602_400_pre
   OPEN p602_cl USING g_ooa.ooa01
   FETCH p602_cl INTO g_ooa.*
   
   FOREACH p602_400_cs INTO g_ooa.*
      CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
      LET g_ooa.ooa34 = '1'
      UPDATE ooa_file SET ooa34 = g_ooa.ooa34 WHERE ooa01 = g_ooa.ooa01
      IF STATUS THEN 
         LET g_success = 'N'
         LET g_totsuccess='N'
      END IF 

      CALL p602_y1()

      IF g_success = 'N' THEN 
         LET g_totsuccess='N'
         LET g_success = 'Y'
      END IF 

      CALL p602_ins_oma()

      IF g_ooy.ooydmy1 = 'Y' THEN 
         SELECT count(*) INTO l_cnt FROM npq_file
          WHERE npq01 = g_ooa.ooa01
            AND npq00 = 3
            AND npqsys = 'AR'
            AND npq011 = 1
         IF l_cnt = 0 THEN
         
            CALL p602_gen_glcr(g_ooa.*,g_ooy.*)

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
      
      #CALL p602_carry_voucher()#產生的是400的資料，不是401的資料，故mark

      CALL cl_flow_notify(g_ooa.ooa01,'Y')
   ELSE 
      LET g_ooa.ooaconf = 'N'
      LET g_success = 'N'
      LET g_totsuccess = 'N'
   END IF 

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01

  #No.TQC-C30188   ---start---   Mark
  #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
  #   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
  #   CALL cl_cmdrun_wait(g_str)
  #END IF
  #No.TQC-C30188   ---start---   Mark
END FUNCTION 

FUNCTION p602_y1()
   DEFINE n       LIKE type_file.num5      
   DEFINE l_cnt   LIKE type_file.num5     
   DEFINE l_flag  LIKE type_file.chr1      
   

   UPDATE ooa_file SET ooaconf = 'Y',ooa34 = '1' WHERE ooa01 = g_ooa.ooa01  
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooa_file',SQLCA.sqlcode,1)
      #CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooaconf",1)  
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL p602_hu2()
 
   IF g_success = 'N' THEN
      RETURN
   END IF      
 
   DECLARE p602_y1_c CURSOR FOR SELECT * FROM oob_file
                                 WHERE oob01 = g_ooa.ooa01
                                 ORDER BY oob02
 
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH p602_y1_c INTO b_oob.*         
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
         CALL p602_bu_11('+')
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '2' THEN
         CALL p602_bu_12('+')
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL p602_bu_13('+')
      END IF
 
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN
         CALL p602_bu_21('+')
      END IF
 
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
         CALL p602_bu_22('+',l_cnt)
      END IF
 
      LET l_cnt = l_cnt + 1
 
   END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF
END FUNCTION 

FUNCTION p602_ins_oma()
DEFINE  i     LIKE  type_file.num5
DEFINE  l_oma RECORD LIKE oma_file.*
DEFINE  l_occ RECORD LIKE occ_file.*
DEFINE  l_oof RECORD LIKE oof_file.*
DEFINE  li_result    LIKE type_file.num5

   IF g_success ='N' THEN RETURN END IF  
   DECLARE p602_sel_oof CURSOR  FOR 
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01
   
   
   FOREACH p602_sel_oof INTO l_oof.*
      IF STATUS THEN CALL cl_err('sel oof',STATUS,1) EXIT FOREACH END IF   
         LET l_oma.oma00  = '14'
         CALL s_auto_assign_no("axr",l_oof.oof05,l_oof.oof06,"14","oma_file","oma01","","","")
              RETURNING li_result,l_oof.oof05
         IF  li_result THEN
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

        LET l_oma.oma70 = '1' #FUN-C30029 add
        INSERT INTO oma_file VALUES(l_oma.*)  
        IF SQLCA.sqlcode THEN    
           CALL s_errmsg('oma01',l_oma.oma01,'ins oma_file',SQLCA.sqlcode,1)        
           #CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","",1) 
           LET g_success = 'N'
           EXIT FOREACH 
        ELSE
           LET g_success ='Y'
        END IF
   END FOREACH 
END FUNCTION

FUNCTION p602_gen_glcr(p_ooa,p_ooy)
    DEFINE p_ooa     RECORD LIKE ooa_file.*
    DEFINE p_ooy     RECORD LIKE ooy_file.*
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_ooa.ooa01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_t400_gl(p_ooa.ooa01,'0')     
    IF g_aza.aza63='Y' THEN         
       CALL s_t400_gl(p_ooa.ooa01,'1')  
    END IF                          
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p602_carry_voucher()
   DEFINE l_ooygslp    LIKE ooy_file.ooygslp
   DEFINE li_result    LIKE type_file.num5     
   DEFINE l_dbs        STRING 
   DEFINE l_sql        STRING                                                                                                        
   DEFINE l_n          LIKE type_file.num5       
   DEFINE l_buser      LIKE type_file.chr10   
   DEFINE l_euser      LIKE type_file.chr10
   DEFINE l_ooy        RECORD LIKE ooy_file.*   
   DEFINE l_oma        RECORD LIKE oma_file.*
 
   IF g_prog <> 'axrt401' THEN RETURN END IF 
   DECLARE  t401_sel_oma CURSOR FOR SELECT oma_file.* FROM oma_file,oob_file WHERE oma01 = oob27 AND oob01 = g_ooa.ooa01 AND oob03 ='1'
   FOREACH t401_sel_oma INTO l_oma.* 
      CALL s_get_doc_no(l_oma.oma01) RETURNING g_t1
      SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      IF NOT(l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y') THEN RETURN END IF
      IF l_ooy.ooyglcr = 'Y' THEN
         LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_ooz.ooz02p,'aba_file'),        
             "  WHERE aba00 = '",g_ooz.ooz02b,"'",                                                                               
             "    AND aba01 = '",l_oma.oma33,"'"                                                                                 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
         CALL cl_parse_qry_sql(l_sql,g_ooz.ooz02p) RETURNING l_sql 
         PREPARE aba_pre21 FROM l_sql                                                                                                     
         DECLARE aba_cs21 CURSOR FOR aba_pre21                                                                                             
         OPEN aba_cs21                                                                                                                    
         FETCH aba_cs21 INTO l_n                                                                                                          
         IF l_n > 0 THEN                                                                                                                 
            CALL cl_err(l_oma.oma33,'aap-991',1) 
            LET g_success ='N'                                                                                        
            RETURN                                                                                                                       
         END IF   
      
         LET l_ooygslp = l_ooy.ooygslp
      ELSE                                                                                             
         RETURN       
      END IF
      IF cl_null(l_ooygslp) THEN
         CALL cl_err(l_oma.oma01,'axr-070',1)
         LET g_success ='N'
         RETURN
      END IF
      IF NOT cl_null(l_oma.oma99) THEN  
         LET l_buser = '0' 
         LET l_euser = 'z'  
      ELSE                 
         LET l_buser = l_oma.omauser  
         LET l_euser = l_oma.omauser  
      END IF                
      LET g_wc_gl = 'npp01 = "',l_oma.oma01,'" AND npp011 = 1'
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",l_buser,"' '",l_euser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",l_oma.oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",l_ooy.ooygslp1,"'"   #No.MOD-840608 add  #No.MOD-860075  #MOD-910250  #No.MOD-920343
      CALL cl_cmdrun_wait(g_str)
   END FOREACH 
END FUNCTION 

FUNCTION p602_hu2()            #最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
      CALL s_errmsg('occ01',g_ooa.ooa03,'sel occ_file',SQLCA.sqlcode,1)
      #CALL cl_err3("sel","occ_file",g_ooa.ooa03,"",STATUS,"","s ccc",1)  
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
     #CALL cl_err3("upd","occ_file",g_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1)  
     LET g_success='N' 
     RETURN
   END IF
END FUNCTION

FUNCTION p602_bu_11(p_sw)                   #更新應收票據檔 (nmh_file)
  DEFINE p_sw       LIKE type_file.chr1,                  # +:更新
       l_nmh17      LIKE  nmh_file.nmh17,
       l_nmh38      LIKE  nmh_file.nmh38
  DEFINE l_nmz59        LIKE nmz_file.nmz59
  DEFINE l_amt1,l_amt2 LIKE nmg_file.nmg25   
 
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

FUNCTION p602_bu_12(p_sw)             #更新TT檔 (nmg_file)
  DEFINE p_sw           LIKE type_file.chr1                    # +:更新 
  DEFINE l_nmg23        LIKE nmg_file.nmg23
  DEFINE l_nmg24        LIKE nmg_file.nmg24,
         l_nmg25        LIKE nmg_file.nmg25,      
         l_nmgconf      LIKE nmg_file.nmgconf,
         l_cnt          LIKE type_file.num5      
  DEFINE tot1,tot3,tot2 LIKE type_file.num20_6   
  DEFINE l_nmz20        LIKE nmz_file.nmz20
  DEFINE l_str          STRING                      
 
  LET l_str = "bu_12:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
  CALL cl_msg(l_str) 
 
##確認時,判斷此參考單號之單據是否已確認
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
          WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
            AND oob03='1'         AND oob04 = '2'
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

FUNCTION p602_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
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
     PREPARE sel_oga27 FROM g_sql
     EXECUTE sel_oga27 INTO l_oma.oma67
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
       #CALL cl_err3("upd","oob_file",b_oob.oob01,b_oob.oob02,SQLCA.sqlcode,"","upd oob06",1)  
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

FUNCTION p602_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1             # +:更新 
  DEFINE l_omaconf      LIKE oma_file.omaconf,              
         l_omavoid      LIKE oma_file.omavoid,  
         l_cnt          LIKE type_file.num5      
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE l_omc   RECORD LIKE omc_file.*          
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
    CALL p602_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4        
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t      
  # 期末調匯(A008)
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN  
       CALL s_errmsg('oma01',b_oob.oob06,'un_pay<pay','axr-196',1) LET g_success='N' RETURN   
       END IF
    END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
                                                        
       IF tot3 <0 THEN                                                          
          CALL cl_err('','axr-185',1)                                           
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
       CALL p602_omc(l_oma00,p_sw)  
    END IF
  # 若有指定沖帳項次, 則對項次再次檢查及更新已沖金額
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
        #CALL cl_err('upd omb34,35','axr-198',3) LET g_success = 'N' RETURN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                          
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1) LET g_success = 'N' RETURN     
     END IF
  END IF
END FUNCTION
 
FUNCTION p602_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
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
 
# 同參考單號若有一筆以上僅沖款一次即可 --------------
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
  PREPARE p602_bu_13_p1 FROM g_sql
  DECLARE p602_bu_13_c1 CURSOR FOR p602_bu_13_p1
  OPEN p602_bu_13_c1 USING b_oob.oob06
  FETCH p602_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57          
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN  
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN   
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p602_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
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
    LET g_sql="UPDATE oma_file ", 
                " SET oma55=?,oma57=?,oma61=? ",
              " WHERE oma01=? "

    PREPARE p602_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2       
    EXECUTE p602_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06  
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)              
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN   
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p602_omc(l_oma00,p_sw)   
    END IF
END FUNCTION


FUNCTION p602_omc(p_oma00,p_sw)   
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
    CALL p602_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t                 
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4                    
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t                  
    LET l_oob09 = l_oob09 +tot4                                                 
    LET l_oob10 = l_oob10 +tot4t                                                

     LET g_sql=" UPDATE omc_file ",  
                  " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "
 
     PREPARE p602_bu_13_p3 FROM g_sql
     EXECUTE p602_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
     LET g_sql=" UPDATE omc_file ",  
                 " SET omc13=omc09-omc11+ ",l_oox10, 
               " WHERE omc01=? AND omc02=? "
     PREPARE p602_bu_13_p4 FROM g_sql
     EXECUTE p602_bu_13_p4 USING b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
END FUNCTION

FUNCTION p602_mntn_offset_inv(p_oob06)
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
#FUN-C20007--add new

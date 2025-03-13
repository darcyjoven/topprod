# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai104
# Descriptions...: 折舊分錄底稿維護作業(FA) 
# Date & Author..: 96/07/10 By Lynn
# Modify.........: 97/02/01 By Star  改為獨立程式並簡化畫面 
# Date & Author..: 97/09/10 By Ann Lee
# Modify.........: 將capi150改成固定資產用的折舊分錄底稿維護作業.
# Modify.........: No:7294 03/09/03 By Wiky 提供detail的修改 B.開放後,單身F2刪除有問題 
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490264 04/10/20 By Nicola [拋轉傳票][拋轉傳票還原]拿掉
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.MOD-570136 05/07/14 By Smapmin 已拋轉傳票不可刪除
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.MOD-5C0103 05/12/20 By Smapmin 分錄底稿格式修改
# Modify.........: No.FUN-620022 06/03/08 By Sarah 移除單身,改成單檔形式,add action"分錄底稿"CALL s_fsgl.4gl維護
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660165 06/08/14 By Sarah 改變畫面顯示方式,直接CALL分錄底稿s_fsgl的畫面跟4gl來維護程式
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i104_q()一開始應清空g_npp.*值
# Modify.........: No.FUN-6A0059 06/10/30 By xumin g_no_ask轉mi_no_ask
# Modify.........: No.FUN-6A0069 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-7B0056 07/11/12 By Rayven  刪除報錯：-400
# Modify.........: No.FUN-780068 07/11/15 By Sarah 當不使用多帳別功能時，隱藏npptype
# Modify.........: No.FUN-8C0050 09/04/27 By ve007 將s_fsgl的_bp函數移入程序內部
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A50187 10/05/28 By Elva 加入传参，供aglq200串查
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:FUN-C50113 12/05/25 By minpp 增加三個功能按鈕，自動攤提折舊，拋轉總帳，拋轉還原 
# Modify.........: No:FUN-D40108 13/05/06 By lujh 增加按鈕 計提折舊，計提折舊還原，自動攤提折舊按鈕名稱改為生成分分錄
#                                                按健順序自上而下應為：計提折舊，計提折舊還原，生成分錄，拋轉憑證，拋轉憑證還原。

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_fsgl.global"      #No.FUN-8C0050
 
DEFINE
    g_argv1         LIKE npp_file.nppsys,               #系統別     #No.FUN-680070 VARCHAR(02)
    g_argv2         LIKE npq_file.npq00,              #類別       #No.FUN-680070 SMALLINT
    g_argv3         LIKE npp_file.npp01,              #單號       #No.FUN-680070 VARCHAR(20)
    g_argv4         LIKE npq_file.npq07,   #本幣金額
    g_argv5         LIKE aaa_file.aaa01,   #帳別
    g_argv6         LIKE npq_file.npq011,              #異動序號       #No.FUN-680070 SMALLINT
    g_argv7         LIKE type_file.chr1,                #確認碼       #No.FUN-680070 VARCHAR(01)
    g_argv8         LIKE npp_file.npptype, #No.FUN-680028
    g_argv9         LIKE azp_file.azp01,    #No.FUN-680028
    g_npp           RECORD LIKE npp_file.*   #FUN-C50113
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			   # Supress DEL key function
 
    LET g_argv1 = ARG_VAL(1)    # FA
    LET g_argv2 = ARG_VAL(2)    # 類別
    LET g_argv3 = ARG_VAL(3)    # 單號
    LET g_argv4 = ARG_VAL(4)    # 本幣金額
    LET g_argv6 = ARG_VAL(6)    # 異動序號
    LET g_argv7 = ARG_VAL(7)    # 確認碼
    LET g_argv8 = ARG_VAL(8)    #No.FUN-680028 
    LET g_argv9 = ARG_VAL(9)    #No.FUN-680028

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AFA")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
 
    LET g_argv5 = g_faa.faa02b  # 帳別   #MOD-5C0103
 
    OPEN WINDOW s_fsgl_w WITH FORM "sub/42f/s_fsgl"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
  # IF g_aza.aza63 != 'Y' THEN  
  # IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 #No:FUN-BA0112 mark
    IF g_faa.faa31 != 'Y' THEN  #No:FUN-BA0112 add 
       CALL cl_set_comp_visible("npptype",FALSE)  
    END IF
    CALL s_fsgl_show_filed()  #FUN-5C0015 051216 BY GILL
 
   #當不使用多帳別功能時，隱藏npptype
 #  IF g_aza.aza63 = 'N' THEN
    IF g_faa.faa31 = 'N' THEN   #NO.FUN-AB0088
       CALL cl_set_comp_visible("npptype",FALSE)
    END IF
   #end FUN-780068 add
 
    #MOD-A50187 --begin
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
       CALL s_fsgl(g_argv1,g_argv2,g_argv3,0,g_faa.faa02b,1,'Y','0',g_faa.faa02p)
    ELSE
       CALL i104_menu()
    END IF
    #CALL i104_menu()
    #MOD-A50187 --end
 
    CLOSE WINDOW s_fsgl_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")     #NO.FUN-8C0050
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_q('FA')
               CALL s_fsgl_nppoutput() RETURNING g_npp.*
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
#              IF   g_argv3 IS NULL THEN    #No.TQC-7B0056 mark
#                   CALL cl_err('',-400,0)  #No.TQC-7B0056 mark
#              ELSE                         #No.TQC-7B0056 mark
                    CALL s_fsgl_r()
#              END IF                       #No.TQC-7B0056 mark
            END IF
            
         #No.FUN-6A0001-----end----
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            #FUN-D40108--add--str--
        WHEN "depreciation"
           IF cl_chk_act_auth() THEN
              CALL i104_depreciation()
           ELSE
              LET g_action_choice = NULL   
           END IF
        WHEN "undo_depreciation"
           IF cl_chk_act_auth() THEN
              CALL i104_undo_depreciation()
           ELSE
              LET g_action_choice = NULL   
           END IF
        WHEN "auto_amor_dep1"
           IF cl_chk_act_auth() THEN
              CALL i104_auto_amor_dep()
           ELSE
              LET g_action_choice = NULL
           END IF
        #FUN-D40108--add--end--
        #FUN-C50113--add--str
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               CALL i104_carry_voucher()
            ELSE
               LET g_action_choice = NULL   
            END IF

         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               CALL i104_undo_carry_voucher()
            ELSE
               LET g_action_choice = NULL               
            END IF
          WHEN "auto_amor_dep"
            IF cl_chk_act_auth() THEN
               CALL i104_auto_amor_dep()
            ELSE
               LET g_action_choice = NULL
            END IF
        #FUN-C50113--add--end 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_out('afai104')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_exporttoexcel()
            END IF
         #No.FUN-6A0001-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_argv3  IS NOT NULL THEN
                 LET g_doc.column1 = "npp01"
                 LET g_doc.value1 = g_argv3
                 CALL cl_doc()
               END IF
           END IF
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         #FUN-D40108--add--str--
      ON ACTION depreciation #計提折舊
         LET g_action_choice="depreciation"
         EXIT DISPLAY
      ON ACTION undo_depreciation #計提折舊
         LET g_action_choice="undo_depreciation"
         EXIT DISPLAY
      ON ACTION auto_amor_dep1 #生成分錄
         LET g_action_choice="auto_amor_dep1"
         EXIT DISPLAY
      #FUN-D40108--add--end--
      #FUN-C50113--add--str
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY

      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY

       ON ACTION auto_amor_dep #自動攤提折舊
         LET g_action_choice="auto_amor_dep"
         EXIT DISPLAY

      #FUN-C50113--add--end 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-8C0050 --end--
#↑end FUN-660165 mark

#FUN-C50113---add-----str
FUNCTION i104_carry_voucher()
   DEFINE l_wc_gl           STRING
   DEFINE l_str             STRING
   DEFINE l_azn02           LIKE azn_file.azn02
   DEFINE l_azn04           LIKE azn_file.azn04
   DEFINE l_plant_gl        LIKE azp_file.azp01
   DEFINE l_sql             STRING

    IF s_shut(0) THEN
       RETURN
    END IF

    CALL s_fsgl_nppoutput() RETURNING g_npp.*  
   
    IF cl_null(g_npp.nppsys) OR cl_null(g_npp.npp01) OR cl_null(g_npp.npptype) OR cl_null(g_npp.npp011)  THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
   
    SELECT nppglno INTO g_npp.nppglno FROM npp_file WHERE npp01=g_npp.npp01
                                                      AND npp00=g_npp.npp00
                                                      AND npptype=g_npp.npptype
                                                      AND npp011=g_npp.npp011
                                                      AND nppsys=g_npp.nppsys
    IF NOT cl_null(g_npp.nppglno) THEN
       CALL cl_err('','aap-122',1)
       RETURN
    END IF
   
    LET l_wc_gl = 'afai104'
    LET l_str="afap302 '",l_wc_gl CLIPPED,"' '' '' '",g_faa.faa02p,"' '",g_faa.faa02b,"' 
               '' '' '' '' 'N' '' '' '",g_npp.npp01,"' '",g_npp.npp011,"' '",g_npp.npp02,"'"
    CALL cl_cmdrun_wait(l_str)

    LET l_azn02=null
    LET l_azn04=null
    LET l_plant_gl=g_faa.faa02p
    IF g_aza.aza63 = 'Y' THEN
       LET l_sql = "SELECT aznn02,aznn04 FROM ",cl_get_target_table(l_plant_gl,'aznn_file'), 
                          " WHERE aznn01 = '",g_npp.npp02,"'",
                          "   AND aznn00 = '",g_npp.npp07,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant_gl) RETURNING l_sql 
      PREPARE azn_p1 FROM l_sql
      DECLARE azn_c1 CURSOR FOR azn_p1
      OPEN azn_c1
      FETCH azn_c1 INTO l_azn02,l_azn04
   ELSE
      SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file   
      WHERE azn01 = g_npp.npp02     #(傳票日)          
   END IF 
   DISPLAY l_azn02 TO azn02
   DISPLAY l_azn04 TO azn04
   
    LET g_npp.nppglno=null
    LET g_npp.npp03 = null
    SELECT nppglno,npp03  
      INTO g_npp.nppglno,g_npp.npp03
      FROM npp_file
     WHERE npp01 = g_npp.npp01 AND npp00=10 AND npp011=g_npp.npp011 AND nppsys='FA'
     DISPLAY  g_npp.nppglno TO nppglno
     DISPLAY  g_npp.npp03   TO npp03
END FUNCTION

FUNCTION i104_undo_carry_voucher()
   DEFINE li_str       STRING
   DEFINE l_azn02      LIKE azn_file.azn02
   DEFINE l_azn04      LIKE azn_file.azn04
   DEFINE l_plant_gl   LIKE azp_file.azp01
   DEFINE l_sql        STRING

   IF s_shut(0) THEN
       RETURN
    END IF

   CALL s_fsgl_nppoutput() RETURNING g_npp.*  
   SELECT nppglno INTO g_npp.nppglno FROM npp_file WHERE npp01=g_npp.npp01
                                                      AND npp00=g_npp.npp00
                                                      AND npptype=g_npp.npptype
                                                      AND npp011=g_npp.npp011
                                                      AND nppsys=g_npp.nppsys
   IF cl_null(g_npp.nppglno) OR g_npp.nppglno IS NULL THEN
      CALL cl_err('','aap-619',1)
      RETURN
   END IF	

    LET li_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_npp.nppglno,"' '10' 'N'"
    CALL cl_cmdrun_wait(li_str)
  
    LET g_npp.nppglno=null
    LET g_npp.npp03 = null
    SELECT nppglno,npp03
      INTO g_npp.nppglno,g_npp.npp03
      FROM npp_file
     WHERE npp01 = g_npp.npp01 AND npp00=10 AND npp011=g_npp.npp011 AND nppsys='FA'
     DISPLAY  g_npp.nppglno  TO nppglno
     DISPLAY  g_npp.npp03    TO npp03
  
    LET l_azn02=null
    LET l_azn04=null
    LET l_plant_gl=g_faa.faa02p
    IF g_aza.aza63 = 'Y' THEN
       LET l_sql = "SELECT aznn02,aznn04 FROM ",cl_get_target_table(l_plant_gl,'aznn_file'), 
                          " WHERE aznn01 = '",g_npp.npp02,"'",
                          "       AND aznn00 = '",g_npp.npp07,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_gl) RETURNING l_sql
      PREPARE azn_p2 FROM l_sql
      DECLARE azn_c2 CURSOR FOR azn_p2
      OPEN azn_c2
      FETCH azn_c1 INTO l_azn02,l_azn04
   ELSE
      SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
      WHERE azn01 = g_npp.npp02     #(傳票日)
   END IF
   DISPLAY l_azn02 TO azn02
   DISPLAY l_azn04 TO azn04


END FUNCTION

FUNCTION i104_auto_amor_dep()
   DEFINE l_str  STRING
   DEFINE l_wc   STRING
   IF s_shut(0) THEN
       RETURN
    END IF
   
   LET l_str="afap120 '' '' '' '' 'N'"  
   CALL cl_cmdrun_wait(l_str) 
END FUNCTION
#FUN-C50113--add------end
#FUN-D40108--add--str--
FUNCTION i104_depreciation()
   DEFINE l_str  STRING
   DEFINE l_wc   STRING
   IF s_shut(0) THEN
       RETURN
    END IF
   
   LET l_str="afap300 '' '' '' 'N'"  
   CALL cl_cmdrun_wait(l_str) 
END FUNCTION

FUNCTION i104_undo_depreciation()
   DEFINE l_str  STRING
   DEFINE l_wc   STRING
   IF s_shut(0) THEN
       RETURN
    END IF
   
   LET l_str="afap301 '' '' '' 'N'"  
   CALL cl_cmdrun_wait(l_str) 
END FUNCTION
#FUN-D40108--add--end--

# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_icdin_rec.4gl   
# Descriptions...: 刻號/BIN入庫明細資料維護作業
# SYNTAX.........: s_icdin_rec(p_idd12,p_idd01,p_idd02,
#                              p_idd03,p_idd04,p_idd10,
#                              p_idd11,p_idd08,p_idd07,p_tot)
# Input parameter:
##               : p_idd12 1:入 0：其他 
##               : p_idd01 料件編號
##               : p_idd02 倉庫
##               ：p_idd03 庫位
##               ：p_idd04 批號
##               ：p_idd10 單據編號
##               ：p_idd11 單據項次
##               ：p_idd08 單據日期
##               : p_idd07 單位
##               ：p_tot   入庫數量(單據img10)
# Return parameter: g_idd18 單身的DIE數總數
# Return code....: 
# Date & Author..: FUN-7B0077 07/12/26 By mike
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-B30192 11/05/09 By shenyang       改icb05為imaicd14

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_idd_lock RECORD LIKE idd_file.*   # FOR LOCK CURSOR TOUCH 
DEFINE g_idd_h RECORD 
                    idd01 LIKE idd_file.idd01,
                    idd02 LIKE idd_file.idd02,
                    idd03 LIKE idd_file.idd03,
                    idd04 LIKE idd_file.idd04,
                    idd10 LIKE idd_file.idd10,
                    idd11 LIKE idd_file.idd11,
                    idd07 LIKE idd_file.idd07,
                    tot        LIKE idd_file.idd13,
                    tot_b      LIKE idd_file.idd13,
                    odds       LIKE idd_file.idd13,
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021,
                    idd08 LIKE idd_file.idd08,
                    idd16 LIKE idd_file.idd16,
                    idd12 LIKE idd_file.idd12,
                   #icb05 LIKE icb_file.icb05   #FUN-B30192
                    imaicd14 LIKE imaicd_file.imaicd14  #FUN-B30192
                   END RECORD
DEFINE b_idd   RECORD LIKE idd_file.* 
DEFINE g_idd   DYNAMIC ARRAY of RECORD    #程式變數
                    idd05 LIKE idd_file.idd05,
                    idd06 LIKE idd_file.idd06,
                    idd22 LIKE idd_file.idd22,
                    idd13 LIKE idd_file.idd13,
                    idd26 LIKE idd_file.idd26,
                    idd27 LIKE idd_file.idd27,
                    idd15 LIKE idd_file.idd15,
                    idd16 LIKE idd_file.idd16,
                    idd18 LIKE idd_file.idd18,
                    idd17 LIKE idd_file.idd17,
                    idd19 LIKE idd_file.idd19,
                    idd20 LIKE idd_file.idd20,
                    idd21 LIKE idd_file.idd21,
                    idd23 LIKE idd_file.idd23,
                    idd24 LIKE idd_file.idd24, #入庫否
                    idd28 LIKE idd_file.idd28,
                    idd25 LIKE idd_file.idd25
                   END RECORD,
       g_idd_t RECORD                        #程式變數備份值
                    idd05 LIKE idd_file.idd05,
                    idd06 LIKE idd_file.idd06,
                    idd22 LIKE idd_file.idd22,
                    idd13 LIKE idd_file.idd13,
                    idd26 LIKE idd_file.idd26,
                    idd27 LIKE idd_file.idd27,
                    idd15 LIKE idd_file.idd15,
                    idd16 LIKE idd_file.idd16,
                    idd18 LIKE idd_file.idd18,
                    idd17 LIKE idd_file.idd17,
                    idd19 LIKE idd_file.idd19,
                    idd20 LIKE idd_file.idd20,
                    idd21 LIKE idd_file.idd21,
                    idd23 LIKE idd_file.idd23,
                    idd24 LIKE idd_file.idd24, #入庫否
                    idd28 LIKE idd_file.idd28,
                    idd25 LIKE idd_file.idd25
                   END RECORD,
       g_idd_o RECORD                        #程式變數舊值
                    idd05 LIKE idd_file.idd05,
                    idd06 LIKE idd_file.idd06,
                    idd22 LIKE idd_file.idd22,
                    idd13 LIKE idd_file.idd13,
                    idd26 LIKE idd_file.idd26,
                    idd27 LIKE idd_file.idd27,
                    idd15 LIKE idd_file.idd15,
                    idd16 LIKE idd_file.idd16,
                    idd18 LIKE idd_file.idd18,
                    idd17 LIKE idd_file.idd17,
                    idd19 LIKE idd_file.idd19,
                    idd20 LIKE idd_file.idd20,
                    idd21 LIKE idd_file.idd21,
                    idd23 LIKE idd_file.idd23,
                    idd24 LIKE idd_file.idd24, #入庫否
                    idd28 LIKE idd_file.idd28,
                    idd25 LIKE idd_file.idd25
                   END RECORD
DEFINE   g_imaicd04      LIKE imaicd_file.imaicd04
#DEFINE   g_icb05         LIKE icb_file.icb05     #FUN-B30192
DEFINE   g_imaicd14      LIKE imaicd_file.imaicd14 #FUN-B30192
DEFINE   g_imaicd01      LIKE imaicd_file.imaicd01
DEFINE   g_pmniicd15     LIKE pmni_file.pmniicd15,
         g_rec_b         LIKE type_file.num5, #單身筆數
         l_ac            LIKE type_file.num5  #目前處理的ARRAY CNT
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_flag          LIKE type_file.chr1  
DEFINE   g_msg           LIKE ze_file.ze03
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
 
 
FUNCTION s_icdin_rec(p_idd12,p_idd01,p_idd02,p_idd03,
                     p_idd04,p_idd10,p_idd11,p_idd08,
                     p_idd07,p_tot)
   DEFINE p_row,p_col LIKE type_file.num5
   DEFINE p_idd12 LIKE idd_file.idd12, #1:入 0：其他
          p_idd01 LIKE idd_file.idd01, #料件編號
          p_idd02 LIKE idd_file.idd02, #倉庫
          p_idd03 LIKE idd_file.idd03, #庫位
          p_idd04 LIKE idd_file.idd04, #批號
          p_idd07 LIKE idd_file.idd07, #單位     
          p_tot   LIKE idd_file.idd13, #數量
          p_idd10 LIKE idd_file.idd10, #單據編號
          p_idd11 LIKE idd_file.idd11, #單據項次
          p_idd08 LIKE idd_file.idd08  #單據日期      
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #先清空會混淆的模組變數
   LET g_flag = 1
   LET g_imaicd04 = NULL   
 # LET g_icb05 = NULL   #GROSS DIE  #FUN-B30192
   LET g_imaicd14 = NULL     #FUN-B30192
   LET g_imaicd01 = NULL   #母體料號
   LET g_pmniicd15 = NULL  #接單料號
   
   IF cl_null(p_idd03) THEN LET p_idd03 = ' ' END IF
   IF cl_null(p_idd04) THEN LET p_idd04 = ' ' END IF
 
  #本作業只供收貨單用
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rvb_file
      WHERE rvb01 = p_idd10
        AND rvb02 = p_idd11
   IF g_cnt = 0 THEN
      RETURN 1
   END IF
 
  #1. CHK傳染參數，除了母批(idd16),儲位,批號外,其他若為NULL則return
       IF cl_null(p_idd01) THEN
          CALL cl_err('p_idd01','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd02) THEN
          CALL cl_err('p_idd02','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd07) THEN 
          CALL cl_err('p_idd07','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_tot) THEN
          CALL cl_err('p_tot','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd10) THEN
          CALL cl_err('p_idd10','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd11) THEN
          CALL cl_err('p_idd11','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd08) THEN
          CALL cl_err('p_idd08','aic-026',1)
          RETURN 0
       END IF
       IF cl_null(p_idd12) THEN
          CALL cl_err('p_idd12','aic-026',1)
          RETURN 0
       END IF
   
   #2. CHK傳入參數合理性 
       #數量>=0
       IF p_tot < 0 THEN
          CALL cl_err('p_tot','afa-043',1)
          RETURN 0
       END IF
   
       #檢查同單號項次的料，倉，儲，批相同否(只要有一筆不同即return)
       LET g_cnt = 0 
       SELECT COUNT(*) INTO g_cnt FROM idd_file
        WHERE idd10 = p_idd10
          AND idd11 = p_idd11
          AND (idd01 <> p_idd01 OR
               idd02 <> p_idd02 OR
               idd03 <> p_idd03 OR
               idd04 <> p_idd04)
 
       IF g_cnt > 0 THEN
          LET g_msg = '[',p_idd01 CLIPPED,']',
                      '[',p_idd02 CLIPPED,']',
                      '[',p_idd03 CLIPPED,']',
                      '[',p_idd04 CLIPPED,']'
          CALL cl_err(g_msg,'sub-177',1)
          RETURN 0
       END IF
       #異動別 =0/1
       IF p_idd12 NOT MATCHES '[01]' THEN
          LET g_msg = 'p_idd12 NOT MATCHES [01]'
          CALL cl_err(g_msg,'!',1)
          RETURN 0
       END IF
      
   #3. CHK傳入料號的imaicd08='Y'時，才可往下執行，反之RETURN 
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt FROM ima_file,imaicd_file 
        WHERE ima01 = p_idd01 AND imaicd08 = 'Y' AND ima01=imaicd00
       IF g_cnt = 0 THEN 
          CALL cl_err(p_idd01,'aic-027',1)
          RETURN 0
       END IF
 
   #4. LOCK單頭
       LET g_forupd_sql = "SELECT * from idd_file ",
                          " WHERE idd01 = ? ",
                          "   AND idd02 = ? ",
                          "   AND idd03 = ? ",
                          "   AND idd04 = ? ",
                          "   AND idd10 = ? ",
                          "   AND idd11 = ? ",
                          " FOR UPDATE  "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE s_icdin_rec_lock_u CURSOR FROM g_forupd_sql
 
   #5. DEFAULT單頭資料(包含備份傳入參數資料)
       INITIALIZE g_idd_h.* TO NULL 
       LET g_idd_h.idd10 = p_idd10 
       LET g_idd_h.idd01 = p_idd01 
       LET g_idd_h.idd02 = p_idd02 
       LET g_idd_h.idd07 = p_idd07 
       LET g_idd_h.idd11 = p_idd11 
       LET g_idd_h.idd03 = p_idd03 
       LET g_idd_h.idd04 = p_idd04 
       LET g_idd_h.tot_b      = 0
       LET g_idd_h.odds       = 0
       LET g_idd_h.tot        = p_tot
       IF cl_null(g_idd_h.idd03) THEN 
          LET g_idd_h.idd03 = ' '
       END IF
       IF cl_null(g_idd_h.idd04) THEN 
          LET g_idd_h.idd04 = ' '
       END IF
       SELECT ima02,ima021,imaicd01,imaicd04
         INTO g_idd_h.ima02,g_idd_h.ima021,
              g_imaicd01,g_imaicd04
         FROM ima_file,imaicd_file
        WHERE ima01 = p_idd01 AND ima01=imaicd00
       IF SQLCA.SQLCODE THEN
          CALL cl_err('sel ima',SQLCA.SQLCODE,1)
          RETURN 0
       END IF
 
       IF cl_null(g_imaicd04) THEN
          CALL cl_err(p_idd01,'sub-178',1)
          RETURN 0
       END IF
   
       #取得GROSS DIE的預設值 
      #LET g_icb05 = NULL
      #SELECT icb05 INTO g_icb05 FROM icb_file
      # WHERE icd01 = p_idd01
       LET g_imaicd14 = NULL     #FUN-B30192
       CALL s_icdfun_imaicd14(p_idd01)   RETURNING g_imaicd14 #FUN-B30192 

       LET g_idd_h.idd08 = p_idd08 
       LET g_idd_h.idd12 = p_idd12
     # LET g_idd_h.icb05  = g_icb05 
       LET g_idd_h.imaicd14 = g_imaicd14      #FUN-B30192
 
       #接單料號(idd23)
       #若是收獲單呼叫此程式透過收獲單及項次串到采購單及項次
       #再抓到采購單單身的最終料號(pmniicd15)除此之外存""
       SELECT DISTINCT(pmniicd15) INTO g_pmniicd15
          FROM pmn_file,rvb_file
         WHERE rvb04 = pmn01           #采購單號    
           AND rvb03 = pmn02           #采購項次
           AND rvb01 = p_idd10         #收貨單號
           AND rvb02 = p_idd11         #收貨項次
       IF SQLCA.SQLCODE THEN
          LET g_pmniicd15 = ''
       END IF
 
   #6. 開窗
       OPEN WINDOW s_icdin_rec_w AT 10,20 WITH FORM "sub/42f/s_icdin_rec"
            ATTRIBUTE(STYLE=g_win_style CLIPPED)
       CALL cl_ui_locale("s_icdin_rec")
 
 
   #7.處理單頭單位換算，數量資料
       CALL s_icdin_rec_process_h()
       IF NOT g_flag THEN RETURN 0 END IF
 
   #8. 取單身/insert單身 
       CALL s_icdin_rec_process_b()
       IF NOT g_flag THEN RETURN 0 END IF
 
   #9. show單頭資料/進menu
       DISPLAY BY NAME g_idd_h.idd01,g_idd_h.idd02,
                       g_idd_h.idd03,g_idd_h.idd04,
                       g_idd_h.idd10,g_idd_h.idd11,
                       g_idd_h.idd07,g_idd_h.tot,
                       g_idd_h.tot_b,g_idd_h.odds,
                       g_idd_h.ima02,g_idd_h.ima021,
                     # g_idd_h.icb05
                       g_idd_h.imaicd14   #FUN-B30192 
       DISPLAY 1 TO FORMONLY.cnt
       DISPLAY g_rec_b TO FORMONLY.cn2
       CALL s_icdin_rec_menu()
 
 
   #10.結束畫面/回復INT_FLAG/回傳結果
       CLOSE WINDOW s_icdin_rec_w  
       LET INT_FLAG = 0
       RETURN 1
END FUNCTION
 
# MENU段
FUNCTION s_icdin_rec_menu()
    WHILE TRUE
      CALL s_icdin_rec_bp("G")
      CASE g_action_choice
           WHEN "detail"
                 CALL s_icdin_rec_b()
           WHEN "help"
                 CALL cl_show_help()
           WHEN "exit"
                 EXIT WHILE
           WHEN "controlg"
                 CALL cl_cmdask()
           WHEN "exporttoexcel"
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                         base.TypeInfo.create(g_idd),'','')
      END CASE
    END WHILE
END FUNCTION
 
# bp段
FUNCTION s_icdin_rec_bp(p_ud)
    DEFINE p_ud  LIKE type_file.chr1
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN RETURN END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel",FALSE)
    CALL SET_COUNT(g_rec_b)
 
    DISPLAY ARRAY g_idd TO s_idd.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting(1,1)
       BEFORE ROW 
          LET l_ac = ARR_CURR()
       ON ACTION detail
          LET g_action_choice = "detail"
          LET l_ac = 1
          EXIT DISPLAY
       ON ACTION help
          LET g_action_choice = "help"
          EXIT DISPLAY
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice = "controlg"
          EXIT DISPLAY
       ON ACTION accept
          LET g_action_choice = "detail"
          LET l_ac = ARR_CURR()
          EXIT DISPLAY
       ON ACTION cancel
          LET INT_FLAG = FALSE
          LET g_action_choice = "exit"
          EXIT DISPLAY
       ON ACTION exporttoexcel
          LET g_action_choice = 'exporttoexcel'
          EXIT DISPLAY
       ON ACTION about
          CALL cl_about()
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
# 處理單身單位換算，數量資料
FUNCTION s_icdin_rec_process_h()
   DEFINE l_idd07      LIKE idd_file.idd07,
          l_factor     LIKE img_file.img21
   
   #1. 清空資料
       CALL g_idd.clear()
       INITIALIZE g_idd_o.* TO NULL 
       INITIALIZE g_idd_t.* TO NULL 
 
   #2. 取得img單位，轉換后數量 
       LET l_factor = 1
       SELECT img09 INTO l_idd07 FROM img_file
        WHERE img01 = g_idd_h.idd01
          AND img02 = g_idd_h.idd02
          AND img03 = g_idd_h.idd03
          AND img04 = g_idd_h.idd04
 
       IF SQLCA.sqlcode = 10 THEN  #無img_file
          LET g_msg = '[',g_idd_h.idd01 CLIPPED,']',
                      '[',g_idd_h.idd02 CLIPPED,']',
                      '[',g_idd_h.idd03 CLIPPED,']',
                      '[',g_idd_h.idd04 CLIPPED,']'
          CALL cl_err(g_msg,'mfg6069',1)
          LET g_flag = 0
          RETURN
       END IF
 
       IF NOT cl_null(l_idd07) THEN
          IF l_idd07 <> g_idd_h.idd07 THEN
             CALL s_umfchk(g_idd_h.idd01,g_idd_h.idd07,
                           l_idd07) RETURNING g_cnt,l_factor
             IF g_cnt = 1 THEN
                LET g_msg = g_idd_h.idd07 CLIPPED,'->',
                            l_idd07
                CALL cl_err(g_msg,'aqc-500',1)
                LET g_flag = 0
                RETURN
             END IF
             #單位轉換       
             LET g_idd_h.idd07 = l_idd07
             LET g_idd_h.tot        = g_idd_h.tot * l_factor
          END IF
       END IF
END FUNCTION
 
#取單身/insert單身    
FUNCTION s_icdin_rec_process_b()
   #撈單身
   DECLARE s_idd_b_cs CURSOR FOR
    SELECT idd05,idd06,idd22,idd13,idd26,idd27,
           idd15,idd16,idd18,idd17,idd19,idd20,
           idd21,idd23,idd24,idd28,idd25
      FROM idd_file
     WHERE idd01 = g_idd_h.idd01
        AND idd02 = g_idd_h.idd02
        AND idd03 = g_idd_h.idd03
        AND idd04 = g_idd_h.idd04
        AND idd10 = g_idd_h.idd10
        AND idd11 = g_idd_h.idd11
      ORDER BY idd05,idd06
 
   LET g_cnt = 1
   CALL g_idd.clear()
   FOREACH s_idd_b_cs INTO g_idd[g_cnt].*
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_idd.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
#單身處理
FUNCTION s_icdin_rec_b()                        # 單身
   DEFINE l_ac_t          LIKE type_file.num5,  #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,
          l_lock_sw       LIKE type_file.chr1,  # 單身鎖住否
          p_cmd           LIKE type_file.chr1,  # 處理狀態
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_idd13_tot     LIKE idd_file.idd13
   DEFINE i               LIKE type_file.num5 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_idd_h.idd01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   #檢查轉入否(idd28)是否有等于'Y', 若有=Y的資料，則return
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idd_file
    WHERE idd01 = g_idd_h.idd01 
      AND idd02 = g_idd_h.idd02 
      AND idd03 = g_idd_h.idd03 
      AND idd04 = g_idd_h.idd04 
      AND idd10 = g_idd_h.idd10 
      AND idd11 = g_idd_h.idd11 
      AND idd28 = 'Y'
 
   IF g_cnt > 0 THEN 
      CALL cl_err('','sub-171',1)
      RETURN 
   END IF
   CALL cl_opmsg('b')
 
   #若imaicd04=1(未測wafer)->不可自行新增
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   IF g_imaicd04 = 1 THEN
      LET l_allow_insert = FALSE
   END IF
 
   LET g_forupd_sql= "SELECT * FROM idd_file ",
                     " WHERE idd01 = ? AND idd02 = ? ",
                     "   AND idd03 = ? AND idd04 = ? ",
                     "   AND idd05 = ? AND idd06 = ? ",
                     "   AND idd10 = ? AND idd11 = ? ",
                     "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_icdin_rec_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   WHILE TRUE
   
      INPUT ARRAY g_idd WITHOUT DEFAULTS FROM s_idd.*
                 ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=FALSE,DELETE ROW=FALSE,
                           APPEND ROW=FALSE)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
   
         BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
   
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               OPEN s_icdin_rec_lock_u USING g_idd_h.idd01,
                                          g_idd_h.idd02,
                                          g_idd_h.idd03,
                                          g_idd_h.idd04,
                                          g_idd_h.idd10,
                                          g_idd_h.idd11
               IF STATUS THEN
                  CALL cl_err("OPEN s_icdin_rec_lock_u",STATUS,1)
                  CLOSE s_icdin_rec_lock_u
                  ROLLBACK WORK 
                  RETURN
               END IF
        
               FETCH s_icdin_rec_lock_u INTO g_idd_lock.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_idd_h.idd01,SQLCA.sqlcode,0)
                  CLOSE s_icdin_rec_lock_u
                  ROLLBACK WORK 
                  RETURN
               END IF
   
               LET p_cmd='u'
               LET g_idd_t.* = g_idd[l_ac].*    #BACKUP
               LET g_idd_o.* = g_idd[l_ac].*    #BACKUP
               OPEN s_icdin_rec_bcl USING g_idd_h.idd01,
                                       g_idd_h.idd02,
                                       g_idd_h.idd03,
                                       g_idd_h.idd04,
                                       g_idd_t.idd05,
                                       g_idd_t.idd06,
                                       g_idd_h.idd10,
                                       g_idd_h.idd11
               IF SQLCA.sqlcode THEN
                  CALL cl_err("OPEN s_icdin_rec_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH s_icdin_rec_bcl INTO b_idd.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FETCH s_icdin_rec_bcl:',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL s_icdin_rec_move_to()
                     LET g_idd_t.* = g_idd[l_ac].*    #BACKUP
                     LET g_idd_o.* = g_idd[l_ac].*    #BACKUP
                  END IF
               END IF
               CALL cl_show_fld_cont() 
            ELSE 
              #防止刪到0筆后，再度進入單身(當新增權限被取消時會發生)
              IF l_allow_insert = FALSE THEN
                 RETURN
              END IF
            END IF
   
         BEFORE INSERT
            #防止刪到0筆后，再度進入單身(當新增權限被取消時會發生)
            IF l_allow_insert = FALSE THEN
               RETURN
            END IF
   
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           
            CALL s_icdin_rec_move_back()
            #加入判斷母批若沒有輸入
            IF g_idd[l_ac].idd16 IS NULL THEN
               CALL cl_err(g_idd[l_ac].idd05,'sub-173',0)
               #不能用next field
               CALL g_idd.deleteElement(l_ac)
               CANCEL INSERT
            END IF
 
            INSERT INTO idd_file VALUES (b_idd.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('insert idd_file',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
              #同單據項次，相同刻號的入庫否狀態要相同
               IF NOT cl_null(g_idd[l_ac].idd24) THEN
                  UPDATE idd_file
                     SET idd24 = g_idd[l_ac].idd24
                   WHERE idd05 = g_idd_t.idd05  #刻號  
                     AND idd10 = g_idd_h.idd10  #單據刻號
                     AND idd11 = g_idd_h.idd11  #項次
               END IF
             
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
   
         AFTER FIELD idd05
            IF NOT cl_null(g_idd[l_ac].idd05) THEN
               IF NOT cl_null(g_idd[l_ac].idd06) THEN
                  IF cl_null(g_idd_t.idd05) OR
                     (g_idd_t.idd05 <> g_idd[l_ac].idd05) THEN
                     #1.檢查重復性
                     LET g_cnt = 0 
                     SELECT COUNT(*) INTO g_cnt FROM idd_file
                      WHERE idd01 = g_idd_h.idd01 
                        AND idd02 = g_idd_h.idd02 
                        AND idd03 = g_idd_h.idd03 
                        AND idd04 = g_idd_h.idd04 
                        AND idd05 = g_idd[l_ac].idd05 
                        AND idd06 = g_idd[l_ac].idd06 
                        AND idd10 = g_idd_h.idd10 
                        AND idd11 = g_idd_h.idd11 
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_idd[l_ac].idd05,'-239',0)
                        LET g_idd[l_ac].idd05 = g_idd_t.idd05
                        NEXT FIELD idd05
                     END IF
                  END IF
               END IF
               #料件狀態(imaicd04)=(0,1,2)已測wafer,同一刻號加總須小于等于1
               IF g_imaicd04 MATCHES '[012]' THEN
                  LET l_idd13_tot = 0
                  SELECT SUM(idd13) INTO l_idd13_tot FROM idd_file
                   WHERE idd01 = g_idd_h.idd01
                     AND idd02 = g_idd_h.idd02
                     AND idd03 = g_idd_h.idd03
                     AND idd04 = g_idd_h.idd04
                     AND idd05 = g_idd[l_ac].idd05
                     AND idd10 = g_idd_h.idd10
                     AND idd11 = g_idd_h.idd11
                  IF cl_null(l_idd13_tot) THEN 
                     LET l_idd13_tot = 0 
                  END IF
                  IF p_cmd = 'a'  THEN
                     LET l_idd13_tot = l_idd13_tot + 
                                            g_idd[l_ac].idd13
                  END IF
                  IF p_cmd = 'u' THEN
                     #刻號沒換，要扣舊+新
                     IF g_idd[l_ac].idd05 = g_idd_t.idd05 THEN
                        LET l_idd13_tot = l_idd13_tot - 
                                               g_idd_t.idd13 +
                                               g_idd[l_ac].idd13
                     END IF
                     #刻號有換，要+新
                     IF g_idd[l_ac].idd05<>g_idd_t.idd05 THEN
                        LET l_idd13_tot = l_idd13_tot + 
                                               g_idd[l_ac].idd13
                     END IF
                  END IF
                  IF l_idd13_tot > 1 THEN
                     CALL cl_err(l_idd13_tot,'sub-176',0)
                     NEXT FIELD idd05
                  END IF
               END IF
            END IF
   
         AFTER FIELD idd06
            IF NOT cl_null(g_idd[l_ac].idd06) THEN
               IF NOT cl_null(g_idd[l_ac].idd05) THEN
                  IF cl_null(g_idd_t.idd06) OR
                     (g_idd_t.idd06 <> g_idd[l_ac].idd06) THEN
                     #1.檢查重復性
                     LET g_cnt = 0 
                     SELECT COUNT(*) INTO g_cnt FROM idd_file
                      WHERE idd01 = g_idd_h.idd01 
                        AND idd02 = g_idd_h.idd02 
                        AND idd03 = g_idd_h.idd03 
                        AND idd04 = g_idd_h.idd04 
                        AND idd05 = g_idd[l_ac].idd05 
                        AND idd06 = g_idd[l_ac].idd06 
                        AND idd10 = g_idd_h.idd10 
                        AND idd11 = g_idd_h.idd11 
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_idd[l_ac].idd06,'-239',0)
                        LET g_idd[l_ac].idd06 = g_idd_t.idd06
                        NEXT FIELD idd06
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD idd13
            IF NOT cl_null(g_idd[l_ac].idd13) THEN
               IF g_idd[l_ac].idd13<0 THEN
                  CALL cl_err(g_idd[l_ac].idd13,'aim-391',0)
                  NEXT FIELD idd13
               END IF
               #料件狀態(imaicd04)=(0,1,2)已測wafer,同一刻號加總須小于等于1
               IF g_imaicd04 MATCHES '[012]' THEN
                  LET l_idd13_tot = 0
                  SELECT SUM(idd13) INTO l_idd13_tot FROM idd_file
                   WHERE idd01 = g_idd_h.idd01
                     AND idd02 = g_idd_h.idd02
                     AND idd03 = g_idd_h.idd03
                     AND idd04 = g_idd_h.idd04
                     AND idd05 = g_idd[l_ac].idd05
                     AND idd10 = g_idd_h.idd10
                     AND idd11 = g_idd_h.idd11
                  IF cl_null(l_idd13_tot) THEN
                     LET l_idd13_tot = 0
                  END IF
                  IF p_cmd = 'a'  THEN
                     LET l_idd13_tot = l_idd13_tot + 
                                            g_idd[l_ac].idd13
                  END IF
                  IF p_cmd = 'u' THEN
                     #刻號沒換，要扣舊+新
                     IF g_idd[l_ac].idd05 = g_idd_t.idd05 THEN
                        LET l_idd13_tot = l_idd13_tot - 
                                               g_idd_t.idd13 +
                                               g_idd[l_ac].idd13
                     END IF
                     #刻號有換，要+新
                     IF g_idd[l_ac].idd05<>g_idd_t.idd05 THEN
                        LET l_idd13_tot = l_idd13_tot + 
                                               g_idd[l_ac].idd13
                     END IF
                  END IF
                  IF l_idd13_tot > 1 THEN
                     CALL cl_err(l_idd13_tot,'sub-176',0)
                     NEXT FIELD idd13
                  END IF
               END IF
               #DIE數(icb17) =實收數量(idd13) * icb05
               IF cl_null(g_idd_o.idd13) OR
                  g_idd[l_ac].idd13 <> g_idd_o.idd13 THEN
            #     LET g_idd[l_ac].idd18 = g_idd[l_ac].idd13 *
            #                                      g_idd_h.icb05
                  LET g_idd[l_ac].idd18 = g_idd[l_ac].idd13 *g_idd_h.imaicd14    #FUN-B30192
               END IF
            END IF
            LET g_idd_o.idd13 = g_idd[l_ac].idd13
   
         AFTER FIELD idd26
            IF NOT cl_null(g_idd[l_ac].idd26) THEN
               IF g_idd[l_ac].idd26<0 THEN
                  CALL cl_err(g_idd[l_ac].idd26,'aim-391',0)
                  NEXT FIELD idd26
               END IF
            END IF
   
         AFTER FIELD idd27
            IF NOT cl_null(g_idd[l_ac].idd27) THEN
               IF g_idd[l_ac].idd27<0 THEN
                  CALL cl_err(g_idd[l_ac].idd27,'aim-391',0)
                  NEXT FIELD idd27
               END IF
            END IF
         
         #加入判斷母批是否有維護
         AFTER FIELD idd16
            IF cl_null(g_idd[l_ac].idd16) THEN
               CALL cl_err(g_idd[l_ac].idd05,'sub-173',0)
               NEXT FIELD idd16   
            END IF 
   
         AFTER FIELD idd22
            IF NOT cl_null(g_idd[l_ac].idd22) THEN
               IF g_idd[l_ac].idd22 NOT MATCHES '[YN]' THEN
                  NEXT FIELD idd22
               END IF
            END IF
 
         ON CHANGE idd24    #入庫否
            IF NOT cl_null(g_idd[l_ac].idd24) THEN
               IF g_idd[l_ac].idd24 = 'Y' THEN
                  FOR i = 1 TO g_rec_b
                      IF g_idd[l_ac].idd05 = g_idd[i].idd05
                         THEN
                         LET g_idd[i].idd24 = 'Y'
                         DISPLAY BY NAME g_idd[i].idd24
                      END IF
                  END FOR
               ELSE
                  FOR i = 1 TO g_rec_b
                      IF g_idd[l_ac].idd05 = g_idd[i].idd05
                         THEN
                         LET g_idd[i].idd24 = 'N'
                         DISPLAY BY NAME g_idd[i].idd24
                      END IF
                  END FOR
               END IF
            END IF
   
         BEFORE DELETE      #是否取消單身
            IF NOT cl_null(g_idd_t.idd05) AND 
               NOT cl_null(g_idd_t.idd06) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF
               DELETE FROM idd_file
                WHERE idd01 = g_idd_h.idd01 
                  AND idd02 = g_idd_h.idd02 
                  AND idd03 = g_idd_h.idd03 
                  AND idd04 = g_idd_h.idd04 
                  AND idd05 = g_idd_t.idd05 
                  AND idd06 = g_idd_t.idd06 
                  AND idd10 = g_idd_h.idd10 
                  AND idd11 = g_idd_h.idd11 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('delete idd_file',SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF 
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
   
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_idd[l_ac].* = g_idd_t.*
               CLOSE s_icdin_rec_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_idd[l_ac].idd05,-263,1)
               LET g_idd[l_ac].* = g_idd_t.*
            ELSE
               CALL s_icdin_rec_move_back()
               UPDATE idd_file SET * = b_idd.*
                WHERE idd01 = g_idd_h.idd01 
                  AND idd02 = g_idd_h.idd02 
                  AND idd03 = g_idd_h.idd03 
                  AND idd04 = g_idd_h.idd04 
                  AND idd05 = g_idd_t.idd05 
                  AND idd06 = g_idd_t.idd06 
                  AND idd10 = g_idd_h.idd10 
                  AND idd11 = g_idd_h.idd11 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('update idd_file',SQLCA.sqlcode,0)
                  LET g_idd[l_ac].* = g_idd_t.*
                  ROLLBACK WORK
               ELSE
                #同單據項次，相同刻號的入庫否狀態要相同
                  IF NOT cl_null(g_idd[l_ac].idd24) THEN
                     UPDATE idd_file 
                        SET idd24 = g_idd[l_ac].idd24
                       WHERE idd05 = g_idd_t.idd05  #刻號
                         AND idd10 = g_idd_h.idd10  #單據編號
                         AND idd11 = g_idd_h.idd11  #項次 
                  END IF  
 
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
   
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            SELECT SUM(idd13) INTO g_idd_h.tot_b FROM idd_file
             WHERE idd01 = g_idd_h.idd01
               AND idd02 = g_idd_h.idd02
               AND idd03 = g_idd_h.idd03
               AND idd04 = g_idd_h.idd04
               AND idd10 = g_idd_h.idd10
               AND idd11 = g_idd_h.idd11
            LET g_idd_h.odds = g_idd_h.tot - g_idd_h.tot_b
            DISPLAY BY NAME g_idd_h.odds,g_idd_h.tot_b
                           
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_idd[l_ac].* = g_idd_t.*
               END IF
               CLOSE s_icdin_rec_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE s_icdin_rec_bcl
            COMMIT WORK
   
         ON ACTION CONTROLG
             CALL cl_cmdask()
   
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION about
            CALL cl_about()
      END INPUT
      IF g_imaicd04 = 1 AND g_idd_h.odds < 0 THEN
         LET g_msg = cl_getmsg('ICD0029',g_lang)
         LET g_msg = g_msg CLIPPED,(-1 * g_idd_h.odds USING '<<<<<')
         LET g_msg = g_msg CLIPPED,cl_getmsg('ICD003',g_lang)
         CALL cl_err(g_msg,'!',1)
         CONTINUE WHILE
      END IF
 
      IF g_imaicd04 <> 1 AND g_idd_h.odds < 0 THEN
         CALL cl_err('','aic-028',1)
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE s_icdin_rec_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION s_icdin_rec_move_to()
    LET g_idd[l_ac].idd05 = b_idd.idd05
    LET g_idd[l_ac].idd06 = b_idd.idd06
    LET g_idd[l_ac].idd22 = b_idd.idd22
    LET g_idd[l_ac].idd13 = b_idd.idd13
    LET g_idd[l_ac].idd26 = b_idd.idd26
    LET g_idd[l_ac].idd27 = b_idd.idd27
    LET g_idd[l_ac].idd15 = b_idd.idd15
    LET g_idd[l_ac].idd16 = b_idd.idd16
    LET g_idd[l_ac].idd18 = b_idd.idd18
    LET g_idd[l_ac].idd17 = b_idd.idd17
    LET g_idd[l_ac].idd19 = b_idd.idd19
    LET g_idd[l_ac].idd20 = b_idd.idd20
    LET g_idd[l_ac].idd21 = b_idd.idd21
    LET g_idd[l_ac].idd23 = b_idd.idd23
    LET g_idd[l_ac].idd24 = b_idd.idd24
    LET g_idd[l_ac].idd28 = b_idd.idd28
    LET g_idd[l_ac].idd25 = b_idd.idd25
END FUNCTION
 
 
FUNCTION s_icdin_rec_move_back()
    LET b_idd.idd05 = g_idd[l_ac].idd05
    LET b_idd.idd06 = g_idd[l_ac].idd06
    LET b_idd.idd22 = g_idd[l_ac].idd22
    LET b_idd.idd13 = g_idd[l_ac].idd13
    LET b_idd.idd26 = g_idd[l_ac].idd26
    LET b_idd.idd27 = g_idd[l_ac].idd27
    LET b_idd.idd15 = g_idd[l_ac].idd15
    LET b_idd.idd16 = g_idd[l_ac].idd16
    LET b_idd.idd18 = g_idd[l_ac].idd18
    LET b_idd.idd17 = g_idd[l_ac].idd17
    LET b_idd.idd19 = g_idd[l_ac].idd19
    LET b_idd.idd20 = g_idd[l_ac].idd20
    LET b_idd.idd21 = g_idd[l_ac].idd21
    LET b_idd.idd23 = g_idd[l_ac].idd23
    LET b_idd.idd24 = g_idd[l_ac].idd24
    LET b_idd.idd28 = g_idd[l_ac].idd28
    LET b_idd.idd25 = g_idd[l_ac].idd25
    LET b_idd.iddplant = g_plant #FUN-980012 add
    LET b_idd.iddlegal = g_legal #FUN-980012 add
END FUNCTION
 
 
FUNCTION s_icin_rec_set_entry_b()
    IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("idd05,idd06,idd13,idd26,idd27",TRUE)
    END IF
END FUNCTION
 
FUNCTION s_icin_rec_set_no_entry_b()
    IF NOT g_before_input_done THEN
       IF g_imaicd04 = '1' THEN
          CALL cl_set_comp_entry("idd05,idd06,idd13,idd26,idd27",FALSE)
       END IF
    END IF
END FUNCTION
 
#回傳DIE數
FUNCTION s_icdin_rec_DIE() 
   DEFINE l_idd18 LIKE idd_file.idd18
   CASE 
       WHEN g_imaicd04 = '1' OR g_imaicd04 = '0'
            SELECT SUM(idd18) INTO l_idd18 FROM idd_file
             WHERE idd01 = g_idd_h.idd01
               AND idd02 = g_idd_h.idd02
               AND idd03 = g_idd_h.idd03
               AND idd04 = g_idd_h.idd04
               AND idd10 = g_idd_h.idd10
               AND idd11 = g_idd_h.idd11
               AND idd18 IS NOT NULL
       WHEN g_imaicd04 = '2'
            SELECT SUM(idd18) INTO l_idd18 FROM idd_file
             WHERE idd01 = g_idd_h.idd01
               AND idd02 = g_idd_h.idd02
               AND idd03 = g_idd_h.idd03
               AND idd04 = g_idd_h.idd04
               AND idd10 = g_idd_h.idd10
               AND idd11 = g_idd_h.idd11
               AND idd18 IS NOT NULL
               AND idd22 = 'Y'
       OTHERWISE
            LET l_idd18 = 0
   END CASE
   IF cl_null(l_idd18) THEN LET l_idd18 = 0 END IF
   RETURN l_idd18
END FUNCTION
 
#No.FUN-7B0077

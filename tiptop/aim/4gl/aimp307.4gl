# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimp307.4gl
# Descriptions...: 同業間借料重新開啟作業
# Input parameter: 
# Return code....: 
# Date & Author..: 03/05/29 By Snow 
#                  1.新增p_ze:aim-500 此張借料單未結案
#                             aim-501 此借料單其單身無任何資料
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0118 04/10/08 By Mandy 底下會show 一行按 [return]鍵執行或取消==>請拿掉該行說明
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.TQC-640172 06/04/21 By Claire logic error
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-710025 07/01/16 By bnlent  錯誤訊息匯整
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C20128 12/02/23 By Elise FUNCTION p307_up_imo07()裡的DEFINE l_n LIKE type_file.chr1改為數字型態
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm         RECORD
               imo01    LIKE imo_file.imo01,    #借料單號
               imo03    LIKE imo_file.imo03,    #廠商編號
               a        LIKE type_file.chr1,    #是否整張借料單全部設定開啟  #No.FUN-690026 VARCHAR(1)
               y        LIKE type_file.chr1     #已開啟資料是否顯示  #No.FUN-690026 VARCHAR(1)
               END RECORD,                      
    g_imp      DYNAMIC ARRAY OF RECORD
               sure     LIKE type_file.chr1,    #確定否     #No.FUN-690026 VARCHAR(1)
               imp02    LIKE imp_file.imp02,    #項次
               imp03    LIKE imp_file.imp03,    #料號
               imp07_d  LIKE ze_file.ze03,      #目前狀況   #No.FUN-690026 VARCHAR(15)
               qty      LIKE imp_file.imp04     #未償還數量 #MOD-530179
               END RECORD,
    g_cmd      LIKE type_file.chr1000,          #No.FUN-690026 VARCHAR(60)
    g_rec_b    LIKE type_file.num5,             #No.FUN-690026 SMALLINT
    l_exit_sw  LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
    l_ac,l_sl  LIKE type_file.num5              #No.FUN-690026 SMALLINT
 
DEFINE g_cnt   LIKE type_file.num10             #No.FUN-690026 INTEGER
DEFINE g_i     LIKE type_file.num5              #count/index for any purpose  #No.FUN-690026 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   CALL p307_tm(0,0)  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION p307_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE l_imo07        LIKE imo_file.imo07
   DEFINE l_flag         LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   LET p_row = 5 LET p_col = 19
 
   OPEN WINDOW p307_w AT p_row,p_col
     WITH FORM "aim/42f/aimp307"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CALL cl_ui_init()
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      CALL g_imp.clear()
      INITIALIZE tm.* TO NULL            # Default condition
      LET tm.a = 'N'
      LET tm.y = 'N'
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
      INPUT BY NAME tm.imo01,tm.a,tm.y WITHOUT DEFAULTS 
 
         AFTER FIELD imo01            #借料單號
            IF tm.imo01 IS NULL OR tm.imo01 =' ' THEN
               NEXT FIELD imo01
            ELSE 
               CALL p307_imo01()  #借料單合理性檢查
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.imo01,g_errno,0)
                  NEXT FIELD imo01
               END IF
               #Add By Snow..030529 #單身若無任何資料結案,不可執行開啟
               LET l_imo07=''   
               SELECT imo07 INTO l_imo07 FROM imo_file 
                WHERE imo01=tm.imo01   
               IF l_imo07='N' THEN
                  LET g_i=0
                  SELECT COUNT(*) INTO g_i FROM imp_file
                   WHERE imp01=tm.imo01 AND imp07='Y'  
                  IF g_i=0 THEN
                     CALL cl_err(tm.imo01,'aim-500',0) #此張借料單未結案
                     NEXT FIELD imo01
                  END IF
               END IF
               #End Add..030529
            END IF
 
         AFTER FIELD a               #整張開啟否
            IF tm.a IS NULL OR tm.a NOT MATCHES "[YNyn]"  THEN
               NEXT FIELD a 
            END IF
 
         AFTER FIELD y               #已開啟資料是否顯示
            IF tm.y IS NULL OR tm.y NOT MATCHES "[YNyn]"  THEN
               NEXT FIELD y 
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imo01) #借料單號
#                 CALL q_imo1(7,3,tm.imo01) RETURNING tm.imo01
#                 CALL FGL_DIALOG_SETBUFFER( tm.imo01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imo1"
                  LET g_qryparam.default1 = tm.imo01
                  CALL cl_create_qry() RETURNING tm.imo01
#                  CALL FGL_DIALOG_SETBUFFER( tm.imo01 )
                   DISPLAY BY NAME tm.imo01    #No.MOD-490371
                  NEXT FIELD imo01
               OTHERWISE EXIT CASE
            END CASE
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         ON ACTION exit
            LET g_action_choice='exit'
            EXIT WHILE  
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
      
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
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM 
      END IF
 
      LET g_success='Y'
      BEGIN WORK
      IF tm.a = 'Y' THEN #是否借料單全部設定為開啟
         IF cl_sure(0,0) THEN 
            CALL cl_wait()
            CALL aimp307()
         END IF
      ELSE 
         CALL aimp307()
      END IF
      CALL s_showmsg()       #No.FUN-710025
      IF g_success='Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
 
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
 
#     IF g_success = 'Y' THEN
#        CALL cl_cmmsg(1) COMMIT WORK
#     ELSE 
#        CALL cl_rbmsg(1) ROLLBACK WORK
#     END IF
      
#     IF l_exit_sw = 'n' THEN CALL cl_end(0,0) END IF
   END WHILE
   ERROR ""
   CLOSE WINDOW p307_w
END FUNCTION
 
FUNCTION p307_imo01()
   DEFINE l_n           LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE l_imoconf     LIKE imo_file.imoconf,
          l_imopost     LIKE imo_file.imopost,
          l_imo07       LIKE imo_file.imo07,
          l_imo03       LIKE imo_file.imo03,
          l_imo04       LIKE imo_file.imo04
 
   LET g_errno=' '
   LET l_imo03=NULL
   LET l_imo04=NULL
        #      確認,     過帳,  結案
   SELECT   imoconf,  imopost,  imo07,  imo03,  imo04
     INTO l_imoconf,l_imopost,l_imo07,l_imo03,l_imo04
     FROM imo_file 
    WHERE imo01 = tm.imo01  
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aim-410' #無此借料單號!
      WHEN l_imoconf='X'       LET g_errno = '9024'   #此筆資料已經作廢!
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   DISPLAY l_imo03 TO FORMONLY.imo03
   DISPLAY l_imo04 TO FORMONLY.imo04
END FUNCTION       
 
FUNCTION aimp307()
   DEFINE 
#  l_time        LIKE type_file.chr8            #No.FUN-6A0074
   l_imo01       LIKE imo_file.imo01,
   l_wc          LIKE type_file.chr1000, #RDSQL STATEMENT  #No.FUN-690026 VARCHAR(200)
   l_sql         LIKE type_file.chr1000, #RDSQL STATEMENT  #No.FUN-690026 VARCHAR(600)
   l_no,l_cnt    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   l_imp07       LIKE imp_file.imp07
 
   LET l_sql = " SELECT 'N',imp02,imp03,imp07,imp04",
               "   FROM imp_file",
               "  WHERE imp01 = '",tm.imo01,"'"
               
   IF tm.y = 'N' THEN #已開啟資料不顯示
       LET l_sql = l_sql CLIPPED,
                  "  AND imp07 != 'N' ",
                  "  ORDER BY imp02 "
   END IF
   PREPARE p307_prepare FROM l_sql
   DECLARE p307_cur CURSOR FOR p307_prepare
   LET l_ac = 1
#  LET g_arrno = 200
   LET l_exit_sw = 'n'
   CALL s_showmsg_init()     #No.FUN-710025
   FOREACH p307_cur INTO g_imp[l_ac].sure,
                         g_imp[l_ac].imp02,
                         g_imp[l_ac].imp03,
                         l_imp07,
                         g_imp[l_ac].qty
       #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710025--End-- 
      IF SQLCA.sqlcode != 0 THEN 
          #No.FUN-710025--Begin--
          #CALL cl_err('foreach p307_cur',SQLCA.sqlcode,1)
           CALL s_errmsg('','','foreach p307_cur',SQLCA.sqlcode,0)
           LET g_success ='N'     #FUN-8A0086
           EXIT FOREACH
          #No.FUN-710025--End--
      END IF
      IF l_imp07 = 'Y' THEN
          #已結案 
          CALL cl_getmsg('aec-078',g_lang) RETURNING g_imp[l_ac].imp07_d
      ELSE
          #未結案
          CALL cl_getmsg('axm-203',g_lang) RETURNING g_imp[l_ac].imp07_d
      END IF
      LET g_rec_b=l_ac
      DISPLAY g_rec_b TO FORMONLY.cn2  
      LET g_cnt = 0
      LET l_ac = l_ac + 1
      LET l_cnt = l_cnt + 1
#     IF l_ac > g_arrno THEN EXIT FOREACH END IF
   END FOREACH
      #No.FUN-710025--Begin--                                                                                                      
       IF g_totsuccess="N" THEN                                                                                                     
          LET g_success="N"                                                                                                         
       END IF                                                                                                                       
      #No.FUN-710025--End--  
   WHILE TRUE
       IF l_cnt = 0 THEN     #此借料單其單身無任何資料
       #No.FUN-710025--Begin--
       #   CALL cl_err(tm.imo01,'aim-501',1) 
           CALL s_errmsg('','','','mfg9171',0)
       #No.FUN-710025--End--
           LET l_exit_sw = 'y'
           EXIT WHILE
       END IF
#      IF l_ac > g_arrno THEN 
#          IF NOT cl_arful(0,0,g_arrno) THEN 
#              EXIT WHILE 
#          END IF
#      END IF
       CALL SET_COUNT(l_ac - 1)
       IF tm.a = 'N' THEN   #是否整張借料單全部設定開啟
           CALL  p307_sure()         #確定否
           IF l_exit_sw = 'y' THEN
               EXIT WHILE 
           END IF
           IF cl_sure(0,0) THEN 
               CALL cl_wait()
               FOR l_no = 1 TO l_cnt
                   IF g_imp[l_no].sure = 'Y' THEN
                       UPDATE imp_file 
                          SET imp07 = 'N'  #結案碼
                        WHERE imp01 = tm.imo01 
                          AND imp02 = g_imp[l_no].imp02 
                       IF SQLCA.sqlcode THEN 
                          LET g_success='N' 
#                         CALL cl_err('up-imp07',SQLCA.sqlcode,1) #No.FUN-660156
                       #No.FUN-710025--Begin--
                       #  CALL cl_err3("upd","imp_file",tm.imo01,g_imp[l_no].imp02,
                       #                SQLCA.sqlcode,"","upd imp07",1)  #No.FUN-660156
                       #   RETURN
                          LET g_showmsg = tm.imo01,"/",g_imp[l_no].imp02 
                          CALL s_errmsg('imp01,imp02',g_showmsg,'up-imp07',SQLCA.sqlcode,1)
                          CONTINUE FOR
                       #No.FUN-710025--End--
                       END IF
                   END IF
               END FOR
               CALL p307_up_imo07() #update 單頭結案碼
           END IF
       ELSE #整張借料單全部設定開啟
           UPDATE imp_file 
              SET imp07 = 'N'  #結案碼
            WHERE imp01 = tm.imo01 
           IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#              CALL cl_err('upall-imp07',SQLCA.sqlcode,1) #No.FUN-660156
           #No.FUN-710025--Begin--
           #   CALL cl_err3("upd","imp_file",tm.imo01,"",
           #                 SQLCA.sqlcode,"","upd imp07",1)  #No.FUN-660156
               CALL s_errmsg('imp01',tm.imo01,'upd imp07',SQLCA.sqlcode,1)
               RETURN
           #No.FUN-710025--End--
           END IF
           CALL p307_up_imo07() #update 單頭結案碼
       END IF
       EXIT WHILE
   END WHILE
#No.FUN-710025--Begin--                                                                                                             
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
#No.FUN-710025--End--  
END FUNCTION
   
FUNCTION p307_sure()
   DEFINE l_buf     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(80)
   #MOD-4A0118 MARK 掉
  #CALL cl_getmsg('mfg3116',g_lang) RETURNING l_buf
  #MESSAGE l_buf CLIPPED
  #CALL ui.Interface.refresh()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imp TO s_imp.* 
      ON ACTION select_cancel
         LET l_ac = ARR_CURR()
         LET l_sl = SCR_LINE()
         IF g_imp[l_ac].sure = 'N' THEN 
            LET g_imp[l_ac].sure = 'Y'
            LET g_cnt = g_cnt + 1
            #TQC-640172-mark
            ##TQC-630106-begin 
            # IF g_cnt > g_max_rec THEN   #MOD-4B0274
            #    CALL cl_err( '', 9035, 0 )
            #   #EXIT FOREACH
            # END IF
            ##TQC-630106-end 
            #TQC-640172-mark
            DISPLAY g_cnt   TO FORMONLY.cn3  
         ELSE 
            LET g_imp[l_ac].sure = 'N'    
            LET g_cnt = g_cnt - 1
            DISPLAY g_cnt   TO FORMONLY.cn3  
         END IF
         DISPLAY g_imp[l_ac].sure TO s_imp[l_sl].sure
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
      ON ACTION give_up
         LET l_exit_sw = 'y'
         EXIT DISPLAY
 
      ON ACTION execute
         EXIT DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   MESSAGE ''
   CALL ui.Interface.refresh()
   IF INT_FLAG THEN LET INT_FLAG = 0  LET l_exit_sw = 'y' END IF
END FUNCTION
 
FUNCTION p307_up_imo07() #update 單頭結案碼
 #DEFINE l_n      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1) #MOD-C20128 mark
  DEFINE l_n      LIKE type_file.num5,    #MOD-C20128
         l_imo07  LIKE imo_file.imo07
 
    SELECT COUNT(*) INTO l_n 
      FROM imp_file
     WHERE imp01 = tm.imo01
       AND imp07 = 'N'
    IF l_n > 0 THEN 
        LET l_imo07 = 'N' #未結案
    ELSE
        LET l_imo07 = 'Y' #結案
    END IF
    UPDATE imo_file
       SET imo07 = l_imo07,
           imomodu = g_user,
           imodate = g_today
     WHERE imo01 = tm.imo01
    IF SQLCA.sqlcode THEN 
        LET g_success='N' 
#       CALL cl_err('up-imo07',SQLCA.sqlcode,1) #No.FUN-660156
#No.FUN-710025--Begin--
#       CALL cl_err3("upd","imo_file",tm.imo01,"",
#                     SQLCA.sqlcode,"","upd imo07",1)  #No.FUN-660156
        CALL s_errmsg('imo01',tm.imo01,'up imo07',SQLCA.sqlcode,1)
#No.FUN-710025--End--
        RETURN
    END IF
END FUNCTION

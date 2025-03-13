# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asms270.4gl
# Descriptions...: 製造管理系統參數設定作業–現場管理
# Date & Author..: 92/10/28 By Lee
# Modify.........: 99/10/12 By Kammy(sma886 改 no use，拿掉)
# Modify.........: 99/11/05 By Kammy(sma83-> no use)
# Modify.........: 00/01/11 By Kammy(sma883->試產性工單是否展至尾階)
# Modify.........: 01/05/11 By Tommy(sma899->工單發料是否許發料誤差)
# Modify.........: 02/06/05 By Wiky(sma884 改 no use，拿掉)
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-910053 09/02/12 By jan 拿掉sma74欄位和相關處理邏輯
# Modify.........: No.FUN-940008 09/04/02 By hongmei GP5.2中增加sma129發料做套數控管
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0080 09/10/14 By Carrier sma127 default方式改變
# Modify.........: No.FUN-A30003 10/03/02 By destiny 增加损耗计算方式栏位
# Modify.........: No:TQC-A50027 10/05/14 By houlia "已打印料表之工單其備料可刪除"這個參數sma8872拿掉的相關處理 
# Modify.........: No.FUN-A60031 10/06/12 By destiny 修改sma141预设值
# Modify.........: No.FUN-A80150 10/08/31 By sabrina 增加號機管理頁面及其參數
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B60142 11/07/04 By jan 增加sam1411欄位
# Modify.........: No:MOD-D20158 13/02/26 By Alberti 修改FUNCTION s270_def()中的IF判斷2次NULL
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 儲位為空則給空格
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 倉庫出錯跳到儲位欄位
# Modify.........: No:160903     16/09/03 By guanyao 

DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma8871       LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01),
# Prog. Version..: '5.30.06-13.03.12(01),           #TQC-A50027    mark
        g_sma_t         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_cnt              LIKE type_file.num10      #No.FUN-690010 INTEGER
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms270()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms270()
    DEFINE
        p_row,p_col LIKE type_file.num5     #No.FUN-690010 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0089
 
 
   IF (NOT cl_user()) THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
 
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 4 LET p_col = 9
    ELSE LET p_row = 4 LET p_col = 2
    END IF
    OPEN WINDOW asms270_w AT p_row,p_col
        WITH FORM "asm/42f/asms270" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms270_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms270_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms270_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms270_show()
    SELECT * INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    LET g_sma8871 = g_sma.sma887[1,1]
#   LET g_sma8872 = g_sma.sma887[2,2]               #TQC-A50027   mark
    DISPLAY BY NAME g_sma.sma27,g_sma.sma71,
                    g_sma.sma78,g_sma.sma883,g_sma.sma104,g_sma.sma105,
                    g_sma.sma107,g_sma.sma129,g_sma.sma896,g_sma.sma73,   #NO:6897  #No.FUN-940008 add sma129
                   #g_sma.sma74,g_sma.sma899,#genero mark g_sma.sma70,#FUN-910053
                    g_sma.sma899,#genero mark g_sma.sma70,  #FUN-910053
                    g_sma.sma72, g_sma.sma848,g_sma.sma75,g_sma.sma76,g_sma.sma849
                    ,g_sma.sma141,g_sma.sma1411,                          #No.FUN-A30003  #FUN-B60142 
                    g_sma.sma1421,g_sma.sma1422,g_sma.sma1423,g_sma.sma1424,g_sma.sma1431,         #FUN-A80150 add
                    g_sma.sma1432,g_sma.sma1433,g_sma.sma1434,g_sma.sma1435                    #FUN-A80150 add
                    ,g_sma.smaud02   #add by guanyao160903
                    ,g_sma.smaud03   #add by guanyao160928
                    
   DISPLAY g_sma8871 TO FORMONLY.q 
#  DISPLAY g_sma8872 TO FORMONLY.s                       #TQC-A50027     mark 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms270_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START---
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL asms270_u()
          END IF
#NO.FUN-5B0134 END-----
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #EXIT MENU
    ON ACTION exit
            LET g_action_choice = "exit"
    EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION asms270_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT * FROM sma_file  ",
      " WHERE sma00 = ?         ",
      "FOR UPDATE              "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN sma_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH sma_curl INTO g_sma.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_sma_o.* = g_sma.*
    LET g_sma_t.* = g_sma.*
    CALL s270_def()
    LET g_sma8871 = g_sma.sma887[1,1]
#   LET g_sma8872 = g_sma.sma887[2,2]     #TQC-A50027   mark
#   DISPLAY BY NAME  g_sma.sma27,g_sma8872,g_sma.sma71,             #TQC-A50027   modify
    DISPLAY BY NAME  g_sma.sma27,g_sma.sma71,                       #TQC-A50027   modify
               g_sma.sma78,g_sma8871,g_sma.sma883,g_sma.sma104,g_sma.sma105,
               g_sma.sma107,g_sma.sma129,g_sma.sma896,g_sma.sma73,   #NO:6897  #No.FUN-940008 add sma129
              #g_sma.sma74,#genero mark g_sma.sma70, #FUN-910053
               g_sma.sma72, g_sma.sma848,g_sma.sma75,g_sma.sma76,g_sma.sma849
               ,g_sma.sma141,g_sma.sma1411,                          #No.FUN-A30003 #FUN-B60142
               g_sma.sma1421,g_sma.sma1422,g_sma.sma1423,g_sma.sma1424,g_sma.sma1431,         #FUN-A80150 add
               g_sma.sma1432,g_sma.sma1433,g_sma.sma1434,g_sma.sma1435                    #FUN-A80150 add
               ,g_sma.smaud02     #add by guanyao160903
               ,g_sma.smaud03   #add by guanyao160928
             
   DISPLAY g_sma8871 TO q 
#  DISPLAY g_sma8872 TO s             #TQC-A50027       mark
    WHILE TRUE
        CALL asms270_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_sma.sma887[1,1]  = g_sma8871
#       LET g_sma.sma887[2,2]  = g_sma8872                 #TQC-A50027   mark
        UPDATE sma_file SET
           sma27=g_sma.sma27,
           sma71=g_sma.sma71, sma78=g_sma.sma78,
           sma896=g_sma.sma896,sma883=g_sma.sma883,
           sma104=g_sma.sma104,sma105=g_sma.sma105,
           sma107=g_sma.sma107,  #NO:6897  
           sma129=g_sma.sma129,  #No.FUN-940008 add
           sma73=g_sma.sma73, #sma74=g_sma.sma74, #FUN-910053 mark sma74
           sma899=g_sma.sma899,
          #genero mark sma70=g_sma.sma70, 
           sma72=g_sma.sma72,
           sma75=g_sma.sma75, sma76=g_sma.sma76,
           sma887 = g_sma.sma887,
           sma848 = g_sma.sma848,
           sma849 = g_sma.sma849,
           sma141 = g_sma.sma141,                     #No.FUN-A30003        
           sma1411 = g_sma.sma1411,                   #FUN-B60142   
           sma1421 = g_sma.sma1421,sma1422 = g_sma.sma1422,  #FUN-A80150 add 
           sma1423 = g_sma.sma1423,sma1424 = g_sma.sma1424,  #FUN-A80150 add
           sma1431 = g_sma.sma1431,sma1432 = g_sma.sma1432,  #FUN-A80150 add 
           sma1433 = g_sma.sma1433,sma1434 = g_sma.sma1434,  #FUN-A80150 add  
           sma1435 = g_sma.sma1435                           #FUN-A80150 add  
           ,smaud02=g_sma.smaud02     #add by guanyao160903
           ,smaud03=g_sma.smaud03   #add by guanyao160928
        WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms270_i()
DEFINE
    l_dir  LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01),
    l_dir1 LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01),
    l_dir2 LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)
 
#   INPUT  g_sma.sma27,g_sma8872,g_sma.sma71,                                         #TQC-A50027    modify
    INPUT  g_sma.sma27,g_sma.sma71,                                                   #TQC-A50027    modify
           g_sma.sma78,g_sma8871,g_sma.sma848,g_sma.sma883,
           g_sma.sma849,g_sma.sma107,g_sma.sma75,g_sma.sma76,
           g_sma.sma129,g_sma.sma896,                                                 #No.FUN-940008 add sma129
           g_sma.sma104,g_sma.sma105, g_sma.sma73,g_sma.sma899,
          #g_sma.sma74,genero mark g_sma.sma70,                                      #FUN-910053
           g_sma.sma72,g_sma.sma141,g_sma.sma1411,                                    #No.FUN-A30003 #FUN-B60142
           g_sma.sma1421,g_sma.sma1422,g_sma.sma1423,g_sma.sma1424,g_sma.sma1431,     #FUN-A80150 add
           g_sma.sma1432,g_sma.sma1433,g_sma.sma1434,g_sma.sma1435                    #FUN-A80150 add
           ,g_sma.smaud02    #add by guanyao160903
           ,g_sma.smaud03   #add by guanyao160928
          WITHOUT DEFAULTS 
#    FROM  sma27,s,sma71,sma78,q,sma848,sma883,               #TQC-A50027   modify
     FROM  sma27,sma71,sma78,q,sma848,sma883,                 #TQC-A50027   modify
           sma849,sma107,sma75,sma76,sma129,sma896,           #No.FUN-940008 add sma129
           sma104,sma105, sma73,sma899,
          #sma74,#genero mark g_sma.sma70,                    #FUN-910053
           sma72,sma141,sma1411,                              #No.FUN-A30003 #FUN-B60142
           sma1421,sma1422,sma1423,sma1424,sma1431,sma1432,sma1433,sma1434,sma1435     #FUN-A80150 add 
           ,smaud02    #add by guanyao160903
           ,smaud03   #add by guanyao160928
           
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL s270_set_entry()
        CALL s270_set_no_entry()
        LET g_before_input_done = TRUE
       #CALL cl_set_comp_entry('sma141',TRUE)      #No.FUN-A30003 #FUN-B60142 mark
        CALL s270_set_entry_sma141()               #FUN-B60142 add
        CALL s270_set_no_entry_sma141()            #FUN-B60142 add
 
    AFTER FIELD sma27
      IF NOT cl_null(g_sma.sma27) THEN
          IF g_sma.sma27 NOT MATCHES "[123]" THEN
              LET g_sma.sma27=g_sma_o.sma27
              DISPLAY BY NAME g_sma.sma27
              NEXT FIELD sma27
          END IF
          LET g_sma_o.sma27=g_sma.sma27
      END IF
 
    #FUN-B60142--begin----add---
    BEFORE FIELD sma71
      CALL s270_set_entry_sma141()
    #FUN-B60142--end----add---
    
    AFTER FIELD sma71
      IF NOT cl_null(g_sma.sma71) THEN
          IF g_sma.sma71 NOT MATCHES '[YN]' THEN
              LET g_sma.sma71=g_sma_o.sma71
              DISPLAY BY NAME g_sma.sma71
              NEXT FIELD sma71
          END IF
          LET g_sma_o.sma71=g_sma.sma71
          #FUN-B60142--begin--mark------
          ##No.FUN-A30003 --begin
          #IF g_sma.sma71 ='Y' THEN 
          #   CALL cl_set_comp_entry('sma141',TRUE)
          #ELSE
          #   CALL cl_set_comp_entry('sma141',FALSE)
          #  #LET g_sma.sma141='0'    #No.FUN-A60031
          #   LET g_sma.sma141='N'    #No.FUN-A60031
          #END IF  
          ##No.FUN-A30003 --end
          #FUN-B60142--end--mark---
          CALL s270_set_no_entry_sma141()            #FUN-B60142 add
      END IF
      
    #No.FUN-A30003 --begin
    ON CHANGE sma71
          #FUN-B60142--begin--mark------
          #IF g_sma.sma71 ='Y' THEN 
          #   CALL cl_set_comp_entry('sma141',TRUE)
          #ELSE
          #   CALL cl_set_comp_entry('sma141',FALSE)
          #  #LET g_sma.sma141='0'    #No.FUN-A60031
          #   LET g_sma.sma141='N'    #No.FUN-A60031
          #END IF
          #FUN-B60142--end--mark---
          CALL s270_set_no_entry_sma141()            #FUN-B60142 add
    #No.FUN-A30003 --end 
    
    #FUN-B60142--begin----add---
    BEFORE FIELD sma141
      CALL s270_set_entry_sma141()
     
    AFTER FIELD sma141
      CALL s270_set_no_entry_sma141() 
      
    ON CHANGE sma141
       CALL s270_set_no_entry_sma141()
    #FUN-B60142--end----add---
    
    AFTER FIELD sma78
      IF NOT cl_null(g_sma.sma78) THEN
          IF g_sma.sma78 NOT MATCHES '[12]' THEN
              LET g_sma.sma78=g_sma_o.sma78
              DISPLAY BY NAME g_sma.sma78
              NEXT FIELD sma78
          END IF
          LET g_sma_o.sma78=g_sma.sma78
      END IF
 
    AFTER FIELD sma883
      IF NOT cl_null(g_sma.sma883) THEN
          IF g_sma.sma883 NOT MATCHES '[YN]' THEN
              LET g_sma.sma883=g_sma_o.sma883
              DISPLAY BY NAME g_sma.sma883
              NEXT FIELD sma883
          END IF
          LET g_sma_o.sma883=g_sma.sma883
      END IF
 
    BEFORE FIELD sma104
        CALL s270_set_entry()
 
    AFTER FIELD sma104
      IF NOT cl_null(g_sma.sma883) THEN
          IF g_sma.sma104 NOT MATCHES '[YN]' THEN
              LET g_sma.sma104=g_sma_o.sma104
              DISPLAY BY NAME g_sma.sma104
              NEXT FIELD sma104
          END IF
          LET g_sma_o.sma104=g_sma.sma104
          IF g_sma.sma104 = 'Y' THEN
              IF cl_null(g_sma.sma105) THEN
                 IF g_sma.sma896 = 'Y' THEN
                     LET g_sma.sma105 = '1'
                 ELSE
                     LET g_sma.sma105 = '2'
                 END IF
                 DISPLAY BY NAME g_sma.sma105
              END IF
          ELSE
              LET g_sma.sma105 = NULL
              DISPLAY BY NAME g_sma.sma105
          END IF
      END IF
      CALL s270_set_no_entry()
 
    AFTER FIELD sma105
       IF g_sma.sma104 = 'Y' THEN
           IF g_sma.sma105 NOT MATCHES '[12]' OR
              cl_null(g_sma.sma105) THEN
               LET g_sma.sma105=g_sma_o.sma105
               DISPLAY BY NAME g_sma.sma105
               #因為有使用聯產品,所以請輸入認定聯產品的時機點為何!
               CALL cl_err('','asm-270',0) 
               NEXT FIELD sma105
           END IF
           IF g_sma.sma896 = 'N' AND 
              g_sma.sma105 = '1' THEN
               LET g_sma.sma105=g_sma_o.sma105
               DISPLAY BY NAME g_sma.sma105
               #是否使用FQC功能設為'N',所以認定聯產品的時機點不可設為1.FQC !
               CALL cl_err('','asm-271',0) 
               NEXT FIELD sma105
           END IF
       END IF
       LET g_sma_o.sma105=g_sma.sma105
 
    AFTER FIELD sma107    #NO:6897
       IF NOT cl_null(g_sma.sma107) THEN
           IF g_sma.sma107 NOT MATCHES '[YN]' THEN
               NEXT FIELD sma107
           END IF
       END IF
 
    BEFORE FIELD sma73
        CALL s270_set_entry()
 
    AFTER FIELD sma73
       IF g_sma.sma73 NOT MATCHES '[YN]' THEN
           LET g_sma.sma73=g_sma_o.sma73
           DISPLAY BY NAME g_sma.sma73
           NEXT FIELD sma73
       END IF
       LET g_sma_o.sma73=g_sma.sma73
       CALL s270_set_no_entry()
 
#FUN-910053--BEGIN--MARK--
#   AFTER FIELD sma74
#    IF NOT cl_null(g_sma.sma74) THEN
#      IF g_sma.sma74 <0 THEN
#            LET g_sma.sma74=g_sma_o.sma74
#            DISPLAY BY NAME g_sma.sma74
#            NEXT FIELD sma74
#      END IF
#      LET g_sma_o.sma74=g_sma.sma74
#    END IF
#FUN-910053--END--MARK--
 
#No.FUN-940008---Begin
    AFTER FIELD sma129
       IF NOT cl_null(g_sma.sma129) THEN
           IF g_sma.sma129 NOT MATCHES '[YN]' THEN
               NEXT FIELD sma129
           END IF
       END IF
#No.FUN-940008---End       
 
    AFTER FIELD sma899
       IF NOT cl_null(g_sma.sma899) THEN
           IF g_sma.sma899 NOT MATCHES '[YN]' THEN
               NEXT FIELD sma899
           END IF
       END IF
   {#genero mark      
    AFTER FIELD sma70
       IF NOT cl_null(g_sma.sma70) THEN 
           IF g_sma.sma70 NOT MATCHES '[12]' THEN
               LET g_sma.sma70=g_sma_o.sma70
               DISPLAY BY NAME g_sma.sma70
               NEXT FIELD sma70
           END IF
           LET g_sma_o.sma70=g_sma.sma70
       END IF
   }
    AFTER FIELD sma72
       IF cl_null(g_sma.sma72) THEN
           IF g_sma.sma72 NOT MATCHES '[YN]' THEN
               LET g_sma.sma72=g_sma_o.sma72
               DISPLAY BY NAME g_sma.sma72
               NEXT FIELD sma72
           END IF
           LET g_sma_o.sma72=g_sma.sma72
       END IF
 
    BEFORE FIELD sma75
        CALL s270_set_entry()
 
    AFTER FIELD sma75
        IF cl_null(g_sma.sma75) THEN
            LET g_sma.sma75 =' '
            LET g_sma.sma76 =' '
            DISPLAY BY NAME g_sma.sma75,g_sma.sma76
        ELSE
            SELECT COUNT(*) INTO g_cnt FROM imd_file
               WHERE imd01 = g_sma.sma75
                  AND imdacti = 'Y' #MOD-4B0169
            IF g_cnt = 0 OR g_cnt IS NULL THEN
               CALL cl_err(g_sma.sma75,'mfg0094',1)
               LET g_sma.sma75 = g_sma_o.sma75
               DISPLAY BY NAME g_sma.sma75
               NEXT FIELD sma75
            END IF
            LET g_sma_o.sma75 = g_sma.sma75
            LET l_dir1='D'
            #FUN-D40103 -----Begin------
            IF NOT s_imechk(g_sma.sma75,g_sma.sma76) THEN
            #  NEXT FIELD sma75    #TQC-D50126 mark
               NEXT FIELD sma76    #TQC-D50126
            END IF
        #FUN-D40103 -----End--------
        END IF
        CALL s270_set_no_entry()
 
    AFTER FIELD sma76
 
 #FUN-D40103 ------Begin--------
       #IF NOT cl_null(g_sma.sma76) THEN
          #SELECT COUNT(*) INTO g_cnt FROM ime_file
          #WHERE ime01=g_sma.sma75 AND ime02=g_sma.sma76
          #IF g_cnt = 0 OR g_cnt IS NULL THEN
          #   CALL cl_err(g_sma.sma76,'mfg0095',1)
          #   LET g_sma.sma76 = g_sma_o.sma76
          #   DISPLAY BY NAME g_sma.sma76
          #   NEXT FIELD sma76
          #END IF
          #LET g_sma_o.sma76 = g_sma.sma76
       #END IF
      #FUN-D40103 ------End----------
        IF cl_null(g_sma.sma76) THEN LET g_sma.sma76 = ' ' END IF   #TQC-D50127
        #FUN-D40103 -----Begin------
        #FUN-D20008---begin
        #IF NOT s_imechk(g_sma.sma75,g_sma.sma76) THEN  #FUN-D20008
        #   NEXT FIELD sma76
        #END IF
        SELECT COUNT(*) INTO g_cnt FROM ime_file
         WHERE ime01=g_sma.sma75 AND ime02=g_sma.sma76
           AND ime04 = 'W'
        IF g_cnt = 0 OR g_cnt IS NULL THEN
           CALL cl_err(g_sma.sma76,'axm1139',1)
           LET g_sma.sma76 = g_sma_o.sma76
           DISPLAY BY NAME g_sma.sma76
         NEXT FIELD sma76
        END IF
        LET g_sma_o.sma76 = g_sma.sma76
        #FUN-D20008---end
        
        IF NOT cl_null(g_sma.sma76) THEN
           LET g_sma_o.sma76 = g_sma.sma76
        END IF
        #FUN-D40103 -----End--------
 
    AFTER FIELD sma848
       IF NOT cl_null(g_sma.sma848) THEN
           IF g_sma.sma848 NOT MATCHES '[12]' THEN
               LET g_sma.sma848=g_sma_o.sma848
               DISPLAY BY NAME g_sma.sma848
               NEXT FIELD sma848
           END IF
           LET g_sma_o.sma848=g_sma.sma848
       END IF
  
   #FUN-A80150---add---start---
    AFTER FIELD sma1421
      IF NOT cl_null(g_sma.sma1421) THEN
          IF g_sma.sma1421 NOT MATCHES '[YN]' THEN
              LET g_sma.sma1421=g_sma_o.sma1421
              DISPLAY BY NAME g_sma.sma1421
              NEXT FIELD sma1421
          END IF
          LET g_sma_o.sma1421=g_sma.sma1421
          IF g_sma.sma1421 ='Y' THEN 
             CALL cl_set_comp_entry('sma1422,sma1423,sma1424',TRUE)
          ELSE
             CALL cl_set_comp_entry('sma1422,sma1423,sma1424',FALSE)
             LET g_sma.sma1422='N'  
             LET g_sma.sma1423='N'  
             LET g_sma.sma1424='N'  
             DISPLAY BY NAME g_sma.sma1422,g_sma.sma1423,g_sma.sma1424
          END IF  
      END IF
    ON CHANGE sma1421
          IF g_sma.sma1421 ='Y' THEN 
             CALL cl_set_comp_entry('sma1422,sma1423,sma1424',TRUE)
          ELSE
             CALL cl_set_comp_entry('sma1422,sma1423,sma1424',FALSE)
             LET g_sma.sma1422='N'  
             LET g_sma.sma1423='N'  
             LET g_sma.sma1424='N'  
             DISPLAY BY NAME g_sma.sma1422,g_sma.sma1423,g_sma.sma1424
          END IF  
    AFTER FIELD sma1431
      IF NOT cl_null(g_sma.sma1431) THEN
          IF g_sma.sma1421 NOT MATCHES '[YN]' THEN
              LET g_sma.sma1431=g_sma_o.sma1431
              DISPLAY BY NAME g_sma.sma1431
              NEXT FIELD sma1431
          END IF
          LET g_sma_o.sma1431=g_sma.sma1431
          IF g_sma.sma1431 ='Y' THEN 
             CALL cl_set_comp_entry('sma1432,sma1433,sma1434,sma1435',TRUE)
          ELSE
             CALL cl_set_comp_entry('sma1432,sma1433,sma1434,sma1435',FALSE)
             LET g_sma.sma1432='N'  
             LET g_sma.sma1433='N'  
             LET g_sma.sma1434='N'  
             LET g_sma.sma1435='Y'  
             DISPLAY BY NAME g_sma.sma1432,g_sma.sma1433,g_sma.sma1434,g_sma.sma1435
          END IF  
      END IF
    ON CHANGE sma1431
          IF g_sma.sma1431 ='Y' THEN 
             CALL cl_set_comp_entry('sma1432,sma1433,sma1434,sma1435',TRUE)
          ELSE
             CALL cl_set_comp_entry('sma1432,sma1433,sma1434,sma1435',FALSE)
             LET g_sma.sma1432='N'  
             LET g_sma.sma1433='N'  
             LET g_sma.sma1434='N'  
             LET g_sma.sma1435='Y'  
             DISPLAY BY NAME g_sma.sma1432,g_sma.sma1433,g_sma.sma1434,g_sma.sma1435
          END IF  
   #FUN-A80150---add---end---
    
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
    #MOD-860081------add-----str---
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     
     ON ACTION about         
        CALL cl_about()      
     
     ON ACTION help          
        CALL cl_show_help()  
    #MOD-860081------add-----end---
 
  END INPUT
 #CALL cl_set_comp_entry('sma141',FALSE)     #No.FUN-A30003  #FUN-B60142 mark
END FUNCTION
 
#處理預設值的部份
FUNCTION s270_def()
#MOD-D20158-Modify--start
#  IF cl_null(g_sma.sma27) IS NULL  THEN LET g_sma.sma27='1' END IF
#  IF cl_null(g_sma.sma71) IS NULL  THEN LET g_sma.sma71='N' END IF
#  IF cl_null(g_sma.sma78) IS NULL  THEN LET g_sma.sma78='2' END IF
#  IF cl_null(g_sma.sma896) IS NULL  THEN LET g_sma.sma896=0 END IF
# #IF cl_null(g_sma.sma74) IS NULL  THEN LET g_sma.sma74='N' END IF  #FUN-910053
#  IF cl_null(g_sma.sma72) IS NULL THEN LET g_sma.sma72='Y' END IF
#  IF cl_null(g_sma.sma883) IS NULL THEN LET g_sma.sma883='Y' END IF
#  IF cl_null(g_sma.sma104) IS NULL THEN LET g_sma.sma104='N' END IF
   IF cl_null(g_sma.sma27)   THEN LET g_sma.sma27='1' END IF
   IF cl_null(g_sma.sma71)   THEN LET g_sma.sma71='N' END IF
   IF cl_null(g_sma.sma78)   THEN LET g_sma.sma78='2' END IF
   IF cl_null(g_sma.sma896)  THEN LET g_sma.sma896=0 END IF
   IF cl_null(g_sma.sma72)   THEN LET g_sma.sma72='Y' END IF
   IF cl_null(g_sma.sma883)  THEN LET g_sma.sma883='Y' END IF
   IF cl_null(g_sma.sma104)  THEN LET g_sma.sma104='N' END IF
#MOD-D20158-Modify--end
   #No.TQC-9A0080  --Begin
   #IF cl_null(g_sma.sma129) IS NULL THEN LET g_sma.sma129='Y' END IF #No.FUN-940008 add
   IF cl_null(g_sma.sma129) THEN LET g_sma.sma129='Y' END IF #No.FUN-940008 add
   #No.TQC-9A0080  --End  
  #FUN-A80150---add---start---
   IF cl_null(g_sma.sma1421) THEN
      LET g_sma.sma1421 = 'N'
      LET g_sma.sma1422 = 'N'
      LET g_sma.sma1423 = 'N'
      LET g_sma.sma1424 = 'N'
   END IF
   IF cl_null(g_sma.sma1431) THEN
      LET g_sma.sma1431 = 'N'
      LET g_sma.sma1432 = 'N'
      LET g_sma.sma1433 = 'N'
      LET g_sma.sma1434 = 'N'
      LET g_sma.sma1435 = 'Y'
   END IF
  #FUN-A80150---add---end---
# IF cl_null(g_sma.sma1411) IS NULL THEN LET g_sma.sma1411='N' END IF  #FUN-B60142 #MOD-D20158 mark
  IF cl_null(g_sma.sma1411) THEN LET g_sma.sma1411='N' END IF              #MOD-D20158
  IF cl_null(g_sma.smaud02) THEN LET g_sma.smaud02 = 'N' END IF            #add by guanyao160903
  IF cl_null(g_sma.smaud03) THEN LET g_sma.smaud03 = 'N' END IF            #add by guanyao160928
END FUNCTION
 
#genero
FUNCTION s270_set_entry()
 
   IF INFIELD(sma104) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma105",TRUE)
   END IF
 
   IF INFIELD(sma73) OR (NOT g_before_input_done) THEN
     #CALL cl_set_comp_entry("sma74,sma899",TRUE)
      CALL cl_set_comp_entry("sma899",TRUE) #FUN-910053
   END IF
 
   IF INFIELD(sma75) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma76,sma899",TRUE)
   END IF

  #FUN-A80150---add---start---
   IF g_sma.sma1421 = 'Y' THEN 
      CALL cl_set_comp_entry("sma1422,sma1423,sma1424",TRUE)
   END IF
   IF g_sma.sma1431 = 'Y' THEN 
      CALL cl_set_comp_entry("sma1432,sma1433,sma1434,sma1435",TRUE)
   END IF
  #FUN-A80150---add---end---
 
END FUNCTION
 
FUNCTION s270_set_no_entry()
 
   IF INFIELD(sma104) OR (NOT g_before_input_done) THEN
      IF g_sma.sma104='N' THEN
          CALL cl_set_comp_entry("sma105",FALSE)
      END IF
   END IF
 
   IF INFIELD(sma73) OR (NOT g_before_input_done) THEN
      IF g_sma.sma73='N' THEN
         #CALL cl_set_comp_entry("sma74,sma899",FALSE)
          CALL cl_set_comp_entry("sma899",FALSE)  #FUN-910053
      END IF
   END IF
 
   IF INFIELD(sma75) OR (NOT g_before_input_done) THEN
      IF cl_null(g_sma.sma75) THEN
          CALL cl_set_comp_entry("sma76",FALSE)
      END IF
   END IF

  #FUN-A80150---add---start---
   IF g_sma.sma1421 = 'N' THEN 
      CALL cl_set_comp_entry("sma1422,sma1423,sma1424",FALSE)
   END IF
   IF g_sma.sma1431 = 'N' THEN 
      CALL cl_set_comp_entry("sma1432,sma1433,sma1434,sma1435",FALSE)
   END IF
  #FUN-A80150---add---end---
 
END FUNCTION

#FUN-B60142(S)
FUNCTION s270_set_entry_sma141()
  CALL cl_set_comp_entry('sma141,sma1411',TRUE)  
END FUNCTION

FUNCTION s270_set_no_entry_sma141()
  IF g_sma.sma71 ='Y' THEN
     CALL cl_set_comp_entry('sma141',TRUE)
  ELSE
     CALL cl_set_comp_entry('sma141',FALSE)
     LET g_sma.sma141='N' 
     DISPLAY BY NAME g_sma.sma141
  END IF 
  IF g_sma.sma141 ='Y' THEN
     CALL cl_set_comp_entry('sma1411',TRUE)
  ELSE
     CALL cl_set_comp_entry('sma1411',FALSE)
     LET g_sma.sma1411='N' 
     DISPLAY BY NAME g_sma.sma1411
  END IF   
END FUNCTION
#FUN-B60142(E)

# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfp322.4gl
# Descriptions...: 已發放工單還原作業
# Date & Author..: 92/11/24 Lee
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.TQC-710007 07/01/04 By day 還應更新sfb87
# Modify.........: No.TQC-730022 07/03/27 By rainy 流程自動化
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-8C0081 09/03/10 By sabrina 執行還原後，簽核狀況碼要更新為〝0：開立〞
# Modify.........: No.TQC-940130 09/05/08 By mike PREPARE p322_cnt FROM l_sql之后并沒有DECLARE CURSOR導致下面OPEN FETCH錯誤  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0184 09/12/29 By lilingyu sql語法有誤
# Modify.........: No:TQC-A50027 10/05/14 By houlia sma8872刪除后程序做相應調整
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2) 
# Modify.........: No:MOD-D70043 13/07/08 By suncx 發放還原不應該管控最多只能還原49筆資料
# Modify.........: No:MOD-D70141 13/07/24 By suncx 檢查是否有發料資料, 若有非作廢狀態的發料資料, 則不允許還原

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm RECORD
        wc    LIKE type_file.chr1000,     #No.FUN-680121 VARCHAR(300) #QBE條件
        sfb13 LIKE sfb_file.sfb13,        #截止開工日期
        sfb15 LIKE sfb_file.sfb15,        #截止完工日期
        cfConfirm LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1) #是否逐一確認
        cfAlc LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1) #是否刪除備料資料
        cfTrk LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1) #是否刪除追蹤資料
    END RECORD,
#   g_sma8872  LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)             #TQC-A50027    mark
    m_part LIKE sfb_file.sfb05,            #料件編號
    m_wostatus LIKE sfb_file.sfb04,        #工單狀態
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        sfb513       LIKE sfb_file.sfb04,          #TQC-A50027   add
        s_t          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_exit_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_argv1   STRING   #TQC-730022
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
  
   LET g_argv1 = ARG_VAL(1)   #TQC-730022
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
  #TQC-730022 begin
   IF NOT cl_null(g_argv1) THEN
     LET tm.cfConfirm = 'N' 
     LET tm.cfAlc     = 'N' 
     LET tm.cfTrk     = 'N' 
     LET tm.sfb13 = NULL
     LET tm.sfb15 = NULL
     LET tm.wc = g_argv1
     CALL p322_p()
   ELSE
  #TQC-730022 end
     CALL p322_cmd(0,0)          #condition input
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p322_cmd(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 10
   END IF
    OPEN WINDOW p322_w AT p_row,p_col
        WITH FORM "asf/42f/asfp322" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
    WHILE TRUE
        IF s_shut(0) THEN RETURN END IF
        CALL p322_i()
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 
        IF cl_sure(0,0)
        THEN
            CALL p322_p()
        END IF
        CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
    END WHILE
    ERROR ""
    CLOSE WINDOW p322_w
END FUNCTION
 
FUNCTION p322_i()
   DEFINE   l_sfRequired    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_cfDirection   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) #TQC-840066
 
 
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
 
   #QBE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb22,sfb27,sfb85 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
   
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET tm.cfConfirm='Y'
   LET tm.cfAlc='Y'
   LET tm.cfTrk='Y'

#TQC-A50027-----------------------modify 
#  INPUT BY NAME tm.sfb13,tm.sfb15,tm.cfConfirm,
#      tm.cfAlc,tm.cfTrk WITHOUT DEFAULTS 
   INPUT BY NAME tm.sfb13,tm.sfb15,tm.cfConfirm,
       tm.cfAlc,tm.cfTrk,sfb513 WITHOUT DEFAULTS
#TQC-A50027----------------------end
 
      AFTER FIELD cfConfirm
         IF tm.cfConfirm IS NULL
            OR tm.cfConfirm NOT MATCHES '[YN]'
         THEN
            NEXT FIELD cfConfirm
         END IF
 
      AFTER FIELD cfAlc
         IF tm.cfAlc IS NULL
            OR tm.cfAlc NOT MATCHES '[YN]'
         THEN
            NEXT FIELD cfAlc
         END IF
 
      AFTER FIELD cfTrk
         IF tm.cfTrk IS NULL
            OR tm.cfTrk NOT MATCHES '[YN]'
         THEN
            NEXT FIELD cfTrk
         END IF
 
      AFTER INPUT    #檢查必要欄位是否輸入
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
   END INPUT
END FUNCTION
 
FUNCTION p322_p()
DEFINE
    l_arWo DYNAMIC ARRAY OF RECORD
        sure  LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
        sfb01 LIKE sfb_file.sfb01,    #工單編號
        sfb04 LIKE sfb_file.sfb04,    #狀態
        sfb05 LIKE sfb_file.sfb05,    #料件編號
        sfb08 LIKE sfb_file.sfb08,    #生產數量
        ima55 LIKE ima_file.ima55,    #單位
        sfb24 LIKE sfb_file.sfb24,    #追蹤
        sfb23 LIKE sfb_file.sfb23    #備料
        END RECORD,
   #l_ima55_fac ARRAY[49] OF LIKE ima_file.ima55_fac,        #No.FUN-680121 DEC(16,8)#換算率   #MOD-D70043 mark
    l_ima55_fac DYNAMIC ARRAY OF LIKE ima_file.ima55_fac,    #MOD-D70043 add
    l_sfa06 LIKE sfa_file.sfa06,
    l_qty LIKE sfb_file.sfb08,        #還原數量
    l_sql LIKE type_file.chr1000,                        #No.FUN-680121 VARCHAR(600)
    l_iIdx,l_iCnt,l_iScl LIKE type_file.num5,            #No.FUN-680121 SMALLINT
    l_allow_insert  LIKE type_file.num5,                 #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #No.FUN-680121 SMALLINT
DEFINE l_cnt LIKE type_file.num5   #MOD-D70141 add
 
    #組SQL
#   LET g_sma8872 = g_sma.sma887[2,2]              #TQC-A50027    mark
    LET l_sql="SELECT 'Y',sfb01,sfb04,sfb05,sfb08,ima55,sfb24,sfb23,ima55_fac",
       #" FROM sfb_file, OUTER ima_file  WHERE sfb_file.sfb05=ima_file.ima01",    #TQC-9C0184
        " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01",             #TQC-9C0184
      #" AND sfbacti= 'Y' ",     #TQC-9C0184
       " WHERE sfbacti= 'Y' ",   #TQC-9C0184 
        " AND sfb02 != '7' ",      ##94/10/18 Modify bY Jackson 不含委外
        " AND sfb09=0  ",
        " AND sfb17 IS NULL"        
    IF tm.sfb13 IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED," AND sfb13>='",tm.sfb13,"'"
    END IF
    IF tm.sfb15 IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED," AND sfb15<='",tm.sfb15,"'"
    END IF
#TQC-A50027--------------------modify
    IF sfb513 = '4' THEN
       LET l_sql = l_sql CLIPPED," AND sfb04 MATCHES '[123]' "
    END IF
#   IF g_sma8872 = 'Y' THEN
#      LET l_sql = l_sql CLIPPED," AND sfb04 IN ('2','3') "
#   ELSE
#      LET l_sql = l_sql CLIPPED," AND sfb04 IN ('2') "
#   END IF
#TQC-A50027--------------------end
    #QBE Conditions
    IF tm.wc IS NOT NULL AND tm.wc!=' 1=1'
    THEN
        LET l_sql=l_sql CLIPPED,' AND ',tm.wc CLIPPED
    END IF
    PREPARE p322_p FROM l_sql
    IF SQLCA.SQLCODE
    THEN
        CALL cl_err('Prepare:',SQLCA.SQLCODE,1)
        RETURN
    END IF
    DECLARE p322_cur CURSOR FOR p322_p
 
    LET l_sql=" SELECT SUM(sfa06)+SUM(sfa061)",
        " FROM sfa_file",
        " WHERE sfa01=?"
   #PREPARE p322_cnt FROM l_sql  #TQC-940130  
    PREPARE p322_precnt FROM l_sql           #TQC-940130   
    DECLARE p322_cnt CURSOR FOR p322_precnt  #TQC-940130 
 
    #取得資料
    LET l_iIdx=1
    FOREACH p322_cur INTO l_arWo[l_iIdx].*,l_ima55_fac[l_iIdx]
        IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
        #有備料資料, 檢查是否已發料, 若已發料, 則不允許還原
        IF l_arWo[l_iIdx].sfb23='Y'
        THEN
            LET l_sfa06=0
            OPEN p322_cnt USING l_arWo[l_iIdx].sfb01
            FETCH p322_cnt INTO l_sfa06
            IF l_sfa06 != 0 THEN CONTINUE FOREACH END IF
        END IF
        
        #MOD-D70141 add begin----------------------------
        #檢查是否有發料資料, 若有非作廢狀態的發料資料, 則不允許還原
        SELECT COUNT(*) INTO l_cnt FROM sfq_file,sfp_file
         WHERE sfq02 = l_arWo[l_iIdx].sfb01 AND sfq01 = sfp01 AND sfpconf != 'X'
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF

        SELECT COUNT(*) INTO l_cnt FROM sfs_file,sfp_file
         WHERE sfs03 = l_arWo[l_iIdx].sfb01 AND sfs01 = sfp01 AND sfpconf !='X'
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        
        SELECT COUNT(*) INTO l_cnt FROM sfe_file,sfp_file
         WHERE sfe01 = l_arWo[l_iIdx].sfb01 AND sfe02 = sfp01 AND sfpconf !='X'
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        #MOD-D70141 add end------------------------------

        LET l_iIdx=l_iIdx+1
       #IF l_iIdx>49 THEN EXIT FOREACH END IF  #MOD-D70043 mark
       #MOD-D70043 add begin----------------------------------
        IF l_iIdx > g_aza.aza34 THEN                         #超過肚量了
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
       #MOD-D70043 add end------------------------------------
    END FOREACH
 
    LET l_iCnt=l_iIdx-1
    IF l_iCnt=0 THEN
        CALL cl_err('','mfg2601',1)
        RETURN
    END IF
 
    #要使用陣列處理, 故先要告訴它筆數
    CALL SET_COUNT(l_iCnt)
 
    #若要逐筆確認
    IF tm.cfConfirm='Y' THEN
        OPEN WINDOW p3221_w AT 9,5
            WITH FORM "asf/42f/asfp3221" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     
        CALL cl_ui_locale("asfp3221")
 
        MESSAGE "COUNT=",l_iCnt 
        CALL ui.Interface.refresh()
       #DISPLAY "COUNT=",l_iCnt AT 2,1   #CHI-A70049 mark
        DISPLAY ARRAY l_arWo TO s_arWo.* ATTRIBUTE(COUNT=l_iCnt)
            BEFORE DISPLAY
               EXIT DISPLAY
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
        END DISPLAY
 
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
     
        INPUT ARRAY l_arWo WITHOUT DEFAULTS FROM s_arWo.*
           ATTRIBUTE(COUNT=l_iCnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
           BEFORE INPUT
                 CALL fgl_set_arr_curr(l_iIdx)
     
           BEFORE ROW
              LET l_iIdx=ARR_CURR()
     
           AFTER FIELD sure
              IF NOT cl_null(l_arWo[l_iIdx].sure) THEN
                 IF l_arWo[l_iIdx].sure NOT MATCHES "[YN]" THEN
                    NEXT FIELD sure
                 END IF
              END IF
 
           ON ACTION CONTROLG
              CALL cl_cmdask()
     
           AFTER ROW
             IF INT_FLAG THEN
                EXIT INPUT
             END IF
     
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
        
        END INPUT
        CALL cl_set_act_visible("accept,cancel", TRUE)
        CLOSE WINDOW p3221_w
        IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
 
    #進行資料的還原
    FOR l_iIdx=1 TO l_iCnt
        IF l_arWo[l_iIdx].sure MATCHES '[Yy]'
        THEN
            MESSAGE '-> ',l_arWo[l_iIdx].sfb01 
            CALL ui.Interface.refresh()       
            
            #刪除備料資料
            IF l_arWo[l_iIdx].sfb23='Y'
                AND tm.cfAlc='Y'
            THEN
                CALL s_delsfa(l_arWo[l_iIdx].sfb01)
            END IF
 
            #刪除追蹤資料
            IF l_arWo[l_iIdx].sfb24='Y'
                AND tm.cfTrk='Y'
            THEN
                DELETE FROM ecm_file
                    WHERE ecm01=l_arWo[l_iIdx].sfb01
            END IF
 
            #工單資料還原
            LET l_qty=l_arWo[l_iIdx].sfb08*l_ima55_fac[l_iIdx]
              # UPDATE ima_file
              #  SET ima75=ima75-l_qty,        #在製量
              #      ima81=ima81+l_qty        #確認生產量
              #  WHERE ima01=l_arWo[l_iIdx].sfb05
            IF l_arWo[l_iIdx].sfb23='Y'
                AND tm.cfAlc='Y'
            THEN
                LET l_arWo[l_iIdx].sfb23='N'
            END IF
            IF l_arWo[l_iIdx].sfb24='Y'
                AND tm.cfAlc='Y'
            THEN
                LET l_arWo[l_iIdx].sfb24='N'
            END IF
            #No.TQC-710007--begin
#           UPDATE sfb_file
#               SET sfb04=1,                    #工單狀態
#                   sfb23=l_arWo[l_iIdx].sfb23,
#                   sfb24=l_arWo[l_iIdx].sfb24
#               WHERE sfb01=l_arWo[l_iIdx].sfb01
            IF g_sma.sma27 = '2' THEN
               UPDATE sfb_file
                   SET sfb04=1,                
                       sfb23=l_arWo[l_iIdx].sfb23,
                       sfb24=l_arWo[l_iIdx].sfb24
                   WHERE sfb01=l_arWo[l_iIdx].sfb01
            ELSE
               UPDATE sfb_file
                   SET sfb04=1,                 
                       sfb23=l_arWo[l_iIdx].sfb23,
                       sfb87='N',
                       sfb43='0',               #FUN-8C0081 add
                       sfb24=l_arWo[l_iIdx].sfb24
                   WHERE sfb01=l_arWo[l_iIdx].sfb01
            END IF
            #No.TQC-710007--end  
        END IF
    END FOR
END FUNCTION

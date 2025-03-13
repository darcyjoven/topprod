# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmp903.4gl
# Descriptions...: 銀行人工對帳
# Date & Author..: 
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.MOD-960075 09/06/09 By baofei 4fd沒有cn2這個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_ac,g_sl     LIKE type_file.num5,        #No.FUN-680107 SMALLINT #program array no
    g_nma  RECORD LIKE nma_file.*,
    g_nme  RECORD LIKE nme_file.*,
    g_wc   STRING,                            #No.FUN-580092 HCN
    g_npc DYNAMIC ARRAY OF RECORD
          npc02   LIKE npc_file.npc02,
          npc03   LIKE npc_file.npc03,
          npc04   LIKE npc_file.npc04,
          npc06   LIKE npc_file.npc06,
          npc05   LIKE npc_file.npc05,
          npc07   LIKE npc_file.npc07,
          npc08   LIKE npc_file.npc08
        END RECORD,
    g_npc01       ARRAY[500] OF LIKE npc_file.npc01,  #No.FUN-680107 ARRAY[500] OF INT #rvb 的 rowid # saki 20070821 rowid chr18 -> num10 
    g_rec_b       LIKE type_file.num5                  #單身筆數 #No.FUN-680107 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5            #No.FUN-680107 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10           #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5            #count/index for any purpose #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0082
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW anmp342_w AT p_row,p_col WITH FORM "anm/42f/anmp903" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL p342_1()                      #接受選擇
 
    CLOSE WINDOW p342_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
 
#將資料選出, 並進行挑選
FUNCTION p342_1()
DEFINE
    l_n     	   LIKE type_file.num5,      #screen array no #No.FUN-680107 SMALLINT
    l_sql          LIKE type_file.chr1000,   #RDSQL STATEMENT #No.FUN-680107 VARCHAR(500)
    l_time1        LIKE type_file.chr8,      #No.FUN-680107 VARCHAR(8)
    g_npc07_o      LIKE npc_file.npc07,
    g_npc08_o      LIKE npc_file.npc08,
    l_allow_insert LIKE type_file.num5,      #可新增否 #No.FUN-680107 SMALLINT
    l_allow_delete LIKE type_file.num5       #可刪除否 #No.FUN-680107 SMALLINT
 
    WHILE TRUE
        CLEAR FORM
        CALL g_npc.clear()
 
        WHILE TRUE
          CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
          CONSTRUCT BY NAME g_wc ON nma01,npc02,npc06,npc05,npc07,npc08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
             ON ACTION locale                    #genero
                LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                EXIT CONSTRUCT
            
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          
             ON ACTION exit              #加離開功能genero
                LET INT_FLAG = 1
                EXIT CONSTRUCT
         
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
          END CONSTRUCT
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup') #FUN-980030
          IF g_action_choice = "locale" THEN  #genero
             LET g_action_choice = ""
             CALL cl_dynamic_locale()
             CONTINUE WHILE 
          END IF
          IF INT_FLAG THEN
             EXIT WHILE
          END IF
          IF g_wc = ' 1=1 ' THEN 
             CALL cl_err(' ','9046',0)
             CONTINUE WHILE 
          ELSE 
             EXIT WHILE
          END IF
        END WHILE
        IF INT_FLAG THEN
           LET INT_FLAG = 0 
           EXIT WHILE
        END IF
 
        LET l_sql = " SELECT npc01,npc02,npc03,npc04,npc06, ",
                      "        npc05,npc07,npc08,nma02,nma04,nma21",
                      "  FROM npc_file,nma_file ",
                      "  WHERE npc01=nma01 ",
                      "  AND ",g_wc CLIPPED," ORDER BY nma02,npc02,npc06"
        PREPARE p342_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
           CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
           EXIT WHILE
        END IF
        DECLARE p342_cs CURSOR WITH HOLD FOR p342_prepare #宣告之
 
        CALL g_npc.clear()
        LET g_cnt=1                                         #總選取筆數
        FOREACH p342_cs INTO g_npc01[g_cnt],g_npc[g_cnt].*,
                             g_nma.nma02,g_nma.nma04,g_nma.nma21
            IF SQLCA.sqlcode THEN                                  #有問題
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                       #超過肚量了
               EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
           CALL cl_err('','aap-129',1)                     #顯示錯誤, 並回去
           CONTINUE  WHILE
        END IF
 
        LET g_rec_b=g_cnt-1                                   #正確的總筆數
        DISPLAY BY NAME g_nma.nma02,g_nma.nma04,g_nma.nma21
        DISPLAY g_rec_b TO FORMONLY.cn3  #顯示總筆數
 
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_npc WITHOUT DEFAULTS FROM s_npc.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE ,DELETE ROW=FALSE   ,APPEND ROW=FALSE)
 
          BEFORE INPUT
            IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(g_ac)
            END IF
         
          BEFORE ROW
             LET g_ac = ARR_CURR()
    #         DISPLAY g_ac TO cn2   #MOD-960075
             LET g_npc07_o=g_npc[g_ac].npc07
             LET g_npc08_o=g_npc[g_ac].npc08
 
          AFTER ROW
             IF g_npc[g_ac].npc07 <> g_npc07_o THEN
                IF g_npc[g_ac].npc07='1' THEN #對帳
                     UPDATE npc_file SET npc08=g_npc[g_ac].npc08,
                                         npc07=g_npc[g_ac].npc07
                     WHERE npc01 = g_npc01[g_ac] AND npc02 = g_npc[g_ac].npc02 AND npc06 = g_npc[g_ac].npc06
                     IF SQLCA.SQLCODE THEN 
#                       CALL cl_err('upd npc',SQLCA.SQLCODE,1)   #No.FUN-660148
                        CALL cl_err3("upd","npc_file",g_npc[g_ac].npc02,g_npc[g_ac].npc03,SQLCA.sqlcode,"","upd npc",1) #No.FUN-660148
                     END IF 
                ELSE          #取消對帳
                     UPDATE npc_file SET npc08=NULL,
                                         npc07='2'
                     WHERE npc01 = g_npc01[g_ac] AND npc02 = g_npc[g_ac].npc02 AND npc06 = g_npc[g_ac].npc06
                     IF SQLCA.SQLCODE THEN 
#                       CALL cl_err('upd npc2',SQLCA.SQLCODE,1)   #No.FUN-660148
                        CALL cl_err3("upd","npc_file",g_npc[g_ac].npc02,g_npc[g_ac].npc03,SQLCA.sqlcode,"","upd npc2",1) #No.FUN-660148
                     END IF 
                END IF
             END IF   
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG CALL cl_cmdask()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
         ON ACTION controls                                                                                                             
            CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
        END INPUT
        IF INT_FLAG THEN 
           LET INT_FLAG = 0
        END IF #使用者中斷
        ERROR ' '
    END WHILE
    CLOSE WINDOW p342_w
END FUNCTION
 

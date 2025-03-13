# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmp160.4gl
# Descriptions...: 應付票據領取作業
# Date & Author..: 92/05/13 BY MAY
#                : By Lynn  廠商編號(nmd08)改為廠商簡稱(nmd24)
# Modify.........: No.MOD-480251 04/08/12 Kammy show 執行成功只要show 一次就好
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       tm    RECORD      
             pdate   LIKE type_file.dat,        #No.FUN-680107 DATE
             wc      STRING                     #No.MOD-480253
             END RECORD
DEFINE   p_row,p_col     LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_rec_b         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_nmd01   DYNAMIC ARRAY OF LIKE nmd_file.nmd01
DEFINE   g_nmd     DYNAMIC ARRAY OF RECORD      #結果
              choice    LIKE type_file.chr1,    #選擇碼 #No.FUN-680107 VARCHAR(1)
              nmd24_1   LIKE nmd_file.nmd24,    #廠商簡稱
              nmd02b    LIKE nmd_file.nmd02,    #票號
              nmd04     LIKE nmd_file.nmd04,    #票面金額
              nmd07b    LIKE nmd_file.nmd07,    #開票日期
              nmd05     LIKE nmd_file.nmd05,    #到期日期
              nmd10     LIKE nmd_file.nmd10     #付款單號
            END RECORD 
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0082
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
   CALL p160_1()                      #接受選擇
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
#將資料選出, 並進行挑選
FUNCTION p160_1()
  DEFINE    l_ac            LIKE type_file.num5,    #program array no  #No.FUN-680107 SMALLINT
            l_i             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
            l_cnt           LIKE type_file.num5,    #所選擇筆數  #No.FUN-680107 SMALLINT
            l_wc            LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(200)
            l_sql           LIKE type_file.chr1000, #RDSQL STATEMENT  #No.FUN-680107 VARCHAR(300)
            l_flag          LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
            l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680107 SMALLINT
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW p160_w AT p_row,p_col WITH FORM "anm/42f/anmp160" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
 
 
   WHILE TRUE
      LET tm.pdate = g_today    #預設今天
      CLEAR FORM
      IF s_anmshut(0) THEN
         EXIT WHILE 
      END IF
     # CALL cl_getmsg('anm-021',g_lang) RETURNING g_msg #No.MOD-480252
     # MESSAGE g_msg                                    #No.MOD-480252
      CALL ui.Interface.refresh()
      DISPLAY BY NAME tm.pdate ,tm.wc
 
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
      # input 輸入領取日和顯示順序
      INPUT BY NAME tm.pdate  WITHOUT DEFAULTS 
 
         AFTER FIELD pdate
            IF tm.pdate IS NULL OR tm.pdate = ' ' THEN
               NEXT FIELD pdate
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
      END INPUT
 
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE 
      END IF
 
     # CALL cl_getmsg('anm-022',g_lang) RETURNING g_msg  #No.MOD-480252
     # MESSAGE g_msg                                     #No.MOD-480252
      CALL ui.Interface.refresh()
      
      CONSTRUCT BY NAME tm.wc ON nmd08,nmd24,nmd02,nmd07
 
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
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      LET l_sql = "SELECT ",                      #組合查詢句子
                  "'',nmd24,nmd02,nmd04,nmd07,nmd05,nmd10,nmd01 ",
                  " FROM nmd_file",
                  " WHERE ",tm.wc CLIPPED,
" AND (nmd15 IS NULL ) ",
                  " AND nmd14 = '2' ",
                  " AND nmd30 = 'Y' ",
                  " AND nmd12 != '9' ",
                  " AND nmd02 IS NOT NULL AND nmd02 != ' ' ",
                  " ORDER BY nmd24,nmd05 "
      PREPARE p160_prepare FROM l_sql      #預備之
      IF SQLCA.sqlcode THEN                          #有問題了
         CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
         EXIT WHILE
      END IF
      DECLARE p160_cs CURSOR FOR p160_prepare     #宣告之
 
      CALL g_nmd.clear()
      CALL g_nmd01.clear()
 
      MESSAGE " SEARCHING! " 
      CALL ui.Interface.refresh()
      LET g_cnt=1                                         #總選取筆數
      FOREACH p160_cs INTO g_nmd[g_cnt].*,g_nmd01[g_cnt]
         IF SQLCA.sqlcode THEN                            #有問題
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_nmd[g_cnt].choice = 'N'
         LET g_cnt = g_cnt + 1                            #累加筆數
         IF g_cnt > g_max_rec THEN                        #超過肚量了
            EXIT FOREACH
         END IF
      END FOREACH
       CALL g_nmd.deleteElement(g_cnt)   #取消 Array Element
 
      MESSAGE ""
      CALL ui.Interface.refresh()
      IF g_cnt=1 THEN                                    #沒有抓到
         CALL cl_err('','anm-050',0)                     #顯示錯誤, 並回去
         CONTINUE WHILE
      END IF
 
      LET g_rec_b=g_cnt-1                                #正確的總筆數
 
      DISPLAY g_rec_b TO FORMONLY.cmt                      #顯示總筆數
      LET l_cnt=0                                        #已選筆數
      DISPLAY l_cnt TO FORMONLY.cnt  
 
     #LET l_allow_insert = cl_detail_input_auth("insert")
     #LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_nmd WITHOUT DEFAULTS FROM s_nmd.* 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE ,DELETE ROW=FALSE ,APPEND ROW=FALSE )
 
         BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
      
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         AFTER FIELD choice
            IF NOT cl_null(g_nmd[l_ac].choice) THEN
               IF g_nmd[l_ac].choice NOT MATCHES "[YN]" THEN
                  NEXT FIELD choice
               END IF
            END IF
            LET l_cnt  = 0 
            FOR g_i =1 TO g_nmd.getLength()
                IF g_nmd[g_i].choice = 'Y' AND
                   NOT cl_null(g_nmd[g_i].nmd02b)  THEN
                   LET l_cnt = l_cnt + 1
                END IF
            END FOR
            DISPLAY l_cnt TO FORMONLY.cnt       #寄出筆數
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION take_all  #整批
            FOR l_i= 1 TO g_nmd.getLength()         #將所有的設為選擇
                LET g_nmd[l_i].choice='Y'
                DISPLAY g_nmd[l_i].choice TO choice
            END FOR
            DISPLAY g_rec_b TO FORMONLY.cnt  
	    LET l_ac = ARR_CURR()
 
         ON ACTION withdraw_none  #整批不領取
            FOR l_i = 1 TO g_nmd.getLength()         #將所有的設為選擇
                LET g_nmd[l_i].choice='N'
                DISPLAY g_nmd[l_i].choice TO choice
            END FOR
            DISPLAY 0 TO FORMONLY.cnt  
            LET l_ac = ARR_CURR()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      END INPUT
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CONTINUE WHILE 
      END IF
 
      IF NOT cl_sure(10,10) THEN
         CONTINUE WHILE
      END IF
 
      CALL cl_wait()
      FOR l_ac = 1 TO g_nmd.getLength()
         IF g_nmd[l_ac].choice='Y' THEN          #該單據要領取
      	  # 1.更新應付票據檔:票號、異動日期
            LET g_success = 'Y'
            BEGIN WORK
       	    UPDATE nmd_file SET nmd15 = tm.pdate,
                                 nmd16 = g_user 
              WHERE nmd01 = g_nmd01[l_ac]
             IF SQLCA.sqlcode THEN 
                LET g_success = 'N'
                CALL cl_err('(p160_process:nmd)',SQLCA.sqlcode,1)
             END IF
            IF g_success = 'Y' THEN
               CALL cl_cmmsg(1) 
               COMMIT WORK
              # CALL cl_end2(1) RETURNING l_flag   #No.MOD-480251
            ELSE 
               CALL cl_rbmsg(1) 
               ROLLBACK WORK
              # CALL cl_end2(2) RETURNING l_flag   #No.MOD-480251
            END IF
         END IF
      END FOR 
       #No.MOD-480251
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
       #No.MOD-480251 (end)
       
   END WHILE
   CLOSE WINDOW p160_w
END FUNCTION

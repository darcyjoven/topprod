# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: p_opentb.4gl
# Descriptions...: 開帳欄位條件設定作業
# Date & Author..: FUN-810012 08/03/13 By ice 作業新增
# Modify.........: No.FUN-890131 08/10/01 By Nicola 字元欄位才可輸入判斷方式
# Modify.........: No.FUN-8A0021 08/10/06 By douzh 欄位/字段若型態為日期,
#                  且資料類型為1.預設值,則自動給資料預設值為當天日期
#                  08/11/12 更改p_opentable.4gl為p_opentb.4gl
#                  08/11/19 新增NOT NULL(zoc12)和primary key(zoc13)的欄位
# Modify.........: No.FUN-8A0050 08/10/06 By Nicola
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING  
# Modify.........: No.FUN-910030 09/01/13 By douzh 當zoc04為計算條件時,不檢查預設值是否含有非數字的字符
# Modify.........: No.MOD-990081 09/09/08 By Dido 檢核系統檔案邏輯調整 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/17 By liuxqa standard sql
# Modify.........: No.TQC-9C0150 09/12/18 By jan 欄位型態的資料顯示不出來/日期欄位的長度顯示錯誤
# Modify.........: No.TQC-A10010 10/01/06 By Dido 增加小寫判斷 
# Modify.........: No.FUN-A50026 10/05/12 By Jay cl_get_column_info傳入參數修改
# Modify.........: No.FUN-A40042 10/04/26 By chenmoyan 單身的資料要對應到單頭
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
# Modify.........: No.FUN-A90024 10/12/01 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zoc01          LIKE zoc_file.zoc01,   # 檔案代號 (假單頭)
       g_zoc01_t        LIKE zoc_file.zoc01,   # 檔案代號 (假單頭)
       g_gat03          LIKE gat_file.gat03,   # 檔案名稱 (假單頭)  
 
       g_zoc_lock RECORD LIKE zoc_file.*,      # FOR LOCK CURSOR TOUCH
       g_zoc    DYNAMIC ARRAY of RECORD        # 程式變數
          zoc02          LIKE zoc_file.zoc02,
          gaq03          LIKE gaq_file.gaq03,
          gaq05          LIKE gaq_file.gaq05,            
          zoc03          LIKE zoc_file.zoc03,
#         zoc04          LIKE type_file.num10, #No.FUN-8A0021
          zoc04          LIKE zoc_file.zoc04,  #No.FUN-8A0021
          zoc12          LIKE zoc_file.zoc12,  #No.FUN-8A0021 add
          zoc13          LIKE zoc_file.zoc13,  #No.FUN-8A0021
          zoc05          LIKE zoc_file.zoc05,
          zoc06          LIKE zoc_file.zoc06,
          zoc07          LIKE zoc_file.zoc07,
          zoc08          LIKE zoc_file.zoc08,
          zoc09          LIKE zoc_file.zoc09,
          zoc10          LIKE zoc_file.zoc10,
          zoc11          LIKE zoc_file.zoc11
                    END RECORD,
       g_zoc_t           RECORD                # 變數舊值
          zoc02          LIKE zoc_file.zoc02,
          gaq03          LIKE gaq_file.gaq03,
          gaq05          LIKE gaq_file.gaq05,            
          zoc03          LIKE zoc_file.zoc03,
#         zoc04          LIKE type_file.num10, #No.FUN-8A0021
          zoc04          LIKE zoc_file.zoc04,  #No.FUN-8A0021
          zoc12          LIKE zoc_file.zoc12,  #No.FUN-8A0021 add
          zoc13          LIKE zoc_file.zoc13,  #No.FUN-8A0021
          zoc05          LIKE zoc_file.zoc05,
          zoc06          LIKE zoc_file.zoc06,
          zoc07          LIKE zoc_file.zoc07,
          zoc08          LIKE zoc_file.zoc08,
          zoc09          LIKE zoc_file.zoc09,
          zoc10          LIKE zoc_file.zoc10,
          zoc11          LIKE zoc_file.zoc11
                    END RECORD,
       g_cnt2                LIKE type_file.num5,   
       g_wc                  STRING,
       g_wcc                 STRING,  
       g_sql                 STRING, 
       g_ss                  LIKE type_file.chr1,    # 決定後續步驟 
       g_rec_b               LIKE type_file.num5,    # 單身筆數    
       l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  
DEFINE g_chr                 LIKE type_file.chr1    
DEFINE g_cnt                 LIKE type_file.num10   
DEFINE g_msg                 LIKE type_file.chr1000  
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_argv1               LIKE zoa_file.zoa03
DEFINE l_argv1               STRING
DEFINE g_curs_index          LIKE type_file.num10    
DEFINE g_row_count           LIKE type_file.num10    
DEFINE g_jump                LIKE type_file.num10    
DEFINE g_no_ask              LIKE type_file.num5     
DEFINE g_std_id              LIKE smb_file.smb01     
DEFINE g_db_type             LIKE type_file.chr3     
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)

   LET g_db_type = cl_db_get_database_type()        #No.FUN-9B0082 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
   LET g_zoc01_t = NULL
 
   OPEN WINDOW p_opentb_w WITH FORM "azz/42f/p_opentb"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql =" SELECT * FROM zoc_file ",  
                     " WHERE zoc01 = ?  ",  
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_opentb_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_opentb_base()
      CALL p_opentb_q()
   END IF
 
   CALL p_opentb_menu() 
 
   CLOSE WINDOW p_opentb_w                     # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time # 計算使用時間 (退出時間) 
END MAIN
 
FUNCTION p_opentb_curs()                       # QBE 查詢資料
   DEFINE   l_n1         LIKE  type_file.num5  
   DEFINE   l_n2         LIKE  type_file.num5  
  #DEFINE   l_string     LIKE  type_file.chr1000	#MOD-990081 mark
   DEFINE   l_string     STRING				#MOD-990081 
   DEFINE   l_string2    STRING				#MOD-990081 
   DEFINE   l_pos        LIKE  type_file.num5		#MOD-990081 
   DEFINE   l_chktable   LIKE  zta_file.zta01		#MOD-990081 
   DEFINE   l_cnt        LIKE  type_file.num5           #MOD-990081
 
   CLEAR FORM                                   # 清除畫面
   CALL g_zoc.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "zoc01 IN (",l_argv1 CLIPPED,") "
   ELSE
      CALL cl_set_head_visible("","YES")  
 
      CONSTRUCT g_wc ON zoc01 FROM zoc01
                               
         AFTER FIELD zoc01           #判斷資料是否存在于all_tables，zoc_file中
            LET l_string=FGL_DIALOG_GETBUFFER()
 
#           LET g_wcc = cl_replace_str("g_wc","zoc01","all_tables")
#          
#           LET g_sql= " SELECT count(*) FROM all_tables ",   
#                      " WHERE UPPER('", g_wcc ,")" CLIPPED,
#                      " AND owner = UPPER('",g_dbs CLIPPED,"') "
#                     
#           PREPARE p_opentb_prepare0 FROM g_sql                  # 預備一下
#           DECLARE p_opentb_b_curs0                              # 宣告成可卷動的
#            SCROLL CURSOR WITH HOLD FOR p_opentb_prepare0 
#            
#           EXECUTE p_opentb_b_curs0 INTO l_n1                     
                     
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF
 
   IF NOT cl_null(l_argv1) THEN
  #-MOD-990081-add-
  #   LET l_string = l_argv1.subString(2,l_argv1.getLength()-1)
      LET l_string2 = l_argv1
      WHILE TRUE  
         LET l_pos = l_string2.getIndexOf(',',1)
         IF l_pos > 0 THEN
            LET l_chktable = l_string2.subString(2,l_pos-2)
         ELSE
            LET l_chktable = l_string2.subString(2,l_string2.getLength()-1)
         END IF   

         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         #SELECT COUNT(*) INTO l_cnt
         #  FROM all_tables
         ##WHERE table_name = UPPER(l_string)
         # WHERE table_name = UPPER(l_chktable)
         #  #AND owner = UPPER(g_dbs)   
         #   AND owner = 'DS'
         SELECT COUNT(DISTINCT sch01) INTO l_cnt FROM sch_file
           WHERE sch01 = l_chktable
         #---FUN-A90024---end-------
         LET l_string2 = l_string2.subString(l_pos+1,l_string2.getLength())
         LET l_n1 = l_n1 + l_cnt
         IF l_pos = 0 THEN
            EXIT WHILE
         END IF
      END WHILE
   END IF
  #-MOD-990081-end-
 
   LET g_sql= "SELECT UNIQUE zoc01 FROM zoc_file ",   
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zoc01"        
   
   PREPARE p_opentb_prepare1 FROM g_sql                  # 預備一下
   DECLARE p_opentb_b_curs                               # 宣告成可卷動的
    SCROLL CURSOR WITH HOLD FOR p_opentb_prepare1
 
   IF l_n1=0  THEN
      OPEN p_opentb_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      IF SQLCA.SQLCODE THEN                         #有問題
         CALL cl_err('',SQLCA.SQLCODE,0)
         INITIALIZE g_zoc01 TO NULL
      ELSE
         CALL p_opentb_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         CALL p_opentb_fetch('F')                  #讀出TEMP第一筆並顯示
      END IF
   ELSE 
     #-MOD-990081-add-
      LET l_string2 = l_argv1
      WHILE TRUE  
         LET l_pos = l_string2.getIndexOf(',',1)
         IF l_pos > 0 THEN
            LET l_chktable = l_string2.subString(2,l_pos-2)
         ELSE
            LET l_chktable = l_string2.subString(2,l_string2.getLength()-1)
         END IF   
         SELECT COUNT(*) INTO l_n2
           FROM zoc_file
         #WHERE zoc01 = l_string
          WHERE zoc01 = l_chktable
         IF l_n2=0 THEN
           #CALL p_opentb_b_fill_2(l_string)
            CALL p_opentb_b_fill_2(l_chktable)
         END IF
         LET l_string2 = l_string2.subString(l_pos+1,l_string2.getLength())
         IF l_pos = 0 THEN
            EXIT WHILE
         END IF
      END WHILE
     #-MOD-990081-end-
     #ELSE
         OPEN p_opentb_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
         IF SQLCA.SQLCODE THEN                         #有問題
            CALL cl_err('',SQLCA.SQLCODE,0)
            INITIALIZE g_zoc01 TO NULL
         ELSE
            CALL p_opentb_count()
            DISPLAY g_row_count TO FORMONLY.cnt
            CALL p_opentb_fetch('F')                  #讀出TEMP第一筆並顯示
         END IF                                             	
     #END IF 
   END IF                 
 
   IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
FUNCTION p_opentb_count()
   DEFINE la_zoc   DYNAMIC ARRAY of RECORD        # 程式變數
          zoc01          LIKE zoc_file.zoc01
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10   
   DEFINE li_rec_b LIKE type_file.num10   
 
   LET g_sql= "SELECT UNIQUE zoc01 FROM zoc_file ", 
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zoc01"      
 
   PREPARE p_opentb_precount FROM g_sql
   DECLARE p_opentb_count CURSOR FOR p_opentb_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH p_opentb_count INTO la_zoc[li_cnt].*  
      LET li_rec_b = li_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET li_rec_b = li_rec_b - 1
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION p_opentb_menu()
 
   WHILE TRUE
      CALL p_opentb_bp("G")
 
      CASE g_action_choice
#        WHEN "reproduce"                       # C.復制
#           IF cl_chk_act_auth() THEN
#              CALL p_opentb_copy()
#           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_opentb_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_opentb_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p_opentb_r()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
#No.FUN-8A0021--begin
#        WHEN "reload"
#           CALL p_opentb_com1(g_zoc01)            
#           CALL p_opentb_com2(g_zoc01)           
#           CALL p_opentb_b_fill(g_wc)           
#No.FUN-8A0021--end
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_opentb_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_zoc.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_opentb_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p_opentb_fetch(p_flag)                  #處理資料的讀取
   DEFINE p_flag   LIKE type_file.chr1,         #處理方式      
          l_abso   LIKE type_file.num10         #絕對的筆數   
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_opentb_b_curs INTO g_zoc01   
      WHEN 'P' FETCH PREVIOUS p_opentb_b_curs INTO g_zoc01   
      WHEN 'F' FETCH FIRST    p_opentb_b_curs INTO g_zoc01   
      WHEN 'L' FETCH LAST     p_opentb_b_curs INTO g_zoc01   
      WHEN '/' 
         IF (NOT g_no_ask) THEN         
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION controlp
                  CALL cl_cmdask()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION about
                  CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_opentb_b_curs INTO g_zoc01
         LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zoc01,SQLCA.sqlcode,0)
      INITIALIZE g_zoc01 TO NULL 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump        
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_opentb_show()
   END IF
END FUNCTION
 
FUNCTION p_opentb_show()                         # 將資料顯示在畫面上
 
   DISPLAY g_zoc01 TO zoc01 
 
   CALL p_opentb_gat03()
 
   CALL p_opentb_com1(g_zoc01)    #No.FUN-8A0050 
 
   CALL p_opentb_com2(g_zoc01)    #No.FUN-8A0050 
 
   CALL p_opentb_b_fill(g_wc)                    # 單身
 
   CALL cl_show_fld_cont()                 
 
END FUNCTION
 
FUNCTION p_opentb_gat03()
 
   LET g_gat03 = ""
 
   SELECT gat03 INTO g_gat03 FROM gat_file
    WHERE gat01=g_zoc01 
      AND gat02=g_lang  
  DISPLAY g_gat03 TO FORMONLY.gat03
 
END FUNCTION
 
FUNCTION p_opentb_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_zoc   RECORD LIKE zoc_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zoc01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM zoc_file
       WHERE zoc01 = g_zoc01
      
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zoc_file",g_zoc01,"",SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE
         CLEAR FORM
         CALL g_zoc.clear()
         CALL p_opentb_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_opentb_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_opentb_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE          
            CALL p_opentb_fetch('/')
         END IF
      END IF
      CALL p_opentb_show()       
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_opentb_b()                            # 單身
   DEFINE l_ac_t          LIKE type_file.num5                # 未取消的ARRAY CNT 
   DEFINE l_n             LIKE type_file.num5                # 檢查重復用        
   DEFINE l_cnt           LIKE type_file.num5                # FUN-7B0081
   DEFINE l_gau01         LIKE type_file.num5                # 檢查重復用        
   DEFINE l_lock_sw       LIKE type_file.chr1                # 單身鎖住否        
   DEFINE p_cmd           LIKE type_file.chr1                # 處理狀態          
   DEFINE l_allow_insert  LIKE type_file.num5             
   DEFINE l_allow_delete  LIKE type_file.num5             
   DEFINE l_count         LIKE type_file.num5             
   DEFINE ls_msg_o        STRING
   DEFINE ls_msg_n        STRING
   DEFINE l_zoc07         LIKE type_file.num5
   DEFINE l_zoc08_1       LIKE type_file.num5
   DEFINE l_zoc08_2       LIKE type_file.num5
   DEFINE l_zoc09         LIKE type_file.num5   
   DEFINE l_zoc01         LIKE  zoc_file.zoc01      
   DEFINE ls_str          STRING
   DEFINE li_inx          LIKE type_file.num5 
   DEFINE l_n2            LIKE type_file.num5                # 檢查輸入的字符長度   #No.FUN-8A0021       
   DEFINE i               LIKE type_file.num5
   DEFINE l_zoc06         LIKE zoc_file.zoc06
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_zoc01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   LET g_forupd_sql= "SELECT zoc02,'','',zoc03,zoc04,zoc12,zoc13,zoc05,zoc06,zoc07,zoc08,zoc09,zoc10,zoc11 ",  #No.FUN-8A0021 add zoc12,zoc13
                     "  FROM zoc_file ",
                     " WHERE zoc01 = ? AND zoc02 = ?  ",
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_opentb_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zoc WITHOUT DEFAULTS FROM tb3.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                 #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zoc_t.* = g_zoc[l_ac].*    #BACKUP
            OPEN p_opentb_bcl USING g_zoc01,g_zoc_t.zoc02           
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_opentb_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_opentb_bcl INTO g_zoc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_opentb_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03 INTO g_zoc[l_ac].gaq03 FROM gaq_file
                WHERE gaq01=g_zoc[l_ac].zoc02
                  AND gaq02=g_lang  
               DISPLAY g_zoc[l_ac].gaq03 TO FORMONLY.gaq03
                 
               SELECT gaq05 INTO g_zoc[l_ac].gaq05 FROM gaq_file
                WHERE gaq01=g_zoc[l_ac].zoc02
                  AND gaq02=g_lang                 
               DISPLAY g_zoc[l_ac].gaq05 TO FORMONLY.gaq05 
            END IF
            CALL cl_show_fld_cont()    
         END IF
         
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zoc[l_ac].* TO NULL      
         LET g_zoc_t.* = g_zoc[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()    
         NEXT FIELD zoc05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO zoc_file(zoc01,zoc02,zoc03,zoc04,zoc05,zoc06,zoc07,zoc08,zoc09,zoc10,
                              zoc11,zoc12,zoc13)                                        #No.FUN-8A0021 add zoc12,zoc13
                      VALUES (g_zoc01,
                              g_zoc[l_ac].zoc02,g_zoc[l_ac].zoc03,g_zoc[l_ac].zoc04,
                              g_zoc[l_ac].zoc05,g_zoc[l_ac].zoc06,g_zoc[l_ac].zoc07,
                              g_zoc[l_ac].zoc08,g_zoc[l_ac].zoc09,g_zoc[l_ac].zoc10,
                              g_zoc[l_ac].zoc11,g_zoc[l_ac].zoc12,g_zoc[l_ac].zoc13)    #No.FUN-8A0021 add zoc12,zoc13
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zoc_file",g_zoc01,g_zoc[l_ac].zoc02,SQLCA.sqlcode,"","",0) 
            CANCEL INSERT
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD zoc02
         SELECT gaq03 INTO g_zoc[l_ac].gaq03 FROM gaq_file
          WHERE gaq01=g_zoc[l_ac].zoc02
            AND gaq02=g_lang  
         DISPLAY g_zoc[l_ac].gaq03 TO FORMONLY.gaq03
          
         SELECT gaq05 INTO g_zoc[l_ac].gaq05 FROM gaq_file
          WHERE gaq01=g_zoc[l_ac].zoc02
            AND gaq02=g_lang                 
         DISPLAY g_zoc[l_ac].gaq05 TO FORMONLY.gaq05
      
      BEFORE FIELD zoc05
         CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",TRUE)
         CALL cl_set_comp_required("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
 
      AFTER FIELD zoc05
         IF cl_null(g_zoc[l_ac].zoc05) THEN
            CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
            CALL cl_err("", 'aap-099', 0)
         END IF 
                                       
         CASE g_zoc[l_ac].zoc05
            #人工輸入
            WHEN "0"
               CALL cl_set_comp_entry("zoc06,zoc09",FALSE)
               #-----No.FUN-890131-----
               IF g_zoc[l_ac].zoc03 MATCHES 'NUMBER' OR g_zoc[l_ac].zoc03 MATCHES 'DATE' THEN
                  CALL cl_set_comp_entry("zoc07,zoc08,zoc10",FALSE)
               END IF
               #-----No.FUN-890131 END-----
            #預設值
            WHEN "1"
               CALL cl_set_comp_entry("zoc07,zoc08,zoc09,zoc10",FALSE)
            #單據編號
            WHEN "2"
               CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
            #預設關聯
            WHEN "3"
               CALL cl_set_comp_entry("zoc06",FALSE)
               CALL cl_set_comp_required("zoc07,zoc08,zoc09",TRUE)
            #計算條件
            WHEN "4"
#No.FUN-8A0021--begin
               IF g_zoc[l_ac].zoc03 = 'NUMBER' THEN
                  CALL cl_set_comp_entry("zoc07,zoc08,zoc09,zoc10",FALSE)
                  CALL cl_set_comp_required("zoc06,",TRUE)
               ELSE
                  CALL cl_set_comp_entry("zoc07,zoc08,zoc09,zoc10",TRUE)
                  CALL cl_set_comp_required("zoc06",FALSE)
                  CALL cl_err(g_zoc[l_ac].zoc05,'azz-534',1)
                  NEXT FIELD zoc05
               END IF
#No.FUN-8A0021--end
            #舊系統單號(唯一值)
            WHEN "5"
#FUN-A40042 --Begin
               CALL p_opentb_chk_zoc(g_zoc01,g_zoc[l_ac].zoc02,g_zoc[l_ac].zoc05)
                  RETURNING l_cnt
               IF l_cnt <> 0 THEN
                  CALL cl_err('','azz-160',0)
                  LET g_zoc[l_ac].zoc05=g_zoc_t.zoc05
                  NEXT FIELD CURRENT
               END IF
#FUN-A40042 --End
               CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
            #存放匯入序號
            WHEN "6"
#No.FUN-8A0021--begin            
              #IF g_zoc[l_ac].zoc03 = 'VARCHAR2' AND g_zoc[l_ac].zoc04 >= '10' THEN                                       #TQC-A10010 mark
               IF (g_zoc[l_ac].zoc03 = 'VARCHAR2' OR g_zoc[l_ac].zoc03 = 'varchar2') AND g_zoc[l_ac].zoc04 >= '10' THEN   #TQC-A10010
                  CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
               ELSE
                  CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",TRUE)
                  CALL cl_err(g_zoc[l_ac].zoc05,'azz-538',1)
                  NEXT FIELD zoc05
               END IF
#No.FUN-8A0021--end            
               CALL cl_set_comp_entry("zoc06,zoc07,zoc08,zoc09,zoc10",FALSE)
#FUN-A40042 --Begin
            WHEN "7"
               CALL p_opentb_chk_zoc(g_zoc01,g_zoc[l_ac].zoc02,g_zoc[l_ac].zoc05)
                  RETURNING l_cnt
               IF l_cnt <> 0 THEN
                  CALL cl_err('','azz-161',0)
                  LET g_zoc[l_ac].zoc05=g_zoc_t.zoc05
                  NEXT FIELD CURRENT
               END IF
               CALL cl_set_comp_entry('zoc07,zoc08',TRUE)
               CALL cl_set_comp_required('zoc07,zoc08',TRUE)
#FUN-A40042 --End
         END CASE
 
         IF g_zoc[l_ac].zoc05 != '2' AND g_zoc[l_ac].zoc05 != '5' AND g_zoc[l_ac].zoc05 != '6'  THEN
            IF g_zoc[l_ac].zoc05 != '1' AND  g_zoc[l_ac].zoc05 != '4' THEN 
               IF g_zoc[l_ac].zoc05='0' THEN
                  LET g_zoc[l_ac].zoc06 = NULL
                  LET g_zoc[l_ac].zoc09 = NULL
                  DISPLAY BY NAME g_zoc[l_ac].zoc06
                  DISPLAY BY NAME g_zoc[l_ac].zoc09 
               ELSE
                  LET g_zoc[l_ac].zoc06 = NULL
                  DISPLAY BY NAME g_zoc[l_ac].zoc06
               END IF
            ELSE 
#No.FUN-8A0021--begin
               IF g_zoc[l_ac].zoc05 ='1' AND g_zoc[l_ac].zoc03 = 'DATE' THEN
                  LET g_zoc[l_ac].zoc06= g_today
                  DISPLAY BY NAME g_zoc[l_ac].zoc06
               END IF
#No.FUN-8A0021--end
               LET g_zoc[l_ac].zoc07 = NULL
               LET g_zoc[l_ac].zoc08 = NULL
               LET g_zoc[l_ac].zoc09 = NULL
               LET g_zoc[l_ac].zoc10 = NULL
               DISPLAY BY NAME g_zoc[l_ac].zoc07 
               DISPLAY BY NAME g_zoc[l_ac].zoc08 
               DISPLAY BY NAME g_zoc[l_ac].zoc09 
               DISPLAY BY NAME g_zoc[l_ac].zoc10 
            END IF 
         ELSE
            LET g_zoc[l_ac].zoc06 = NULL
            LET g_zoc[l_ac].zoc07 = NULL
            LET g_zoc[l_ac].zoc08 = NULL
            LET g_zoc[l_ac].zoc09 = NULL
            LET g_zoc[l_ac].zoc10 = NULL
            DISPLAY BY NAME g_zoc[l_ac].zoc06
            DISPLAY BY NAME g_zoc[l_ac].zoc07 
            DISPLAY BY NAME g_zoc[l_ac].zoc08 
            DISPLAY BY NAME g_zoc[l_ac].zoc09 
            DISPLAY BY NAME g_zoc[l_ac].zoc10 
         END IF
 
#No.FUN-8A0021--begin
      AFTER FIELD zoc06
         IF NOT cl_null(g_zoc[l_ac].zoc06) THEN 
            IF g_zoc[l_ac].zoc03 = 'VARCHAR2' THEN
               LET l_n2= LENGTH(g_zoc[l_ac].zoc06)
               #如果前後是"，扣掉二碼
               IF g_zoc[l_ac].zoc06[1,1]='"' AND g_zoc[l_ac].zoc06[l_n2,l_n2]='"' THEN
                  LET l_n2 = l_n2 -2
               END IF
               IF l_n2 > g_zoc[l_ac].zoc04 THEN
                  CALL cl_err(g_zoc[l_ac].zoc06,'azz-533',1)
                  NEXT FIELD zoc06
               END IF
            END IF
            IF g_zoc[l_ac].zoc03 = 'NUMBER' THEN
               IF g_zoc[l_ac].zoc05 !='4' THEN                       #No.FUN-910030  
                  LET l_n2= LENGTH(g_zoc[l_ac].zoc06)
                  #判斷是否有非數字存在
                  FOR i = 1 TO l_n2
                     LET l_zoc06 = g_zoc[l_ac].zoc06[i,i]
                     IF l_zoc06 NOT MATCHES '[0-9]' THEN
                        CALL cl_err(g_zoc[l_ac].zoc06,'azz-543',1)
                        NEXT FIELD zoc06
                        EXIT FOR
                     END IF
                  END FOR
               END IF                                                #No.FUN-910030
 
               IF g_zoc[l_ac].zoc04 ='5' THEN
                  IF g_zoc[l_ac].zoc06 < -32767 OR g_zoc[l_ac].zoc06 >32767 THEN
                     CALL cl_err(g_zoc[l_ac].zoc06,'azz-535',1)
                     NEXT FIELD zoc06
                  END IF
               END IF
               IF g_zoc[l_ac].zoc04 ='10' THEN
                  IF g_zoc[l_ac].zoc06< -2147483647 OR g_zoc[l_ac].zoc06 >2147483647 THEN
                     CALL cl_err(g_zoc[l_ac].zoc06,'azz-535',1)
                     NEXT FIELD zoc06
                  END IF
               END IF
            END IF
         END IF 
#No.FUN-8A0021--end
 
      AFTER FIELD zoc07
         IF NOT cl_null(g_zoc[l_ac].zoc07) THEN 
#FUN-A40042 --Begin
            IF g_zoc[l_ac].zoc05 = '7' THEN
               SELECT count(*) INTO l_cnt FROM zoc_file
                WHERE zoc01 = g_zoc[l_ac].zoc07
                  AND zoc05 = '5'
               IF l_cnt = 0 THEN
                  CALL cl_err('','azz-162',0)
                  LET g_zoc[l_ac].zoc07 = g_zoc_t.zoc07
                  NEXT FIELD CURRENT
               END IF
            END IF
#FUN-A40042 --End
            #FUN-A70082-----start----
            #SELECT COUNT(*) INTO l_zoc07
            #  FROM gat_file 
            # WHERE gat01=g_zoc[l_ac].zoc07 
            SELECT COUNT(*) INTO l_zoc07
              FROM zta_file
             WHERE zta01=g_zoc[l_ac].zoc07 AND zta02 = 'ds'
            #FUN-A70082-----end-----
            IF l_zoc07=0 THEN
               IF g_zoc[l_ac].zoc07 !='IN' THEN
                  CALL cl_err(g_zoc[l_ac].zoc07,'azz-512',1)
                  NEXT FIELD zoc07	
               END IF
            END IF
         END IF 
          
      AFTER FIELD zoc08
#No.FUN-8A0021--begin
#        IF NOT cl_null(g_zoc[l_ac].zoc07) AND cl_null(g_zoc[l_ac].zoc08) THEN
         IF NOT cl_null(g_zoc[l_ac].zoc07) AND g_zoc[l_ac].zoc07 !='IN' 
            AND cl_null(g_zoc[l_ac].zoc08) THEN
#No.FUN-8A0021--end
            CALL cl_err("", 'aar-011', 0)                    
            NEXT FIELD zoc08
         END IF               
 
         IF NOT cl_null(g_zoc[l_ac].zoc07) AND
            NOT cl_null(g_zoc[l_ac].zoc08) THEN
            SELECT COUNT(*) INTO l_zoc08_1
              FROM gaq_file
             WHERE gaq01=g_zoc[l_ac].zoc08
            IF l_zoc08_1=0 THEN
               CALL cl_err(g_zoc[l_ac].zoc08,'azz-513',1)
               NEXT FIELD zoc08
            END IF

            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構      
            #SELECT COUNT(*) INTO l_zoc08_2
            #  FROM all_tab_columns 
            # WHERE table_name=UPPER(g_zoc[l_ac].zoc07)                            
            #   AND column_name=UPPER(g_zoc[l_ac].zoc08)
            #   AND owner = 'DS'
            SELECT COUNT(*) INTO l_zoc08_2
              FROM sch_file
             WHERE sch01 = g_zoc[l_ac].zoc07  
                AND sch02 = g_zoc[l_ac].zoc08
            #---FUN-A90024---end-------
            
            IF l_zoc08_2=0 THEN
               CALL cl_err(g_zoc[l_ac].zoc08,'azz-514',1)
               NEXT FIELD zoc08
            END IF                
         END IF 
            
      AFTER FIELD zoc09
         IF NOT cl_null(g_zoc[l_ac].zoc09) THEN
            SELECT DISTINCT zoc01 INTO l_zoc01
              FROM zoc_file 
             WHERE zoc02=g_zoc[l_ac].zoc02

            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構   
            #SELECT COUNT(*) INTO l_zoc09
            #  FROM all_tab_columns 
            # WHERE table_name=UPPER(l_zoc01)
            #   AND column_name=UPPER(g_zoc[l_ac].zoc09)	
            #   AND column_name<>UPPER(g_zoc[l_ac].zoc02)
            #   AND owner = 'DS'   
            SELECT COUNT(*) INTO l_zoc09
              FROM sch_file
             WHERE sch01 = l_zoc01
               AND sch02 = g_zoc[l_ac].zoc09
               AND sch02 <> g_zoc[l_ac].zoc02
            #---FUN-A90024---end-------           
            
            IF l_zoc09=0 THEN
               CALL cl_err(g_zoc[l_ac].zoc09,'azz-514', 0)
               NEXT FIELD zoc09                 
            END IF   
         END IF 
          
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zoc_t.zoc02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM zoc_file WHERE zoc01 = g_zoc01
                                   AND zoc02 = g_zoc[l_ac].zoc02
 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zoc_file",g_zoc01,g_zoc_t.zoc02,SQLCA.sqlcode,"","",0)   
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
            LET g_zoc[l_ac].* = g_zoc_t.*
            CLOSE p_opentb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zoc[l_ac].zoc02,-263,1)
            LET g_zoc[l_ac].* = g_zoc_t.*
         ELSE
            UPDATE zoc_file
               SET zoc02 = g_zoc[l_ac].zoc02,
                   zoc03 = g_zoc[l_ac].zoc03,
                   zoc04 = g_zoc[l_ac].zoc04,
                   zoc05 = g_zoc[l_ac].zoc05,
                   zoc06 = g_zoc[l_ac].zoc06,
                   zoc07 = g_zoc[l_ac].zoc07,
                   zoc08 = g_zoc[l_ac].zoc08,
                   zoc09 = g_zoc[l_ac].zoc09,
                   zoc10 = g_zoc[l_ac].zoc10,
                   zoc11 = g_zoc[l_ac].zoc11,
                   zoc12 = g_zoc[l_ac].zoc12,
                   zoc13 = g_zoc[l_ac].zoc13
             WHERE zoc01 = g_zoc01
               AND zoc02 = g_zoc_t.zoc02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zoc_file",g_zoc01,g_zoc_t.zoc02,SQLCA.sqlcode,"","",0)   
               LET g_zoc[l_ac].* = g_zoc_t.*
            ELSE   
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF               
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zoc[l_ac].* = g_zoc_t.*
            END IF
            CLOSE p_opentb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_opentb_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(zoc02) AND l_ac > 1 THEN
            LET g_zoc[l_ac].* = g_zoc[l_ac-1].*
            NEXT FIELD zoc02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zoc07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_zoc[l_ac].zoc07
               CALL cl_create_qry() RETURNING g_zoc[l_ac].zoc07
               DISPLAY BY NAME g_zoc[l_ac].zoc07
               NEXT FIELD zoc07
               
            WHEN INFIELD(zoc08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang
               LET ls_str = g_zoc[l_ac].zoc07
               LET li_inx = ls_str.getIndexOf("_file",1)
               IF li_inx >= 1 THEN
                  LET ls_str = ls_str.subString(1,li_inx - 1)
               ELSE
                  LET ls_str = ""
               END IF
               LET g_qryparam.arg2 = ls_str
               LET g_qryparam.default1 = g_zoc[l_ac].zoc08
               CALL cl_create_qry() RETURNING g_zoc[l_ac].zoc08
               DISPLAY BY NAME g_zoc[l_ac].zoc08
               NEXT FIELD zoc08
            OTHERWISE
               EXIT CASE
         END CASE
               
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
                                                                                           
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   END INPUT
   CALL p_opentb_zoc05ck()
 
   CLOSE p_opentb_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_opentb_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING 
 
#No.FUN-8A0021--begin
#  LET g_sql = "SELECT LOWER(column_name),data_type,data_length,data_scale", 
#              " FROM all_tab_columns ",
#              " WHERE LOWER(table_name) ='",p_zoc01 CLIPPED,"'",
#              " AND owner = UPPER('",g_dbs CLIPPED,"') ",
#              " ORDER BY column_id"                    
#  LET g_sql = "SELECT zoc02,'','',zoc03,zoc04,zoc05,zoc06,zoc07,zoc08,zoc09,zoc10,zoc11",
#              " FROM zoc_file ",
#              " WHERE zoc01 = '",g_zoc01 CLIPPED,"' ",
#              " AND ",p_wc CLIPPED 
#              " ORDER BY zoc02"     
   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構       
   #LET g_sql = "SELECT LOWER(column_name)",
   #            " FROM all_tab_columns ",
   #            " WHERE LOWER(table_name) ='",g_zoc01 CLIPPED,"'",
   #         #  " AND owner = UPPER('",g_dbs CLIPPED,"') ",
   #            " AND owner = 'DS' ",
   #            " ORDER BY column_id"   
   LET g_sql = "SELECT sch02 ",
               " FROM sch_file ",
               " WHERE sch01 ='",g_zoc01 CLIPPED,"'",
               " ORDER BY sch05"   
   #---FUN-A90024---end-------
               
#No.FUN-8A0021--begin
 
   PREPARE p_opentb_prepare_1 FROM g_sql           #
   DECLARE zoc_curs CURSOR FOR p_opentb_prepare_1
 
   CALL g_zoc.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH zoc_curs INTO g_zoc[g_cnt].zoc02   #
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         SELECT zoc03,zoc04,zoc12,zoc13,zoc05,zoc06,zoc07,zoc08,zoc09,zoc10,zoc11         #No.FUN-8A0021 add zoc12,zoc13
           INTO g_zoc[g_cnt].zoc03,
                g_zoc[g_cnt].zoc04,
                g_zoc[g_cnt].zoc12,
                g_zoc[g_cnt].zoc13,
                g_zoc[g_cnt].zoc05,
                g_zoc[g_cnt].zoc06,
                g_zoc[g_cnt].zoc07,
                g_zoc[g_cnt].zoc08,
                g_zoc[g_cnt].zoc09,
                g_zoc[g_cnt].zoc10,
                g_zoc[g_cnt].zoc11 
          FROM zoc_file 
          WHERE zoc02 = g_zoc[g_cnt].zoc02

         LET g_zoc[g_cnt].zoc03 = UPSHIFT(g_zoc[g_cnt].zoc03)   #FUN-A90024
 
         SELECT gaq03 INTO g_zoc[g_cnt].gaq03 FROM gaq_file
          WHERE gaq01=g_zoc[g_cnt].zoc02 
            AND gaq02=g_lang
         DISPLAY g_zoc[g_cnt].gaq03 TO FORMONLY.gaq03
          
         SELECT gaq05 INTO g_zoc[g_cnt].gaq05 FROM gaq_file
          WHERE gaq01=g_zoc[g_cnt].zoc02
            AND gaq02=g_lang               
         DISPLAY g_zoc[g_cnt].gaq05 TO FORMONLY.gaq05
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zoc.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_opentb_zoc05ck()
  DEFINE l_n        LIKE type_file.num5
 
  SELECT COUNT(*) INTO l_n FROM zoc_file
   WHERE zoc01 = g_zoc01
     AND zoc05 = '6'
   IF l_n = 0 THEN
      CALL cl_err(g_zoc01,'azz-521',1)
#     CALL  p_opentb_b()   #No.FUN-8A0050 Mark
   END IF
 
END FUNCTION
 
FUNCTION p_opentb_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_zoc TO tb3.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
#     ON ACTION reproduce                        # C.復制
#        LET g_action_choice='reproduce'
#        EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
        LET g_action_choice='delete'
        EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_opentb_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION previous                         # P.上筆
         CALL p_opentb_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                 
 
      ON ACTION jump                             # 指定筆
         CALL p_opentb_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                 
 
      ON ACTION next                             # N.下筆
         CALL p_opentb_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION last                             # 最終筆
         CALL p_opentb_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#No.FUN-8A0021--begin
#     ON ACTION reload
#        LET g_action_choice="reload"
#        EXIT DISPLAY
#No.FUN-8A0021--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_opentb_copy()
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_new01   LIKE zoc_file.zoc01
   DEFINE l_old01   LIKE zoc_file.zoc01
 
   IF s_shut(0) THEN                            
      RETURN
   END IF
 
   IF g_zoc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")  
   INPUT l_new01 WITHOUT DEFAULTS FROM zoc01 
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(l_new01) THEN
            NEXT FIELD zoc01
         END IF
 
         SELECT COUNT(*) INTO g_cnt FROM zoc_file
          WHERE zoc01 = l_new01  
         IF g_cnt > 0 THEN
            CALL cl_err(l_new01,-239,0)
            NEXT FIELD zoc01
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_zoc01 TO zoc01
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM zoc_file WHERE zoc01=g_zoc01 
       INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_zoc01,"",SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
 
   UPDATE x
      SET zoc01 = l_new01                       # 資料鍵值
 
   INSERT INTO zoc_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","zoc_file",l_new01,"",SQLCA.sqlcode,"","",0) 
      RETURN
   END IF
 
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   LET l_old01 = g_zoc01
   LET g_zoc01 = l_new01
   CALL p_opentb_b()
   #LET g_zoc01 = l_old01 #FUN-C30027
   #CALL p_opentb_show()  #FUN-C30027
END FUNCTION
 
FUNCTION p_opentb_b_fill_2(p_wc)               #BODY FILL UP 無資料時的填充
   DEFINE 
         #p_wc          LIKE  type_file.chr10 
          p_wc         STRING       #NO.FUN-910082
   DEFINE l_zoc01       LIKE  zoc_file.zoc01
  #DEFINE l_data_length LIKE  type_file.num5      #No.FUN-8A0021#TQC-9C0150        
   DEFINE l_data_length STRING     #TQC-9C0150
   DEFINE l_data_scale  LIKE  type_file.num5      #No.FUN-8A0021        
   DEFINE l_str         STRING                    #No.FUN-8A0021
   DEFINE l_data_null    LIKE  type_file.chr1  #確定該欄位是否可以NULL
   DEFINE l_i           LIKE type_file.num5
 
#  LET g_sql = "SELECT LOWER(column_name),'','',data_type,'','','','','','','','',",             #No.FUN-8A0021
#              "to_char(ecode(data_precision,null,data_length,data_precision),'9999.99'),",     #No.FUN-8A0021
#              " data_scale",                                                                    #No.FUN-8A0021
#              " FROM all_tab_columns ",
#              " WHERE LOWER(table_name) ='",p_wc CLIPPED,"'",
#             #" AND owner = UPPER('",g_dbs CLIPPED,"') ",
#              " AND owner = 'DS' ",
#              " ORDER BY column_id"                       #No.FUN-8A0021
 
#  PREPARE p_opentb_prepare_fill_2 FROM g_sql           #預備一下
#  DECLARE curs CURSOR FOR p_opentb_prepare_fill_2
 
#  CALL g_zoc.clear()
 
#  LET g_cnt = 1
#  LET g_rec_b = 0
 
#  LET g_success = 'Y'
#  BEGIN WORK
#  FOREACH curs INTO g_zoc[g_cnt].*,l_data_length,l_data_scale     #單身 ARRAY 填充  #No.FUN-8A0021 add l_data_length,l_data_scale
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        LET g_success = 'N'
#        EXIT FOREACH
#     ELSE
#        SELECT gaq03 INTO g_zoc[g_cnt].gaq03 FROM gaq_file
#         WHERE gaq01=g_zoc[g_cnt].zoc02
#           AND gaq02=g_lang  
#        DISPLAY g_zoc[g_cnt].gaq03 TO FORMONLY.gaq03
#        
#        SELECT gaq05 INTO g_zoc[g_cnt].gaq05 FROM gaq_file
#         WHERE gaq01=g_zoc[g_cnt].zoc02
#           AND gaq02=g_lang               
#        DISPLAY g_zoc[g_cnt].gaq05 TO FORMONLY.gaq05
#        #No.FUN-8A0021--begin
#        IF g_zoc[g_cnt].zoc03 = 'NUMBER' AND NOT cl_null(l_data_scale) THEN
#           IF l_data_scale= 0 THEN
#              LET g_zoc[g_cnt].zoc04= l_data_length
#           ELSE
#              LET l_str = l_data_length USING "<<<<<<<<",",",l_data_scale USING "<<<<<<<<"
#              LET g_zoc[g_cnt].zoc04= l_str CLIPPED
#           END IF
#        ELSE
#           LET g_zoc[g_cnt].zoc04= l_data_length USING "<<<<<<<<"
#        END IF 
#        #No.FUN-8A0021--end
#        LET g_sql = "SELECT distinct LOWER(table_name)",
#                    " FROM all_tab_columns ",
#                    " WHERE LOWER(table_name) ='",p_wc CLIPPED,"'",
#                   #" AND owner = UPPER('",g_dbs CLIPPED,"') "
#                    " AND owner = 'DS' "
#                    
#        PREPARE p_opentb_prepare_fill_3 FROM g_sql           #預備一下
#        DECLARE curs2 CURSOR FOR p_opentb_prepare_fill_3
 
#        EXECUTE  curs2 INTO l_zoc01  
#        
#        LET g_zoc01 = l_zoc01
#       
#        LET g_zoc[g_cnt].zoc05 = '0'
 
#        LET g_sql = "SELECT nullable",
#                    " FROM all_tab_columns ",
#                    " WHERE LOWER(column_name) ='",g_zoc[g_cnt].zoc02 CLIPPED,"'",
#                   #" AND owner = UPPER('",g_dbs CLIPPED,"') "
#                    " AND owner = 'DS' "
#     
#        PREPARE p_opentb_prepare_2 FROM g_sql
#        DECLARE cursnull CURSOR FOR p_opentb_prepare_2
#     
#        EXECUTE cursnull INTO l_data_null  
#     
#           #去系統表里確認該欄位是否是NOT NULL的欄位
#           IF l_data_null = 'Y' THEN
#              LET g_zoc[g_cnt].zoc12 = 'N'
#           ELSE
#              LET g_zoc[g_cnt].zoc12 = 'Y'
#           END IF
 
#           #去系統表里確認該欄位是否是primary key
#           SELECT COUNT(*) INTO l_i FROM user_ind_columns 
#            WHERE index_name = l_index
#              AND lower(column_name)= g_zoc[g_cnt].zoc02
#           IF l_i > 0 THEN
#              LET g_zoc[g_cnt].zoc13 = 'Y'
#           ELSE
#              LET g_zoc[g_cnt].zoc13 = 'N'
#           END IF
 
#        INSERT INTO zoc_file(zoc01,zoc02,zoc03,zoc04,zoc05,zoc06,zoc07,zoc08,zoc09,zoc10,zoc11,zoc12,zoc13)   #No.FUN-8A0021 add zoc12,zoc13
#                     VALUES (g_zoc01,
#                             g_zoc[g_cnt].zoc02,g_zoc[g_cnt].zoc03,g_zoc[g_cnt].zoc04,
#                             g_zoc[g_cnt].zoc05,g_zoc[g_cnt].zoc06,g_zoc[g_cnt].zoc07,
#                             g_zoc[g_cnt].zoc08,g_zoc[g_cnt].zoc09,g_zoc[g_cnt].zoc10,
#                             g_zoc[g_cnt].zoc11,g_zoc[g_cnt].zoc12,g_zoc[g_cnt].zoc13)                        #No.FUN-8A0021 add zoc12,zoc13
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","zoc_file",g_zoc01,g_zoc[l_ac].zoc02,SQLCA.sqlcode,"","",0) 
#           LET g_success = 'N'
#           EXIT FOREACH
#        END IF                          
#     END IF
#     LET g_rec_b = g_rec_b + 1
#     LET g_cnt = g_cnt + 1
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err('',9035,0)
#        LET g_success = 'N'
#        EXIT FOREACH
#     END IF
#  END FOREACH
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#  ELSE
#     ROLLBACK WORK
#  END IF
 
#  CALL g_zoc.deleteElement(g_cnt)
#  LET g_rec_b = g_cnt - 1
#  DISPLAY g_rec_b TO FORMONLY.cn2
 
   #-----No.FUN-8A0050-----
   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #LET g_sql = "SELECT LOWER(table_name) ",
   #            " FROM all_tables ",
   #            " WHERE LOWER(table_name) ='",p_wc CLIPPED,"'",
   #            " AND owner = 'DS' "
   LET g_sql = "SELECT DISTINCT sch01 FROM sch_file ",
               "   WHERE sch01 ='",p_wc CLIPPED,"'"
   #---FUN-A90024---end------- 
 
   PREPARE p_opentb_prepare_fill_2 FROM g_sql           #預備一下
   DECLARE curs CURSOR FOR p_opentb_prepare_fill_2
 
   FOREACH curs INTO l_zoc01
 
      CALL p_opentb_com2(l_zoc01)
 
   END FOREACH
   #-----No.FUN-8A0050 END-----
 
   LET g_gat03 = ""
       
   SELECT gat03 INTO g_gat03 FROM gat_file
    WHERE gat01=g_zoc01
      AND gat02=g_lang   
   DISPLAY g_zoc01 TO zoc01           
   DISPLAY g_gat03 TO FORMONLY.gat03           
 
   DISPLAY ARRAY g_zoc TO tb3.* ATTRIBUTE(UNBUFFERED)
 
   BEFORE DISPLAY 
     EXIT DISPLAY     
   END DISPLAY 
 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_opentb_base()
   DEFINE l_cmd    STRING
   DEFINE l_zob02  LIKE zob_file.zob02
   DEFINE l_str    STRING
 
   LET l_str = NULL
   DECLARE p_opentb_cur3 CURSOR FOR
    SELECT zob02 
      FROM zob_file
     WHERE zob01 = g_argv1
     ORDER BY zob02
 
   FOREACH p_opentb_cur3 INTO l_zob02
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
      LET l_str = l_str,l_zob02,"\'\,\'"
   END FOREACH
 
   LET l_str = l_str.subString(1,l_str.getLength()-2)
   LET l_str = "\'",l_str
 
   LET l_argv1 = l_str
END FUNCTION
 
#NO.FUN-8A0021--begin
 
#更新匯入資料(比對zoc_file里的資料,和系統表資料是否一致)
FUNCTION p_opentb_com1(p_zoc01)
   DEFINE p_zoc01       LIKE  zoc_file.zoc01 
   DEFINE p_zoc02       LIKE  zoc_file.zoc02
   DEFINE l_zoc01       LIKE  zoc_file.zoc01
   DEFINE l_zoc02       LIKE  zoc_file.zoc02
   DEFINE l_zoc04       LIKE  zoc_file.zoc04
   DEFINE l_cnt         LIKE  type_file.num5
   
   
   LET g_sql = "SELECT zoc02 ",  
               " FROM zoc_file ",
               " WHERE zoc01 ='",p_zoc01 CLIPPED,"'"
 
   PREPARE p_opentb_prepare_com1 FROM g_sql           #預備一下
   DECLARE curs5 CURSOR FOR p_opentb_prepare_com1
 
   FOREACH curs5 INTO l_zoc02
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      #SELECT COUNT(LOWER(column_name)) INTO l_cnt
      #  FROM all_tab_columns 
      # WHERE LOWER(table_name) = p_zoc01
      #  #AND owner = UPPER(g_dbs)
      #   AND owner = 'DS'
      #   AND LOWER(column_name) = l_zoc02
      SELECT COUNT(sch02) INTO l_cnt
        FROM sch_file 
       WHERE sch01 = p_zoc01
         AND sch02 = l_zoc02
      #---FUN-A90024---end-------

      IF l_cnt =0  THEN
         DELETE FROM zoc_file
          WHERE zoc01=p_zoc01
            AND zoc02 = l_zoc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] =0 THEN
            CALL cl_err3("del","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
            RETURN
         END IF                          
      END IF
   END FOREACH
 
END FUNCTION
 
#更新匯入資料(比對系統表里的資料,和zoc_file資料是否一致,如有不同則更新或新增)
FUNCTION p_opentb_com2(p_zoc01)
   DEFINE p_zoc01        LIKE  zoc_file.zoc01 
   DEFINE l_zoc02        LIKE  zoc_file.zoc02 
   DEFINE l_zoc03        LIKE  zoc_file.zoc03 
   DEFINE c_zoc03        LIKE  zoc_file.zoc03 
   DEFINE c_zoc04        LIKE  zoc_file.zoc04 
   DEFINE l_length       LIKE  zoc_file.zoc04 
   DEFINE l_data_length1  LIKE  type_file.num5 #TQC-9C0150
   DEFINE l_data_length  string #TQC-9C0150
   DEFINE l_data_scale   LIKE  type_file.num5  
   DEFINE l_str          STRING                 
   DEFINE l_cn           LIKE  type_file.num5    
   DEFINE l_data_null    LIKE  type_file.chr1  #確定該欄位是否可以NULL
   DEFINE l_data_notnull LIKE  type_file.chr1
   DEFINE l_data_pk      LIKE  type_file.chr1
   DEFINE l_i            LIKE  type_file.num5    
   DEFINE c_zoc12        LIKE  zoc_file.zoc12 
   DEFINE c_zoc13        LIKE  zoc_file.zoc13 
   DEFINE l_index        LIKE  type_file.chr8
   DEFINE l_azw05        LIKE  azw_file.azw05   #FUN-A50026
 
#去抓表的primary key的名稱
   SELECT index_name INTO l_index FROM user_indexes 
    WHERE lower(table_name) = p_zoc01 
      AND uniqueness='UNIQUE'

#---FUN-A90024---start-----
#統一用cl_get_column_info來取得欄位資訊
##FUN-9B0082 mod --begin
#CASE g_db_type
#  WHEN "ORA"
#      #LET g_sql = "SELECT LOWER(column_name),data_type,",  
#      LET g_sql = "SELECT LOWER(column_name),'','',",  
#                  #"to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",   
#                  " data_scale,nullable",
#                  " FROM all_tab_columns ",
#                  " WHERE LOWER(table_name) ='",p_zoc01 CLIPPED,"'",
#                  #" AND owner = UPPER('",g_dbs CLIPPED,"') ",
#                  " AND owner = 'DS' ",
#                 " ORDER BY column_id"                    
#  WHEN "IFX"
#      LET g_sql = "SELECT b.colname,b.coltype,'','',''",
#                  "  FROM systables a,syscolumns b",
#                  " WHERE a.tabname = '",p_zoc01 CLIPPED,"'",
#                  "   AND a.tabid = b.tabid",
#                  " ORDER BY colno"
#  WHEN "MSV"
#      LET g_sql = "SELECT a.name,'','',a.scale,a.isnullable ",
#                  "  FROM sys.all_columns a,sys.types b ",
#                  " WHERE a.object_id = object_id('",p_zoc01 CLIPPED,"')",
#                  "   AND a.system_type_id = b.user_type_id ",
#                  " ORDER BY column_id"
#END CASE
##FUN-9B0082 mod --end
   LET g_sql = "SELECT sch02, '', '', '', '' FROM sch_file ",
               "  WHERE sch01 = '",p_zoc01 CLIPPED,"'",
               "  ORDER BY sch05"
#---FUN-A90024---end-------

 
   PREPARE p_opentb_prepare_com2 FROM g_sql           #預備一下
   DECLARE curs3 CURSOR FOR p_opentb_prepare_com2
 
   FOREACH curs3 INTO l_zoc02,l_zoc03,l_data_length1,l_data_scale,l_data_null     #單身ARRAY 填充#TQC-9C0150
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_data_length = l_data_length1  #TQC-9C0150

      #---FUN-A90024---start-----
      #統一用cl_get_column_info來取得欄位資訊
      ##FUN-9B0082 --mod
      #   IF g_db_type="IFX" THEN
      #      LET l_data_scale = 0
      #      IF l_zoc03 = 5 or l_zoc03 = 261 THEN
      #         LET l_data_scale = l_zoc03 mod 16
      #      END IF
      #      IF l_zoc03>=256 THEN
      #          LET l_data_notnull = 'Y'
      #      END IF
      #      CALL s_get_azw05(g_plant) RETURNING l_azw05       #FUN-A50026
      #      #CALL cl_get_column_info(g_dbs,p_zoc01,l_zoc02)
      #      CALL cl_get_column_info(l_azw05,p_zoc01,l_zoc02)  #FUN-A50026
      #         RETURNING l_zoc03,l_data_length
      #      IF l_zoc03 = 'date' OR l_zoc03 = 'DATE' THEN #TQC-9C0150
      #         LET l_data_length = '10'                  #TQC-9C0150
      #      END IF                                       #TQC-9C0150
      #   ELSE
      #     IF g_db_type="MSV" THEN
      #      IF l_data_null=0 THEN
      #         LET l_data_notnull='Y'
      #      ELSE
      #         LET l_data_notnull='N' 
      #      END IF
      #       CALL s_get_azw05(g_plant) RETURNING l_azw05       #FUN-A50026
      #       #CALL cl_get_column_info(g_dbs,p_zoc01,l_zoc02)
      #       CALL cl_get_column_info(l_azw05,p_zoc01,l_zoc02)  #FUN-A50026
      #         RETURNING l_zoc03,l_data_length
      #      IF l_zoc03 = 'date' OR l_zoc03 = 'DATE' THEN #TQC-9C0150
      #         LET l_data_length = '10'                  #TQC-9C0150
      #      END IF                                       #TQC-9C0150
      #     ELSE
      #        CALL s_get_azw05(g_plant) RETURNING l_azw05       #FUN-A50026
      #        #CALL cl_get_column_info(g_dbs,p_zoc01,l_zoc02)
      #        CALL cl_get_column_info(l_azw05,p_zoc01,l_zoc02)  #FUN-A50026 
      #         RETURNING l_zoc03,l_data_length
      #      IF l_zoc03 = 'date' OR l_zoc03 = 'DATE' THEN #TQC-9C0150
      #         LET l_data_length = '10'                  #TQC-9C0150
      #      END IF                                       #TQC-9C0150
      #     END IF     
      #   END IF
      ##FUN-9B0082 --end
      
      ##去系統表里確認該欄位是否是NOT NULL的欄位
      #IF l_data_null = 'Y' THEN
      #   LET l_data_notnull = 'N'
      #ELSE
      #   LET l_data_notnull = 'Y'
      #END IF
      CALL s_get_azw05(g_plant) RETURNING l_azw05
      CALL cl_get_column_info(l_azw05, p_zoc01, l_zoc02)    
           RETURNING l_zoc03, l_data_length  
      LET l_data_notnull = cl_get_column_notnull(p_zoc01, l_zoc02)
      LET l_zoc03 = UPSHIFT(l_zoc03)
      #---FUN-A90024---end-------
      
#去系統表里確認該欄位是否是primary key
      SELECT COUNT(*) INTO l_i FROM user_ind_columns 
       WHERE index_name = l_index
         AND lower(column_name)= l_zoc02
      IF l_i > 0 THEN
         LET l_data_pk = 'Y'
      ELSE
         LET l_data_pk = 'N'
      END IF
      SELECT count(*) INTO l_cn FROM zoc_file 
       WHERE zoc01=p_zoc01
         AND zoc02=l_zoc02
      IF l_cn = 0 THEN
         #---FUN-A90024---start-----
         #IF l_zoc03 = 'NUMBER' AND NOT cl_null(l_data_scale) THEN
         #  #IF l_data_scale= 0 THEN  #TQC-9C0150
         #      LET l_length= l_data_length
         #  #TQC-9C0150--begin--mark--
         #  #ELSE
         #  #   LET l_str = l_data_length USING "<<<<<<<<",",",l_data_scale USING "<<<<<<<<"
         #  #   LET l_length= l_str CLIPPED
         #  #END IF
         #  #TQC-9C0150--end--mark--
         #ELSE
         #   LET l_length = l_data_length USING "<<<<<<<<"
         #END IF
         LET l_length = l_data_length CLIPPED
         #---FUN-A90024---end-------
         INSERT INTO zoc_file(zoc01,zoc02,zoc03,zoc04,zoc05,zoc12,zoc13)
                      VALUES (p_zoc01,l_zoc02,l_zoc03,trim(l_length),'0',l_data_notnull,l_data_pk)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
         END IF                          
      ELSE
         SELECT zoc03,zoc04,zoc12,zoc13 INTO c_zoc03,c_zoc04,c_zoc12,c_zoc13 FROM zoc_file
          WHERE zoc01 = p_zoc01
            AND zoc02 = l_zoc02
         IF cl_null(c_zoc03) OR (l_zoc03 = c_zoc03) THEN
           #IF l_data_scale= 0 OR cl_null(l_data_scale) THEN #TQC-9C0150
               LET l_length= l_data_length
           #TQC-9C0150--begin--mark--
           #ELSE
           #   LET l_str = l_data_length USING "<<<<<<<<",",",l_data_scale USING "<<<<<<<<"
           #   LET l_length= l_str CLIPPED
           #END IF
           #TQC-9C0150--end--mark--
            IF cl_null(c_zoc04) OR (l_length != c_zoc04) THEN
               UPDATE zoc_file SET zoc04 = l_length
                WHERE zoc01=p_zoc01 AND zoc02 = l_zoc02 
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                  CALL cl_err3("upd","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
                  RETURN
               END IF
            END IF
         ELSE
            #---FUN-A90024---start-----
            #IF l_zoc03 = 'NUMBER' AND NOT cl_null(l_data_scale) THEN
            #  #IF l_data_scale= 0 THEN  #TQC-9C0150
            #      LET l_length= l_data_length
            #  #TQC-9C0150--begin--mark--
            #  #ELSE
            #  #   LET l_str = l_data_length USING "<<<<<<<<",",",l_data_scale USING "<<<<<<<<"
            #  #   LET l_length= l_str CLIPPED
            #  #END IF
            #  #TQC-9C0150--end--mark--
            #ELSE
            #   LET l_length = l_data_length USING "<<<<<<<<"
            #END IF
            LET l_length = l_data_length CLIPPED
            #---FUN-A90024---end------- 
            
            UPDATE zoc_file SET zoc03 = l_zoc03,
                                zoc04 = trim(l_length)
             WHERE zoc01=p_zoc01 AND zoc02 = l_zoc02 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
               CALL cl_err3("upd","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
               RETURN
            END IF
         END IF
         IF cl_null(c_zoc12) OR c_zoc12 != l_data_notnull THEN
            UPDATE zoc_file SET zoc12 = l_data_notnull
             WHERE zoc01=p_zoc01 AND zoc02 = l_zoc02 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
               CALL cl_err3("upd","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
               RETURN
            END IF
         END IF
         IF cl_null(c_zoc13) OR c_zoc13 != l_data_pk THEN
            UPDATE zoc_file SET zoc13 = l_data_pk
             WHERE zoc01=p_zoc01 AND zoc02 = l_zoc02 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
               CALL cl_err3("upd","zoc_file",p_zoc01,l_zoc02,SQLCA.sqlcode,"","",0) 
               RETURN
            END IF
         END IF
      END IF
   END FOREACH
 
END FUNCTION
#NO.FUN-8A0021--end
 
#No.FUN-810012
#FUN-A40042 --Begin
FUNCTION p_opentb_chk_zoc(p_zoc01,p_zoc02,p_newvalue)
DEFINE p_zoc01    LIKE zoc_file.zoc01
DEFINE p_zoc02    LIKE zoc_file.zoc02
DEFINE p_newvalue LIKE zoc_file.zoc05
DEFINE l_n        LIKE type_file.num5
   SELECT COUNT(*) INTO l_n
     FROM zoc_file
    WHERE zoc01 = p_zoc01
      AND zoc02 <> p_zoc02
      AND zoc05 = p_newvalue
   RETURN l_n
END FUNCTION
#FUN-A40042 --End

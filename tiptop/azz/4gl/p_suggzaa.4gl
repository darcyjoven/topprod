# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_suggzaa
# Descriptions...: 建議報表列印格式
# Date & Author..: 04/12/02 echo  
# Modify.........: NO.FUN-640073 06/04/09 By Echo 欄位屬性增加「S:品名」、「T:規格」
# Modify.........: No.FUN-660081 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/09/15 By ice 欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: NO.TQC-670054 06/09/13 By Echo 當zaa19為null時,p_zaa同ㄧ筆資料會查出來變成2筆
# Modify.........: NO.TQC-750038 07/05/17 By jacklai 當zaa20,zaa21為null時,p_zaa同ㄧ筆資料會查出來變成2筆
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zaa01                LIKE zaa_file.zaa01,   # 程式代碼
       g_zaa01_t              LIKE zaa_file.zaa01,   # 程式代碼
       g_zaa_t                RECORD                 # 變數舊值
          zaa09               LIKE zaa_file.zaa09,
          zaa02               LIKE zaa_file.zaa02,
          zaa03               LIKE zaa_file.zaa03,
          zaa14               LIKE zaa_file.zaa14,
          zaa05               LIKE zaa_file.zaa05,
          zaa06               LIKE zaa_file.zaa06,
          zaa15               LIKE zaa_file.zaa15,
          zaa07               LIKE zaa_file.zaa07,
          zaa18               LIKE zaa_file.zaa18,    
          zaa08               LIKE zaa_file.zaa08,
          memo                LIKE zab_file.zab05    
                             END RECORD
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE g_zaa07_seq           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_zaa18_seq           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_n                   LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_cnt2                LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_cnt3                LIKE type_file.num10,  #No.FUN-680135 INTEGER
       g_sql                 string, 
       g_rec_b               LIKE type_file.num5,   # 單身筆數  #No.FUN-680135 SMALLINT
       l_ac                  LIKE type_file.num5,   # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
       g_b_flag              LIKE type_file.num5    #FUN-D30034 add
DEFINE g_backup              LIKE type_file.num5    #記錄是否備份儲存(zac_file) #No.FUN-680135 SMALLINT
DEFINE g_zaa01a      LIKE zaa_file.zaa01,
       g_zaa14       LIKE zaa_file.zaa14,           #FUN-640073
       g_len_o       LIKE type_file.num10,          #FUN-640073 #No.FUN-680135 INTEGER
       g_wc          string,
       g_sma119_len  LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE g_zaa_a       DYNAMIC ARRAY OF RECORD
            zaasave  LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
            zaa01    LIKE zaa_file.zaa01,
            gaz03    LIKE gaz_file.gaz03,
            zaa04    LIKE zaa_file.zaa04,
            zaa17    LIKE zaa_file.zaa17,
            zaa10    LIKE zaa_file.zaa10,
            zaa11    LIKE zaa_file.zaa11
            END RECORD
DEFINE g_zaa_b       DYNAMIC ARRAY of RECORD
            zaa09               LIKE zaa_file.zaa09,
            zaa02               LIKE zaa_file.zaa02,
            zaa03               LIKE zaa_file.zaa03,
            zaa14               LIKE zaa_file.zaa14,
            zaa05               LIKE zaa_file.zaa05,
            zaa06               LIKE zaa_file.zaa06,
            zaa15               LIKE zaa_file.zaa15,
            zaa07               LIKE zaa_file.zaa07,
            zaa18               LIKE zaa_file.zaa18,    #FUN-580020
            zaa08               LIKE zaa_file.zaa08,
            memo                LIKE zab_file.zab05     #MOD-530271
            END RECORD
 
MAIN
#   DEFINE   l_time              LIKE type_file.chr8     # 計算被使用時間  #No.FUN-680135 VARCHAR(8) #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-6A0096 --begin --
#     CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
#   RETURNING l_time
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
#No.FUN-6A0096 -- end --
 
   CALL zaa_sug_cs()
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT PROGRAM
   END IF
 
   OPEN WINDOW p_suggzaa_info AT 0,0
       WITH FORM "azz/42f/p_suggzaa_info" ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_suggzaa_info")
 
   LET l_ac = 1
   CALL cl_set_combo_lang("zaa03")
   CALL zaa_sug_fill()
   
   CALL zaa_sug_menu()
 
   LET INT_FLAG = 0
   CALL zaa_backup()
   
   CLOSE WINDOW p_suggzaa
#No.FUN-6A0096 -- begin --
#   CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間) #No.MOD
#   RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
#No.FUN-6A0096 -- end --
END MAIN
 
FUNCTION zaa_sug_menu()
 
    WHILE TRUE
       CALL zaa_sug_bp()
       CASE g_action_choice
         WHEN "re_construct"
            CALL zaa_sug_cs()
            LET l_ac = 1
            CALL zaa_sug_fill()
         WHEN "sug_detail"
            IF cl_chk_act_auth() THEN
               CALL zaa_sug_b(l_ac)
            END IF
         WHEN "load_zaa"
            IF cl_chk_act_auth() THEN
               CALL zaa_sug_load(l_ac)
            END IF
         WHEN "batch_load_zaa"
            IF cl_chk_act_auth() THEN
               CALL zaa_sug_batch_load()
            END IF
         WHEN "save_backup"
            IF cl_chk_act_auth() THEN
               CALL zaa_backup()
            END IF
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
       END CASE
    END WHILE
 
END FUNCTION
 
FUNCTION zaa_sug_bp()
DEFINE l_str            STRING
DEFINE l_total_len      LIKE type_file.num10   #No.FUN-680135 INTEGER
       
       IF g_action_choice = "sug_detail" AND g_b_flag = 1 THEN RETURN END IF  #FUN-D30034 add
       IF g_action_choice != "sug_detail"  THEN
              LET g_action_choice = " "
       END IF
       CALL cl_set_act_visible("accept,cancel", FALSE)
 
       DISPLAY ARRAY g_zaa_a TO s_zaa_a.* ATTRIBUTE(UNBUFFERED,KEEP CURRENT ROW)
 
          BEFORE DISPLAY
              CALL fgl_set_arr_curr(l_ac)
 
          BEFORE ROW
              LET l_ac = ARR_CURR()
              IF l_ac > 0 AND g_action_choice !="sug_detail" THEN
                    CALL zaa_title_fill(l_ac)
              ELSE
                    LET g_action_choice = " "
                    CALL cl_view_report(g_zaa_b) RETURNING l_str,l_total_len
                    DISPLAY l_str TO FORMONLY.content
              END IF
 
          ON ACTION re_construct
             LET g_action_choice="re_construct"
             EXIT DISPLAY
 
          ON ACTION sug_detail
             LET g_action_choice="sug_detail"
             EXIT DISPLAY
 
          ON ACTION load_zaa
             LET g_action_choice="load_zaa"
             EXIT DISPLAY
 
          ON ACTION batch_load_zaa
             LET g_action_choice="batch_load_zaa"
             EXIT DISPLAY
 
          ON ACTION save_backup
             LET g_action_choice="save_backup"
             EXIT DISPLAY
 
          ON ACTION exit                             # Esc.結束
             LET g_action_choice="exit"
             EXIT DISPLAY
 
          ON ACTION cancel
             LET g_action_choice="exit"
             EXIT DISPLAY
      
          ON ACTION controlg
             LET g_action_choice="controlg"
             EXIT DISPLAY
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
      
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION zaa_sug_cs()
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE l_window       ui.Window
DEFINE lnode_item     om.DomNode
DEFINE l_sma119       LIKE sma_file.sma119
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-680135 INTEGER
#FUN-640073
DEFINE l_zaa01        STRING
DEFINE buf            base.StringBuffer,
       l_tok          base.StringTokenizer
DEFINE l_str          STRING
#END FUN-640073
 
   LET g_zaa01_t = NULL
   LET p_row = 0
   LET p_col = 0
   OPEN WINDOW p_suggzaa AT p_row, p_col
        WITH FORM "azz/42f/p_suggzaa" ATTRIBUTE(STYLE = "dialog")
 
   CALL cl_ui_init()
   OPEN WINDOW p_suggzaa_sel AT p_row, p_col
        WITH FORM "azz/42f/p_suggzaa_sel" ATTRIBUTE(STYLE = "dialog")
 
   CALL cl_ui_locale("p_suggzaa_sel")
 
   MENU ""
       ON ACTION newcs
          LET g_action_choice="newcs"
          EXIT MENU
 
       ON ACTION oldcs
          LET g_action_choice="oldcs"
          EXIT MENU
 
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET g_action_choice="exit"
          LET INT_FLAG = 1
          EXIT MENU
#TQC-860017 start
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
#TQC-860017 end
   END MENU
   CLOSE WINDOW p_suggzaa_sel
   IF INT_FLAG THEN
        CLOSE WINDOW p_suggzaa
        RETURN
   END IF
   IF g_action_choice="oldcs" THEN
        LET g_sql = "SELECT zac01,zac02,zac05,zac03,zac04 FROM zac_file "
   ELSE
        SELECT sma119 INTO l_sma119 FROM sma_file where sma00='0'
        CASE l_sma119
           WHEN "0"
              LET g_sma119_len = 20
           WHEN "1"
              LET g_sma119_len = 30
           WHEN "2"
              LET g_sma119_len = 40
        END CASE
        #FUN-640073
        LET g_len_o = g_sma119_len
        DISPLAY g_sma119_len TO FORMONLY.zaa14_len
        LET g_zaa14 = 'N'
        LET l_zaa01 = ''            #FUN-640073
        CALL cl_set_comp_entry("zaa14_len", FALSE)
        WHILE TRUE
          #CONSTRUCT g_wc ON zaa01,zaa14 FROM zaa01,zaa14  
           INPUT l_zaa01,g_zaa14,g_sma119_len                      #FUN-640073
              WITHOUT DEFAULTS FROM zaa01,zaa14,zaa14_len  
        
            ON CHANGE zaa14
               CALL cl_set_comp_entry("zaa14_len",TRUE)
               CASE g_zaa14 
                   WHEN 'N'
                        LET g_sma119_len = g_len_o
                        CALL cl_set_comp_entry("zaa14_len", FALSE)
                   WHEN 'S'
                        LET g_sma119_len = 30
                   WHEN 'T'
                        LET g_sma119_len = 30
               END CASE
               DISPLAY g_sma119_len TO FORMONLY.zaa14_len
 
            ON ACTION controlp
                CASE
                    WHEN INFIELD(zaa01)                     #MOD-530267
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_zz"
                      LET g_qryparam.arg1 =  g_lang
                      LET g_qryparam.state = "c"            #FUN-640073
                      LET g_qryparam.default1= l_zaa01      #FUN-640073
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      LET l_zaa01 = g_qryparam.multiret     #FUN-640073
                      DISPLAY g_qryparam.multiret TO zaa01
                      NEXT FIELD zaa01
                 END CASE
          #END CONSTRUCT
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
#TQC-860017 end          
           END INPUT
           IF g_zaa14 = 'N' THEN
                CALL cl_set_comp_entry("zaa14_len", TRUE)
           END IF
           IF INT_FLAG THEN
                 CLOSE WINDOW p_suggzaa
                 RETURN
           END IF
           LET g_wc = ""
           IF NOT cl_null(l_zaa01) THEN
               #LET l_zaa01 = g_zaa01
                IF l_zaa01.getIndexOf('*',1) > 0 THEN
                    LET buf = base.StringBuffer.create()
                    CALL buf.append(l_zaa01)
                    CALL buf.replace( "*","%", 0)
                    LET l_zaa01 = buf.toString()
                    LET g_wc = "zaa01 like '",l_zaa01 CLIPPED,"' "
                ELSE
                    #FUN-640073
                    IF l_zaa01.getIndexOf('|',1) > 0 THEN
                        LET g_wc = "zaa01 in ("
                        LET l_cnt = 0
                        LET l_tok = base.StringTokenizer.createExt(l_zaa01 CLIPPED,"|","",TRUE)
                        WHILE l_tok.hasMoreTokens()
                              LET l_str = l_tok.nextToken()
                              IF l_cnt = 0 THEN
                                   LET g_wc = g_wc ,"'", l_str,"'"
                                   LET l_cnt = 1
                              ELSE
                                   LET g_wc = g_wc ,",'", l_str,"'"
                              END IF
                        END WHILE
                        LET g_wc = g_wc , ")"
                    ELSE
                       LET g_wc = "zaa01='",l_zaa01 CLIPPED,"' "
                    END IF
                    #END FUN-640073
                END IF
           END IF 
           IF NOT cl_null(g_zaa14) THEN
               IF NOT cl_null(g_wc) THEN
                   LET g_wc = g_wc CLIPPED," AND zaa14='",g_zaa14 CLIPPED,"' "
               ELSE
                   LET g_wc = "zaa14='",g_zaa14 CLIPPED,"' "
               END IF 
           END IF 
          #END FUN-640073
            
           LET g_sql = "select COUNT(*) FROM zaa_file ",
                       " WHERE ", g_wc CLIPPED, " AND zaa09='2' "
           DECLARE p_sugg_count CURSOR FROM g_sql  
           OPEN p_sugg_count
           FETCH p_sugg_count INTO l_cnt
           IF l_cnt > 0 THEN
                  EXIT WHILE
           ELSE
                  CALL cl_err('',100,1)
           END IF
        END WHILE
        LET g_sql = "SELECT UNIQUE zaa01,zaa04,zaa17,zaa10,zaa11 FROM zaa_file ",
                    " WHERE ", g_wc CLIPPED,
                    " AND zaa09='2' ORDER BY zaa01"
   END IF
        
   PREPARE p_sug_prepare FROM g_sql          # 預備一下
   DECLARE p_sug_b_curs                      # 宣告成可捲動的
    SCROLL CURSOR WITH HOLD FOR p_sug_prepare
 
 
   CLOSE WINDOW p_suggzaa
END FUNCTION 
    
FUNCTION zaa_sug_fill()
 
    IF INT_FLAG THEN                              #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
 
   CALL g_zaa_a.clear()
   CALL g_zaa_b.clear()
   DISPLAY '' TO FORMONLY.content         
 
    LET g_cnt = 1
    FOREACH p_sug_b_curs INTO g_zaa_a[g_cnt].zaa01,g_zaa_a[g_cnt].zaa04,g_zaa_a[g_cnt].zaa17,g_zaa_a[g_cnt].zaa10,g_zaa_a[g_cnt].zaa11
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gaz03 INTO g_zaa_a[g_cnt].gaz03 
         FROM gaz_file WHERE gaz01 = g_zaa_a[g_cnt].zaa01 AND gaz02=g_lang
       LET g_zaa_a[g_cnt].zaasave = 'N'
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zaa_a.deleteElement(g_cnt)
    LET g_cnt  = g_cnt - 1
    LET g_cnt2 = 0 
    LET g_cnt3 = g_cnt
    LET g_rec_b = g_cnt2 - 1 #FUN-D30034
    DISPLAY g_cnt  TO FORMONLY.cnt
    DISPLAY g_cnt2 TO FORMONLY.cnt2
    DISPLAY g_cnt3 TO FORMONLY.cnt3
    LET g_backup=FALSE
    
END FUNCTION
 
FUNCTION zaa_title_fill(p_ac)
DEFINE p_ac           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE a,b,c          LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_prog_t       LIKE zz_file.zz01      #No.FUN-680135 VARCHAR(10)
DEFINE l_str          STRING
DEFINE l_total_len    LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_zaa_sort     DYNAMIC ARRAY WITH DIMENSION 3 OF RECORD
                        zaa02  LIKE zaa_file.zaa02,  #序號
                        zaa06  LIKE zaa_file.zaa06,  #隱藏否
                        zaa05  LIKE zaa_file.zaa05   #寬度
                      END RECORD
DEFINE l_zaa05_t      DYNAMIC ARRAY WITH DIMENSION 2 OF INTEGER #備份zaa_file的寬度
DEFINE l_size         LIKE type_file.num10,  #No.FUN-680135 INTEGER
       l_h            LIKE type_file.num10,  #No.FUN-680135 INTEGER
       l_k            LIKE type_file.num10,  #No.FUN-680135 INTEGER
       l_view_cnt     LIKE type_file.num10,  #No.FUN-680135 INTEGER
       l_zaa08_cnt    LIKE type_file.num10,  #No.FUN-680135 INTEGER
       g_sort         DYNAMIC ARRAY WITH DIMENSION 3 OF RECORD
                        zaa02  LIKE zaa_file.zaa02,   #序號
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa07  LIKE zaa_file.zaa07,   #順序
                        column LIKE type_file.num5    #定位點 #No.FUN-680135 SMALLINT
                      END RECORD,
       #FUN-640073
       g_sort_t       DYNAMIC ARRAY OF RECORD
                        zaa15  LIKE zaa_file.zaa15,   #行序
                        zaa03  LIKE zaa_file.zaa03,   #語言
                        zaa07  LIKE zaa_file.zaa07,   #順序
                        zaa05  LIKE zaa_file.zaa05    #寬度
                      END RECORD,
       l_i            LIKE type_file.num5,    #No.FUN-680135 SMALLINT
       l_size_tag     LIKE type_file.num5     #No.FUN-680135 SMALLINT
       #END FUN-640073
DEFINE l_column       LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
    LET g_sql = "SELECT UNIQUE zaa09,zaa02,zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08 FROM zaa_file ",
               " WHERE zaa01='",g_zaa_a[p_ac].zaa01 CLIPPED,
               "'  AND zaa04='",g_zaa_a[p_ac].zaa04 CLIPPED,
               "'  AND zaa17='",g_zaa_a[p_ac].zaa17 CLIPPED,
               "'  AND zaa10='",g_zaa_a[p_ac].zaa10 CLIPPED,
               "'  AND zaa11='",g_zaa_a[p_ac].zaa11 CLIPPED,
               "'  AND zaa09='2' ORDER BY zaa02,zaa03"
 
    PREPARE zaa_title_prepare FROM g_sql          # 預備一下
    DECLARE zaa_title_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR zaa_title_prepare
 
    CALL g_zaa_b.clear()
 
    LET l_cnt = 1
    FOREACH zaa_title_curs INTO g_zaa_b[l_cnt].zaa09,g_zaa_b[l_cnt].zaa02,g_zaa_b[l_cnt].zaa03,
                              g_zaa_b[l_cnt].zaa14,g_zaa_b[l_cnt].zaa05,g_zaa_b[l_cnt].zaa06,
                              g_zaa_b[l_cnt].zaa15,g_zaa_b[l_cnt].zaa07,g_zaa_b[l_cnt].zaa18,
                              g_zaa_b[l_cnt].zaa08
                           
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-640073
       #IF g_zaa_b[l_cnt].zaa14='H' OR g_zaa_b[l_cnt].zaa14='I'    #MOD-530271
       #THEN
       #END IF
       LET l_zaa05_t[g_zaa_b[l_cnt].zaa03+1,g_zaa_b[l_cnt].zaa02]= 0
       IF g_zaa_b[l_cnt].zaa14 = 'H' OR g_zaa_b[l_cnt].zaa14='I' OR   
          g_zaa_b[l_cnt].zaa14 = g_zaa14
       THEN
           CASE  g_zaa_b[l_cnt].zaa14
             WHEN "H"
                  CALL zaa_sug_memo(l_cnt)
             WHEN "I"
                  CALL zaa_sug_memo(l_cnt)
            #WHEN "K"
            #     LET g_zaa_b[l_cnt].zaa05 = g_no_ep
             WHEN "N"
                  IF (g_zaa_b[l_cnt].zaa05 = 20 ) OR (g_zaa_b[l_cnt].zaa05 = 30 ) OR
                     (g_zaa_b[l_cnt].zaa05 = 40 ) 
                  THEN 
                      LET l_zaa05_t[g_zaa_b[l_cnt].zaa03+1,g_zaa_b[l_cnt].zaa02]= g_sma119_len
                  END IF
             WHEN 'S'
                      LET l_zaa05_t[g_zaa_b[l_cnt].zaa03+1,g_zaa_b[l_cnt].zaa02]= g_sma119_len
             WHEN 'T'
                      LET l_zaa05_t[g_zaa_b[l_cnt].zaa03+1,g_zaa_b[l_cnt].zaa02]= g_sma119_len
           END CASE  
        END IF
       #END FUN-640073
       
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zaa_b.deleteElement(l_cnt)
 
    CALL l_zaa_sort.clear()
    FOR l_k = 1 to g_zaa_b.getLength()
        IF (g_zaa_b[l_k].zaa03 IS NULL) OR (g_zaa_b[l_k].zaa15 IS NULL) OR
           (g_zaa_b[l_k].zaa07 IS NULL) OR (g_zaa_b[l_k].zaa05 IS NULL)
        THEN
            CALL cl_err('','azz-122',1)
            RETURN 
        END IF
 
        LET a = g_zaa_b[l_k].zaa03 + 1
        LET b = g_zaa_b[l_k].zaa15
        LET c = g_zaa_b[l_k].zaa07
        LET l_zaa_sort[a,b,c].zaa02 = g_zaa_b[l_k].zaa02
        LET l_zaa_sort[a,b,c].zaa05 = g_zaa_b[l_k].zaa05
        LET l_zaa_sort[a,b,c].zaa06 = g_zaa_b[l_k].zaa06
    END FOR
 
    LET l_view_cnt = 0
    FOR a = 1 to l_zaa_sort.getLength()                  #語言別
      FOR b = 1 to l_zaa_sort[a].getLength()             #行序
        LET l_h = 0
        FOR c = 1 to l_zaa_sort[a,b].getLength()         #順序
            LET l_h = l_h + 1
            LET g_sort[a,b,l_h].zaa02= l_zaa_sort[a,b,c].zaa02
            LET g_sort[a,b,l_h].zaa05= l_zaa_sort[a,b,c].zaa05
            LET g_sort[a,b,l_h].zaa07= c
            IF l_zaa_sort[a,b,c].zaa06 = "N" THEN
              IF l_h = 1 THEN
                 LET g_sort[a,b,l_h].column= 1
              ELSE
                 LET g_sort[a,b,l_h].column=g_sort[a,b,l_h-1].column +
                                            g_sort[a,b,l_h-1].zaa05 + 1
              END IF         
            END IF
        END FOR
      END FOR
      IF l_zaa05_t[a].getLength() THEN
         FOR b = 1 TO g_sort[a].getLength()          #行序
           FOR c = 1 TO g_sort[a,b].getLength()                          #順序
              LET l_size = 0
              IF g_sort[a,b,c].zaa02 IS NOT NULL THEN
                IF l_zaa05_t[a,g_sort[a,b,c].zaa02] > 0 THEN
                     LET l_size = l_zaa05_t[a,g_sort[a,b,c].zaa02] - g_sort[a,b,c].zaa05
                END IF
              END IF
              #FUN-640073
              IF l_size <> 0 THEN
                 FOR l_k = 1 TO g_sort[a].getLength()
                   FOR l_h = 1 TO g_sort[a,l_k].getLength()
                     IF l_zaa_sort[a,b,c].zaa06 = "N" THEN
                       IF (g_sort[a,l_k,l_h].column =  g_sort[a,b,c].column)
                       THEN 
                            IF g_sort[a,l_k,l_h].zaa05 + l_size > 0 THEN
                                LET l_i = l_i + 1
                                LET g_sort_t[l_i].zaa03 = a
                                LET g_sort_t[l_i].zaa15 = l_k
                                LET g_sort_t[l_i].zaa07 = l_h
                                LET g_sort[a,l_k,l_h].zaa05 = g_sort[a,l_k,l_h].zaa05 + l_size
                                EXIT FOR
                             ELSE
                                LET l_size_tag = TRUE
                             END IF
                       ELSE IF l_h <> g_sort[a,l_k].getLength()
                       THEN
                         IF (g_sort[a,l_k,l_h+1].column >= g_sort[a,b,c+1].column)  
                         THEN
                            IF g_sort[a,l_k,l_h].zaa05 + l_size > 0 THEN
                                LET l_i = l_i + 1
                                LET g_sort_t[l_i].zaa03 = a
                                LET g_sort_t[l_i].zaa15 = l_k
                                LET g_sort_t[l_i].zaa07 = l_h
                                LET g_sort[a,l_k,l_h].zaa05 = g_sort[a,l_k,l_h].zaa05 + l_size
                                EXIT FOR
                             ELSE
                                LET l_size_tag = TRUE
                             END IF
                         END IF                  
                       END IF
                       END IF
                     END IF
                   END FOR
                   IF l_size_tag = TRUE THEN 
                       EXIT FOR 
                   END IF
                 END FOR
                 IF l_size_tag = TRUE THEN
                      FOR l_i = 1 TO g_sort_t.getLength()
                           LET g_sort[g_sort_t[l_i].zaa03,g_sort_t[l_i].zaa15,g_sort_t[l_i].zaa07].zaa05 = g_sort[g_sort_t[l_i].zaa03,g_sort_t[l_i].zaa15,g_sort_t[l_i].zaa07].zaa05 - l_size
                      END FOR
                      LET l_size_tag = FALSE
                 END IF
                 LET l_i = 0
                 CALL g_sort_t.clear() 
              END IF
              #END FUN-640073
           END FOR
        END FOR
      END IF
    END FOR
    FOR l_k = 1 to g_zaa_b.getLength()
           LET g_zaa_b[l_k].zaa05 = g_sort[g_zaa_b[l_k].zaa03+1,g_zaa_b[l_k].zaa15,g_zaa_b[l_k].zaa07].zaa05
    END FOR
 
    IF g_action_choice <> "batch_load_zaa" THEN
 
        DISPLAY ARRAY g_zaa_b TO s_zaa_b.* 
          BEFORE DISPLAY
             EXIT DISPLAY
        
          AFTER DISPLAY
             CONTINUE DISPLAY
#TQC-860017 start
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
#TQC-860017 end       
        END DISPLAY
        
        CALL cl_view_report(g_zaa_b) RETURNING l_str,l_total_len
        DISPLAY l_str TO FORMONLY.content
    END IF
END FUNCTION
 
FUNCTION zaa_sug_memo(p_cnt)
DEFINE p_cnt   LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_zab05 LIKE zab_file.zab05
 
    LET g_sql = "SELECT zab05 from zab_file ",
             " WHERE zab01='",g_zaa_b[p_cnt].zaa08 CLIPPED,
             "'  AND zab04='",g_zaa_b[p_cnt].zaa03,"' "
    DECLARE lcurs_qry3 CURSOR FROM g_sql
    LET g_zaa_b[p_cnt].memo = ""
    FOREACH lcurs_qry3 INTO l_zab05
       IF g_zaa_b[p_cnt].memo = " " OR g_zaa_b[p_cnt].memo IS NULL THEN
           LET g_zaa_b[p_cnt].memo = l_zab05
       ELSE
           LET g_zaa_b[p_cnt].memo = g_zaa_b[p_cnt].memo, ASCII 10,l_zab05
       END IF
    END FOREACH
    LET l_zab05 = ""
END FUNCTION
 
 
FUNCTION zaa_sug_b(p_ac)                            # 單身
   DEFINE   p_ac            LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT  #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,    # 檢查重複用  #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否  #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,    # 處理狀態  #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE k,i               LIKE type_file.num10    #No.FUN-680135 INTEGER
   DEFINE l_zaa02           LIKE zaa_file.zaa02
   DEFINE l_zaa07           LIKE zaa_file.zaa07
   DEFINE l_zaa13           LIKE zaa_file.zaa13
   DEFINE l_zab05           LIKE zab_file.zab05
   DEFINE l_num             LIKE type_file.num10    # FUN-580020 #No.FUN-680135 INTEGER
 
   IF s_shut(0) THEN RETURN END IF
   IF p_ac = 0 THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_b_flag = 0  #FUN-D30034 add 
   LET l_ac_t = 0
   LET l_ac = 0
   INPUT ARRAY g_zaa_b WITHOUT DEFAULTS FROM s_zaa_b.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         CALL cl_set_action_active("controlp", FALSE)
 
         BEGIN WORK
         LET p_cmd='u'
         LET g_zaa_t.* = g_zaa_b[l_ac].*    #BACKUP
 #No.MOD-580056 --start
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
         SELECT UNIQUE zaa13 INTO l_zaa13 FROM zaa_file WHERE
             zaa01 = g_zaa_a[p_ac].zaa01 AND zaa04 = g_zaa_a[p_ac].zaa04 
         AND zaa10 = g_zaa_a[p_ac].zaa10 AND zaa11 = g_zaa_a[p_ac].zaa11
         AND zaa17 = g_zaa_a[p_ac].zaa17 
 
         LET l_num=0
         SELECT MAX(zaa15) INTO l_num FROM zaa_file WHERE
             zaa01 = g_zaa_a[p_ac].zaa01 AND zaa04 = g_zaa_a[p_ac].zaa04 
         AND zaa10 = g_zaa_a[p_ac].zaa10 AND zaa11 = g_zaa_a[p_ac].zaa11
         AND zaa17 = g_zaa_a[p_ac].zaa17 
         IF l_num > 1 THEN
            CALL cl_set_comp_entry("zaa18",TRUE)
         ELSE
            INITIALIZE g_zaa_b[l_ac].zaa18 TO NULL
            CALL cl_set_comp_entry("zaa18",FALSE)
         END IF
 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zaa_b[l_ac].* TO NULL       #900423
         LET g_zaa_t.* = g_zaa_b[l_ac].*          #新輸入資料
         LET g_zaa_b[l_ac].zaa06='N'
         LET g_zaa_b[l_ac].zaa14='G'               #MOD-530271
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zaa09
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF (g_zaa_b[l_ac].zaa05 < 1) OR (g_zaa_b[l_ac].zaa05 IS NULL) THEN
             NEXT FIELD zaa05
         END IF
 
      BEFORE FIELD zaa02   
         IF g_zaa_b[l_ac].zaa02 IS NULL OR g_zaa_b[l_ac].zaa02 = 0 THEN
            LET l_n = 1
            FOR k = 1 TO g_zaa_b.getLength()
                  IF g_zaa_b[k].zaa02 > l_n
                  THEN
                       LET l_n = g_zaa_b[k].zaa02 
                  END IF
            END FOR
            LET g_zaa_b[l_ac].zaa02 = l_n + 1
         END IF           
         
      AFTER FIELD zaa02
         IF g_zaa_b[l_ac].zaa02 < 1 THEN
             NEXT FIELD zaa02
         END IF
         IF NOT cl_null(g_zaa_b[l_ac].zaa02) THEN
            IF g_zaa_b[l_ac].zaa02 != g_zaa_t.zaa02 OR g_zaa_t.zaa02 IS NULL THEN
               LET l_n = 0 
               FOR k = 1 TO g_zaa_b.getLength()
                     IF g_zaa_b[k].zaa02 = g_zaa_b[l_ac].zaa02 AND
                        g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND
                        k <> l_ac
                     THEN
                          LET l_n = 1 
                     END IF
               END FOR
               IF l_n > 0 THEN
                  CALL cl_err(g_zaa_b[l_ac].zaa02,-239,0)
                  LET g_zaa_b[l_ac].zaa02 = g_zaa_t.zaa02
                  NEXT FIELD zaa02
               ELSE
                  IF g_zaa_b[l_ac].zaa09 = 2 THEN
                    IF g_zaa_b[l_ac].zaa07 IS NULL OR g_zaa_b[l_ac].zaa07 = 0 THEN
                      LET l_n = 0
                      FOR k = 1 TO g_zaa_b.getLength()
                            IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                             AND g_zaa_b[k].zaa07 > l_n  
                             AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15  
                            THEN
                                  LET l_n = g_zaa_b[k].zaa07
                            END IF
                      END FOR
                      LET g_zaa_b[l_ac].zaa07 = l_n + 1
                    END IF
                    #FUN-580020   先自動給值
                    IF l_num >1 THEN
                        IF g_zaa_b[l_ac].zaa18 IS NULL OR g_zaa_b[l_ac].zaa18 = 0 THEN
                          LET l_n = 0
                          FOR k = 1 TO g_zaa_b.getLength()
                                IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                                 AND g_zaa_b[k].zaa18 > l_n  
                                THEN
                                      LET l_n = g_zaa_b[k].zaa18
                                END IF
                          END FOR
                          LET g_zaa_b[l_ac].zaa18 = l_n + 1
                        END IF
                     END IF
                    #FUN-580020(end)
                    IF g_zaa_b[l_ac].zaa15 IS NULL OR g_zaa_b[l_ac].zaa15 = 0 THEN
                       LET g_zaa_b[l_ac].zaa15 = 1
                    END IF
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD zaa03
         IF NOT cl_null(g_zaa_b[l_ac].zaa03) THEN
            IF g_zaa_b[l_ac].zaa03 != g_zaa_t.zaa03 OR g_zaa_t.zaa03 IS NULL THEN
               LET l_n = 0 
               FOR k = 1 TO g_zaa_b.getLength()
                     IF g_zaa_b[k].zaa02 = g_zaa_b[l_ac].zaa02 AND
                        g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND
                        k <> l_ac
                     THEN
                          LET l_n = 1 
                     END IF
               END FOR
               IF l_n > 0 THEN
                  CALL cl_err(g_zaa_b[l_ac].zaa03,-239,0)
                  LET g_zaa_b[l_ac].zaa03 = g_zaa_t.zaa03
                  NEXT FIELD zaa03
               ELSE
                  LET l_n = 0 
                  FOR k = 1 TO g_zaa_b.getLength()
                        IF g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15 AND
                           g_zaa_b[k].zaa07 = g_zaa_b[l_ac].zaa07 AND
                           g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND
                           k <> l_ac
                        THEN
                             LET l_n = 1 
                        END IF
                  END FOR
                  IF l_n > 0 THEN
                      NEXT FIELD zaa07
                  END IF
 
                  LET l_n = 0 
                  FOR k = 1 TO g_zaa_b.getLength()
                        IF g_zaa_b[k].zaa18 = g_zaa_b[l_ac].zaa18 AND
                           g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND
                           k <> l_ac
                        THEN
                             LET l_n = 1 
                        END IF
                  END FOR
                  IF l_n > 0 THEN
                      NEXT FIELD zaa18
                  END IF
 
               END IF
            END IF
         END IF
        #MOD-530271
      AFTER FIELD zaa14b
       IF g_zaa_b[l_ac].zaa14 != g_zaa_t.zaa14 THEN
           IF g_zaa_b[l_ac].zaa14 = "H" OR g_zaa_b[l_ac].zaa14= "I" THEN
                IF g_zaa_t.zaa14 != "H" AND g_zaa_t.zaa14 != "I" THEN
                    LET l_n = 0
                    FOR k = 1 TO g_zaa_b.getLength()
                          IF g_zaa_b[k].zaa14 MATCHES "[HI]" AND
                             g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND
                             k <> l_ac
                          THEN
                               LET l_n = 1 
                          END IF
                    END FOR
                    IF l_n > 0 THEN
                          CALL cl_err(g_zaa_b[l_ac].zaa14,'azz-109',1)
                          LET g_zaa_b[l_ac].zaa14 = g_zaa_t.zaa14
                          NEXT FIELD zaa14
                    END IF
 
                     CALL zaa_sug_memo(l_ac)           #MOD-530271
                  END IF
            ELSE
              IF g_zaa_b[l_ac].zaa09 = "2" THEN
                IF g_zaa_b[l_ac].zaa05 IS NULL OR g_zaa_b[l_ac].zaa05 = 0 THEN
                 CASE 
                   WHEN g_zaa_b[l_ac].zaa14 = "A"
                       LET g_zaa_b[l_ac].zaa05= 15
                   WHEN g_zaa_b[l_ac].zaa14 = "B"
                       LET g_zaa_b[l_ac].zaa05= 18
                   WHEN g_zaa_b[l_ac].zaa14 = "C"
                       LET g_zaa_b[l_ac].zaa05= 10
                   WHEN g_zaa_b[l_ac].zaa14 = "D"
                       LET g_zaa_b[l_ac].zaa05= 18
                   WHEN g_zaa_b[l_ac].zaa14 = "E"
                       LET g_zaa_b[l_ac].zaa05= 15
                  END CASE  
                 END IF 
               END IF  
             END IF
       END IF
       #MOD-530271
     BEFORE FIELD zaa05,zaa06,zaa15,zaa07,zaa18
        IF g_zaa_b[l_ac].zaa09 = 1 THEN
                NEXT FIELD next
        END IF
        IF INFIELD(zaa15) THEN
         CALL cl_set_comp_entry("zaa18",TRUE)    #FUN-580020
         IF (l_zaa13 = "N") THEN
             IF NOT cl_confirm("azz-087") THEN
                 LET g_zaa_b[l_ac].zaa15 = g_zaa_t.zaa15
                 NEXT FIELD zaa08
             END IF
         END IF
        END IF
        IF INFIELD (zaa07) THEN
         IF (l_zaa13 = "N") THEN
             IF NOT cl_confirm("azz-087") THEN
                 LET g_zaa_b[l_ac].zaa07 = g_zaa_t.zaa07
                 NEXT FIELD zaa08
             END IF
         END IF
        END IF
        #FUN-580020
        IF INFIELD (zaa18) THEN
            IF (l_zaa13 = "N") THEN
                IF NOT cl_confirm("azz-087") THEN
                    LET g_zaa_b[l_ac].zaa18 = g_zaa_t.zaa18
                    NEXT FIELD zaa08
                END IF
            END IF
 
        END IF
        #FUN-580020(end)
      AFTER FIELD zaa05
         IF (g_zaa_b[l_ac].zaa05 < 1) OR (g_zaa_b[l_ac].zaa05 IS NULL) THEN
             NEXT FIELD zaa05
         END IF
 
 
      AFTER FIELD zaa15
         IF NOT cl_null(g_zaa_b[l_ac].zaa15) THEN
            IF g_zaa_b[l_ac].zaa15 != g_zaa_t.zaa15 OR g_zaa_t.zaa15 IS NULL THEN
                LET l_n = 0
                FOR k = 1 TO g_zaa_b.getLength()
                      IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                       AND g_zaa_b[k].zaa07 > l_n  
                       AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15  
                      THEN
                            LET l_n = g_zaa_b[k].zaa07
                      END IF
                END FOR
                LET g_zaa_b[l_ac].zaa07 = l_n + 1
            END IF   
            
               #FUN-580020
            IF l_num > 1 THEN
                CALL cl_set_comp_entry("zaa18",TRUE)
                LET l_n = 0
                FOR k = 1 TO g_zaa_b.getLength()
                      IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                       AND g_zaa_b[k].zaa18 > l_n  
                      THEN
                            LET l_n = g_zaa_b[k].zaa18
                      END IF
                END FOR
                LET g_zaa_b[l_ac].zaa18 = l_n + 1
            ELSE
               INITIALIZE g_zaa_b[l_ac].zaa18 TO NULL
               CALL cl_set_comp_entry("zaa18",FALSE)
            END IF 
         END IF
  
 
      AFTER FIELD zaa07
         IF NOT cl_null(g_zaa_b[l_ac].zaa07) THEN
            IF g_zaa_b[l_ac].zaa15 != g_zaa_t.zaa15 OR
               g_zaa_b[l_ac].zaa07 != g_zaa_t.zaa07 OR g_zaa_t.zaa07 IS NULL 
            THEN
               LET l_n = 0
               FOR k = 1 TO g_zaa_b.getLength()
                     IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND 
                        g_zaa_b[k].zaa02 <> g_zaa_b[l_ac].zaa02 AND
                        g_zaa_b[k].zaa07 = g_zaa_b[l_ac].zaa07 AND
                        g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15 
                     THEN
                           LET l_n = 1
                     END IF
               END FOR
               IF l_n > 0 THEN
                  LET g_n = 0
                  LET g_n = p_zaa_seq(p_cmd,p_ac)
                  IF g_n = 0 THEN
                  LET g_zaa_b[l_ac].zaa07 = g_zaa_t.zaa07
                  NEXT FIELD zaa07
               END IF
                          
               END IF
            END IF
         END IF
      #FUN-580020
      AFTER FIELD zaa18    
         IF NOT cl_null(g_zaa_b[l_ac].zaa18) THEN
            IF g_zaa_b[l_ac].zaa18 != g_zaa_t.zaa18 OR g_zaa_t.zaa18 IS NULL 
            THEN
               LET l_n = 0
               FOR k = 1 TO g_zaa_b.getLength()
                     IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND 
                        g_zaa_b[k].zaa02 <> g_zaa_b[l_ac].zaa02 AND
                        g_zaa_b[k].zaa18 = g_zaa_b[l_ac].zaa18
                     THEN
                           LET l_n = 1
                     END IF
               END FOR
               IF l_n > 0 THEN
                  LET g_n = 0
                  LET g_n = p_zaa_seq1(p_cmd,p_ac)
                  IF g_n = 0 THEN
                    LET g_zaa_b[l_ac].zaa18 = g_zaa_t.zaa18
                    NEXT FIELD zaa18
                  END IF
               END IF
            END IF
         END IF
 
      #FUN-580020(end)
        BEFORE FIELD zaa08
             IF g_zaa_b[l_ac].zaa14='H' OR g_zaa_b[l_ac].zaa14='I' THEN   #MOD-530271
                CALL cl_set_action_active("controlp", TRUE)
            END IF
 
        AFTER FIELD zaa08
             IF g_zaa_b[l_ac].zaa14='H' OR g_zaa_b[l_ac].zaa14='I' THEN    #MOD-530271
               CALL cl_set_action_active("controlp", FALSE)
                CALL zaa_sug_memo(l_ac)           #MOD-530271
             END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zaa_t.zaa02)) AND (NOT cl_null(g_zaa_t.zaa03)) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            LET g_zaa07_seq = g_zaa_b[l_ac].zaa07 - 1
            FOR k = 1 to g_zaa_b.getLength()
                IF g_zaa_b[k].zaa03 = g_zaa_t.zaa03 AND g_zaa_b[k].zaa15 = g_zaa_t.zaa15 
                   AND g_zaa_b[k].zaa07 > g_zaa_b[l_ac].zaa07 
                THEN
                    LET g_zaa_b[k].zaa07 = g_zaa_b[k].zaa07 - 1
                END IF
            END FOR
            #FUN-580020  刪除時更新單行順序
            LET g_zaa18_seq = g_zaa_b[l_ac].zaa18 - 1
            FOR k = 1 to g_zaa_b.getLength()
                IF g_zaa_b[k].zaa03 = g_zaa_t.zaa03 AND 
                   g_zaa_b[k].zaa18 > g_zaa_b[l_ac].zaa18 
                THEN
                    LET g_zaa_b[k].zaa18 = g_zaa_b[k].zaa18 - 1
                END IF
            END FOR
 
            #FUN-580020(end)
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zaa_b[l_ac].* = g_zaa_t.*
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaa_b[l_ac].zaa02,-263,1)
            LET g_zaa_b[l_ac].* = g_zaa_t.*
         END IF
         IF (g_zaa_b[l_ac].zaa05 < 1) OR (g_zaa_b[l_ac].zaa05 IS NULL) THEN
             NEXT FIELD zaa05
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30034
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zaa_b[l_ac].* = g_zaa_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zaa_b.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "sug_detail"
                  LET g_b_flag = 1 
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            EXIT INPUT
         END IF
         IF (g_zaa_b[l_ac].zaa05 < 1) OR (g_zaa_b[l_ac].zaa05 IS NULL) THEN
             NEXT FIELD zaa05
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
 
     ON ACTION controlp 
         CASE
             WHEN INFIELD(zaa08)                     #MOD-530267
                 #MOD-530271
               CALL q_zab(g_zaa_b[l_ac].zaa08,g_zaa_b[l_ac].zaa03) RETURNING g_zaa_b[l_ac].zaa08,g_zaa_b[l_ac].memo
               DISPLAY BY NAME g_zaa[l_ac].zaa08 
               IF g_zaa_b[l_ac].zaa08 = g_zaa_t.zaa08 THEN 
                    LET g_zaa_b[l_ac].memo = g_zaa_t.memo
               END IF
               DISPLAY g_zaa_b[l_ac].memo TO FORMONLY.memo
                 #MOD-530271
               LET INT_FLAG = 0
               NEXT FIELD zaa08
         END CASE
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac > 1 THEN
            LET g_zaa_b[l_ac].* = g_zaa_b[l_ac-1].*
            LET l_n = 1
            FOR k = 1 TO g_zaa_b.getLength()
                  IF g_zaa_b[k].zaa02 > l_n
                  THEN
                       LET l_n = g_zaa_b[k].zaa02 
                  END IF
            END FOR
            LET g_zaa_b[l_ac].zaa02 = l_n + 1
 
            LET l_n = 0
            FOR k = 1 TO g_zaa_b.getLength()
                  IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                   AND g_zaa_b[k].zaa07 > l_n  
                   AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15  
                  THEN
                        LET l_n = g_zaa_b[k].zaa07
                  END IF
            END FOR
            LET g_zaa_b[l_ac].zaa07 = l_n + 1
 
            #FUN-580020   先自動給值
            IF l_num >1 THEN
                 LET l_n = 0
                 FOR k = 1 TO g_zaa_b.getLength()
                       IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                        AND g_zaa_b[k].zaa18 > l_n  
                       THEN
                             LET l_n = g_zaa_b[k].zaa18
                       END IF
                 END FOR
                 LET g_zaa_b[l_ac].zaa18 = l_n + 1
            END IF
 
            NEXT FIELD zaa09
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   LET l_ac = p_ac
END FUNCTION
 
FUNCTION zaa_sug_load(p_ac)
DEFINE p_ac              LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_zaa13           LIKE zaa_file.zaa13
DEFINE l_zaa12           LIKE zaa_file.zaa12
DEFINE l_zaa16           LIKE zaa_file.zaa16
DEFINE l_zaa19           LIKE zaa_file.zaa19           #TQC-670054
DEFINE l_zaa20           LIKE zaa_file.zaa20           #NO.TQC-750038
DEFINE l_zaa21           LIKE zaa_file.zaa21           #NO.TQC-750038
DEFINE l_num             LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_i               LIKE type_file.num10    #No.FUN-680135 INTEGER
 
       IF NOT cl_confirm("azz-119") THEN
          RETURN
       END IF
 
       BEGIN WORK
 
       SELECT UNIQUE zaa12,zaa13,zaa16,zaa19,zaa20,zaa21 INTO l_zaa12,l_zaa13,l_zaa16,l_zaa19,l_zaa20,l_zaa21  #TQC-670054 #NO.TQC-750038
          FROM zaa_file WHERE zaa01 = g_zaa_a[p_ac].zaa01 
          AND zaa04 = g_zaa_a[p_ac].zaa04 AND zaa10 = g_zaa_a[p_ac].zaa10 
          AND zaa11 = g_zaa_a[p_ac].zaa11 AND zaa17 = g_zaa_a[p_ac].zaa17 
 
       DELETE FROM zaa_file WHERE zaa01 = g_zaa_a[p_ac].zaa01 
          AND zaa04 = g_zaa_a[p_ac].zaa04 AND zaa10 = g_zaa_a[p_ac].zaa10 
          AND zaa11 = g_zaa_a[p_ac].zaa11 AND zaa17 = g_zaa_a[p_ac].zaa17 
          AND zaa09 = '2'
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
#               CALL cl_err('DELETE zaa_file:',SQLCA.sqlcode,0)   #No.FUN-660081
                CALL cl_err3("del","zaa_file",g_zaa_a[p_ac].zaa01,g_zaa_a[p_ac].zaa04,SQLCA.sqlcode,"","DELETE zaa_file",0)   #No.FUN-660081
                ROLLBACK WORK
       ELSE
              FOR l_i = 1 TO g_zaa_b.getLength()
                  INSERT INTO zaa_file(zaa01,zaa02,zaa03,zaa04,zaa05,zaa06,zaa07,zaa08,
                                       zaa09,zaa10,zaa11,zaa12,zaa13,zaa16,zaa17,zaa14,
                                       zaa15,zaa18,zaa19,zaa20,zaa21) #MOD-530271 #FUN-560079 #FUN-580020 #NO.TQC-750038
                      VALUES (g_zaa_a[p_ac].zaa01, g_zaa_b[l_i].zaa02, g_zaa_b[l_i].zaa03,
                              g_zaa_a[p_ac].zaa04, g_zaa_b[l_i].zaa05, g_zaa_b[l_i].zaa06,
                              g_zaa_b[l_i].zaa07,  g_zaa_b[l_i].zaa08, g_zaa_b[l_i].zaa09,
                              g_zaa_a[p_ac].zaa10, g_zaa_a[p_ac].zaa11,
                              l_zaa12, l_zaa13, l_zaa16,
                              g_zaa_a[p_ac].zaa17, g_zaa_b[l_i].zaa14,
                              g_zaa_b[l_i].zaa15,  g_zaa_b[l_i].zaa18,l_zaa19,l_zaa20,l_zaa21)   #TQC-670054 #NO.TQC-750038
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('INSERT zaa_file',SQLCA.sqlcode,0)   #No.FUN-660081
                     CALL cl_err3("ins","zaa_file",g_zaa_a[p_ac].zaa01,g_zaa_b[l_i].zaa02,SQLCA.sqlcode,"","INSERT zaa_file",0)   #No.FUN-660081
                     ROLLBACK WORK
                     RETURN
                  END IF
              END FOR
              LET g_zaa_a[p_ac].zaasave = 'Y' 
              DISPLAY g_zaa_a[p_ac].zaasave TO FORMONLY.zaasave
              LET g_backup=FALSE
 
              LET g_cnt2 = g_cnt2 + 1
              LET g_cnt3 = g_cnt3 - 1
              DISPLAY g_cnt2 TO FORMONLY.cnt2
              DISPLAY g_cnt3 TO FORMONLY.cnt3
 
              COMMIT WORK
       END IF
END FUNCTION
 
FUNCTION zaa_sug_batch_load()
DEFINE l_k              LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_zaa13          LIKE zaa_file.zaa13
DEFINE l_zaa12          LIKE zaa_file.zaa12
DEFINE l_zaa16          LIKE zaa_file.zaa16
DEFINE l_zaa19          LIKE zaa_file.zaa19     #NO.TQC-750038
DEFINE l_zaa20          LIKE zaa_file.zaa20     #NO.TQC-750038
DEFINE l_zaa21          LIKE zaa_file.zaa21     #NO.TQC-750038
DEFINE l_num            LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_i              LIKE type_file.num10    #No.FUN-680135 INTEGER
 
       IF NOT cl_confirm("azz-119") THEN
          RETURN
       END IF
 
       BEGIN WORK
 
       FOR l_k = 1 TO g_zaa_a.getLength()
 
           CALL zaa_title_fill(l_k)
 
           SELECT UNIQUE zaa12,zaa13,zaa16,zaa19,zaa20,zaa21 INTO l_zaa12,l_zaa13,l_zaa16,l_zaa19,l_zaa20,l_zaa21   #NO.TQC-750038
              FROM zaa_file WHERE zaa01 = g_zaa_a[l_k].zaa01 
              AND zaa04 = g_zaa_a[l_k].zaa04 AND zaa10 = g_zaa_a[l_k].zaa10 
              AND zaa11 = g_zaa_a[l_k].zaa11 AND zaa17 = g_zaa_a[l_k].zaa17 
    
           DELETE FROM zaa_file WHERE zaa01 = g_zaa_a[l_k].zaa01 
              AND zaa04 = g_zaa_a[l_k].zaa04 AND zaa10 = g_zaa_a[l_k].zaa10 
              AND zaa11 = g_zaa_a[l_k].zaa11 AND zaa17 = g_zaa_a[l_k].zaa17 
              AND zaa09 = '2'
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
#                   CALL cl_err('DELETE zaa_file:',SQLCA.sqlcode,0)   #No.FUN-660081
                    CALL cl_err3("del","zaa_file",g_zaa_a[l_k].zaa01,g_zaa_a[l_k].zaa04,SQLCA.sqlcode,"","DELETE zaa_file",0)   #No.FUN-660081
                    ROLLBACK WORK
                    RETURN
           ELSE
                  FOR l_i = 1 TO g_zaa_b.getLength()
                      INSERT INTO zaa_file(zaa01,zaa02,zaa03,zaa04,zaa05,zaa06,zaa07,zaa08,
                                            zaa09,zaa10,zaa11,zaa12,zaa13,zaa16,zaa17,zaa14,zaa15,zaa18,zaa19,zaa20,zaa21) #MOD-530271 #FUN-560079 #FUN-580020 #NO.TQC-750038
                          VALUES (g_zaa_a[l_k].zaa01, g_zaa_b[l_i].zaa02, g_zaa_b[l_i].zaa03,
                                  g_zaa_a[l_k].zaa04, g_zaa_b[l_i].zaa05, g_zaa_b[l_i].zaa06,
                                  g_zaa_b[l_i].zaa07,  g_zaa_b[l_i].zaa08, g_zaa_b[l_i].zaa09,
                                  g_zaa_a[l_k].zaa10, g_zaa_a[l_k].zaa11,
                                  l_zaa12, l_zaa13, l_zaa16,
                                  g_zaa_a[l_k].zaa17, g_zaa_b[l_i].zaa14,
                                  g_zaa_b[l_i].zaa15,  g_zaa_b[l_i].zaa18, l_zaa19, l_zaa20, l_zaa21) #NO.TQC-750038
                      IF SQLCA.sqlcode THEN
#                        CALL cl_err('INSERT zaa_file',SQLCA.sqlcode,0)   #No.FUN-660081
                         CALL cl_err3("ins","zaa_file",g_zaa_a[l_k].zaa01,g_zaa_b[l_i].zaa02,SQLCA.sqlcode,"","INSERT zaa_file",0)   #No.FUN-660081
                         ROLLBACK WORK
                         RETURN
                      END IF
                  END FOR
                  LET g_zaa_a[l_k].zaasave = 'Y' 
                  DISPLAY g_zaa_a[l_k].zaasave TO FORMONLY.zaasave
                  LET g_backup=FALSE
           END IF
       END  FOR
       LET g_cnt2 = g_cnt
       LET g_cnt3 = 0
       DISPLAY g_cnt2 TO FORMONLY.cnt2
       DISPLAY g_cnt3 TO FORMONLY.cnt3
       COMMIT WORK
END FUNCTION
 
FUNCTION zaa_backup()
DEFINE l_cnt       LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_i         LIKE type_file.num10    #No.FUN-680135 INTEGER
 
     SELECT COUNT(*) INTO l_cnt FROM zac_file 
     IF g_backup = TRUE THEN
          RETURN
     END IF
     FOR l_i = 1 to g_zaa_a.getLength()
           IF g_zaa_a[l_i].zaasave <> 'Y' THEN
               IF g_action_choice="exit" THEN
                  IF NOT cl_confirm("azz-125") THEN
                     RETURN
                  END IF
                  LET g_action_choice = " " 
               END IF
                 
               IF l_cnt > 0 THEN
                 IF NOT cl_confirm("azz-124") THEN
                    RETURN
                 END IF
                 DELETE FROM zac_file 
                 IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
#                    CALL cl_err('Delete zac_file failed:', SQLCA.SQLCODE, 1)   #No.FUN-660081
                     CALL cl_err3("del","zac_file","","",SQLCA.sqlcode,"","Delete zac_file failed", 1)   #No.FUN-660081)   #No.FUN-660081
                     RETURN         #MOD-580132
                 END IF
                 LET l_cnt = 0 
               END IF
               INSERT INTO zac_file(zac01,zac02,zac03,zac04,zac05)
                  VALUES (g_zaa_a[l_i].zaa01, g_zaa_a[l_i].zaa04,g_zaa_a[l_i].zaa10,
                          g_zaa_a[l_i].zaa11, g_zaa_a[l_i].zaa17)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
#                  CALL cl_err('Insert zac_file failed:', SQLCA.SQLCODE, 1)   #No.FUN-660081
                   CALL cl_err3("ins","zac_file",g_zaa_a[l_i].zaa01,g_zaa_a[l_i].zaa04,SQLCA.sqlcode,"","Insert zac_file failed:", 1)   #No.FUN-660081)   #No.FUN-660081
                   RETURN         #MOD-580132
               END IF
               LET g_backup = TRUE
           END IF
     END FOR
     SELECT COUNT(*) INTO l_cnt FROM zac_file 
END FUNCTION
 
FUNCTION p_zaa_seq(p_cmd,p_ac)
DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE p_ac      LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE k         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_zaa02   LIKE zaa_file.zaa02
DEFINE l_zaa07   LIKE zaa_file.zaa07
    OPTIONS
        FORM        LINE FIRST + 1,
        MESSAGE     LINE LAST,
        PROMPT      LINE LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
             OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
                  ATTRIBUTE (STYLE = g_win_style)
             CALL cl_ui_locale("p_zaa_1")
 
             INPUT g_n WITHOUT DEFAULTS FROM a 
                  ON ACTION cancel
                     LET g_n = 0
                     EXIT INPUT
                     
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE INPUT
                  
              END INPUT
              BEGIN WORK
              CASE g_n
                WHEN 1   #欄位順序調換
                  IF p_cmd = "a" THEN
                      LET g_zaa_t.zaa07 = 0
                      FOR k = 1 TO g_zaa_b.getLength()
                            IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 
                             AND g_zaa_b[k].zaa07 > g_zaa_t.zaa07  
                             AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15  
                            THEN
                                  LET g_zaa_t.zaa07 = g_zaa_b[k].zaa07
                            END IF
                      END FOR
                      LET g_zaa_t.zaa07 = g_zaa_t.zaa07 + 1
                      LET g_zaa_t.zaa15 = g_zaa_b[l_ac].zaa15 
                  END IF
                  FOR k = 1 to g_zaa_b.getLength()
                      IF (k <> l_ac) AND g_zaa_b[k].zaa03=g_zaa_b[l_ac].zaa03
                        AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15 
                        AND g_zaa_b[k].zaa07 = g_zaa_b[l_ac].zaa07 
                      THEN
                        LET g_zaa_b[k].zaa07 = g_zaa_t.zaa07
                        LET g_zaa_b[k].zaa15 = g_zaa_t.zaa15
                        EXIT FOR
                      END IF
                  END FOR
                 
                 IF p_cmd = "u" THEN                                      
                   LET g_zaa_t.zaa07 = g_zaa_b[l_ac].zaa07
                   LET g_zaa_t.zaa15 = g_zaa_b[l_ac].zaa15
                 END IF
             
                WHEN 2         #以下欄位順序自動往後遞增一位
                   FOR k = 1 to g_zaa_b.getLength()
                     IF (k <> l_ac) AND g_zaa_b[k].zaa03=g_zaa_b[l_ac].zaa03
                      AND g_zaa_b[k].zaa15 = g_zaa_b[l_ac].zaa15 
                      AND g_zaa_b[k].zaa07 >= g_zaa_b[l_ac].zaa07
                      AND ((g_zaa_b[k].zaa07 <= g_zaa_t.zaa07) OR
                           (g_zaa_t.zaa07 <= g_zaa_b[l_ac].zaa07))
                     THEN
                        LET g_zaa_b[k].zaa07 = g_zaa_b[k].zaa07 + 1
                     END IF
                   END FOR
                   LET g_zaa_t.zaa07 = g_zaa_b[l_ac].zaa07
                   LET g_zaa_t.zaa15 = g_zaa_b[l_ac].zaa15
                   
              END CASE
              CLOSE WINDOW p_zaa_1
              RETURN g_n
END FUNCTION
 
FUNCTION p_zaa_seq1(p_cmd,p_ac)
DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE p_ac      LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE k         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE l_zaa02   LIKE zaa_file.zaa02
DEFINE l_zaa18   LIKE zaa_file.zaa18
    OPTIONS
        FORM        LINE FIRST + 1,
        MESSAGE     LINE LAST,
        PROMPT      LINE LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
        OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
            ATTRIBUTE (STYLE = g_win_style)
        CALL cl_ui_locale("p_zaa_1")
 
        INPUT g_n WITHOUT DEFAULTS FROM a
            ON ACTION cancel
               LET g_n=0
               EXIT INPUT
            ON ACTION g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
        END INPUT
        BEGIN WORK
        CASE g_n
           WHEN 1
             IF p_cmd = "a" THEN
               LET g_zaa_t.zaa18 = 0
               FOR k = 1 TO g_zaa_b.getLength()
                     IF g_zaa_b[k].zaa03 = g_zaa_b[l_ac].zaa03 AND 
                        g_zaa_b[k].zaa18 > g_zaa_t.zaa18 
                     THEN
                           LET g_zaa_t.zaa18 = g_zaa_b[k].zaa18
                     END IF
               END FOR
               LET g_zaa_t.zaa18 = g_zaa_t.zaa18 + 1
             END IF
 
             FOR k = 1 to g_zaa_b.getLength()
                 IF (k <> l_ac) AND g_zaa_b[k].zaa03=g_zaa_b[l_ac].zaa03 
                   AND g_zaa_b[k].zaa18 = g_zaa_b[l_ac].zaa18 
                 THEN
                    LET g_zaa_b[k].zaa18 = g_zaa_t.zaa18
                    EXIT FOR
                 END IF
             END FOR
             IF p_cmd = "u" THEN
               LET g_zaa_t.zaa18 = g_zaa_b[l_ac].zaa18
             END IF
           WHEN 2
             FOR k = 1 to g_zaa_b.getLength()
                 IF (k <> l_ac) AND g_zaa_b[k].zaa03=g_zaa_b[l_ac].zaa03
                    AND g_zaa_b[k].zaa18 >= g_zaa_b[l_ac].zaa18
                    AND ((g_zaa_b[k].zaa18 <= g_zaa_t.zaa18) OR
                         (g_zaa_t.zaa18 <= g_zaa_b[l_ac].zaa18))
                 THEN
                     LET g_zaa_b[k].zaa18 = g_zaa_b[k].zaa18 + 1
                 END IF
             END FOR
             LET g_zaa_t.zaa18 = g_zaa_b[l_ac].zaa18
        END CASE
        CLOSE WINDOW p_zaa_1
        RETURN g_n
 
END FUNCTION

# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: csmi100.4gl
# Descriptions...: 光板拆lot设置，依据客户

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
type tc_sma record
    tc_sma02 like tc_sma_file.tc_sma02,
    tc_sma02_desc  varchar(500),
    tc_sma03 like tc_sma_file.tc_sma03,
    tc_sma04 like tc_sma_file.tc_sma04,
    tc_sma05 like tc_sma_file.tc_sma05,
    tc_sma06 like tc_sma_file.tc_sma06,
    tc_sma07 like tc_sma_file.tc_sma07,
    tc_sma08 like tc_sma_file.tc_sma08,
    tc_sma09 like tc_sma_file.tc_sma09,
    tc_sma10 like tc_sma_file.tc_sma10,
    tc_sma11 like tc_sma_file.tc_sma11,
    tc_sma12 like tc_sma_file.tc_sma12,
    tc_sma13 like tc_sma_file.tc_sma13,
    tc_sma14 like tc_sma_file.tc_sma14,
    tc_sma15 like tc_sma_file.tc_sma15,
    tc_sma16 like tc_sma_file.tc_sma16,
    tc_sma17 like tc_sma_file.tc_sma17,
    tc_sma18 like tc_sma_file.tc_sma18,
    tc_sma19 like tc_sma_file.tc_sma19,
    tc_sma20 like tc_sma_file.tc_sma20,
    tc_smauser like tc_sma_file.tc_smauser,
    tc_smamod  like tc_sma_file.tc_smamod
end record
DEFINE 
    g_tc_sma01         LIKE tc_sma_file.tc_sma01,
    g_tc_sma03         LIKE tc_sma_file.tc_sma03,
    g_tc_sma02         LIKE tc_sma_file.tc_sma02,
    g_tc_sma04         LIKE tc_sma_file.tc_sma04,
    g_tc_sma01_t       LIKE tc_sma_file.tc_sma01,
    g_tc_sma02_t       LIKE tc_sma_file.tc_sma02,
    g_tc_sma03_t       LIKE tc_sma_file.tc_sma03,
    g_tc_sma           DYNAMIC ARRAY OF tc_sma ,
    g_tc_sma_t         tc_sma ,
    g_wc,g_wc2,g_sql     STRING,     
    g_rec_b         LIKE type_file.num5,      #單身筆數 
    g_ss            LIKE type_file.chr1,      
    g_s             LIKE type_file.chr1,       #料件處理狀況  
    l_flag          LIKE type_file.chr1,     
    g_buf           LIKE tc_sma_file.tc_sma01,  
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT 
    l_cmd           LIKE type_file.chr1000  
DEFINE p_row,p_col          LIKE type_file.num5 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5 
 
DEFINE   g_sql_tmp       STRING       
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_jump         LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5    
DEFINE   l_sql          STRING                 
DEFINE   g_str          STRING                
DEFINE   l_table        STRING               
DEFINE  g_tc_sma_item    DYNAMIC ARRAY of RECORD        # 程式變數
            tc_sma03          LIKE tc_sma_file.tc_sma03,
            tc_sma05          LIKE tc_sma_file.tc_sma05
                      END RECORD,
         g_tc_sma_item_t           RECORD                 # 變數舊值
            tc_sma03          LIKE tc_sma_file.tc_sma03,
            tc_sma05          LIKE tc_sma_file.tc_sma05
                      END RECORD,
         g_cnt2                LIKE type_file.num5, 
         g_rec_b1              LIKE type_file.num5,     # 單身筆數              #No.FUN-680135 SMALLINT
         l_ac1                 LIKE type_file.num5      # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT

define g_argv1  varchar(20)
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF    #FUN-A10109
   let g_argv1 = ARG_VAL(1)
   let g_prog = g_argv1
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time              
 
   LET p_row = 2 LET p_col = 12
 
   OPEN WINDOW i100_w AT p_row,p_col              #顯示畫面
        WITH FORM "csm/42f/csmi100"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   let g_prog = g_argv1 
   let g_tc_sma01 = g_argv1
   call i100_set_dny_combo()
   call i100_b_fill(" 1=1") #darcy:2024/11/29 add
   CALL i100_menu()
 
   CLOSE WINDOW i100_w              #結束畫面
   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
        RETURNING g_time             
END MAIN
 
#QBE 查詢資料
FUNCTION i100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
   CLEAR FORM                             #清除畫面
   call i100_set_dny_combo() 
   CALL g_tc_sma.clear()
   CALL cl_set_head_visible("","YES")       
 
    CONSTRUCT g_wc ON  tc_sma02,tc_sma03,tc_sma04,tc_sma05,tc_sma06,
                       tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,
                       tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,
                       tc_sma17,tc_sma18,tc_sma19,tc_sma20,tc_smauser,tc_smamod
            FROM s_tc_sma[1].tc_sma02,s_tc_sma[1].tc_sma03,s_tc_sma[1].tc_sma04,s_tc_sma[1].tc_sma05,s_tc_sma[1].tc_sma06,
                 s_tc_sma[1].tc_sma07,s_tc_sma[1].tc_sma08,s_tc_sma[1].tc_sma09,s_tc_sma[1].tc_sma10,s_tc_sma[1].tc_sma11,
                 s_tc_sma[1].tc_sma12,s_tc_sma[1].tc_sma13,s_tc_sma[1].tc_sma14,s_tc_sma[1].tc_sma15,s_tc_sma[1].tc_sma16,
                 s_tc_sma[1].tc_sma17,s_tc_sma[1].tc_sma18,s_tc_sma[1].tc_sma19,s_tc_sma[1].tc_sma20,s_tc_sma[1].tc_smauser,s_tc_sma[1].tc_smamod
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
            ON ACTION controlp
               CASE 
                  WHEN INFIELD(tc_sma02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gat"
                       LET g_qryparam.arg1 = g_lang
                       LET g_qryparam.state= "c"
#                       LET g_qryparam.where= " gat07 = 'T' "  #FUN-A40008
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_sma06
                       NEXT FIELD tc_sma06
               END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about     
               CALL cl_about()   
            
            ON ACTION help        
               CALL cl_show_help() 
            
            ON ACTION controlg     
               CALL cl_cmdask()   
    
            ON ACTION qbe_save
               CALL cl_qbe_save()
    END CONSTRUCT                  
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    
    if g_prog = 'csmi100' then
        LET g_sql = "SELECT UNIQUE tc_sma01 FROM tc_sma_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY tc_sma01"
    ELSE
        LET g_sql = "SELECT UNIQUE tc_sma01 FROM tc_sma_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND tc_sma01 = '",g_prog  CLIPPED ,"'" ,
                   " ORDER BY tc_sma01"
    end if
    PREPARE i100_prepare FROM g_sql
    DECLARE i100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
 
    DROP TABLE x 
    if g_prog = 'csmi100' then
        LET g_sql_tmp = "SELECT UNIQUE tc_sma01 FROM tc_sma_file",
                   " WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x "
    ELSE
        LET g_sql_tmp = "SELECT UNIQUE tc_sma01 FROM tc_sma_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND tc_sma01 = '",g_prog  CLIPPED ,"'" ,
                   "  INTO TEMP x "
    end if
    PREPARE i100_precount_x FROM g_sql_tmp
    EXECUTE i100_precount_x
         
    LET g_sql="SELECT COUNT(*) FROM x "  
    PREPARE i100_precount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION
 
FUNCTION i100_menu()

   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
              CALL i100_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sma),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_sma01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_sma01"
                 LET g_doc.value1 = g_tc_sma01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL i100_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0) 
    ELSE
       OPEN i100_count
       FETCH i100_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式 
    l_tc_smauser       LIKE tc_sma_file.tc_smauser
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i100_cs INTO g_tc_sma01
    WHEN 'P' FETCH PREVIOUS i100_cs INTO g_tc_sma01
    WHEN 'F' FETCH FIRST    i100_cs INTO g_tc_sma01
    WHEN 'L' FETCH LAST     i100_cs INTO g_tc_sma01
    WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()     
                   
                   ON ACTION help        
                      CALL cl_show_help() 
                   
                   ON ACTION controlg    
                      CALL cl_cmdask()  
 
                
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i100_cs INTO g_tc_sma01
            LET mi_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sma01,SQLCA.sqlcode,0) 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
 
    LET g_tc_sma01_t = g_tc_sma01 
    DISPLAY g_tc_sma01  TO tc_sma01 

 
    CALL i100_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()        
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i100_r()
    IF s_shut(0) THEN RETURN END IF  

    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM tc_sma_file WHERE tc_sma01 = g_tc_sma01 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","tc_sma_file",g_tc_sma04,"",SQLCA.sqlcode,"",
                        "BODY DELETE",1) 
        ELSE
            COMMIT WORK
            let g_rec_b = 0
            CLEAR FORM
            call i100_set_dny_combo() 
            CALL g_tc_sma.clear()
            CALL g_tc_sma.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            DROP TABLE x
            PREPARE i100_precount_x2 FROM g_sql_tmp 
            EXECUTE i100_precount_x2               
            OPEN i100_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i100_cs
               CLOSE i100_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i100_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i100_cs
               CLOSE i100_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i100_cs 
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i100_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i100_fetch('/')
            END IF
        END IF
    END IF
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,                 #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增否 
    l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE   li_count   LIKE type_file.num5  
DEFINE   li_inx     LIKE type_file.num5 
DEFINE   ls_str     STRING             
DEFINE   ls_sql     STRING            
DEFINE   li_cnt     LIKE type_file.num5 
DEFINE   l_gay01    LIKE gay_file.gay01 
DEFINE   l_tc_sma      RECORD LIKE tc_sma_file.*
DEFINE   l_datatype  STRING 
DEFINE   l_length    STRING 
DEFINE   l_azw05    LIKE  azw_file.azw05   #FUN-A50016
DEFINE   l_dic      LIKE type_file.chr1    #FUN-A70026
define l_cnt INTEGER
define l_repeat     boolean #darcy:2024/11/29
define l_msg        string #darcy:2024/11/29
 
    LET g_action_choice = ""
    IF g_tc_sma01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b') 
    LET g_forupd_sql = 
        " SELECT tc_sma02,'',tc_sma03,tc_sma04,tc_sma05,tc_sma06,",
        "               tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,",
        "               tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,",
        "               tc_sma17,tc_sma18,tc_sma19,tc_sma20,tc_smauser,tc_smamod FROM tc_sma_file ",
        " WHERE tc_sma01 = ? AND tc_sma02 = ? AND tc_sma03 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_sma WITHOUT DEFAULTS FROM s_tc_sma.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd =''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_tc_sma_t.* = g_tc_sma[l_ac].*  #BACKUP
               LET g_tc_sma01_t = g_tc_sma01 
 
               OPEN i100_bcl USING g_tc_sma01_t,g_tc_sma_t.tc_sma02,g_tc_sma_t.tc_sma03
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i100_bcl INTO g_tc_sma[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tc_sma01_t,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
                  let g_tc_sma[l_ac].tc_sma02_desc = i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[l_ac].tc_sma02)
               END IF
               CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_sma[l_ac].* TO NULL 
            call i100_get_default()
            LET g_tc_sma_t.* = g_tc_sma[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD tc_sma02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #darcy:2024/11/28 add s---
            let l_repeat = false
            case g_tc_sma01
                when "csmi110"
                    select count(1) into l_cnt from tc_sma_file
                     where tc_sma01 = g_tc_sma01 and tc_sma02 = g_tc_sma[l_ac].tc_sma02
                    if l_cnt > 0 then
                        let l_repeat = true
                        let l_msg = g_tc_sma[l_ac].tc_sma02
                    end if
            end case
            if l_repeat then
                call cl_err(l_msg,"-239",1)
                CANCEL INSERT
            end if
            #darcy:2024/11/28 add e---
            INSERT INTO tc_sma_file(
                tc_sma01,tc_sma02,tc_sma03,tc_sma04,tc_sma05,
                tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma10,
                tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,
                tc_sma16,tc_sma17,tc_sma18,tc_sma19,tc_sma20,
                tc_smauser,tc_smamod
            )VALUES(
                g_tc_sma01,g_tc_sma[l_ac].tc_sma02,g_tc_sma[l_ac].tc_sma03,g_tc_sma[l_ac].tc_sma04,g_tc_sma[l_ac].tc_sma05,
                g_tc_sma[l_ac].tc_sma06,g_tc_sma[l_ac].tc_sma07,g_tc_sma[l_ac].tc_sma08,g_tc_sma[l_ac].tc_sma09,g_tc_sma[l_ac].tc_sma10,
                g_tc_sma[l_ac].tc_sma11,g_tc_sma[l_ac].tc_sma12,g_tc_sma[l_ac].tc_sma13,g_tc_sma[l_ac].tc_sma14,g_tc_sma[l_ac].tc_sma15,
                g_tc_sma[l_ac].tc_sma16,g_tc_sma[l_ac].tc_sma17,g_tc_sma[l_ac].tc_sma18,g_tc_sma[l_ac].tc_sma19,g_tc_sma[l_ac].tc_sma20,
                g_tc_sma[l_ac].tc_smauser,g_tc_sma[l_ac].tc_smamod
            )
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_sma_file",g_tc_sma01,g_tc_sma[l_ac].tc_sma02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF

        AFTER FIELD tc_sma02
           IF NOT cl_null(g_tc_sma[l_ac].tc_sma02) THEN
                IF g_tc_sma[l_ac].tc_sma02 <> g_tc_sma_t.tc_sma02 OR cl_null(g_tc_sma_t.tc_sma02) THEN 
                    let l_cnt = 0
                    if not i100_chk_tc_sma02(g_tc_sma01,g_tc_sma[l_ac].tc_sma02) then
                        next field tc_sma02
                    end if
                    let g_tc_sma[l_ac].tc_sma02_desc = i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[l_ac].tc_sma02)
                    display by name g_tc_sma[l_ac].tc_sma02_desc
                END IF
                if p_cmd='a' then
                    let l_cnt = 0 
                    SELECT NVL(MAX(tc_sma03),0)+1 into l_cnt FROM tc_sma_file
                     where tc_sma01 = g_tc_sma01 and tc_sma02 = g_tc_sma[l_ac].tc_sma02
                    let g_tc_sma[l_ac].tc_sma03 = l_cnt
                    display by name g_tc_sma[l_ac].tc_sma03
                end if
           END IF
        
        after field tc_sma04
            call i100_get_default()
        
        on change tc_sma05,tc_sma08,tc_sma11,tc_sma14,tc_sma17
            case 
                when infield(tc_sma05)
                    if g_tc_sma[l_ac].tc_sma05 ='Y' then
                        call cl_set_comp_entry('tc_sma06,tc_sma07',true)
                    else
                        call cl_set_comp_entry('tc_sma06,tc_sma07',false)
                    end if
                when infield(tc_sma08)
                    if g_tc_sma[l_ac].tc_sma08 ='Y' then
                        call cl_set_comp_entry('tc_sma09,tc_sma10',true)
                    else
                        call cl_set_comp_entry('tc_sma09,tc_sma10',false)
                    end if
                when infield(tc_sma11)
                    if g_tc_sma[l_ac].tc_sma11 ='Y' then
                        call cl_set_comp_entry('tc_sma12,tc_sma13',true)
                    else
                        call cl_set_comp_entry('tc_sma12,tc_sma13',false)
                    end if
                when infield(tc_sma13)
                    if g_tc_sma[l_ac].tc_sma13 ='Y' then
                        call cl_set_comp_entry('tc_sma14,tc_sma15',true)
                    else
                        call cl_set_comp_entry('tc_sma14,tc_sma15',false)
                    end if
                when infield(tc_sma17)
                    if g_tc_sma[l_ac].tc_sma17 ='Y' then
                        call cl_set_comp_entry('tc_sma18,tc_sma19',true)
                    else
                        call cl_set_comp_entry('tc_sma18,tc_sma19',false)
                    end if
            end case
 
        BEFORE DELETE                            #是否取消單身
            #darcy:2023/10/09 add s---
               # 权限判断
               let g_action_choice = "delete"
               if not cl_chk_act_auth() then
                  CANCEL DELETE
               end if
               let g_action_choice = "detail"
            #darcy:2023/10/09 add e---
            IF g_tc_sma_t.tc_sma02 IS NOT NULL THEN
                #檢查是否已有單別正在使用中，若是則無清刪除
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM tc_sma_file 
                 WHERE tc_sma01 = g_tc_sma01
                   AND tc_sma02 = g_tc_sma_t.tc_sma02
                   AND tc_sma03 = g_tc_sma_t.tc_sma03
                IF SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err3("del","tc_sma_file",g_tc_sma01,g_tc_sma_t.tc_sma02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE
                   LET g_rec_b = g_rec_b -1 
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   COMMIT WORK
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_sma[l_ac].* = g_tc_sma_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_sma[l_ac].tc_sma02,-263,1)
               LET g_tc_sma[l_ac].* = g_tc_sma_t.*
            ELSE
               LET g_tc_sma[l_ac].tc_smauser=g_user  
               LET g_tc_sma[l_ac].tc_smamod=current
               UPDATE tc_sma_file SET
                    tc_sma02 = g_tc_sma[l_ac].tc_sma02,
                    tc_sma03 = g_tc_sma[l_ac].tc_sma03,
                    tc_sma04 = g_tc_sma[l_ac].tc_sma04,
                    tc_sma05 = g_tc_sma[l_ac].tc_sma05,
                    tc_sma06 = g_tc_sma[l_ac].tc_sma06,
                    tc_sma07 = g_tc_sma[l_ac].tc_sma07,
                    tc_sma08 = g_tc_sma[l_ac].tc_sma08,
                    tc_sma09 = g_tc_sma[l_ac].tc_sma09,
                    tc_sma10 = g_tc_sma[l_ac].tc_sma10,
                    tc_sma11 = g_tc_sma[l_ac].tc_sma11,
                    tc_sma12 = g_tc_sma[l_ac].tc_sma12,
                    tc_sma13 = g_tc_sma[l_ac].tc_sma13,
                    tc_sma14 = g_tc_sma[l_ac].tc_sma14,
                    tc_sma15 = g_tc_sma[l_ac].tc_sma15,
                    tc_sma16 = g_tc_sma[l_ac].tc_sma16,
                    tc_sma17 = g_tc_sma[l_ac].tc_sma17,
                    tc_sma18 = g_tc_sma[l_ac].tc_sma18,
                    tc_sma19 = g_tc_sma[l_ac].tc_sma19,
                    tc_sma20 = g_tc_sma[l_ac].tc_sma20,
                    tc_smauser = g_tc_sma[l_ac].tc_smauser,
                    tc_smamod = g_tc_sma[l_ac].tc_smamod
                WHERE tc_sma01 = g_tc_sma01_t
                  AND tc_sma02 = g_tc_sma_t.tc_sma02
                  AND tc_sma03 = g_tc_sma_t.tc_sma03
          
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_sma_file",g_tc_sma_t.tc_sma02,g_tc_sma_t.tc_sma03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_tc_sma[l_ac].* = g_tc_sma_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_sma[l_ac].* = g_tc_sma_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_tc_sma.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i100_bcl
            COMMIT WORK
 
        ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO") 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_sma02) AND l_ac > 1 THEN
                LET g_tc_sma[l_ac].* = g_tc_sma[l_ac-1].*
                NEXT FIELD tc_sma02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(tc_sma02)
                case g_tc_sma01
                    when 'csmi101'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gat"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma06 TO tc_sma02
                        NEXT FIELD tc_sma02
                    when 'csmi103'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_ecd3"
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma06 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2023/12/27 add s---
                    when 'csmi106'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_ima03"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma06 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2023/12/27 add e---
                    #darcy:2024/01/08 add s---
                    when 'csmi107'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_eca1"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma06 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2024/01/08 add e---
                    #darcy:2024/04/23 add s---
                    when 'csmi108'
                    #darcy:2024/04/23 add e---
                    #darcy:2024/07/25 add s---
                    when 'csmi109'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_imd01"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma06 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2024/07/25 add e---
                    #darcy:2024/11/28 add s---
                    when 'csmi110'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_ima09"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2024/11/28 add e---
                    #darcy:2025/02/21 add s---
                    when 'csmi112'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gaz"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    #darcy:2025/02/21 add e---
                    #darcy:2025/04/21 add s---
                    when 'csmi113'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_tc_sma02"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    when 'csmi114'
                        next field tc_sma02
                    #darcy:2025/04/21 add e---
                    # darcy:2025/06/16 add s---
                    when 'csmi115' 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_imz"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    # darcy:2025/06/16 add e---
                    # darcy:2025/06/23 add s---
                    when 'csmi116'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_tc_sma02"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    # darcy:2025/06/23 add e---
                    # darcy:2025/07/28 add s---
                    when 'csmi118'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_occ"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    # darcy:2025/07/28 add e---
                    # darcy:2025/07/28 add s---
                    when 'csmi119'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_ima02"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    # darcy:2025/07/28 add e---
                    # darcy:2025/07/28 add s---
                    when 'csmi120'
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "cq_ima02"
                        LET g_qryparam.arg1 = g_lang
                        LET g_qryparam.default1 = g_tc_sma[l_ac].tc_sma02
                        CALL cl_create_qry() RETURNING g_tc_sma[l_ac].tc_sma02
                        DISPLAY g_tc_sma[l_ac].tc_sma02 TO tc_sma02
                        NEXT FIELD tc_sma02
                    # darcy:2025/07/28 add s---
                end case
              
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about      
           CALL cl_about()  
        
        ON ACTION help        
           CALL cl_show_help()
 
    
    END INPUT
 
    CLOSE i100_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000 
 
   IF cl_null(p_wc2) THEN LET p_wc2 = '1 = 1 '  END IF 
   LET g_sql = " SELECT tc_sma02,'',tc_sma03,tc_sma04,tc_sma05,tc_sma06,",
               "       tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,",
               "       tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,",
               "       tc_sma17,tc_sma18,tc_sma19,tc_sma20,tc_smauser,tc_smamod FROM tc_sma_file ",
               " WHERE tc_sma01 ='",g_tc_sma01,"'",  #單頭
               "   AND ",p_wc2 CLIPPED
    # darcy:2025/07/28 add s---            #單身
    case g_tc_sma01 
        when 'csmi119'
             let g_sql = g_sql,"ORDER BY tc_sma06,tc_sma07,tc_sma02"
        otherwise
            let g_sql = g_sql,"ORDER BY tc_sma02,tc_sma03"
    end case
    # darcy:2025/07/28 add e---
 
   PREPARE i100_pb FROM g_sql
   DECLARE tc_sma_curs CURSOR FOR i100_pb
 
   CALL g_tc_sma.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH tc_sma_curs INTO g_tc_sma[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       call i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[g_cnt].tc_sma02)
            returning g_tc_sma[g_cnt].tc_sma02_desc
       LET g_cnt = g_cnt + 1
     
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    
   END FOREACH
   CALL g_tc_sma.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
END FUNCTION
 
FUNCTION i100_a()
  DEFINE  l_cnt  LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    call i100_set_dny_combo() 
    CALL g_tc_sma.clear()
    LET g_tc_sma01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i100_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0       
        IF g_ss='N' THEN
            CALL g_tc_sma.clear()
        ELSE
            CALL i100_b_fill('1=1')          #單身
        END IF
        CALL i100_b()                        #輸入單身
        LET g_tc_sma02_t = g_tc_sma02                 #保留舊值
        LET g_tc_sma01_t = g_tc_sma01                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION i100_u()
  DEFINE  l_buf      LIKE type_file.chr1000 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sma04 IS NULL OR g_tc_sma01 IS NULL THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_sma01_t = g_tc_sma01
    BEGIN WORK   #No.+205 mark 拿掉
    WHILE TRUE
        CALL i100_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_tc_sma01=g_tc_sma01_t
            DISPLAY g_tc_sma04 TO tc_sma04               #單頭
                
            DISPLAY g_tc_sma01 TO tc_sma01               #單頭
                
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i100_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,  
    l_buf           LIKE type_file.chr1000,
    l_n             LIKE type_file.num5    
 
    LET g_ss = 'Y'
    DISPLAY BY NAME g_tc_sma04,g_tc_sma01 
    CALL cl_set_head_visible("","YES")  
    let g_tc_sma01 = g_prog
    display g_prog
    
    DISPLAY g_tc_sma01 to tc_sma01

END FUNCTION
FUNCTION i100_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   display g_tc_sma01 to tc_sma01
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tc_sma TO s_tc_sma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first 
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY          
                              
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY        
                              
 
      ON ACTION jump 
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY          
                              
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
                              
 
      ON ACTION last 
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY          
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
         LET g_tc_sma03 = g_lang 
         CALL i100_b_fill('1=1')          #單身
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
   
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls     
         CALL cl_set_head_visible("","AUTO") 
 
      ON ACTION related_document            
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i100_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                           
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("tc_sma04,tc_sma01,tc_sma02",TRUE)                                                                                     
   END IF                                                                                                                           

   #darcy:2024/11/29 add s---
   case g_tc_sma01
    when "csmi110"
        if p_cmd == 'a' then
            call cl_set_comp_entry("tc_sma02",true)    
        end if
    # 动态设置栏位不能修改
    when "csmi120"
        if p_cmd = "a" then
            call cl_set_comp_entry("tc_sma02",true)    
        end if
    # darcy:2025/07/28 add e---
   end case
   #darcy:2024/11/29 add e---
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i100_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                          
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("tc_sma04,tc_sma01,tc_sma02",FALSE)                                                                                    
   END IF                                                                                                                           

   #darcy:2024/11/29 add s---
   case g_tc_sma01
    when "csmi110"
        if p_cmd = 'u' then
            call cl_set_comp_entry("tc_sma02",false)    
        end if
    # darcy:2025/07/28 add ---
    # 动态设置栏位不能修改
    when "csmi120"
        if p_cmd = "u" then
            call cl_set_comp_entry("tc_sma02",false)    
        end if
    # darcy:2025/07/28 add e---
   end case
   #darcy:2024/11/29 add e---

END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i100_set_dny_combo() 
    DEFINE ps_values,ps_items  STRING
    DEFINE l_str       STRING
    DEFINE tok base.StringTokenizer
    define l_ze01      like ze_file.ze01
    define l_gaz03      like gaz_file.gaz03

    let ps_values = "csmi100,csmi101,csmi102,csmi103,csmi104,csmi105,csmi106,csmi107,csmi108,csmi109,csmi110,csmi111,",
                    "csmi112,csmi113,csmi114,csmi115,csmi116,csmi117,csmi118,csmi119,csmi120,csmi121"

    LET tok = base.StringTokenizer.create(ps_values,",")
    let l_ze01 = tok.nextToken()
    SELECT gaz03 into l_gaz03 FROM gaz_file WHERE gaz01 = l_ze01 AND gaz02 = g_lang
    let l_str = l_gaz03
    
    WHILE tok.hasMoreTokens()
        let l_ze01 = tok.nextToken()
        SELECT gaz03 into l_gaz03 FROM gaz_file WHERE gaz01 = l_ze01 AND gaz02 = g_lang
        let l_str = l_str,",",l_gaz03
    END WHILE
    call cl_set_combo_items("tc_sma01",ps_values,l_str)

    #TODO: 

    case g_tc_sma01 
        when 'csmi101'
            call cl_set_combo_items("tc_sma04","1,2","线圈板/载板,CMM")
        when 'csmi102'
            display "字段类型说明中不可录入英文逗号" to lb_msg
        when 'csmi103'
            # display "字段类型说明中不可录入英文逗号" to lb_msg
        when 'csmi104'
            display "本作业设置aeci620作业编号对应工序类型" to lb_msg
        when 'csmi105'
            display "本作业设置成品料号对应的研发单号" to lb_msg
        when 'csmi106'
            display "本作业设置组装料号拆批规则" to lb_msg
        when 'csmi107'
            display "线边仓不允许混用料工站维护" to lb_msg
        when 'csmi108'
            display "请按照料号维护光板拆分规则" to lb_msg
        when 'csmi109'
            display "此作业用来维护样品原材仓库、和相关单据编号" to lb_msg
        when 'csmi110'
            display "此作业维护原材料对应的成品料号，呆滞分析报表中使用" to lb_msg
        when 'csmi111'
            display "此作业维护收件人群组，方便发送邮件通知" to lb_msg
        when 'csmi112'
            display '全局参数设置'
        when 'csmi113'
            display '光板样品下料规则'
        when 'csmi114'
            display '预测工单拆单日期管控'
        when 'csmi115'
            display '分群码设置固定损耗量，损耗率'
        when 'csmi116'
            call cl_set_combo_items("tc_sma04","1,2","光板,组装")
            display '成品生产前置天数'
        when 'csmi117'
            display '订单达交率账龄设置'
        when 'csmi118'
            display '业务客户查询顺序'
        when 'csmi119'
            display '月份销售预测FCST维护'
        # darcy:2025/07/28 s---
        # 程序名称
        when 'csmi120'
            display '示例程序'
        # darcy:2025/07/28 e---
        # darcy:2025/09/03 add s---
        when 'csmi121'
            display '料件项目属性维护'
        # darcy:2025/09/03 add e---
    end case

    call i100_set_visiable()
END FUNCTION

function i100_get_tc_sma_desc(p_tc_sma01,p_tc_sma02)
    define p_tc_sma01  like tc_sma_file.tc_sma01
    define p_tc_sma02  like tc_sma_file.tc_sma02
    define l_tc_sma02_desc  varchar(500)
    #TODO: 

    case p_tc_sma01
        when 'csmi101' #客户编号
            select occ02 into l_tc_sma02_desc
              from occ_file where occ01 = p_tc_sma02
        when 'csmi102'
            select gaz03 into l_tc_sma02_desc from gaz_file
             where gaz01 = p_tc_sma02 and gaz02='2'
        when 'csmi103'
            select ecd02 into l_tc_sma02_desc from ecd_file
             where ecd01 = p_tc_sma02
        when 'csmi104'
            select ecd02 into l_tc_sma02_desc from ecd_file
             where ecd01 = p_tc_sma02
        when 'csmi106'
            select ima02 into l_tc_sma02_desc from ima_file
             where ima01 = p_tc_sma02
        when 'csmi107'
            select eca02 into l_tc_sma02_desc from eca_file
             where eca01 = p_tc_sma02
        when 'csmi112'
            select gaz03 into l_tc_sma02_desc from gaz_file
             where gaz01 = p_tc_sma02 and gaz02 = '2'
        when 'csmi113'
            select tc_sma06 into l_tc_sma02_desc from tc_sma_file
             where tc_sma01 = 'csmi102' and tc_sma02 = 'aimi100'
               and tc_sma03 = p_tc_sma02
        when 'csmi115'
            select imz02 into l_tc_sma02_desc from imz_file
             where imz01 = p_tc_sma02
        when 'csmi116'
            select tc_sma06 into l_tc_sma02_desc from tc_sma_file
             where tc_sma01 = 'csmi102' and tc_sma02 = 'aimi100'
               and tc_sma03 = p_tc_sma02
        when "csmi118"
            select occ02 into l_tc_sma02_desc from occ_file
             where occ01 = p_tc_sma02
        when "csmi119"
            select ima02 into l_tc_sma02_desc from ima_file
             where ima01 = p_tc_sma02
        # darcy:2025/07/28 add s---
        # 自动带出
        when 'csmi120'
            select ima02 into l_tc_sma02_desc from ima_file
             where ima01 = p_tc_sma02
        # darcy:2025/07/28 add e---
        otherwise
            let l_tc_sma02_desc = null
    end case
    return l_tc_sma02_desc
end function
 
function i100_chk_tc_sma02(p_tc_sma01,p_tc_sma02)
    define p_tc_sma01  like tc_sma_file.tc_sma01
    define p_tc_sma02  like tc_sma_file.tc_sma02
    define l_cnt integer

    #TODO: 
    let l_cnt = 0
    case p_tc_sma01
        when 'csmi101' #客户编号
            select count(1) into l_cnt from occ_file where occ01 = p_tc_sma02
            if l_cnt = 0 then
                call cl_err(p_tc_sma02,'anm-045',1)
                return false
            end if
        when 'csmi106' # 料件编号
            select count(1) into l_cnt from ima_file where ima01 = p_tc_sma02
            if l_cnt = 0 then
               call cl_err(p_tc_sma02,'asf-184',1)
               return false
            end if
        when 'csmi107' # 料件编号
            select count(1) into l_cnt from eca_file where eca01 = p_tc_sma02
            if l_cnt = 0 then
               call cl_err(p_tc_sma02,'csm-001',1)
               return false
            end if
        # darcy:2025/06/16 add s---
        when 'csmi115'
            select count(1) into l_cnt from imz_file where imz01 = p_tc_sma02
            if l_cnt = 0 then
               call cl_err(p_tc_sma02,'csm-001',1)
               return false
            end if
        # darcy:2025/06/16 add e---
        # darcy:2025/07/28 add s---
        when "csmi119"
            select count(1) into l_cnt from ima_file where ima01 = p_tc_sma02
            and ima06 in ('G01','G02','BCP') 
            if l_cnt = 0 then
               call cl_err(p_tc_sma02,'cxm-050',1)
               return false
            end if
        # darcy:2025/07/28 add e---
        # darcy:2025/07/28 add s---
        # 资料内容检查
        when 'csmi120'
            return true
        # darcy:2025/07/28 add e---
    end case
    return true
end function

function i100_set_visiable()
    #TODO:
    case g_tc_sma01
        when 'csmi101' #客户编号
            call cl_set_comp_att_text("tc_sma02","客户编号")
            call cl_set_comp_att_text("tc_sma02_desc","简称")
            call cl_set_comp_att_text("tc_sma04","客户类型")
            call cl_set_comp_att_text("tc_sma05","排版数限制")
            call cl_set_comp_att_text("tc_sma06","最小排版数")
            call cl_set_comp_att_text("tc_sma07","最大排版数")
            call cl_set_comp_att_text("tc_sma19","PNL拆分数")
            call cl_set_comp_entry("tc_sma02,tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma19",true)
            call cl_set_comp_visible("tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18",false)
        when 'csmi102'
            call cl_set_comp_att_text("tc_sma02","作业编码")
            call cl_set_comp_att_text("tc_sma02_desc","作业名称")
            call cl_set_comp_att_text("tc_sma03","类型序号")
            call cl_set_comp_att_text("tc_sma06","类型说明")
            call cl_set_comp_att_text("tc_sma07","最小排版")
            call cl_set_comp_att_text("tc_sma09","PNL拆分量")
            call cl_set_comp_att_text("tc_sma10","备注")
            call cl_set_comp_visible("tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02",false)
            call cl_set_comp_entry("tc_sma06,tc_sma07,tc_sma09,tc_sma10,tc_sma20",true)
            call cl_set_comp_required("tc_sma06,tc_sma07,tc_sma09",true)
            # if g_user != 'tiptop' then
            #    call cl_set_comp_entry("tc_sma07,tc_sma09,tc_sma20",false)
            #    call cl_set_comp_visible("tc_sma07,tc_sma09",false)
            # end if
        when "csmi103"
            call cl_set_comp_att_text("tc_sma02","作业编号")
            call cl_set_comp_att_text("tc_sma02_desc","说明")
            call cl_set_comp_att_text("tc_sma06","损耗率%")
            call cl_set_comp_visible("tc_sma03,tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06",true)
        when "csmi104"
        when "csmi105"
            call cl_set_comp_att_text("tc_sma02","料件编号")
            # call cl_set_comp_att_text("tc_sma02_desc","说明")
            call cl_set_comp_att_text("tc_sma03","序号")
            call cl_set_comp_att_text("tc_sma06","对应研发单号") 
            call cl_set_comp_visible("tc_sma02_desc,tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma03,tc_sma06",true)
        #darcy:2023/12/27 add s---
        when 'csmi106'
            call cl_set_comp_att_text("tc_sma02","料件编号")
            call cl_set_comp_att_text("tc_sma02_desc","品名")
            call cl_set_comp_att_text("tc_sma06","PNL拆分数")
            call cl_set_comp_visible("tc_sma03,tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06",true)
        #darcy:2023/12/27 add e---
        when 'csmi107'
            call cl_set_comp_att_text("tc_sma02","工作站")
            call cl_set_comp_att_text("tc_sma02_desc","说明")
            call cl_set_comp_visible("tc_sma03,tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02",true)
        #darcy:2024/04/23 add s---
        when 'csmi108'
            call cl_set_comp_att_text("tc_sma02","料件编号")
            call cl_set_comp_att_text("tc_sma06","PNL拆分数")
            call cl_set_comp_visible("tc_sma02_desc,tc_sma03,tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06",true)
        #darcy:2024/04/23 add e---
        #darcy:2024/07/25 add s---
        when 'csmi109'
            call cl_set_comp_att_text("tc_sma02","编号")
            call cl_set_comp_att_text("tc_sma06","类型:1.仓库2.请购单3.采购单4.收货单")
            call cl_set_comp_visible("tc_sma02_desc,tc_sma03,tc_sma04,tc_sma05,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06",true)
        #darcy:2024/07/25 add e---
        #darcy:2024/11/28 add s---
        when "csmi110"
            call cl_set_comp_att_text("tc_sma02","料件编号")
            call cl_set_comp_att_text("tc_sma10","成品料号1")
            call cl_set_comp_att_text("tc_sma12","成品料号2")
            call cl_set_comp_att_text("tc_sma13","成品料号3")
            call cl_set_comp_visible("tc_sma02_desc,tc_sma03,tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma11,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma10,tc_sma12,tc_sma13",true)
        #darcy:2024/11/28 add e---
        #darcy:2024/12/06 add s---
        when "csmi111"
            call cl_set_comp_att_text("tc_sma02","群组名称")
            call cl_set_comp_att_text("tc_sma18","收件人")
            call cl_set_comp_att_text("tc_sma19","抄送人")
            call cl_set_comp_visible("tc_sma02_desc,tc_sma03,tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17",false)
            call cl_set_comp_entry("tc_sma02,tc_sma18,tc_sma19",true)
        #darcy:2024/12/06 add s---
        #darcy:2025/02/21 add s---
        when 'csmi112'
            call cl_set_comp_att_text("tc_sma02","作业编号")
            call cl_set_comp_att_text("tc_sma02_desc","作业名称")
            call cl_set_comp_att_text("tc_sma10","参数名称") 
            call cl_set_comp_att_text("tc_sma12","说明") 
            call cl_set_comp_att_text("tc_sma13","参数值")
            call cl_set_comp_visible("tc_sma03,tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma11,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma19,tc_sma18",false)
            call cl_set_comp_entry("tc_sma02,tc_sma10,tc_sma12,tc_sma13",true)

        #darcy:2025/02/21 add e---
        #darcy:2025/04/21 add s---
        when 'csmi113'
            call cl_set_comp_att_text("tc_sma02","市场类型")
            call cl_set_comp_att_text("tc_sma02_desc","说明")
            call cl_set_comp_att_text("tc_sma03","项次")
            call cl_set_comp_att_text("tc_sma04","宽幅")
            call cl_set_comp_att_text("tc_sma05","包含以上层数")
            call cl_set_comp_att_text("tc_sma07","层数layer")
            call cl_set_comp_att_text("tc_sma09","料号")
            call cl_set_comp_att_text("tc_sma10","下料良率%")
            call cl_set_comp_att_text("tc_sma12","出货资料数PCS")
            call cl_set_comp_att_text("tc_sma13","最低投料数PNL")
            call cl_set_comp_att_text("tc_sma15","首件损耗")
            call cl_set_comp_att_text("tc_sma16","有阻抗产品")
            call cl_set_comp_att_text("tc_sma18","卷料生产")
            call cl_set_comp_att_text("tc_sma19","辅料生产")
            call cl_set_comp_visible("tc_sma06,tc_sma08,tc_sma11,tc_sma14,tc_sma17",false)
            call cl_set_comp_entry("tc_sma02,tc_sma03,tc_sma04,tc_sma05,tc_sma07,tc_sma09,tc_sma10,tc_sma12,tc_sma13,tc_sma15,tc_sma16,tc_sma18,tc_sma19",true)
            call cl_set_combo_items("tc_sma04",'0,1,2,3','LCM*250,LCM&500,汽车板<600mm,汽车板>=600mm')
            call cl_set_comp_required('tc_sma04',false)
        #darcy:2025/04/21 add e---
        #darcy:2025/06/13 add s---
        when 'csmi114'
            call cl_set_comp_att_text("tc_sma02","作业编号")
            call cl_set_comp_att_text("tc_sma03","类型")
            call cl_set_comp_att_text("tc_sma07","说明")
            call cl_set_comp_att_text("tc_sma06","最少间隔天数")
            call cl_set_comp_visible("tc_sma02_desc,tc_sma05,tc_sma04,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma03,tc_sma07,tc_sma06",true)
        #darcy:2025/06/13 add e---
        #darcy:2025/06/16 add s---
        when 'csmi115'
            call cl_set_comp_att_text("tc_sma02","分群码") 
            call cl_set_comp_att_text("tc_sma03","项次")
            call cl_set_comp_att_text("tc_sma06","固定损耗量")
            call cl_set_comp_att_text("tc_sma07","固定损耗率%")
            call cl_set_comp_visible("tc_sma04,tc_sma05,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06,tc_sma07",true)
        #darcy:2025/06/16 add e---
        #darcy:2025/07/05 add s---
        when 'csmi116'
            call cl_set_comp_att_text('tc_sma02',"市场类型")
            call cl_set_comp_att_text("tc_sma03","项次")
            call cl_set_comp_att_text("tc_sma04","光板/组装")
            call cl_set_comp_att_text("tc_sma06","1层")
            call cl_set_comp_att_text("tc_sma07","2层")
            call cl_set_comp_att_text("tc_sma09","3层")
            call cl_set_comp_att_text("tc_sma10","4层")
            call cl_set_comp_att_text("tc_sma12","5层")
            call cl_set_comp_att_text("tc_sma13","6层")
            call cl_set_comp_visible("tc_sma05,tc_sma08,tc_sma11,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma04,tc_sma03,tc_sma06,tc_sma07,tc_sma09,tc_sma10,tc_sma12,tc_sma13",true)
        #darcy:2025/07/05 add e---
        #darcy:2025/07/03 add s---
        when 'csmi117'
            call cl_set_comp_att_text('tc_sma02','类型')
            call cl_set_comp_att_text('tc_sma03','项次')
            call cl_set_comp_att_text('tc_sma06','开始天数')
            call cl_set_comp_att_text('tc_sma07','结束天数')
            call cl_set_comp_visible("tc_sma02_desc,tc_sma04,tc_sma05,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma06,tc_sma07",true)
        #darcy:2025/07/03 add e---
        # darcy:2025/07/28 add s---
        when 'csmi118'
            call cl_set_comp_att_text('tc_sma02','客户编号')
            call cl_set_comp_att_text('tc_sma02_desc','简称')
            call cl_set_comp_att_text('tc_sma03','顺序')
            call cl_set_comp_visible("tc_sma04,tc_sma05,tc_sma06,tc_sma07,tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma03",true)
        # darcy:2025/07/28 add e---
        # darcy:2025/07/28 add s---
        when 'csmi119'
            call cl_set_comp_att_text('tc_sma02','成品料号')
            call cl_set_comp_att_text('tc_sma02_desc','品名')
            call cl_set_comp_att_text('tc_sma03','年度期别') 
            call cl_set_comp_att_text('tc_sma06','FCST数量')
            call cl_set_comp_visible("tc_sma04,tc_sma05,tc_sma09,tc_sma07,tc_sma08,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma02,tc_sma03,tc_sma06",true)
        # darcy:2025/07/28 add e---
        # darcy:2025/07/28 add s---
        -- 字段是否允许录入
        when 'csmi120'
            call cl_set_comp_att_text('tc_sma02','开窗栏位')
            call cl_set_comp_att_text('tc_sma02_desc','一个说明栏位')
            call cl_set_comp_att_text('tc_sma03','顺序栏位')
            call cl_set_comp_att_text('tc_sma04','下拉框')
            call cl_set_comp_att_text('tc_sma05','勾选框')
            call cl_set_comp_att_text('tc_sma06','输入框')
            call cl_set_comp_att_text('tc_sma07','输入框')
            call cl_set_comp_att_text('tc_sma08','勾选框')
            call cl_set_comp_att_text('tc_sma09','输入框')
            call cl_set_comp_att_text('tc_sma10','输入框')
            call cl_set_comp_att_text('tc_sma11','单选框')
            call cl_set_comp_att_text('tc_sma12','输入框')
            call cl_set_comp_att_text('tc_sma13','输入框')
            call cl_set_comp_att_text('tc_sma14','单选框')
            call cl_set_comp_att_text('tc_sma15','输入框')
            call cl_set_comp_att_text('tc_sma16','输入框')
            call cl_set_comp_att_text('tc_sma17','单选框')
            call cl_set_comp_att_text('tc_sma18','输入框')
            call cl_set_comp_att_text('tc_sma19','输入框')
            call cl_set_comp_att_text('tc_sma20','有效否')
            -- 是否隐藏
            -- call cl_set_comp_visible("tc_sma02,tc_sma02_desc,tc_sma03,tc_sma04,tc_sma05,
            --                           tc_sma08,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,
            --                           tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            -- 是否可以录入
            call cl_set_comp_entry("tc_sma02,tc_sma03",true)
        # darcy:2025/07/28 add e---
        # darcy:2025/09/03 add s---
        when 'csmi121'
            call cl_set_comp_att_text('tc_sma02','项目阶段')
            call cl_set_comp_att_text('tc_sma03','项目阶段值')
            call cl_set_comp_att_text('tc_sma06','项目阶段说明')
            call cl_set_comp_att_text('tc_sma07','备注')
            call cl_set_comp_visible("tc_sma02_desc,tc_sma04,tc_sma05,
                                      tc_sma08,tc_sma09,tc_sma10,tc_sma11,tc_sma12,tc_sma13,tc_sma14,
                                      tc_sma15,tc_sma16,tc_sma17,tc_sma18,tc_sma19",false)
            call cl_set_comp_entry("tc_sma03,tc_sma06,tc_sma07",true)
        # darcy:2025/09/03 add e---
    end case
    
end function

function i100_get_default()
    #TODO:
    LET g_tc_sma[l_ac].tc_smauser = g_user
    LET g_tc_sma[l_ac].tc_smamod = current 
    LET g_tc_sma[l_ac].tc_sma05 = 'N'
    LET g_tc_sma[l_ac].tc_sma08 = 'N'
    LET g_tc_sma[l_ac].tc_sma11 = 'N'
    LET g_tc_sma[l_ac].tc_sma14 = 'N'
    LET g_tc_sma[l_ac].tc_sma17 = 'N'
    LET g_tc_sma[l_ac].tc_sma20 = 'Y'
    case g_tc_sma01
        when 'csmi101'
            if g_tc_sma[l_ac].tc_sma04 ='1' then
                let g_tc_sma[l_ac].tc_sma19 = 36
            end if
            if g_tc_sma[l_ac].tc_sma04 ='2' then
                # CMM
                let g_tc_sma[l_ac].tc_sma05 = 'Y'
                let g_tc_sma[l_ac].tc_sma06 = 300
                let g_tc_sma[l_ac].tc_sma19 = 50
            end if
         when 'csmi102'
            let g_tc_sma[l_ac].tc_sma02 ='aimi100'
            let g_tc_sma[l_ac].tc_sma07 = 0
            let g_tc_sma[l_ac].tc_sma09 = 100
            let g_tc_sma[l_ac].tc_sma02_desc = i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[l_ac].tc_sma02)
         when 'csmi103'
            let g_tc_sma[l_ac].tc_sma06 = 0
            let g_tc_sma[l_ac].tc_sma02_desc = i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[l_ac].tc_sma02)
         when 'csmi104'
            let g_tc_sma[l_ac].tc_sma06 = g_tc_sma[l_ac].tc_sma03
            let g_tc_sma[l_ac].tc_sma02_desc = i100_get_tc_sma_desc(g_tc_sma01,g_tc_sma[l_ac].tc_sma02)
         when "csmi105"
         when 'csmi115'
            let g_tc_sma[l_ac].tc_sma06 = 0
            let g_tc_sma[l_ac].tc_sma07 = 0
         # darcy:2025/07/28 add s--- 
         # 默认值
         when 'csmi120'
            let g_tc_sma[l_ac].tc_sma06 = 'default'
         # darcy:2025/07/28 add e--- 
         # darcy:2025/09/03 add s---
         when 'csmi121'
            let g_tc_sma[l_ac].tc_sma02 = 'aimi100'
         # darcy:2025/09/03 add e---
    end case
end function

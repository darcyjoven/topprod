# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimi113.4gl
# Descriptions...: demo作业示例
# Date & Author..: No.FUN-790025 07/10/26 By douzh
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
DATABASE ds
 
GLOBALS "../../config/top.global"

#模組變數(Module Variables)
TYPE tc_cma RECORD
         tc_cma01    LIKE tc_cma_file.tc_cma01,
         imz02       like imz_file.imz02,
         tc_cma02    LIKE tc_cma_file.tc_cma02,
         tc_cma03    LIKE tc_cma_file.tc_cma03,
         tc_cma04    LIKE tc_cma_file.tc_cma04,
         tc_cma05    LIKE tc_cma_file.tc_cma05,
         tc_cma06    LIKE tc_cma_file.tc_cma06,
         tc_cma07    LIKE tc_cma_file.tc_cma07,
         tc_cma08    LIKE tc_cma_file.tc_cma08,
         tc_cma09    LIKE tc_cma_file.tc_cma09,
         tc_cma10    LIKE tc_cma_file.tc_cma10
    END RECORD
TYPE tc_cmb RECORD
         tc_cmb03    LIKE tc_cmb_file.tc_cmb03,
         tc_cmb04    LIKE tc_cmb_file.tc_cmb04,
         tc_cmb05    LIKE tc_cmb_file.tc_cmb05,
         tc_cmb06    LIKE tc_cmb_file.tc_cmb06,
         tc_cmb07    LIKE tc_cmb_file.tc_cmb07
    END RECORD

DEFINE 
    g_tc_cma01         LIKE tc_cma_file.tc_cma01,
    g_tc_cma02         LIKE tc_cma_file.tc_cma02,
    g_tc_cma01_t       LIKE tc_cma_file.tc_cma01,
    g_tc_cma           tc_cma,
    g_tc_cma_t         tc_cma,
    g_tc_cmb           DYNAMIC ARRAY OF  tc_cmb,
    g_tc_cmb_t         tc_cmb,
    g_tc_cmb_o         tc_cmb,
    g_tc_cmb2          tc_cmb,  
    g_wc,g_wc2,g_wc3,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    g_buf           LIKE tc_cmb_file.tc_cmb01,  
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  
    l_ac_t          LIKE type_file.num5,                #目前處理的ARRAY CNT  
    l_cmd           LIKE type_file.chr1000  
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE g_cnt        LIKE type_file.num10   
DEFINE g_chr        LIKE type_file.chr1   
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg        LIKE type_file.chr1000 
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10 
DEFINE g_jump       LIKE type_file.num10  
DEFINE g_no_ask     LIKE type_file.num5    
# DEFINE g_pjz        RECORD LIKE pjz_file.*
DEFINE g_argv1      LIKE tc_cma_file.tc_cma01      #No.FUN-830139
DEFINE g_cn         LIKE type_file.num5      #No.FUN-830139 
DEFINE g_t1         LIKE tc_cma_file.tc_cma01
define g_imz02      like imz_file.imz02

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
 
   # SELECT * INTO g_pjz.* FROM pjz_file 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  

 
   LET g_forupd_sql = "SELECT tc_cma01,tc_cma02,tc_cma03,tc_cma04,tc_cma05,tc_cma06,tc_cma07,tc_cma08,tc_cma09,tc_cma10",
                      "  FROM tc_cma_file WHERE tc_cma01 = ? AND tc_cma02 =? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i113_cl CURSOR FROM g_forupd_sql

   LET g_forupd_sql = " SELECT tc_cmb03,tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07",
                      " FROM tc_cmb_file WHERE tc_cmb01 = ? AND tc_cmb02 = ? AND tc_cmb03 =? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i113_bcl CURSOR FROM g_forupd_sql 

 
   LET g_argv1 = ARG_VAL(1)                       #No.FUN-830139
 
   OPEN WINDOW i113_w WITH FORM "cim/42f/cimi113"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
   CALL i113_init()               
        
   IF g_argv1 IS NOT NULL THEN 
      SELECT count(*) INTO g_cn FROM tc_cmb_file WHERE tc_cmb01 = g_argv1
      IF g_cn > 0 THEN
         CALL i113_q()
      ELSE
         CALL i113_tc_cmb01('d')
         CALL i113_b()
      END IF
   END IF
 
   CALL i113_menu()
 
   CLOSE WINDOW i113_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           
END MAIN
 
 
FUNCTION i113_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
  CLEAR FORM                             #清除畫面
  IF cl_null(g_argv1) THEN               #No.FUN-830139 add  by douzh 
    CALL g_tc_cmb.clear()
    CALL cl_set_head_visible("","YES")    
   
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
      CONSTRUCT BY NAME g_wc ON tc_cma01,imz02,tc_cma02,tc_cma03,tc_cma04,tc_cma05,tc_cma06,
                                tc_cma07,tc_cma08,tc_cma09
         BEFORE CONSTRUCT
         #NOTE nothing

         AFTER FIELD tc_cma01

         ON ACTION controlp INFIELD tc_cma01
         #NOTE 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         #    EXIT CONSTRUCT 

      END CONSTRUCT

      CONSTRUCT g_wc2 ON tc_cmb03,tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07
                    FROM s_tc_cmb[1].tc_cmb03,s_tc_cmb[1].tc_cmb04,s_tc_cmb[1].tc_cmb05,
                    s_tc_cmb[1].tc_cmb06,s_tc_cmb[1].tc_cmb07
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #NOTE nothing

         AFTER FIELD tc_cmb03

         ON ACTION controlp INFIELD tc_cmb05
         #NOTE 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         # EXIT CONSTRUCT

      END CONSTRUCT


      BEFORE DIALOG
         CALL cl_qbe_init() 
      #    # LET g_inbb_d[1].inbbseq = ""
          
      
      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG


   END DIALOG

   #TODO wc 条件组合
     
              
 
     
  IF INT_FLAG THEN RETURN END IF 
    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')         #MOD-C10146 mark
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_cmauser', 'tc_cmagrup')         #MOD-C10146 add 
  ELSE                                                           #No.FUN-830139
    LET g_wc="tc_cma01='",g_argv1,"'"                               #No.FUN-830139 
    LET g_wc2 = " 1=1"
  END IF                                                         #No.FUN-830139 
 
 
 
  IF INT_FLAG THEN RETURN END IF 
   
 
END FUNCTION
FUNCTION i113_prepare()
   IF g_wc2 = " 1=1"  THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  tc_cma01,tc_cma02 FROM tc_cma_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_cma01"  
   ELSE
      LET g_sql = "SELECT UNIQUE tc_cma01,tc_cma02 ",
               "  FROM tc_cma_file, tc_cmb_file",
               " WHERE tc_cma01 = tc_cmb01 AND tc_cma02=tc_cmb02",
               "   AND ",g_wc CLIPPED ,
               "   AND ", g_wc2 CLIPPED
   END IF
   
   PREPARE i113_prepare FROM g_sql
   DECLARE i113_cs                         #SCROLL CURSOR
         SCROLL CURSOR WITH HOLD FOR i113_prepare
   
   
   IF g_wc2 = " 1=1"  THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tc_cma_file ",
                  " WHERE ", g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE tc_cma01,tc_cma02) ",
                  "  FROM tc_cma_file,tc_cmb_file ",
                  " WHERE tc_cmb01=tc_cma01 AND tc_cma02=tc_cmb02",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
   
   PREPARE i113_precount FROM g_sql
   DECLARE i113_count CURSOR FOR i113_precount
END FUNCTION
 
FUNCTION i113_menu()
 
   WHILE TRUE
      CALL i113_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i113_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i113_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i113_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i113_i("u")
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i113_i("u")
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i113_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_cmb),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_cma01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_cmb01"
                  LET g_doc.value1 = g_tc_cma01
                  CALL cl_doc()
                  END IF
            END IF
         when "confirm"
            if cl_chk_act_auth() then
               call i113_confirm("Y")
            end if
         when "unconfirm"
            if cl_chk_act_auth() then
               call i113_confirm("N")
            end if
      END CASE
   END WHILE
END FUNCTION
 
#Insert 錄入
FUNCTION i113_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_cmb.clear()
 
   INITIALIZE g_tc_cma01    LIKE tc_cmb_file.tc_cmb01
   INITIALIZE g_tc_cma.*    LIKE tc_cma_file.*
    
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL i113_i('a')
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_tc_cma01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      # CALL i113_b()    #NOTE 可以省略                      # 輸入單身
      LET g_tc_cma01_t=g_tc_cma01
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#Query 查詢
FUNCTION i113_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL i113_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tc_cma.* TO NULL
        RETURN
    END IF

    CALL i113_prepare()  #NOTE 归纳为一个函数，避免逻辑不清
    #TODO 如果查不到资料，直接报错

    MESSAGE " SEARCHING ! " 
    OPEN i113_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_tc_cma01 = NULL 
       INITIALIZE g_tc_cma.* TO NULL
    ELSE
       OPEN i113_count
       FETCH i113_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i113_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i113_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式   
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i113_cs INTO g_tc_cma01,g_tc_cma02
    WHEN 'P' FETCH PREVIOUS i113_cs INTO g_tc_cma01,g_tc_cma02
    WHEN 'F' FETCH FIRST    i113_cs INTO g_tc_cma01,g_tc_cma02
    WHEN 'L' FETCH LAST     i113_cs INTO g_tc_cma01,g_tc_cma02
    WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i113_cs INTO g_tc_cma01,g_tc_cma02
            LET g_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_cma01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_cma.* TO NULL            
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
    SELECT UNIQUE tc_cma01,tc_cma02 INTO g_tc_cma01,g_tc_cma02
      FROM tc_cma_file 
     WHERE tc_cma01 = g_tc_cma01 and tc_cma02 = g_tc_cma02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_cma_file",g_tc_cma01,"",SQLCA.sqlcode,"","",1) 
       INITIALIZE g_tc_cma01 TO NULL
       initialize g_tc_cma02 to null
       RETURN
    END IF 
    CALL i113_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i113_show()
   SELECT tc_cma01,imz02,tc_cma02,tc_cma03,tc_cma04,tc_cma05,tc_cma06,tc_cma07,tc_cma08,tc_cma09,tc_cma10
     INTO g_tc_cma.* FROM tc_cma_file,imz_file
    WHERE tc_cma01 = g_tc_cma01 and tc_cma02 = g_tc_cma02
      and tc_cma01 = imz01
   LET g_tc_cma_t.* = g_tc_cma.*                #保存單頭舊值
   DISPLAY BY NAME g_tc_cma.* 
                   
   CALL i113_tc_cmb01('d')
   CALL i113_b_fill(g_wc2)                 #單身  #FUN-840141
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i113_tc_cmb01(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
#TODO：
 
END FUNCTION
 
FUNCTION i113_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
   DEFINE   l_count      LIKE type_file.num5   
   DEFINE   l_n          LIKE type_file.num5, 
            l_allow_insert  LIKE type_file.num5,                #可新增否
            l_allow_delete  LIKE type_file.num5   
   # DISPLAY BY NAME g_tc_cmb.*
   DEFINE   li_result    LIKE type_file.chr1
   DEFINE   c            DATETIME HOUR TO SECOND
   define   l_cnt        like type_file.num5
   define   l_cnt1       like type_file.num5

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET g_before_input_done = FALSE

   let g_success = true

   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)

      INPUT BY NAME g_tc_cma.tc_cma01,g_tc_cma.tc_cma03,g_tc_cma.tc_cma10 ATTRIBUTE(WITHOUT DEFAULTS) 

         BEFORE INPUT
            MESSAGE "" 
         #TODO: 检查事务
            
         #TODO: 更新

         #TODO: 设置actionchoice

         #TODO 默认值
            IF p_cmd='a' THEN
                LET g_tc_cma.tc_cma03='N'
            ELSE 
                BEGIN WORK
                OPEN i113_cl USING g_tc_cma01,g_tc_cma02
                IF STATUS THEN
                  CALL cl_err("OPEN i113_cl:", STATUS, 1)
                  CLOSE i113_cl
                  ROLLBACK WORK
                  RETURN
                END IF

                FETCH i113_cl INTO g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                                   g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_cma.tc_cma01,SQLCA.sqlcode,1)  
                  ROLLBACK WORK
                  RETURN
                END IF
               select imz02 into g_tc_cma.imz02 from imz_file where imz01 = g_tc_cma.tc_cma01

                IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_cma.tc_cma01,SQLCA.sqlcode,1)  
                  ROLLBACK WORK
                  RETURN
                END IF
            END IF

         #TODO: entry设置
            CALL i113_set_entry(p_cmd)
            CALL i113_set_entry_b(p_cmd)
            CALL i113_set_no_entry(p_cmd)
            CALL i113_set_no_entry_b(p_cmd)
            CALL i113_set_required(p_cmd)

         BEFORE FIELD tc_cma01
         #TODO 判断是修改还是新增
             IF p_cmd = 'u' THEN
               NEXT FIELD tc_cma10
             END IF

         AFTER FIELD tc_cma01 
         #TODO: 检查
            IF NOT cl_null(g_tc_cma.tc_cma01) OR (g_tc_cma.tc_cma01!=g_tc_cma.tc_cma01) THEN
                call i113_get_tc_cma02(g_tc_cma.tc_cma01) returning g_success,g_tc_cma.tc_cma02
                if not g_success then
                    next field tc_cma01
                display g_tc_cma.tc_cma02 to tc_cma02
                end if
                let g_tc_cma01 = g_tc_cma.tc_cma01
                let g_tc_cma02 = g_tc_cma.tc_cma02

            END IF 
         ON ACTION controlp INFIELD tc_cma01
            call cl_init_qry_var()
            let g_qryparam.form     = "q_imz"
            let g_qryparam.state    = "i"
            call cl_create_qry() returning g_tc_cma.tc_cma01
            display g_tc_cma.tc_cma01 to tc_cma01
            NEXT FIELD tc_cma01 
 
         AFTER INPUT
         #TODO 检查错误信息
         #TODO 根据actionchoice 确认update还是insert
            IF i113_input(p_cmd) THEN
               display g_tc_cma.tc_cma02 to tc_cma02
               continue dialog
            END IF

      END INPUT 

      INPUT ARRAY g_tc_cmb FROM s_tc_cmb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

         BEFORE INPUT
            MESSAGE ""
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

            
         #TODO 检查新增时，需要确定新增单号单号

         #TODO 如果是新增，将游标设置为当前位置+1
         #TODO 如果是修改，游标设置为第一个位置
         #TODO 设置当前长度等变量

         BEFORE ROW
         #TODO 设置项次自动编号
         #NOTE 设置当前游标位置
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
         #NOTE 检查事务 
            IF p_cmd='a' THEN 
            ELSE
                BEGIN WORK
                OPEN i113_cl USING g_tc_cma01,g_tc_cma02
                IF STATUS THEN
                    CALL cl_err("OPEN i113_cl:", STATUS, 1)
                    CLOSE i113_cl
                    ROLLBACK WORK
                    RETURN
                END IF

                FETCH i113_cl INTO g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                                   g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_cma.tc_cma01,SQLCA.sqlcode,1)  
                    ROLLBACK WORK
                    RETURN
                END IF
            end if

         #NOTE 游标大于当前行数，判断为修改，修改前先重新显示一遍
            if l_ac <= g_rec_b then
            # IF g_rec_b < l_ac THEN
               LET p_cmd = 'u'
               LET g_tc_cmb_t.* = g_tc_cmb[l_ac].*
         #NOTE 检查单身事务
               begin work
               OPEN i113_bcl USING g_tc_cma01,g_tc_cma02,g_tc_cmb_t.tc_cmb03
               IF STATUS THEN
                  CALL cl_err("OPEN i113_bcl:", STATUS, 1)
               ELSE
                  FETCH i113_bcl INTO g_tc_cmb2.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tc_cmb_t.tc_cmb03,SQLCA.sqlcode,1)
                  ELSE
                     LET g_tc_cmb[l_ac].* = g_tc_cmb2.*
                  END IF
               END IF
            END IF 

         #NOTE 设置requery
         #NOTE 设置entry
            CALL i113_set_required(p_cmd)
            CALL i113_set_entry_b(p_cmd)
            CALL i113_set_no_entry_b(p_cmd)

            next field tc_cmb03
         
         before field tc_cmb03
            if  g_rec_b < l_ac then
               let l_cnt = 0
               let l_cnt1 = 0
               select max(tc_cmb03),max(tc_cmb04) into l_cnt,l_cnt1 from tc_cmb_file 
                where tc_cmb01 = g_tc_cma01 and tc_cmb02 =g_tc_cma02
               if l_cnt > 0 then
                  let g_tc_cmb[l_ac].tc_cmb03 = l_cnt + 1
                  let g_tc_cmb[l_ac].tc_cmb04 = l_cnt1 + 1
               else
                  let g_tc_cmb[l_ac].tc_cmb03 = 1
                  let g_tc_cmb[l_ac].tc_cmb04 = 1
               end if
            end if

         BEFORE INSERT  
            LET l_n = ARR_COUNT()
            BEGIN WORK
            LET p_cmd='a'
            # LET g_before_input_done = FALSE
         #NOTE 设置entry
            CALL i113_set_entry_b(p_cmd)
            CALL i113_set_no_entry_b(p_cmd)
         #NOTE 清空值
            INITIALIZE g_tc_cmb[l_ac].* TO NULL
            INITIALIZE g_tc_cmb_t.* TO NULL
            INITIALIZE g_tc_cmb_o.* TO NULL
            INITIALIZE g_tc_cmb2.* TO NULL
         #NOTE 设置默认值
         
         #TODO 检查事务  

         AFTER INSERT
            IF INT_FLAG THEN 
               # CALL cl_err()
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            LET g_tc_cmb2.* = g_tc_cmb[l_ac].*

         #TODO 基本检查
         #TODO 资料未重复，插入新增资料
            
            INSERT INTO tc_cmb_file(tc_cmb01,tc_cmb02,tc_cmb03,tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07) 
            VALUES(g_tc_cma01,g_tc_cma02,g_tc_cmb[l_ac].tc_cmb03,g_tc_cmb[l_ac].tc_cmb04,g_tc_cmb[l_ac].tc_cmb05,
                   g_tc_cmb[l_ac].tc_cmb06,g_tc_cmb[l_ac].tc_cmb07)
            IF SQLCA.sqlcode THEN
               CALL cl_err("ins tc_cmb_file",SQLCA.sqlcode,1) 
               LET g_success = 'N'
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            IF g_success THEN
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2         
               COMMIT WORK 
            ELSE
               ROLLBACK WORK
            END IF

         #TODO 继续插入第二笔之后资料

         BEFORE DELETE
         #TODO 修改模式时，弹窗确认
         #NOTE 删除单身
            DELETE FROM tc_cmb_file 
             WHERE tc_cmb01 = g_tc_cma01 
               AND tc_cmb02 = g_tc_cma02
               AND tc_cmb03 = g_tc_cmb[l_ac].tc_cmb03
         
         #TODO 设置单身笔数
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         #TODO 提交事务

         AFTER DELETE 
         #TODO 如果是最后一笔要设置游标

         AFTER FIELD tc_cmb03
         #TODO 检查

         ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_tc_cmb[l_ac].* = g_tc_cmb_t.* 
               CLOSE i113_bcl
               ROLLBACK WORK 
               EXIT DIALOG
            END IF

            LET g_tc_cmb2.* = g_tc_cmb[l_ac].*
         #TODO UPDATE 单身
            UPDATE tc_cmb_file 
               SET tc_cmb03 = g_tc_cmb[l_ac].tc_cmb03,
                   tc_cmb04 = g_tc_cmb[l_ac].tc_cmb04,
                   tc_cmb05 = g_tc_cmb[l_ac].tc_cmb05,
                   tc_cmb06 = g_tc_cmb[l_ac].tc_cmb06,
                   tc_cmb07 = g_tc_cmb[l_ac].tc_cmb07
             WHERE tc_cmb01 = g_tc_cma01 
               AND tc_cmb02 = g_tc_cma02
               AND tc_cmb03 = g_tc_cmb[l_ac].tc_cmb03 
            IF SQLCA.sqlcode THEN
               CALL cl_err("",SQLCA.sqlcode,1)
               LET g_tc_cmb[l_ac].* = g_tc_cmb_t.*
               LET g_success = 'N'
            END IF

            IF g_success THEN
               MESSAGE 'UPDATE O.K'    
               COMMIT WORK
               CALL i113_b_fill(' 1=1') 
            ELSE
               ROLLBACK WORK
            END IF

         #TODO 重新fill单身

         AFTER ROW
            DISPLAY "AFTER ROW=",g_tc_cmb.getLength()," l_ac=",l_ac
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,1)
               LET INT_FLAG = FALSE
            #NOTE   
               IF p_cmd = 'u' THEN
                  LET g_tc_cmb[l_ac].* = g_tc_cmb_t.*
               ELSE 
                  CALL g_tc_cmb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               DISPLAY 'leave =',g_tc_cmb.getLength()," l_ac=",l_ac
               CLOSE i113_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac_t = l_ac      #TQC-D40025
            CLOSE i113_bcl
            COMMIT WORK

         #TODO 提交事务

         AFTER INPUT
         #TODO 提交事务
            IF INT_FLAG THEN                         
               LET INT_FLAG = FALSE
               EXIT DIALOG
            END IF

         ON ACTION controlo
         #TODO 复制 
 
      END INPUT


      BEFORE DIALOG

      #TODO 决定双击进入哪个单身
      #TODO 新增的时候，游标设置为1

      AFTER DIALOG
      #TODO nothing

      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()


      ON ACTION accept 
      #TODO INSERT 
         #INSERT    
         IF i113_input(p_cmd) THEN
           let g_action_choice = ""
            EXIT DIALOG
         END IF

      ON ACTION cancel 
      #TODO 放弃输入，提交事务
         rollback work
         let g_action_choice = ""
         exit DIALOG

      ON ACTION close
      #TODO 关掉作业
         let g_action_choice = ""
         exit DIALOG

      ON ACTION exit #toolbar 離開
      #TODO 关掉作业
         let g_action_choice = ""
         EXIT DIALOG
 

   END DIALOG
 
END FUNCTION
 
FUNCTION i113_r()
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_gav   RECORD LIKE gav_file.*
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_tc_cma01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF  
 
   BEGIN WORK
 
   OPEN i113_cl USING g_tc_cma01,g_tc_cma02
   IF STATUS THEN
      CALL cl_err("OPEN i113_cl:", STATUS, 1)
      CLOSE i113_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i113_cl INTO g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                                   g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_cma01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   #No.TQC-A70016  --Begin                                                      
   #IF cl_delh(0,0) THEN                   #确认一下                            
   IF cl_confirm('lib-357') THEN                                                
   #No.TQC-A70016  --End    
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tc_cmb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tc_cma01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24

      delete from tc_cma_file where tc_cma01 = g_tc_cma01 and tc_cma02 = g_tc_cma02
      if sqlca.sqlcode then
         call cl_err("delete tc_cma_file",sqlca.sqlcode,1)
         rollback work
         return
      end if
      DELETE FROM tc_cmb_file WHERE tc_cmb01 = g_tc_cma01 and tc_cmb02 = g_tc_cma02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tc_cmb_file",g_tc_cma01,"",SQLCA.sqlcode,"","BODY DELETE",0)  
         rollback work
         return
      ELSE
         CLEAR FORM
         CALL g_tc_cmb.clear()
         OPEN i113_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i113_cs
            CLOSE i113_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i113_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i113_cs
            CLOSE i113_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i113_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i113_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE         
            CALL i113_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i113_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_cma01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION i113_b() 
#TODO 
 
END FUNCTION
 
#檢查資料重復
FUNCTION i113_b_check()
DEFINE p_tc_cmb04  LIKE tc_cmb_file.tc_cmb04
DEFINE p_tc_cmb05  LIKE tc_cmb_file.tc_cmb05
DEFINE p_tc_cmb06  LIKE tc_cmb_file.tc_cmb06
DEFINE l_n      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
 
  LET g_errno ="" 
 
  SELECT count(*) INTO l_n FROM tc_cmb_file 
   WHERE tc_cmb01 = g_tc_cma01 
    AND tc_cmb04 = g_tc_cmb[l_ac].tc_cmb04
    AND tc_cmb05 = g_tc_cmb[l_ac].tc_cmb05
    AND tc_cmb06 = g_tc_cmb[l_ac].tc_cmb06
  
  IF l_n > 0 THEN
     LET g_errno = '-239'
  ELSE
     SELECT count(*) INTO l_n2 FROM tc_cmb_file 
      WHERE tc_cmb01 = g_tc_cma01 
        AND tc_cmb03 = g_tc_cmb[l_ac].tc_cmb06
        AND tc_cmb09 ='Y'
     IF l_n2 > 0 THEN
        LET g_errno = 'apj-078'
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i113_b_askkey()
#  DEFINE l_wc    STRING     #NO.FUN-910082
 
#     CONSTRUCT l_wc  ON tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb03,tc_cmb03,
#                        tc_cmb07,tc_cmb08,tc_cmb09,tc_cmb25,tc_cmb10,tc_cmb11,
#                        tc_cmb12,tc_cmb13,tc_cmb14,tc_cmb21,tc_cmbacti 
#             FROM s_tc_cmb[1].tc_cmb04, s_tc_cmb[1].tc_cmb05, 
#                  s_tc_cmb[1].tc_cmb06, s_tc_cmb[1].tc_cmb03,s_tc_cmb[1].tc_cmb03, 
#                  s_tc_cmb[1].tc_cmb07, s_tc_cmb[1].tc_cmb08,s_tc_cmb[1].tc_cmb09,s_tc_cmb[1].tc_cmb25,
#                  s_tc_cmb[1].tc_cmb10, s_tc_cmb[1].tc_cmb11,s_tc_cmb[1].tc_cmb12,
#                  s_tc_cmb[1].tc_cmb13, s_tc_cmb[1].tc_cmb14,s_tc_cmb[1].tc_cmb21,s_tc_cmb[1].tc_cmbacti
 
#               BEFORE CONSTRUCT
#                  CALL cl_qbe_init()
 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
 
#       ON ACTION about         
#          CALL cl_about()     
 
#       ON ACTION help        
#          CALL cl_show_help() 
 
#       ON ACTION controlg    
#          CALL cl_cmdask()   
 
#       ON ACTION qbe_select
#          CALL cl_qbe_select() 
 
#       ON ACTION qbe_save
#          CALL cl_qbe_save()
 
#     END CONSTRUCT
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         RETURN
#     END IF
#     CALL i113_b_fill(l_wc," 1=1 ")
 
END FUNCTION
 
FUNCTION i113_b_fill(p_wc1)              #BODY FILL UP
DEFINE  p_wc1  STRING
 
   LET g_sql = " SELECT tc_cmb03,tc_cmb04,tc_cmb05,tc_cmb06,tc_cmb07 ",
               " FROM tc_cmb_file",
               " WHERE tc_cmb01 ='",g_tc_cma01,"' AND tc_cmb02 = '",g_tc_cma02,"'",
               "   AND ",p_wc1 CLIPPED,
               " ORDER BY tc_cmb03"
 
   PREPARE i113_pb_deb FROM g_sql
   DECLARE tc_cmb_curs CURSOR FOR i113_pb_deb
 
   CALL g_tc_cmb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH tc_cmb_curs INTO g_tc_cmb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
     
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    
   END FOREACH
   CALL g_tc_cmb.deleteElement(g_cnt) 
   let  g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i113_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   DISPLAY "/u1/topprod/tiptop/doc/pic/pdf_logo_flymn2.jpg" TO tc_cma12
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
         DISPLAY ARRAY g_tc_cmb TO s_tc_cmb.* ATTRIBUTES(COUNT=g_rec_b)

               BEFORE ROW
               #TODO: 显示单身笔数，确定当下选择的笔数
               MESSAGE ""

               BEFORE DISPLAY
               #TODO: 

         END DISPLAY 

         BEFORE DIALOG

               #TODO: 先填充browser资料
               #TODO: 游标回归旧笔数
               #TODO: #有資料才進行fetch
               #TODO: 笔数显示

         ON ACTION first 
            CALL i113_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                              
 
         ON ACTION previous
            CALL i113_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                                 
   
         ON ACTION jump 
            CALL i113_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                   
                                 
   
         ON ACTION next
            CALL i113_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                                 
   
         ON ACTION last 
            CALL i113_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY 

         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
   
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
         
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
         
         on action confirm
            let g_action_choice="confirm"
            exit dialog

         on action unconfirm
            let g_action_choice="unconfirm"
            exit dialog
   
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
   
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
   
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()     
   
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
   
         ON ACTION controlg 
            LET g_action_choice="controlg"
            EXIT DIALOG
   
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
   
         ON ACTION cancel
            LET INT_FLAG=FALSE 	
            LET g_action_choice="exit"
            EXIT DIALOG
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
   
         ON ACTION about         
            CALL cl_about()     
   
         ON ACTION exporttoexcel  
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
   
         ON ACTION controls      
            CALL cl_set_head_visible("","AUTO")     
   
         ON ACTION related_document            #相關文件
            LET g_action_choice="related_document"          
            EXIT DIALOG 
   
         # AFTER DISPLAY
         #    CONTINUE DISPLAY

         &include "qry_string.4gl"

   END DIALOG

   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i113_b_y(p_cmd,l_cnt)
   DEFINE   p_cmd LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   # IF g_tc_cmb[l_cnt].tc_cmb21 !='0' THEN
   #    CALL cl_err("",'9021',0)
   #    RETURN
   # END IF
 
   IF cl_confirm('aap-222') THEN
      BEGIN WORK
 
      OPEN i113_cl USING g_tc_cma01,g_tc_cma02
      IF STATUS THEN
         CALL cl_err("OPEN i113_cl:", STATUS, 1)
         CLOSE i113_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH i113_cl INTO g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                                   g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_cma01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
  
      CALL i113_b_fill(g_wc2)   #FUN-840141
   
      # LET g_tc_cmb[l_cnt].tc_cmb21='1'
 
      # UPDATE tc_cmb_file SET tc_cmb21=g_tc_cmb[l_cnt].tc_cmb21,
      #                     tc_cmbmodu=g_user,
      #                     tc_cmbdate=g_today
      #               WHERE tc_cmb01=g_tc_cma01
      #                 AND tc_cmb03=g_tc_cmb[l_cnt].tc_cmb03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_cmb_file",g_tc_cma01,g_tc_cmb[l_cnt].tc_cmb03,SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
      END IF
 
      CLOSE i113_cl
 
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_tc_cma01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF
   
END FUNCTION
 
FUNCTION i113_b_v(p_cmd,l_cnt)
   DEFINE   p_cmd   LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   # IF g_tc_cmb[l_cnt].tc_cmb21 !='1' THEN
   #    CALL cl_err("",'9021',0)
   #    RETURN
   # END IF
   
   IF cl_confirm('aap-224') THEN 
      BEGIN WORK
 
      OPEN i113_cl USING g_tc_cma01,g_tc_cma02
      IF STATUS THEN
         CALL cl_err("OPEN i113_cl:", STATUS, 1)
         CLOSE i113_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH i113_cl INTO g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                                   g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_cma01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
   
      CALL i113_b_fill(g_wc2)  #FUN-840141
   
      # LET g_tc_cmb[l_cnt].tc_cmb21='0'
 
      # UPDATE tc_cmb_file SET tc_cmb21=g_tc_cmb[l_cnt].tc_cmb21,
      #                     tc_cmbmodu=g_user,
      #                     tc_cmbdate=g_today
      #               WHERE tc_cmb01=g_tc_cma01
      #                 AND tc_cmb03=g_tc_cmb[l_cnt].tc_cmb03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_cmb_file",g_tc_cma01,g_tc_cmb[l_cnt].tc_cmb03,SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
      END IF
   
      CLOSE i113_cl
   
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_tc_cma01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF 
 
END FUNCTION
 
FUNCTION i113_out()
DEFINE l_i      LIKE type_file.num5,  
       sr       RECORD
               tc_cmb03    LIKE tc_cmb_file.tc_cmb03,
               tc_cmb04    LIKE tc_cmb_file.tc_cmb04,
               tc_cmb05    LIKE tc_cmb_file.tc_cmb05,
               tc_cmb06    LIKE tc_cmb_file.tc_cmb06,
               tc_cmb07    LIKE tc_cmb_file.tc_cmb07
                END RECORD,
       l_name   LIKE type_file.chr20,  
       l_za05   LIKE type_file.chr1000 
 
    IF g_wc IS NULL THEN
       LET g_wc ="tc_cma01 ='",g_tc_cma01,"'"
    END IF
 
    CALL cl_wait()
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * ",
              " FROM tc_cmb_file,tc_cma_file",
              " WHERE tc_cmb01 = tc_cma01 ",
              "   AND ",g_wc CLIPPED,
              " ORDER BY tc_cmb03 "
     CALL cl_prt_cs1('cimi113','cimi113',g_sql,'')
 
END FUNCTION
 
FUNCTION i113_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("tc_cmb01",TRUE) 
   END IF
 
END FUNCTION
 
FUNCTION i113_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       
 
   CALL cl_set_comp_entry("tc_cma03",FALSE) 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("tc_cma01",FALSE) 
   END IF
END FUNCTION
FUNCTION i113_set_entry_b(p_cmd)  
  DEFINE p_cmd   LIKE type_file.chr1       
END FUNCTION
FUNCTION i113_set_no_entry_b(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1       
END FUNCTION 
FUNCTION i113_set_required(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1       
   CALL cl_set_comp_required("tc_cma02,tc_cma03",TRUE)

END FUNCTION 
FUNCTION i113_set_comp()
#    CALL cl_set_combo_items("tc_cma07","1,2,3,4","一,二,三,四")
#    CALL cl_set_combo_items("tc_cmb07","1,2","香蕉,苹果")
   # CALL cl_set_combo_items("tc_cma08","1,2,3","苹果,橘子,香蕉")
END FUNCTION
FUNCTION i113_init()
   CALL i113_set_comp()
END FUNCTION
# 检查单头资料
FUNCTION i113_input(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          li_result  LIKE type_file.chr1,
          l_cnt      LIKE type_file.num5
   #NOTE 检查必要栏位
   IF cl_null(g_tc_cma.tc_cma01) THEN
      CALL cl_err("请录入分群码!","!",1)
      RETURN FALSE
   END IF  
   
    let g_tc_cma.tc_cma04 = g_user
    let g_tc_cma.tc_cma05 = g_today
    let g_tc_cma.tc_cma06 = g_user
    let g_tc_cma.tc_cma07 = g_today


    IF p_cmd='a' AND g_before_input_done = FALSE THEN 
        INSERT INTO tc_cma_file (tc_cma01,tc_cma02,tc_cma03,tc_cma04,tc_cma05,
                                tc_cma06,tc_cma07,tc_cma08,tc_cma09,tc_cma10) 
        VALUES(g_tc_cma.tc_cma01,g_tc_cma.tc_cma02,g_tc_cma.tc_cma03,g_tc_cma.tc_cma04,g_tc_cma.tc_cma05,
                g_tc_cma.tc_cma06,g_tc_cma.tc_cma07,g_tc_cma.tc_cma08,g_tc_cma.tc_cma09,g_tc_cma.tc_cma10)
        IF SQLCA.sqlcode THEN
            CALL cl_err("insert into tc_cma_file:",SQLCA.sqlcode,1) 
            ROLLBACK WORK
            RETURN FALSE
        ELSE 
            COMMIT WORK
            RETURN TRUE
        END IF 
    END IF 

   IF g_before_input_done ='Y' OR p_cmd='u' THEN
      UPDATE tc_cma_file 
         SET tc_cma02 = g_tc_cma.tc_cma02,
             tc_cma03 = g_tc_cma.tc_cma03,
             tc_cma04 = g_tc_cma.tc_cma04,
             tc_cma05 = g_tc_cma.tc_cma05,
             tc_cma06 = g_tc_cma.tc_cma06,
             tc_cma07 = g_tc_cma.tc_cma07,
             tc_cma08 = g_tc_cma.tc_cma08,
             tc_cma09 = g_tc_cma.tc_cma09,
             tc_cma10 = g_tc_cma.tc_cma10
       WHERE tc_cma01 = g_tc_cma.tc_cma01
         and tc_cma02 = g_tc_cma.tc_cma02

      IF SQLCA.sqlcode THEN
         CALL cl_err("update tc_cma_file:",SQLCA.sqlcode,1) 
         ROLLBACK WORK
         RETURN FALSE
      ELSE 
         COMMIT WORK
         RETURN TRUE
      END IF
   END IF 
END FUNCTION 

function i113_get_tc_cma02(p_tc_cma01)
    define p_tc_cma01  like tc_cma_file.tc_cma01
    define l_tc_cma02  like tc_cma_file.tc_cma02

    define cnt         like type_file.num5

    let cnt = 0
    select count(1) into cnt from imz_file where imz01 = p_tc_cma01 and imzacti='Y'
    if cnt = 0 then
        call cl_err(p_tc_cma01,"aic-037",1)
        return false,""
    else
        select imz01,imz02 into p_tc_cma01,g_imz02 from imz_file where imz01 = p_tc_cma01
        if sqlca.sqlcode then
            call cl_err("select imz",status,1)
            return false,""
        end if
        let l_tc_cma02 = 0
        select max(tc_cma02) into l_tc_cma02 from tc_cma_file where tc_cma01=p_tc_cma01
        if sqlca.sqlcode then
            call cl_err("select tc_cma",status,1)
            return false,""
        end if
        if l_tc_cma02 =0 or cl_null(l_tc_cma02) then
            let l_tc_cma02 = 1
        else
            let l_tc_cma02 = l_tc_cma02 + 1
        end if
    end if

    return true,l_tc_cma02
end function

function i113_confirm(flag)
   define flag varchar(1)

   begin work
   update tc_cma_file set tc_cma03 = flag where tc_cma01 = g_tc_cma01 and tc_cma02 = g_tc_cma02
   if sqlca.sqlcode then
      call cl_err("update tc_cma",sqlca.sqlcode,1)
      rollback work
      return
   end if

   if flag ='Y' then
      update tc_cma_file set tc_cma03 = flag where tc_cma01 = g_tc_cma01 and tc_cma02 != g_tc_cma02
      if sqlca.sqlcode then
         call cl_err("update tc_cma 2",sqlca.sqlcode,1)
         rollback work
         return
      end if
   end if

   commit work
   let g_tc_cma.tc_cma03 = flag
   display flag to tc_cma03

end function

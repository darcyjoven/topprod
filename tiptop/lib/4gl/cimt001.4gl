# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cimt001.4gl
# Descriptions...: demo作业示例
# Date & Author..: No.FUN-790025 07/10/26 By douzh
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
DATABASE ds
 
GLOBALS "../../config/top.global"

#模組變數(Module Variables)
TYPE tc_dea RECORD
         tc_dea01    LIKE tc_dea_file.tc_dea01,
         tc_dea02    LIKE tc_dea_file.tc_dea02,
         tc_dea03    LIKE tc_dea_file.tc_dea03,
         tc_dea04    LIKE tc_dea_file.tc_dea04,
         tc_dea05    LIKE tc_dea_file.tc_dea05,
         tc_dea06    LIKE tc_dea_file.tc_dea06,
         tc_dea07    LIKE tc_dea_file.tc_dea07,
         tc_dea08    LIKE tc_dea_file.tc_dea08,
         tc_dea09    LIKE tc_dea_file.tc_dea09,
         tc_dea10    LIKE tc_dea_file.tc_dea10,
         tc_dea11    LIKE tc_dea_file.tc_dea11,
         tc_dea12    LIKE tc_dea_file.tc_dea12,
         tc_dea13    LIKE tc_dea_file.tc_dea13,
         tc_dea14    LIKE tc_dea_file.tc_dea14,
         tc_dea15    LIKE tc_dea_file.tc_dea15,
         tc_dea16    LIKE tc_dea_file.tc_dea16,
         tc_dea17    LIKE tc_dea_file.tc_dea17,
         tc_dea18    LIKE tc_dea_file.tc_dea18,
         tc_dea19    LIKE tc_dea_file.tc_dea19,
         tc_dea20    LIKE tc_dea_file.tc_dea20
    END RECORD
TYPE tc_deb RECORD
         tc_deb02    LIKE tc_deb_file.tc_deb02,
         tc_deb04    LIKE tc_deb_file.tc_deb04,
         tc_deb05    LIKE tc_deb_file.tc_deb05,
         tc_deb06    LIKE tc_deb_file.tc_deb06,
         tc_deb07    LIKE tc_deb_file.tc_deb07,
         tc_deb08    LIKE tc_deb_file.tc_deb08,
         tc_deb09    LIKE tc_deb_file.tc_deb09,
         tc_deb10    LIKE tc_deb_file.tc_deb10,
         tc_deb11    LIKE tc_deb_file.tc_deb11,
         tc_deb12    LIKE tc_deb_file.tc_deb12,
         tc_deb13    LIKE tc_deb_file.tc_deb13,
         tc_deb14    LIKE tc_deb_file.tc_deb14,
         tc_deb15    LIKE tc_deb_file.tc_deb15,
         tc_deb16    LIKE tc_deb_file.tc_deb16
    END RECORD
TYPE tc_dec RECORD
         tc_dec02    LIKE tc_dec_file.tc_dec02,
         tc_dec04    LIKE tc_dec_file.tc_dec04,
         tc_dec05    LIKE tc_dec_file.tc_dec05,
         tc_dec06    LIKE tc_dec_file.tc_dec06,
         tc_dec07    LIKE tc_dec_file.tc_dec07,
         tc_dec08    LIKE tc_dec_file.tc_dec08,
         tc_dec09    LIKE tc_dec_file.tc_dec09,
         tc_dec10    LIKE tc_dec_file.tc_dec10,
         tc_dec11    LIKE tc_dec_file.tc_dec11,
         tc_dec12    LIKE tc_dec_file.tc_dec12,
         tc_dec13    LIKE tc_dec_file.tc_dec13,
         tc_dec14    LIKE tc_dec_file.tc_dec14,
         tc_dec15    LIKE tc_dec_file.tc_dec15,
         tc_dec16    LIKE tc_dec_file.tc_dec16,
         tc_dec17    LIKE tc_dec_file.tc_dec17,
         tc_dec18    LIKE tc_dec_file.tc_dec18
    END RECORD
DEFINE 
    g_tc_deb01         LIKE tc_deb_file.tc_deb01,
    g_tc_deb01_t       LIKE tc_deb_file.tc_deb01,
    g_tc_dea           tc_dea,
    g_tc_dea_t         tc_dea,
    g_tc_deb           DYNAMIC ARRAY OF  tc_deb,
    g_tc_deb_t         tc_deb,
    g_tc_dec           DYNAMIC ARRAY OF  tc_dec,
    g_tc_dec_t         tc_dec,
    g_wc,g_wc2,g_wc3,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    g_buf           LIKE tc_deb_file.tc_deb01,  
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  
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
DEFINE g_argv1      LIKE tc_dea_file.tc_dea01      #No.FUN-830139
DEFINE g_cn         LIKE type_file.num5      #No.FUN-830139 
DEFINE g_tc_deb16      LIKE tc_deb_file.tc_deb16 
DEFINE g_t1         LIKE tc_dea_file.tc_dea01

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

 
   LET g_forupd_sql = "SELECT tc_deb01 FROM tc_deb_file WHERE tc_deb01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1)                       #No.FUN-830139
 
   OPEN WINDOW t001_w WITH FORM "cim/42f/cimt001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
   CALL t100_init()               
        
   IF g_argv1 IS NOT NULL THEN 
      SELECT count(*) INTO g_cn FROM tc_deb_file WHERE tc_deb01 = g_argv1
      IF g_cn > 0 THEN
         CALL t001_q()
      ELSE
         CALL t001_tc_deb01('d')
         CALL t001_b()
      END IF
   END IF
 
   CALL t001_menu()
 
   CLOSE WINDOW t001_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           
END MAIN
 
 
FUNCTION t001_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
  CLEAR FORM                             #清除畫面
  IF cl_null(g_argv1) THEN               #No.FUN-830139 add  by douzh 
    CALL g_tc_deb.clear()
    CALL g_tc_dec.clear()
    CALL cl_set_head_visible("","YES")    
   
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
      CONSTRUCT BY NAME g_wc ON tc_dea01,tc_dea02,tc_dea03,tc_dea04,tc_dea05,tc_dea06,
                                tc_dea07,tc_dea08,tc_dea09,tc_dea10,tc_dea11,tc_dea14,
                                tc_dea15,tc_dea16,tc_dea17,tc_dea18,tc_dea19,tc_dea20
         BEFORE CONSTRUCT
         #TODO nothing

         AFTER FIELD tc_dea01

         ON ACTION controlp INFIELD tc_dea01
         #TODO 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         #    EXIT CONSTRUCT 

      END CONSTRUCT

      CONSTRUCT g_wc2 ON tc_deb02,tc_deb04,tc_deb05,tc_deb06,tc_deb07,tc_deb08,tc_deb09,tc_deb10,
                         tc_deb11,tc_deb12,tc_deb13,tc_deb14,tc_deb15,tc_deb16
                    FROM s_tc_deb[1].tc_deb02,s_tc_deb[1].tc_deb04,s_tc_deb[1].tc_deb05,
                    s_tc_deb[1].tc_deb06,s_tc_deb[1].tc_deb07,s_tc_deb[1].tc_deb08,s_tc_deb[1].tc_deb09,
                    s_tc_deb[1].tc_deb10,s_tc_deb[1].tc_deb11,s_tc_deb[1].tc_deb12,s_tc_deb[1].tc_deb13,
                    s_tc_deb[1].tc_deb14,s_tc_deb[1].tc_deb15,s_tc_deb[1].tc_deb16
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #TODO nothing

         AFTER FIELD tc_deb02

         ON ACTION controlp INFIELD tc_deb05
         #TODO 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         # EXIT CONSTRUCT

      END CONSTRUCT

      CONSTRUCT g_wc3 ON tc_dec02,tc_dec04,tc_dec05,tc_dec06,tc_dec07,tc_dec08,tc_dec09,tc_dec10,
                         tc_dec11,tc_dec12,tc_dec13,tc_dec14,tc_dec15,tc_dec16,tc_dec17,tc_dec18
                    FROM s_tc_dec[1].tc_dec02,s_tc_dec[1].tc_dec04,s_tc_dec[1].tc_dec05,s_tc_dec[1].tc_dec06,
                         s_tc_dec[1].tc_dec07,s_tc_dec[1].tc_dec08,s_tc_dec[1].tc_dec09,s_tc_dec[1].tc_dec10,
                         s_tc_dec[1].tc_dec11,s_tc_dec[1].tc_dec12,s_tc_dec[1].tc_dec13,s_tc_dec[1].tc_dec14,
                         s_tc_dec[1].tc_dec15,s_tc_dec[1].tc_dec16,s_tc_dec[1].tc_dec17,s_tc_dec[1].tc_dec18

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #TODO nothing

         AFTER FIELD tc_dec02

         ON ACTION controlp INFIELD tc_dec05
         #TODO 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         #    EXIT CONSTRUCT

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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_deauser', 'tc_deagrup')         #MOD-C10146 add 
  ELSE                                                           #No.FUN-830139
    LET g_wc="tc_dea01='",g_argv1,"'"                               #No.FUN-830139 
    LET g_wc2 = " 1=1"
  END IF                                                         #No.FUN-830139 
 
 
 
  IF INT_FLAG THEN RETURN END IF 
   
 
END FUNCTION
FUNCTION t001_prepare()
   IF g_wc2 = " 1=1"  THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  tc_dea01 FROM tc_dea_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_dea01"  
   ELSE
      LET g_sql = "SELECT UNIQUE tc_dea_file. tc_dea01 ",
               "  FROM tc_dea_file, tc_deb_file",
               " WHERE tc_dea01 = tc_deb01 ",
               "   AND ",g_wc CLIPPED ,
               "   AND ", g_wc2 CLIPPED
   END IF
   
   PREPARE t001_prepare FROM g_sql
   DECLARE t001_cs                         #SCROLL CURSOR
         SCROLL CURSOR WITH HOLD FOR t001_prepare
   
   
   IF g_wc2 = " 1=1"  THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tc_dea_file ",
                  " WHERE ", g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tc_dea01) ",
                  "  FROM tc_dea_file,tc_deb_file ",
                  " WHERE tc_deb01=tc_dea01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
   
   PREPARE t001_precount FROM g_sql
   DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
          
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t001_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_deb),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_deb01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_deb01"
                 LET g_doc.value1 = g_tc_deb01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Insert 錄入
FUNCTION t001_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_deb.clear()
 
   INITIALIZE g_tc_deb01    LIKE tc_deb_file.tc_deb01
   INITIALIZE g_tc_dea.*    LIKE tc_dea_file.*
    
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL t001_i('a')
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_tc_deb01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      # CALL t001_b()    #NOTE 可以省略                      # 輸入單身
      LET g_tc_deb01_t=g_tc_deb01
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#Query 查詢
FUNCTION t001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL t001_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tc_dea.* TO NULL
        RETURN
    END IF

    CALL t001_prepare()  #NOTE 归纳为一个函数，避免逻辑不清
    #TODO 如果查不到资料，直接报错

    MESSAGE " SEARCHING ! " 
    OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_tc_deb01 = NULL 
       INITIALIZE g_tc_dea.* TO NULL
    ELSE
       OPEN t001_count
       FETCH t001_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式   
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     t001_cs INTO g_tc_deb01
    WHEN 'P' FETCH PREVIOUS t001_cs INTO g_tc_deb01
    WHEN 'F' FETCH FIRST    t001_cs INTO g_tc_deb01
    WHEN 'L' FETCH LAST     t001_cs INTO g_tc_deb01
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
            FETCH ABSOLUTE g_jump t001_cs INTO g_tc_deb01
            LET g_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_deb01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_dea.* TO NULL            
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
    SELECT UNIQUE tc_dea01 INTO g_tc_deb01
      FROM tc_dea_file 
     WHERE tc_dea01 = g_tc_deb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_dea_file",g_tc_deb01,"",SQLCA.sqlcode,"","",1) 
       INITIALIZE g_tc_deb01 TO NULL
       RETURN
    END IF 
    CALL t001_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t001_show()
 
    LET g_tc_dea_t.* = g_tc_dea.*                #保存單頭舊值
    DISPLAY g_tc_deb01
         TO tc_deb01
    DISPLAY "/u1/topprod/tiptop/doc/pic/pdf_logo_flymn2.jpg" TO tc_dea12
                    
    CALL t001_tc_deb01('d')
    CALL t001_b_fill(g_wc2,g_wc3)                 #單身  #FUN-840141
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t001_tc_deb01(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
#TODO：
 
END FUNCTION
 
FUNCTION t001_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
   DEFINE   l_count      LIKE type_file.num5   
   DEFINE   l_n          LIKE type_file.num5, 
            l_allow_insert  LIKE type_file.num5,                #可新增否
            l_allow_delete  LIKE type_file.num5   
   # DISPLAY BY NAME g_tc_deb.*
   DEFINE   li_result    LIKE type_file.chr1
            

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)

      INPUT BY NAME g_tc_dea.tc_dea01,g_tc_dea.tc_dea02,g_tc_dea.tc_dea03,g_tc_dea.tc_dea04,g_tc_dea.tc_dea05,
                    g_tc_dea.tc_dea06,g_tc_dea.tc_dea07,g_tc_dea.tc_dea08,g_tc_dea.tc_dea09,g_tc_dea.tc_dea10,
                    g_tc_dea.tc_dea11,g_tc_dea.tc_dea14,g_tc_dea.tc_dea15,g_tc_dea.tc_dea16,g_tc_dea.tc_dea17,
                    g_tc_dea.tc_dea18,g_tc_dea.tc_dea19,g_tc_dea.tc_dea20   ATTRIBUTE(WITHOUT DEFAULTS) 

         BEFORE INPUT
            MESSAGE "" 
         #TODO: 检查事务
         #TODO: 更新
         #TODO: 设置actionchoice
         #TODO 默认值
         LET g_tc_dea.tc_dea02=TODAY
         IF p_cmd='a' THEN
            LET g_tc_dea.tc_dea03=1
         ELSE 
            LET g_tc_dea.tc_dea03= g_tc_dea.tc_dea03 + 1
         END IF
         # DISPLAY BY NAME g_tc_dea.tc_dea02,g_tc_dea.tc_dea03

         #TODO: entry设置
            CALL t001_set_entry(p_cmd)
            CALL t001_set_entry_b(p_cmd)
            CALL t001_set_no_entry(p_cmd)
            CALL t001_set_no_entry_b(p_cmd)
            CALL t001_set_required(p_cmd)

         BEFORE FIELD tc_dea01
         #TODO 判断是修改还是新增
             IF p_cmd = 'u' THEN
               NEXT FIELD tc_dea02
             END IF

         AFTER FIELD tc_dea01 
         #TODO: 检查
            IF NOT cl_null(g_tc_dea.tc_dea01) OR (g_tc_dea.tc_dea01!=g_tc_dea.tc_dea01) THEN
            #NOTE 修改或者录入才需要检查
               LET g_t1=s_get_doc_no(g_tc_dea.tc_dea01) 
               CALL s_check_no("apm",g_tc_dea.tc_dea01,g_tc_deb01_t,'2',"tc_dea_file","tc_dea01","") #TQC-9B0191
                  RETURNING li_result,g_tc_dea.tc_dea01
               DISPLAY BY NAME g_tc_dea.tc_dea01
               IF (NOT li_result) THEN
                  NEXT FIELD pmm01
               END IF

            END IF

         ON CHANGE tc_dea09
            LET g_tc_dea.tc_dea10 = g_tc_dea.tc_dea09
            DISPLAY BY NAME g_tc_dea.tc_dea10
         
         ON ACTION controlp INFIELD tc_dea01      
            CALL q_smy(FALSE,FALSE,'','APM','2') RETURNING g_tc_dea.tc_dea01    
            DISPLAY BY NAME g_tc_dea.tc_dea01
            NEXT FIELD pmm01 

         ON ACTION controlp INFIELD tc_dea06
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "i"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_dea06
            NEXT FIELD tc_dea06

         AFTER INPUT
         #TODO 检查错误信息
         #TODO 根据actionchoice 确认update还是insert

         

      END INPUT 

      INPUT ARRAY g_tc_deb FROM s_tc_deb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

         BEFORE INPUT
            MESSAGE ""
         #TODO 如果是新增，将游标设置为当前位置+1
         #TODO 如果是修改，游标设置为第一个位置
         #TODO 设置当前长度等变量

         BEFORE ROW
         #TODO 设置当前游标位置
         #TODO 检查事务
         #TODO 检查事务
         #TODO 游标大于当前行数，判断为修改，修改前先重新显示一遍
         #TODO 设置requery
         #TODO 设置entry
         #TODO 设置项次自动编号
         
         BEFORE INSERT 
         #TODO 检查事务
         #TODO 设置预设值

         AFTER INSERT
            # IF INT_FLAG THEN 
            #    # CALL cl_err()
            #    LET INT_FLAG = 0
            #    CANCEL INSERT
            # END IF
         #TODO 基本检查
         #TODO 资料未重复，插入新增资料
         #TODO 继续插入第二笔之后资料

         BEFORE DELETE
         #TODO 修改模式时，弹窗确认
         #TODO 删除单身
         #TODO 设置单身笔数
         #TODO 提交事务

         AFTER DELETE 
         #TODO 如果是最后一笔要设置游标

         AFTER FIELD tc_deb02
         #TODO 检查

         ON ROW CHANGE
            # IF INT_FLAG THEN
            #    LET INT_FLAG = 0 
            #    # CLOSE aint302_bcl
            #    # CALL s_transaction_end('N','0')
            #    # CALL cl_err()
            #    EXIT INPUT
            # END IF
         #TODO UPDATE 单身
         #TODO 重新fill单身

         AFTER ROW
         #TODO 提交事务

         AFTER INPUT
         #TODO 提交事务

         ON ACTION controlo
         #TODO 复制
 
      END INPUT

      INPUT ARRAY g_tc_dec FROM s_tc_dec.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

         BEFORE INPUT
            MESSAGE ""
         #TODO 
          

      END INPUT

      BEFORE DIALOG

      #TODO 决定双击进入哪个单身
      #TODO 新增的时候，游标设置为1

      AFTER DIALOG
      #TODO nothing

      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

      ON ACTION cancel 
      #TODO 放弃输入，提交事务

      ON ACTION close
      #TODO 关掉作业

      ON ACTION exit #toolbar 離開
      #TODO 关掉作业
         EXIT DIALOG
 

   END DIALOG
 
END FUNCTION
 
FUNCTION t001_r()
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_gav   RECORD LIKE gav_file.*
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_tc_deb01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF  
 
   BEGIN WORK
 
   OPEN t001_cl USING g_tc_deb01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_deb01                       # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_deb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   #No.TQC-A70016  --Begin                                                      
   #IF cl_delh(0,0) THEN                   #确认一下                            
   IF cl_confirm('lib-357') THEN                                                
   #No.TQC-A70016  --End    
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tc_deb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tc_deb01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tc_deb_file WHERE tc_deb01 = g_tc_deb01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tc_deb_file",g_tc_deb01,"",SQLCA.sqlcode,"","BODY DELETE",0)  
      ELSE
         CLEAR FORM
         CALL g_tc_deb.clear()
         OPEN t001_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t001_cs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t001_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t001_cs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t001_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE         
            CALL t001_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t001_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_deb01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t001_b() 
#TODO 
 
END FUNCTION
 
#檢查資料重復
FUNCTION t001_b_check()
DEFINE p_tc_deb04  LIKE tc_deb_file.tc_deb04
DEFINE p_tc_deb05  LIKE tc_deb_file.tc_deb05
DEFINE p_tc_deb06  LIKE tc_deb_file.tc_deb06
DEFINE l_n      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
 
  LET g_errno ="" 
 
  SELECT count(*) INTO l_n FROM tc_deb_file 
   WHERE tc_deb01 = g_tc_deb01 
    AND tc_deb04 = g_tc_deb[l_ac].tc_deb04
    AND tc_deb05 = g_tc_deb[l_ac].tc_deb05
    AND tc_deb06 = g_tc_deb[l_ac].tc_deb06
  
  IF l_n > 0 THEN
     LET g_errno = '-239'
  ELSE
     SELECT count(*) INTO l_n2 FROM tc_deb_file 
      WHERE tc_deb01 = g_tc_deb01 
        AND tc_deb02 = g_tc_deb[l_ac].tc_deb06
        AND tc_deb09 ='Y'
     IF l_n2 > 0 THEN
        LET g_errno = 'apj-078'
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t001_b_askkey()
#  DEFINE l_wc    STRING     #NO.FUN-910082
 
#     CONSTRUCT l_wc  ON tc_deb04,tc_deb05,tc_deb06,tc_deb02,tc_deb03,
#                        tc_deb07,tc_deb08,tc_deb09,tc_deb25,tc_deb10,tc_deb11,
#                        tc_deb12,tc_deb13,tc_deb14,tc_deb21,tc_debacti 
#             FROM s_tc_deb[1].tc_deb04, s_tc_deb[1].tc_deb05, 
#                  s_tc_deb[1].tc_deb06, s_tc_deb[1].tc_deb02,s_tc_deb[1].tc_deb03, 
#                  s_tc_deb[1].tc_deb07, s_tc_deb[1].tc_deb08,s_tc_deb[1].tc_deb09,s_tc_deb[1].tc_deb25,
#                  s_tc_deb[1].tc_deb10, s_tc_deb[1].tc_deb11,s_tc_deb[1].tc_deb12,
#                  s_tc_deb[1].tc_deb13, s_tc_deb[1].tc_deb14,s_tc_deb[1].tc_deb21,s_tc_deb[1].tc_debacti
 
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
#     CALL t001_b_fill(l_wc," 1=1 ")
 
END FUNCTION
 
FUNCTION t001_b_fill(p_wc1,p_wc2)              #BODY FILL UP
DEFINE  p_wc1  STRING      
DEFINE  p_wc2  STRING      
 
   LET g_sql = "SELECT * ",
               " FROM tc_deb_file",
               " WHERE tc_deb01 ='",g_tc_deb01,"'",               #單頭
               "   AND ",p_wc1 CLIPPED,                      #單身  
               " ORDER BY tc_deb02"
 
   PREPARE t001_pb_deb FROM g_sql
   DECLARE tc_deb_curs CURSOR FOR t001_pb_deb
 
   CALL g_tc_deb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH tc_deb_curs INTO g_tc_deb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_deb.deleteElement(g_cnt)

   LET g_sql = "SELECT *",
               " FROM tc_dec_file",
               " WHERE tc_dec01 ='",g_tc_deb01,"'",
               "   AND ",p_wc1 CLIPPED,                      #單身  
               " ORDER BY tc_dec02"
   
   PREPARE t001_pb_dec FROM g_sql
   DECLARE tc_dec_curs CURSOR FOR t001_pb_dec

   CALL g_tc_dec.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH tc_dec_curs INTO g_tc_dec[g_cnt].*   #單身 ARRAY 填充
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

   CALL g_tc_dec.deleteElement(g_cnt) 

   LET g_rec_b =g_tc_dec.getLength()
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t001_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   DISPLAY "/u1/topprod/tiptop/doc/pic/pdf_logo_flymn2.jpg" TO tc_dea12
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
         DISPLAY ARRAY g_tc_deb TO s_tc_deb.* ATTRIBUTES(COUNT=g_rec_b)

               BEFORE ROW
               #TODO: 显示单身笔数，确定当下选择的笔数
               MESSAGE ""

               BEFORE DISPLAY
               #TODO: 

         END DISPLAY
         DISPLAY ARRAY g_tc_dec TO s_tc_dec.* ATTRIBUTES(COUNT=g_rec_b)

            BEFORE ROW
               # CALL aint302_idx_chk()
               # LET l_ac2 = DIALOG.getCurrentRow("s_detail2")
               # LET g_detail_idx2 = l_ac2
               MESSAGE ""

            BEFORE DISPLAY 
               # CALL FGL_SET_ARR_CURR(g_detail_idx2)
               # LET l_ac2 = DIALOG.getCurrentRow("s_detail2")
               # CALL aint302_idx_chk()
               # LET g_current_page = 2

         END DISPLAY

         BEFORE DIALOG

               #TODO: 先填充browser资料
               #TODO: 游标回归旧笔数
               #TODO: #有資料才進行fetch
               #TODO: 笔数显示

         ON ACTION first 
            CALL t001_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                              
 
         ON ACTION previous
            CALL t001_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                                 
   
         ON ACTION jump 
            CALL t001_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                   
                                 
   
         ON ACTION next
            CALL t001_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            # ACCEPT DISPLAY                  
                                 
   
         ON ACTION last 
            CALL t001_fetch('L')
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

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
   
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
 
FUNCTION t001_b_y(p_cmd,l_cnt)
   DEFINE   p_cmd LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   # IF g_tc_deb[l_cnt].tc_deb21 !='0' THEN
   #    CALL cl_err("",'9021',0)
   #    RETURN
   # END IF
 
   IF cl_confirm('aap-222') THEN
      BEGIN WORK
 
      OPEN t001_cl USING g_tc_deb01
      IF STATUS THEN
         CALL cl_err("OPEN t001_cl:", STATUS, 1)
         CLOSE t001_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH t001_cl INTO g_tc_deb01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_deb01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
  
      CALL t001_b_fill(g_wc2,g_wc3)   #FUN-840141
   
      # LET g_tc_deb[l_cnt].tc_deb21='1'
 
      # UPDATE tc_deb_file SET tc_deb21=g_tc_deb[l_cnt].tc_deb21,
      #                     tc_debmodu=g_user,
      #                     tc_debdate=g_today
      #               WHERE tc_deb01=g_tc_deb01
      #                 AND tc_deb02=g_tc_deb[l_cnt].tc_deb02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_deb_file",g_tc_deb01,g_tc_deb[l_cnt].tc_deb02,SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
      END IF
 
      CLOSE t001_cl
 
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_tc_deb01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF
   
END FUNCTION
 
FUNCTION t001_b_v(p_cmd,l_cnt)
   DEFINE   p_cmd   LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   # IF g_tc_deb[l_cnt].tc_deb21 !='1' THEN
   #    CALL cl_err("",'9021',0)
   #    RETURN
   # END IF
   
   IF cl_confirm('aap-224') THEN 
      BEGIN WORK
 
      OPEN t001_cl USING g_tc_deb01
      IF STATUS THEN
         CALL cl_err("OPEN t001_cl:", STATUS, 1)
         CLOSE t001_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH t001_cl INTO g_tc_deb01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_deb01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
   
      CALL t001_b_fill(g_wc2,g_wc3)  #FUN-840141
   
      # LET g_tc_deb[l_cnt].tc_deb21='0'
 
      # UPDATE tc_deb_file SET tc_deb21=g_tc_deb[l_cnt].tc_deb21,
      #                     tc_debmodu=g_user,
      #                     tc_debdate=g_today
      #               WHERE tc_deb01=g_tc_deb01
      #                 AND tc_deb02=g_tc_deb[l_cnt].tc_deb02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_deb_file",g_tc_deb01,g_tc_deb[l_cnt].tc_deb02,SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
      END IF
   
      CLOSE t001_cl
   
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_tc_deb01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF 
 
END FUNCTION
 
FUNCTION t001_out()
DEFINE l_i      LIKE type_file.num5,  
       sr       RECORD
               tc_deb02    LIKE tc_deb_file.tc_deb02,
               tc_deb04    LIKE tc_deb_file.tc_deb04,
               tc_deb05    LIKE tc_deb_file.tc_deb05,
               tc_deb06    LIKE tc_deb_file.tc_deb06,
               tc_deb07    LIKE tc_deb_file.tc_deb07,
               tc_deb08    LIKE tc_deb_file.tc_deb08,
               tc_deb09    LIKE tc_deb_file.tc_deb09,
               tc_deb10    LIKE tc_deb_file.tc_deb10,
               tc_deb11    LIKE tc_deb_file.tc_deb11,
               tc_deb12    LIKE tc_deb_file.tc_deb12,
               tc_deb13    LIKE tc_deb_file.tc_deb13,
               tc_deb14    LIKE tc_deb_file.tc_deb14,
               tc_deb15    LIKE tc_deb_file.tc_deb15,
               tc_deb16    LIKE tc_deb_file.tc_deb16
                END RECORD,
       l_name   LIKE type_file.chr20,  
       l_za05   LIKE type_file.chr1000 
 
    IF g_wc IS NULL THEN
       LET g_wc ="tc_dea01 ='",g_tc_deb01,"'"
    END IF
 
    CALL cl_wait()
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * ",
              " FROM tc_deb_file,tc_dea_file",
              " WHERE tc_deb01 = tc_dea01 ",
              "   AND ",g_wc CLIPPED,
              " ORDER BY tc_deb02 "
     CALL cl_prt_cs1('cimt001','cimt001',g_sql,'')
 
END FUNCTION
 
FUNCTION t001_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("tc_deb01",TRUE) 
   END IF
 
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       
 
   CALL cl_set_comp_entry("tc_deb02",FALSE) 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("tc_deb01",FALSE) 
   END IF
END FUNCTION
FUNCTION t001_set_entry_b(p_cmd)  
  DEFINE p_cmd   LIKE type_file.chr1       
END FUNCTION
FUNCTION t001_set_no_entry_b(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1       
END FUNCTION 
FUNCTION t001_set_required(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1       
   CALL cl_set_comp_required("tc_dea02,tc_dea03",TRUE)

END FUNCTION 
FUNCTION t100_set_comp()
   CALL cl_set_combo_items("tc_dea07","1,2,3,4","一,二,三,四")
   # CALL cl_set_combo_items("tc_dea08","1,2,3","苹果,橘子,香蕉")
END FUNCTION
FUNCTION t100_init()
   CALL t100_set_comp()
END FUNCTION

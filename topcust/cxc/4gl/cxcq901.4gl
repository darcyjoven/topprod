# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: cxcq901.4gl
# Descriptions...: 仓库原材料收发存
# Date & Author..: 17/07/18         By luoyb

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

TYPE t_ta_cck          RECORD                                    #记录集
         ta_ccc01         LIKE ima_file.ima01,
         ta_ccc02         LIKE type_file.num5,
         ta_ccc03         LIKE type_file.num5,
         ima02            LIKE ima_file.ima02,
         ima021           LIKE ima_file.ima021,
         ima39            LIKE ima_file.ima39,
         ima25            LIKE ima_file.ima25,
         ta_ccc11         LIKE type_file.num20_6,
         ta_ccc12         DEC(20,2),
         ta_ccc211        LIKE type_file.num20_6,
         ta_ccc22a1       DEC(20,2),
         ta_ccc31         LIKE type_file.num20_6,
         ta_ccc32         DEC(20,2),
         ta_ccc214        LIKE type_file.num20_6,
         ta_ccc22a4       DEC(20,2),
         ta_ccc41         LIKE type_file.num20_6,
         ta_ccc42         DEC(20,2),
         ta_ccc61         LIKE type_file.num20_6,
         ta_ccc62         DEC(20,2),
         ta_ccc91         LIKE type_file.num20_6,
         ta_ccc26         LIKE type_file.num20_6,
         ta_ccc92         DEC(20,2),
         ta_cccud11       LIKE type_file.num20_6,
         ta_ccc31_1       LIKE type_file.num20_6,
         ta_ccc32_1       DEC(20,2),
         ta_ccc43         LIKE type_file.num20_6,
         ta_ccc44         DEC(20,2),
         tzsl             LIKE type_file.num20_6,
         tzje             DEC(20,2)
                         END RECORD
                         
DEFINE g_ta_cck            DYNAMIC ARRAY OF t_ta_cck               #单身全局
DEFINE tm                  RECORD
       wc                  STRING,
       yy                  LIKE type_file.num5,
       mm                  LIKE type_file.num5
                         END RECORD
DEFINE ta_cck_cnt          LIKE type_file.num10                       #单身总笔数
DEFINE ta_cck_ac           LIKE type_file.num10                       #光标所在NO.
DEFINE g_sql               STRING                                     #定义sql
DEFINE ta_cck_wc           STRING                                     #定义CONSTRUCT接受变量
DEFINE g_forupd_sql        STRING                                     #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done STRING                                     #判斷是否已執行 Before Input指令
DEFINE g_cnt               LIKE type_file.num10                       #定义ima_file笔数
DEFINE g_rec_b             LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10                       #获取Fetch当前笔index
DEFINE g_row_count         LIKE type_file.num10                       #获取Fetch总笔数
DEFINE g_jump              LIKE type_file.num10                       #跳转Fetch指定index
DEFINE g_no_ask            LIKE type_file.num10                       #是否开启指定笔視窗
DEFINE g_msg               LIKE type_file.chr1000                     #错误信息
DEFINE g_statebar          STRING                                     #笔数变量
DEFINE g_argv1	           LIKE type_file.num5          

MAIN
DEFINE p_row,p_col         LIKE type_file.num5

       OPTIONS
       #FIELD ORDER FORM,                                             #依照FORM上栏位顺序跳转(默认依照INPUT顺序栏位跳转)
       INPUT NO WRAP                                                  #输入方式:不打转
       DEFER INTERRUPT                                                #截取中断键

       IF (NOT cl_user()) THEN                                        #预设部分参数(g_prog,g_user),切换使用者预设营运中心
          EXIT PROGRAM                                                #退出程序
       END IF

       WHENEVER ERROR CALL cl_err_msg_log                             #遇错则记录到log档

       IF (NOT cl_setup("CXC")) THEN                                  #预设模组参数(g_aza.*,...)权限参数,判断使用者执行权限
          EXIT PROGRAM                                                #退出程序
       END IF

       CALL cl_used(g_prog,g_time,1) RETURNING g_time                 #程式进入时间

       LET g_statebar = "Total: %1 / %2"                              #笔数显示变量定义

       LET p_row = 2 LET p_col = 2
       OPEN WINDOW q901_w AT p_row,p_col WITH FORM "cxc/42f/cxcq901"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)                   #界面Style设置(p_zz设置)

       CALL cl_ui_init()                                              #加载ToolBar、栏位中文描述、p_per/p_perlang等系统设置
       
       SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
       
       LET g_action_choice = ""                                       #初始化Action执行标示
       CALL q901_menu()                                               #进入菜单

       CLOSE WINDOW q901_w                                            #关闭WINDOW

       CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #程序退出时间
END MAIN

FUNCTION q901_menu()
DEFINE l_cmd               STRING

       WHILE TRUE
             CALL q901_bp("G",ta_cck_ac)
             CASE g_action_choice
                  WHEN "query"
                       IF cl_chk_act_auth() THEN                      #判断g_user是否有执行权限
                          CALL q901_q()                               #点击"查询"或按"Q"进入此函数
                       END IF
                  WHEN "help"
                       CALL cl_show_help()                            #点击"帮助"或按"Ctrl+H"进入此函数

                  WHEN "exit"
                       EXIT WHILE                                     #点击"离开"或按"Esc"进入此函数

                  WHEN "controlg"
                       CALL cl_cmdask()                               #运行Ctrl+G窗口

                  WHEN "locale"
                       CALL cl_dynamic_locale()                       #动态转换画面语言别
                       CALL cl_show_fld_cont()                        #根据p_per设置栏位格式

                  WHEN "about"
                       CALL cl_about()                                #程式信息

                  WHEN "exporttoexcel"
                       IF cl_chk_act_auth() THEN
                          CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ta_cck),'','')
                          #点击"导出Excel"或按"E"进入此函数
                       END IF
             END CASE
       END WHILE

END FUNCTION

FUNCTION q901_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01 

       CLEAR FORM
       CALL g_ta_cck.clear()                                             #数组变量清空 
       INITIALIZE tm.* TO NULL
       DIALOG ATTRIBUTES(UNBUFFERED)
           
           INPUT BY NAME tm.yy,tm.mm

               BEFORE INPUT 
                  LET tm.yy = g_ccz.ccz01
                  LET tm.mm = g_ccz.ccz02
                  DISPLAY BY NAME tm.yy,tm.mm

               AFTER FIELD yy
                 IF NOT cl_null(tm.yy) THEN

                 END IF
                 
              AFTER FIELD mm
                 IF NOT cl_null(tm.mm) THEN
                    SELECT azm02 INTO g_azm.azm02 FROM azm_file
                      WHERE azm01 = tm.yy
                    IF g_azm.azm02 = 1 THEN
                       IF tm.mm > 12 OR tm.mm < 1 THEN
                          CALL cl_err('','agl-020',0)
                          NEXT FIELD mm
                       END IF
                    ELSE
                       IF tm.mm > 13 OR tm.mm < 1 THEN
                          CALL cl_err('','agl-020',0)
                          NEXT FIELD mm
                       END IF
                    END IF
                 END IF
                 IF cl_null(tm.mm) THEN
                    NEXT FIELD mm
                 END IF
         
           END INPUT 

           CONSTRUCT tm.wc ON ta_ccc01
                FROM
                              s_ta_cck[1].ta_ccc01
             BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)
           END CONSTRUCT

        ON ACTION controlp
                CASE
                   WHEN INFIELD(ta_ccc01) #产品编号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ima"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ta_ccc01
                        NEXT FIELD ta_ccc01
                END CASE
        
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

             ON ACTION about
                CALL cl_about()

             ON ACTION help
                CALL cl_show_help()

             ON ACTION controlg
                CALL cl_cmdask()

             ON ACTION qbe_select
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)

             ON ACTION qbe_save
                CALL cl_qbe_save()

             ON ACTION accept
                EXIT DIALOG

             ON ACTION EXIT
                LET INT_FLAG = TRUE
                EXIT DIALOG

             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG
            END DIALOG
            
           IF INT_FLAG THEN
               LET INT_FLAG = 0
               RETURN
           END IF

       CALL q901_b_fill()

END FUNCTION

FUNCTION q901_q()

       CALL q901_cs()                                                 #CONSTRUCT(输入查询条件)

END FUNCTION

FUNCTION q901_bp(p_ud,i)
DEFINE p_ud                LIKE type_file.chr1
DEFINE i   LIKE type_file.num5

       IF p_ud <> "G" OR g_action_choice = "detail" THEN
          RETURN
       END IF

       LET g_action_choice = " "

       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY g_ta_cck TO s_ta_cck.* ATTRIBUTE(COUNT=ta_cck_cnt,UNBUFFERED)

               BEFORE DISPLAY
                  CALL cl_navigator_setting(g_curs_index, g_row_count)#设置ToolBar 上下笔按钮状态
                  CALL ui.Interface.refresh()
                  IF i!=0 THEN CALL fgl_set_arr_curr(i) END IF

               BEFORE ROW
                  LET ta_cck_ac = ARR_CURR()                             #获取当前光标行NO.
                  CALL cl_show_fld_cont()                             #根据p_per设置栏位格式
                  MESSAGE SFMT(g_statebar,ta_cck_ac,ta_cck_cnt)

               ON ACTION query
                  LET g_action_choice="query"
                  EXIT DISPLAY

               ON ACTION HELP
                  LET g_action_choice="help"
                  EXIT DISPLAY

               ON ACTION locale
                  LET g_action_choice="locale"

               ON ACTION EXIT
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION CANCEL
                  LET INT_FLAG=FALSE
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION CLOSE
                  LET g_action_choice="exit"
                  EXIT DISPLAY

               ON ACTION controlg
                  LET g_action_choice="controlg"
                  EXIT DISPLAY

               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE DISPLAY

               ON ACTION about
                  LET g_action_choice="about"

               ON ACTION related_document
                  LET g_action_choice="related_document"
                  EXIT DISPLAY

               ON ACTION exporttoexcel
                  LET g_action_choice="exporttoexcel"
                  EXIT DISPLAY

               ON ACTION controls
                  CALL cl_set_head_visible("","AUTO")                 #隐藏单头

               AFTER DISPLAY
                     CONTINUE DISPLAY

       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION q901_b_fill()
  DEFINE l_cnt        LIKE type_file.num5
  DEFINE l_cnt1       LIKE type_file.num5
  DEFINE l_cnt2       LIKE type_file.num5
  DEFINE l_sql        STRING
  DEFINE l_tot1       LIKE type_file.num20_6
  DEFINE l_tot2       LIKE type_file.num20_6
  DEFINE l_tot3       LIKE type_file.num20_6
  DEFINE l_tot4       LIKE type_file.num20_6
  DEFINE l_tot5       LIKE type_file.num20_6
  DEFINE l_tot6       LIKE type_file.num20_6
  DEFINE l_tot7       LIKE type_file.num20_6
  DEFINE l_tot8       LIKE type_file.num20_6
  
  LET l_sql = "SELECT * FROM cxcq901_file ",
              " WHERE ta_ccc02 = ",tm.yy,
              "   AND ta_ccc03 = ",tm.mm,
              "   AND ",tm.wc

  CALL g_ta_cck.clear()
  LET g_cnt = 1
  LET g_rec_b = 0
  LET l_cnt=0

  LET l_tot1 = 0 LET l_tot2 = 0 
  LET l_tot3 = 0 LET l_tot4 = 0
  LET l_tot5 = 0 LET l_tot6 = 0
  LET l_tot7 = 0 LET l_tot8 = 0
  
  PREPARE q901_p FROM l_sql
  DECLARE q901_c1 CURSOR FOR q901_p
  FOREACH q901_c1 INTO g_ta_cck[g_cnt].*
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF

    LET l_tot1 = l_tot1 + g_ta_cck[g_cnt].ta_ccc12
    LET l_tot2 = l_tot2 + g_ta_cck[g_cnt].ta_ccc22a1
    LET l_tot3 = l_tot3 + g_ta_cck[g_cnt].ta_ccc32
    LET l_tot4 = l_tot4 + g_ta_cck[g_cnt].ta_ccc62
    LET l_tot5 = l_tot5 + g_ta_cck[g_cnt].tzje
    LET l_tot6 = l_tot6 + g_ta_cck[g_cnt].ta_ccc22a4
    LET l_tot7 = l_tot7 + g_ta_cck[g_cnt].ta_ccc42
    LET l_tot8 = l_tot8 + g_ta_cck[g_cnt].ta_ccc92
    
    LET g_cnt = g_cnt + 1
  END FOREACH
  CALL g_ta_cck.deleteElement(g_cnt)
  LET g_rec_b = g_cnt - 1
  DISPLAY g_rec_b TO FORMONLY.cnt

  DISPLAY l_tot1 TO FORMONLY.tot1
  DISPLAY l_tot2 TO FORMONLY.tot2
  DISPLAY l_tot3 TO FORMONLY.tot3
  DISPLAY l_tot4 TO FORMONLY.tot4
  DISPLAY l_tot5 TO FORMONLY.tot5
  DISPLAY l_tot6 TO FORMONLY.tot6
  DISPLAY l_tot7 TO FORMONLY.tot7
  DISPLAY l_tot8 TO FORMONLY.tot8
  
END FUNCTION
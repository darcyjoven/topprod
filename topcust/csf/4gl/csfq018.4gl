# Prog. Version..: 5.20.01-10.05.01(00000)__代码生成器生成
#
# Pattern name...: csfq018.4gl
# Descriptions...: 合约订单状况表
# Date & Author..: 2016-05-05 11:29:24 & By guanyao


DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

TYPE t_sfb          RECORD                                            #记录集\
       sfa01        LIKE sfa_file.sfa01,      
       ima02        LIKE ima_file.ima02,
       ima021       LIKE ima_file.ima021,
       sfa27        LIKE sfa_file.sfa27,
       sfa08        LIKE sfa_file.sfa08,
       ecd07        LIKE ecd_file.ecd07,
       eca02        LIKE eca_file.eca02,
       sfa06        LIKE sfa_file.sfa06,
       sfa161       LIKE sfa_file.sfa161,
       sum          LIKE sfa_file.sfa06,
       img10        LIKE img_file.img10
                    END RECORD
DEFINE g_sfb               DYNAMIC ARRAY OF t_sfb
DEFINE b_oea               RECORD LIKE oea_file.*                     #单身Record

DEFINE tm                  RECORD 
       wc2                   STRING 
                         END RECORD   

DEFINE oea_cnt             LIKE type_file.num10                       #单身总笔数
DEFINE oea_ac              LIKE type_file.num10                       #光标所在NO.
DEFINE g_sfb01_t           LIKE oea_file.oea01                        #定义KEY值旧值
DEFINE g_sql               STRING                                     #定义sql
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
DEFINE g_yymm              LIKE type_file.chr10
DEFINE g_yy                LIKE type_file.chr10
DEFINE g_mm                LIKE type_file.chr10
DEFINE g_argv1	           LIKE oea_file.oea01          
DEFINE g_argv2             LIKE oea_file.oea03              #No.TQC-630072


MAIN
DEFINE p_row,p_col         LIKE type_file.num5

       OPTIONS
       INPUT NO WRAP                                                  #输入方式:不打转
       DEFER INTERRUPT                                                #截取中断键
       
       LET g_argv1  = ARG_VAL(1)

       IF (NOT cl_user()) THEN                                        #预设部分参数(g_prog,g_user),切换使用者预设营运中心
          EXIT PROGRAM                                                #退出程序
       END IF

       WHENEVER ERROR CALL cl_err_msg_log                             #遇错则记录到log档

       IF (NOT cl_setup("CSF")) THEN                                  #预设模组参数(g_aza.*,...)权限参数,判断使用者执行权限
          EXIT PROGRAM                                                #退出程序
       END IF

       CALL cl_used(g_prog,g_time,1) RETURNING g_time                 #程式进入时间


       LET g_statebar = "Total: %1 / %2"                              #笔数显示变量定义

       LET p_row = 2 LET p_col = 2
       OPEN WINDOW q001_w AT p_row,p_col WITH FORM "csf/42f/csfq018"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)                   #界面Style设置(p_zz设置)

       CALL cl_ui_init()                                              #加载ToolBar、栏位中文描述、p_per/p_perlang等系统设置
       LET g_action_choice = ""                                       #初始化Action执行标示
       IF NOT cl_null(g_argv1) THEN 
          LET tm.wc2 = " oea01 = '",g_argv1,"'"
          CALL q001_b_fill()
       END IF 
       CALL q001_menu()                                               #进入菜单

       CLOSE WINDOW q001_w                                            #关闭WINDOW

       CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #程序退出时间
END MAIN

FUNCTION q001_menu()
DEFINE l_cmd               STRING

       WHILE TRUE
             CALL q001_bp("G")
             CASE g_action_choice
                  WHEN "query"
                       IF cl_chk_act_auth() THEN                      #判断g_user是否有执行权限
                          CALL q001_q()                               #点击"查询"或按"Q"进入此函数
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
                          CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
                          #点击"导出Excel"或按"E"进入此函数
                       END IF
             END CASE
       END WHILE

END FUNCTION

FUNCTION q001_cs()

       CLEAR FORM
       CALL g_sfb.clear()                                             #数组变量清空
       LET tm.wc2 = NULL
       
           CONSTRUCT tm.wc2 ON sfa01,sfa27,sfa08
           FROM
                   s_sfb[1].sfa01,s_sfb[1].sfa27,s_sfb[1].sfa08

               BEFORE CONSTRUCT                                           #预设查询条件
                  CALL cl_qbe_init()                                      #读取用户存档的预设条件

               ON ACTION controlp 
                 CASE 
                   WHEN INFIELD(sfa01)  #                        #按Ctrl+P触发(一般用于ButtonEdit)
                       CALL cl_init_qry_var() 
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form ="q_sfb" 
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfa01
                       NEXT FIELD sfb01
                   WHEN INFIELD(sfa03)  #                         #按Ctrl+P触发(一般用于ButtonEdit)
                       CALL cl_init_qry_var() 
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form ="q_ima00"  
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfa03
                       NEXT FIELD oea03
                 END CASE                                       

               ON IDLE g_idle_seconds
                  CALL cl_on_idle()                                       #程序闲置时间管控
                  CONTINUE CONSTRUCT

               ON ACTION controlg
                  CALL cl_cmdask()                                        #运行Ctrl+G窗口

               ON ACTION about
                  CALL cl_about()                                         #程序信息

               ON ACTION HELP
                  CALL cl_show_help()                                     #点击"帮助"或按"Ctrl+H"进入此函数

               ON ACTION qbe_select
                  CALL cl_qbe_select()                                    #选择存储的查询条件

               ON ACTION qbe_save
                  CALL cl_qbe_save()                                      #存储画面上的栏位条件

           END CONSTRUCT


 #      LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')     #资料权限检查

       IF INT_FLAG THEN
          LET tm.wc2 = NULL
          LET INT_FLAG = 0
          RETURN
       END IF

       CALL q001_b_fill()

END FUNCTION

FUNCTION q001_q()

       CALL q001_cs()                                                 #CONSTRUCT(输入查询条件)

END FUNCTION

FUNCTION q001_bp(p_ud)
DEFINE p_ud                LIKE type_file.chr1

       IF p_ud <> "G" OR g_action_choice = "detail" THEN
          RETURN
       END IF

       LET g_action_choice = " "

       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=oea_cnt,UNBUFFERED)

               BEFORE DISPLAY
                  CALL cl_navigator_setting(g_curs_index, g_row_count)#设置ToolBar 上下笔按钮状态

               BEFORE ROW
                  LET oea_ac = ARR_CURR()                             #获取当前光标行NO.
                  CALL cl_show_fld_cont()                             #根据p_per设置栏位格式
                  MESSAGE SFMT(g_statebar,oea_ac,oea_cnt)

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

FUNCTION q001_b_fill()
   DEFINE l_oga24       LIKE oga_file.oga24
   DEFINE l_type        LIKE type_file.chr1
   DEFINE l_cnt         LIKE type_file.num5,
          l_cmje        LIKE pmm_file.pmm40,
          l_zje         LIKE pmm_file.pmm40
   DEFINE l_sql         STRING 
   DEFINE l_sfa26       LIKE  sfa_file.sfa26
   DEFINE l_tc_shb12    LIKE tc_shb_file.tc_shb12

   IF cl_null(tm.wc2) THEN 
      LET tm.wc2=" 1=1" 
   END IF
   LET g_sql =" SELECT DISTINCT sfa01,ima02,ima021,sfa27,sfa08,ecd07,eca02,sum(sfa06),sfa161,0 sum,0 img10,sfa26 ",
              "   FROM sfa_file ",
              " LEFT JOIN ima_file ON sfa03=ima01 ",
              " LEFT JOIN ecd_file ON ecd01=sfa08 ",
              " LEFT JOIN eca_file ON eca01=ecd07 ",
              " ,sfb_file ",
              " WHERE sfa11!='E' AND sfb04!='8' AND sfb87='Y' AND sfa01=sfb01 ",
              "    AND ", tm.wc2 CLIPPED,
              " GROUP BY sfa01,ima02,ima021,sfa27,sfa08,ecd07,eca02,sfa26,sfa161  ORDER BY sfa01,sfa27,sfa08 "


   PREPARE csfq018_pb FROM g_sql
   DECLARE oea_curs  CURSOR FOR csfq018_pb        #CURSOR


   CALL g_sfb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   LET l_cnt=0
   FOREACH oea_curs INTO g_sfb[g_cnt].*,l_sfa26
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #IF l_sfa26='4' THEN   #表明有替代的情况
      SELECT SUM(tc_shb12) INTO l_tc_shb12 FROM tc_shb_file WHERE tc_shb04=g_sfb[g_cnt].sfa01 
      AND tc_shb08=g_sfb[g_cnt].sfa08 AND tc_shb01='2' 
      IF cl_null(l_tc_shb12) THEN LET l_tc_shb12=0 END IF 
      LET g_sfb[g_cnt].sum=g_sfb[g_cnt].sfa06-l_tc_shb12*g_sfb[g_cnt].sfa161
     # END IF 
      SELECT SUM(img10) INTO  g_sfb[g_cnt].img10  FROM img_file WHERE img01=g_sfb[g_cnt].sfa27
      AND img02='XBC' AND img03=g_sfb[g_cnt].ecd07
      IF cl_null(g_sfb[g_cnt].img10) THEN LET g_sfb[g_cnt].img10 =0 END IF 


      LET g_cnt = g_cnt + 1

   END FOREACH
   CALL g_sfb.deleteElement(g_cnt)   
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt 

END FUNCTION

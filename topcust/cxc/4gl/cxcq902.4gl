# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: cxcq902.4gl
# Descriptions...: 仓库原材料收发存
# Date & Author..: 17/07/18         By luoyb

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

TYPE t_ta_cck          RECORD                                    #记录集
         ta_ccc01         LIKE ima_file.ima01,
         ta_ccc02         LIKE type_file.num5,
         ta_ccc03         LIKE type_file.num5,
         ima02         LIKE ima_file.ima02,
         ima021         LIKE ima_file.ima021,
         ima39         LIKE ima_file.ima39,
         ima25         LIKE ima_file.ima25,
         ta_ccc18         LIKE type_file.num20_6,
         sqdj         LIKE type_file.num20_6,
         ta_ccc19         LIKE type_file.num20_6,
         bqly         LIKE type_file.num20_6,
         lyje         LIKE type_file.num20_6,
         ta_ccc217         LIKE type_file.num20_6,
         zsje         LIKE type_file.num20_6,
         ta_ccc81         LIKE type_file.num20_6,
         wzfje         LIKE type_file.num20_6,
         ta_ccc98         LIKE type_file.num20_6,
         qmjcje         LIKE type_file.num20_6,
         bqhysl         LIKE type_file.num20_6,
         bqhyje         LIKE type_file.num20_6,
         desl         LIKE type_file.num20_6,
         deje         LIKE type_file.num20_6,
         ta_cccud12         LIKE type_file.num20_6,
         ta_cccud07         LIKE type_file.num20_6,
         ta_ccc31         LIKE type_file.num20_6,
         llje         LIKE type_file.num20_6,
         ta_ccc43         LIKE type_file.num20_6,
         tlje         LIKE type_file.num20_6,
         tzje         LIKE type_file.num20_6,
         tdf         LIKE type_file.chr1
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
       OPEN WINDOW q902_w AT p_row,p_col WITH FORM "cxc/42f/cxcq902"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)                   #界面Style设置(p_zz设置)

       CALL cl_ui_init()                                              #加载ToolBar、栏位中文描述、p_per/p_perlang等系统设置
       
       SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
       
       LET g_action_choice = ""                                       #初始化Action执行标示
       CALL q902_menu()                                               #进入菜单

       CLOSE WINDOW q902_w                                            #关闭WINDOW

       CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #程序退出时间
END MAIN

FUNCTION q902_menu()
DEFINE l_cmd               STRING

       WHILE TRUE
             CALL q902_bp("G",ta_cck_ac)
             CASE g_action_choice
                  WHEN "query"
                       IF cl_chk_act_auth() THEN                      #判断g_user是否有执行权限
                          CALL q902_q()                               #点击"查询"或按"Q"进入此函数
                       END IF
                        
                   WHEN "gen_entry"
							         IF cl_chk_act_auth() THEN
							            CALL q902_drill_down()   #ADD-11911
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

FUNCTION q902_cs()
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

       CALL q902_b_fill()

END FUNCTION

FUNCTION q902_q()

       CALL q902_cs()                                                 #CONSTRUCT(输入查询条件)

END FUNCTION

FUNCTION q902_bp(p_ud,i)
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
							  ON ACTION gen_entry 
					         LET g_action_choice="gen_entry"
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

FUNCTION q902_b_fill()
  DEFINE l_cnt        LIKE type_file.num5
  DEFINE l_cnt1       LIKE type_file.num5
  DEFINE l_cnt2       LIKE type_file.num5
  DEFINE l_sql        STRING
  DEFINE l_bqhyje     LIKE type_file.num20_6
  DEFINE l_tzje       LIKE type_file.num20_6
  DEFINE l_ta_ccq20   LIKE type_file.num20_6   #add by liyjf181224
  
#  LET l_sql = "SELECT * FROM cxcq902_file ",
#              " WHERE ta_ccc02 = ",tm.yy,
#              "   AND ta_ccc03 = ",tm.mm,
#              "   AND ",tm.wc

   LET l_sql = 
   "SELECT ta_ccc01,ta_ccc02,ta_ccc03,                                          ",
   "       ima02,ima021,ima39,ima25,ta_ccc18,                                   ",
   "       CASE WHEN ta_ccc18 = 0 THEN 0 ELSE  round(ta_ccc19 / ta_ccc18, 6) END sqdj, ",
   "       ta_ccc19,                                                            ",
   "       ta_ccc31 + ta_ccc43 bqly,                                            ",
   "       ROUND((ta_ccc31) * ta_ccc23 + (ta_ccc43) * ta_cccud07, 2) lyje,      ",
   "       ta_ccc217,                                                           ",
   "       ta_ccc217 * ta_cccud07 zsje,                                         ",
   "       TA_CCC81 * -1 ta_ccc81,                                              ",
   "       TA_CCC81 * -1 * ta_cccud07 wzfje,                                    ",
   "       ta_ccc98,                                                            ",
   "       ta_cccud07 * ta_ccc98 qmjcje,                                        ",
   "       nvl(ta_ccc18 + ta_ccc217 + ta_ccc31 + ta_ccc43 + TA_CCC81 - ta_ccc98,0) bqhysl, ",
   "       ta_ccc19 + nvl(ta_ccc217 + ta_ccc43 + TA_CCC81 - ta_ccc98, 0) * ta_cccud07 +  ta_ccc31 * ta_ccc23 bqhyje,",
   "       round(NVL(BZXH, 0) + NVL(BZXH1, 0), 8) * -1 desl,                    ",
   "       (NVL(BZXH, 0) + NVL(BZXH1, 0)) * ta_cccud07 * -1 deje,               ",
   "       ta_cccud12,                                                          ",
   "       ta_cccud07,                                                          ",
   "       ta_ccc31,                                                            ",
   "       ROUND((ta_ccc31) * ta_ccc23, 2) llje,                                ",
   "       ta_ccc43,                                                            ",
   "       ROUND((ta_ccc43) * ta_cccud07, 2) tlje,                              ",
   "       ta_ccc19 + ta_ccc217 * ta_cccud07 + (ta_ccc23 * ta_ccc31) +          ",
   "       (ta_ccc43) * ta_cccud07 - TA_CCC81 * -1 * ta_cccud07 -               ",
   "       ta_cccud07 * ta_ccc98 - ta_ccc19 -                                   ",
   "       nvl(ta_ccc217 + ta_ccc43 + TA_CCC81 - ta_ccc98, 0) * ta_cccud07 -    ",
   "       ta_ccc31 * ta_ccc23 tzje,                                            ",
   "       CASE WHEN ta_cccud06 = 'Y' THEN 'Y' ELSE 'N' END tdf                 ",
   "  FROM ta_ccp_file,ima_file,gfe_file,                                       ",
   "       (SELECT CCH04, SUM(BZXH) BZXH FROM ex_ccg_result                     ",
   "         WHERE yym = ",tm.yy,
   "           AND mmy = ",tm.mm,
   "           AND INSTR(cch04, '.') > 0                                        ",
   "           AND SUBSTR(cch04, 1, 1) <> 'K'                                   ",
   "         GROUP BY CCH04) HYB,                                               ",
   "       (SELECT YJLH, SUM(BZXH * LJYL) BZXH1                                 ",
   "          FROM ex_ccg_WGD, EX_BOM_CP                                        ",
   "         WHERE CCH04 = CPLH                                                 ",
   "           AND ex_bom_cp.yy = yym AND ex_bom_cp.mm = mmy                    ",  #No.171017001 add
   "           AND yym = ",tm.yy,
   "           AND mmy = ",tm.mm,
   "           AND to_char(sxrq1, 'yyyyMM') <= TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'), 'yyyyMM') ",
   "           AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'), 'yyyyMM') ",
   "           AND INSTR(YJLH, '.') > 1                                         ",
   "         GROUP BY YJLH) HYC                                                 ",
   " WHERE ta_ccc01 = ima01                                                     ",
   "   AND INSTR(ta_ccc01, '.') > 0                                             ",
   "   AND ta_ccc01 = HYB.cch04(+)                                              ",
   "   AND ta_ccc01 = HYC.YJLH(+)                                               ",
   "   AND ima25 = gfe01                                                        ",
   #"   AND (ta_ccc217 <> 0 OR ta_ccc18 <> 0 OR ta_ccc31 <> 0 OR ta_ccc81 <> 0 OR ta_ccc98 <> 0) ",
   "   AND (ta_ccc211 <> 0 OR ta_ccc217 <> 0  OR ta_ccc18<>0  OR ta_ccc214 <> 0 OR ta_ccc11 <> 0 OR ta_ccc31 <> 0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 or ta_ccc41 <> 0 OR ta_ccc43 <> 0 OR ta_ccc61 <> 0 OR ta_ccc91 <> 0 OR ta_ccc213 <> 0  OR ta_ccc81<>0 OR ta_ccc98<>0) ",  #No.171017001
   "   AND ta_ccc02 = ",tm.yy,
   "   AND ta_ccc03 = ",tm.mm,
   "   AND ",tm.wc

  CALL g_ta_cck.clear()
  LET g_cnt = 1
  LET g_rec_b = 0
  LET l_cnt=0
  LET l_bqhyje = 0
  LET l_tzje = 0
  
  PREPARE q902_p FROM l_sql
  DECLARE q902_c1 CURSOR FOR q902_p
  FOREACH q902_c1 INTO g_ta_cck[g_cnt].*
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    ###add by liyjf181224 str ???????
    LET l_ta_ccq20 = ''
    SELECT ta_ccq20 INTO l_ta_ccq20 FROM ta_ccq_file WHERE ta_ccq05 = g_ta_cck[g_cnt].ta_ccc01  AND ta_ccq02 = g_ta_cck[g_cnt].ta_ccc02 AND ta_ccq03 = g_ta_cck[g_cnt].ta_ccc03 
    IF NOT cl_null(l_ta_ccq20) AND l_ta_ccq20>0 THEN 
       LET g_ta_cck[g_cnt].ta_cccud12 = l_ta_ccq20
    END IF 
    ###add by liyjf181224 end
    LET l_bqhyje = l_bqhyje + g_ta_cck[g_cnt].bqhyje
    LET l_tzje = l_tzje + g_ta_cck[g_cnt].tzje
    LET g_cnt = g_cnt + 1
  END FOREACH
  CALL g_ta_cck.deleteElement(g_cnt)
  LET g_rec_b = g_cnt - 1
  DISPLAY g_rec_b TO FORMONLY.cnt
  DISPLAY l_bqhyje TO sum_bqhyje
  DISPLAY l_tzje TO sum_tzje
END FUNCTION
FUNCTION q902_drill_down()                                                      
                                                                                
   IF cl_null(tm.yy) OR cl_null(tm.mm) THEN RETURN END IF                                   
   LET g_msg = "cxcq001 '",tm.yy,"' '",tm.mm,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION 
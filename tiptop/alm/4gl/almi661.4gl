# Prog. Version..: '5.30.06-13.04.09(00004)'     #
#
# Pattern name...: almi661.4gl
# Descriptions...: 收券规则设置作业
# Date & Author..: NO.FUN-CB0025 12/11/07 By yangxf
# Modify.........: No.FUN-CC0058 12/12/26 By xumeimei 调整收券规则逻辑
# Modify.........: No.FUN-D10117 13/01/31 By dongsz 收券規則設置作業規則類型改為4
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

       #收券规则设置单头集合
DEFINE g_ltp         RECORD LIKE ltp_file.*,
       #收券规则设置单头集合旧值
       g_ltp_t       RECORD LIKE ltp_file.*,
       #收券规则设置单头集合备份值
       g_ltp_o       RECORD LIKE ltp_file.*,
       #制定营运中心旧值
       g_ltp01_t     LIKE ltp_file.ltp01,
       #所属营运中心旧值
       g_ltpplant_t  LIKE ltp_file.ltpplant,
       #规则单号旧值
       g_ltp02_t     LIKE ltp_file.ltp02,
       #收券规则单身一资料
       g_ltq         DYNAMIC ARRAY OF RECORD
          #制定营运中心
          ltq01      LIKE ltq_file.ltq01,
          #规则单号
          ltq02      LIKE ltq_file.ltq02,
          #编号
          ltq03      LIKE ltq_file.ltq03,
          #编号说明
          ltq03_desc LIKE type_file.chr100,
          #有效否
          ltqacti    LIKE ltq_file.ltqacti
                     END RECORD,
       #收券规则单身一资料旧值
       g_ltq_t       RECORD
          #制定营运中心
          ltq01      LIKE ltq_file.ltq01,
          #规则单号
          ltq02      LIKE ltq_file.ltq02,
          #编号
          ltq03      LIKE ltq_file.ltq03,
          #编号说明
          ltq03_desc LIKE type_file.chr100,
          #有效否
          ltqacti    LIKE ltq_file.ltqacti
                     END RECORD,
       #收券规则单身二资料
       g_ltr         DYNAMIC ARRAY OF RECORD
          #制定营运中心
          ltr01      LIKE ltr_file.ltr01,
          #规则单号
          ltr02      LIKE ltr_file.ltr02,
          #编号
          ltr03      LIKE ltr_file.ltr03,
          #编号说明
          ltr03_desc LIKE type_file.chr100,
          #有效否
          ltracti    LIKE ltr_file.ltracti
                     END RECORD,
       #收券规则单身二资料旧值
       g_ltr_t       RECORD
          #制定营运中心
          ltr01      LIKE ltr_file.ltr01,
          #规则单号
          ltr02      LIKE ltr_file.ltr02,
          #编号
          ltr03      LIKE ltr_file.ltr03,
          #编号说明
          ltr03_desc LIKE type_file.chr100,
          #有效否
          ltracti    LIKE ltr_file.ltracti
                     END RECORD,
       #组sql语句
       g_sql         STRING,
       #单头查询条件
       g_wc          STRING,
       #单身一查询条件
       g_wc2         STRING,
       #单身二查询条件
       g_wc3         STRING,
       #单身一笔数
       g_rec_b       LIKE type_file.num5,
       #单身二笔数
       g_rec_b1      LIKE type_file.num5,
       #单身一光标
       l_ac          LIKE type_file.num5,
       #单身二光标
       l_ac1         LIKE type_file.num5,
       #组锁资料语句
       g_forupd_sql        STRING,
       #输入状态
       g_before_input_done LIKE type_file.num5,
       #记录有效码状态
       g_chr               LIKE type_file.chr1,
       #计数器
       g_cnt               LIKE type_file.num10,
       #获取返回信息
       g_msg               LIKE ze_file.ze03,
       #单头第几笔资料
       g_curs_index        LIKE type_file.num10,
       #单头资料笔数
       g_row_count         LIKE type_file.num10,
       #跳页
       g_jump              LIKE type_file.num10,
       #是否開啟指定筆視窗
       g_no_ask            LIKE type_file.num5,
       #pos状态
       g_ltppos            LIKE ltp_file.ltppos,
       #标识符
       g_copy_flag         LIKE type_file.chr1,
       #标识符
       g_copy_flag1        LIKE type_file.chr1,
       #单据别
       g_t1                LIKE oay_file.oayslip,
       #标识符
       g_sel               LIKE type_file.chr1,
       #券种编号
       g_ltp03             LIKE ltp_file.ltp03,
       #有效日期
       g_lpx03             LIKE lpx_file.lpx03,
       #失效日期
       g_lpx04             LIKE lpx_file.lpx04,
       #单据性质
       g_gee02             LIKE gee_file.gee02

#主函数
MAIN
   #改變一些系統預設值
   OPTIONS
      #輸入的方式: 不打轉
      INPUT NO WRAP
   #擷取中斷鍵, 由程式處理
   DEFER INTERRUPT
   #判断用户权限
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #如果遇到错误就写入记录档里
   WHENEVER ERROR CALL cl_err_msg_log
   #判断模组正确否
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   #計時程序運行時間
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #组锁单头资料语句
   LET g_forupd_sql = "SELECT * FROM ltp_file WHERE ltp01 = ? AND ltp02 = ? AND ltpplant = ? FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i661_cl CURSOR FROM g_forupd_sql
   #开启画面
   OPEN WINDOW i661_w WITH FORM "alm/42f/almi661"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   #初始化
   CALL cl_ui_init()
   #隐藏栏位
   CALL cl_set_comp_visible("ltq01,ltq02,ltr01,ltr02",FALSE) 
   IF g_aza.aza88 = 'Y' THEN
      #显示ltppos栏位
      CALL cl_set_comp_visible("ltppos",TRUE)
   ELSE
      #隐藏ltppos栏位
      CALL cl_set_comp_visible("ltppos",FALSE)
   END IF
   #预设单据性质
   LET g_gee02 = 'Q8'
   #进入MENU
   CALL i661_menu()
   #关闭窗口
   CLOSE WINDOW i661_w
   #记录程序结束时间
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#输入查询条件
FUNCTION i661_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   #清空画面
   CLEAR FORM
   #清空单身一数组变量
   CALL g_ltq.clear()
   #清空单身二数组变量
   CALL g_ltr.clear()
   CALL cl_set_head_visible("","YES")
   #单头变量初始化
   INITIALIZE g_ltp.* TO NULL
   DIALOG ATTRIBUTE(UNBUFFERED)
      #输入查询条件
      CONSTRUCT BY NAME g_wc ON ltp01,ltp02,ltp021,ltp03,ltp04,ltp05,ltp06,
                                ltp07,ltp08,ltp09,ltp10,ltppos,ltpconf,ltpconu,
                                ltpcond,ltp11,ltp12,ltpuser,ltpgrup,ltporiu,
                                ltpmodu,ltpdate,ltporig,ltpacti,ltpcrat
      
         BEFORE CONSTRUCT
            #初始化
            CALL cl_qbe_init()
      
         #开窗查询
         ON ACTION controlp
            CASE
               #制定营运中心
               WHEN INFIELD(ltp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltp01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltp01
                  NEXT FIELD ltp01
               #规则单号
               WHEN INFIELD(ltp02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltp02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltp02
                  NEXT FIELD ltp02
               #券种编号
               WHEN INFIELD(ltp03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltp03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltp03
                  NEXT FIELD ltp03
               #审核人员
               WHEN INFIELD(ltpconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltpconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltpconu
                  NEXT FIELD ltpconu
      
               OTHERWISE EXIT CASE
            END CASE
      
         END CONSTRUCT
         #在单身一下查询条件
         CONSTRUCT g_wc2 ON ltq03,ltqacti
                       FROM s_ltq[1].ltq03,s_ltq[1].ltqacti
      
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE
               #编号
               WHEN INFIELD(ltq03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltq03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltq03
                  NEXT FIELD ltq03
               OTHERWISE EXIT CASE
            END CASE
      
      END CONSTRUCT
      #在单身二下查询条件
      CONSTRUCT g_wc3 ON ltr03,ltracti
                    FROM s_ltr[1].ltr03,s_ltr[1].ltracti

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         #开窗查询
         ON ACTION controlp
            CASE
               #编号
               WHEN INFIELD(ltr03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltr03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltr03
                  NEXT FIELD ltr03
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
      #开启另一只作业
      ON ACTION controlg
         CALL cl_cmdask()
      #关闭
      ON ACTION close
         LET INT_FLAG = 1
         EXIT DIALOG
      #确定
      ON ACTION accept
         EXIT DIALOG
      #取消
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
   END DIALOG
   #中断
   IF INT_FLAG THEN
      RETURN
   END IF
   #清空查询条件后面空白
   LET g_wc2 = g_wc2 CLIPPED
   #单身二没有下条件
   IF g_wc3 = " 1=1" THEN
      #单身一没有下条件
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT ltp01,ltp02,ltpplant FROM ltp_file ",
                      " WHERE ltpplant= '",g_plant,"' AND ", g_wc CLIPPED,
                      " ORDER BY ltp01 "
      #单身一有下条件                
      ELSE
          LET g_sql = "SELECT UNIQUE ltp01,ltp02,ltpplant ",
                      "  FROM ltp_file, ltq_file ",
                      " WHERE ltpplant = ltqplant AND ltp01 = ltq01 AND ltp02 = ltq02 ",
                      "   AND ltpplant = '",g_plant,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY ltp01"
      END IF
   #单身二有下条件   
   ELSE
      #单身一没有下条件
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT UNIQUE ltp01,ltp02,ltpplant FROM ltp_file,ltr_file ",
                      " WHERE ltpplant = ltrplant AND ltp01 = ltr01 AND ltp02 = ltr02 ",
                      "   AND ltpplant = '",g_plant,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY ltp01"
      #单身一有下条件                
      ELSE
         LET g_sql = "SELECT UNIQUE ltp01,ltp02,ltpplant ",
                     "  FROM ltp_file, ltq_file,ltr_file ",
                     " WHERE ltpplant = ltqplant AND ltp01 = ltq01 AND ltp02 = ltq02 ",
                     "   AND ltpplant = ltrplant AND ltp01 = ltr01 AND ltp02 = ltr02 ",
                     "   AND ltpplant = '",g_plant,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY ltp01"
      END IF
   END IF
   PREPARE i661_prepare FROM g_sql
   DECLARE i661_cs
       SCROLL CURSOR WITH HOLD FOR i661_prepare
   #单身二没有下条件    
   IF g_wc3 = " 1=1" THEN
      #单身一没有下条件 
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) FROM ltp_file ",
                      " WHERE ltpplant='",g_plant,"' AND ", g_wc CLIPPED,
                      " ORDER BY ltp01"
      #单身一有下条件                
      ELSE
          LET g_sql = "SELECT COUNT(*) ",
                      "  FROM ltp_file, ltq_file ",
                      " WHERE ltpplant = ltqplant AND ltp01 = ltq01 AND ltp02 = ltq02 ",
                      "   AND ltpplant = '",g_plant,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY ltp01"
      END IF
   #单身二有下条件   
   ELSE
      #单身一没有下条件
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) ltp_file, ltr_file",
                      " WHERE ltpplant = ltrplant AND ltp01 = ltr01 AND ltp02 = ltr02",
                      "   AND ltpplant = '",g_plant,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY ltp01"
      #单身一有下条件                
      ELSE
         LET g_sql = "SELECT COUNT(*) ",
                     "  FROM ltp_file, ltq_file,ltr_file ",
                     " WHERE ltpplant = ltqplant AND ltp01 = ltq01 AND ltp02 = ltq02 ",
                     "   AND ltpplant = ltrplant AND ltp01 = ltr01 AND ltp02 = ltr02 ",
                     "   AND ltpplant = '",g_plant,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY ltp01"
      END IF
   END IF
   PREPARE i661_precount FROM g_sql
   DECLARE i661_count CURSOR FOR i661_precount
END FUNCTION

#MENU界面
FUNCTION i661_menu()

   WHILE TRUE
      CALL i661_bp("G")
      CASE g_action_choice
         #新增 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i661_a()
            END IF
         #查询
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i661_q()
            END IF
         #删除
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i661_r()
            END IF
         #修改
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i661_u()
            END IF
         #复制
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i661_copy()
            END IF
         #单身
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i661_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #帮助
         WHEN "help"
            CALL cl_show_help()
         #退出
         WHEN "exit"
            EXIT WHILE
         #开启另一只作业
         WHEN "controlg"
            CALL cl_cmdask()
         #汇出
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltq),base.TypeInfo.create(g_ltr),'')
            END IF
         #相关文件
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ltp.ltp01 IS NOT NULL THEN
                    LET g_doc.column1 = "ltpplant"
                    LET g_doc.value1  = g_ltp.ltpplant
                    LET g_doc.column2 = "ltp01"
                    LET g_doc.value2  = g_ltp.ltp01
                    LET g_doc.column3 = "ltp02"
                    LET g_doc.value3  = g_ltp.ltp02
                    CALL cl_doc()
                  END IF
              END IF
         #无效 
         WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i661_x()
           END IF
         #审核
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i661_conf()
            END IF
         #取消审核
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i661_unconf()
            END IF
         #发布
         WHEN "release"
            IF cl_chk_act_auth() THEN
               CALL i661_release()
            END IF
         #生效营运中心     
         WHEN "eff_plant"
            IF cl_chk_act_auth() THEN
               CALL i661_eff_plant()
            END IF
      END CASE
   END WHILE

   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF

END FUNCTION

#显示单身数据及交互指令
FUNCTION i661_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   #隐藏确认，取消按钮
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ltq TO s_ltq.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            LET g_sel = '1'
            CALL cl_navigator_setting( g_curs_index, g_row_count )
      
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
      
      DISPLAY ARRAY g_ltr TO s_ltr.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            LET g_sel = '2'
            CALL cl_navigator_setting( g_curs_index, g_row_count )
      
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      #新增
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      #查询
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      #删除
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      #修改
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      #复制
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      #第一笔
      ON ACTION first
         CALL i661_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      #上一笔
      ON ACTION previous
         CALL i661_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      #指定笔
      ON ACTION jump
         CALL i661_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      #下一笔 
      ON ACTION next
         CALL i661_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      #末笔
      ON ACTION last
         CALL i661_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      #单身
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      #帮助
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      #语言别
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      #退出
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      #开启另一支作业
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      #确定
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
      #取消
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      #时间管控
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      #关于
      ON ACTION about
         CALL cl_about()
      #汇出
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      #无效
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
      #生效营运中心
      ON ACTION eff_plant
         LET g_action_choice="eff_plant"
         EXIT DIALOG
      #审核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      #取消审核
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
      #发布
      ON ACTION release
         LET g_action_choice="release"
         EXIT DIALOG
      #相关文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
      
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#刷新单身一资料
FUNCTION i661_bp_refresh()

  DISPLAY ARRAY g_ltq TO s_ltq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

#刷新单身二资料
FUNCTION i661_bp1_refresh()

  DISPLAY ARRAY g_ltr TO s_ltr.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

#新增
FUNCTION i661_a()
          #正确码
   DEFINE li_result   LIKE type_file.num5 

   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
   #清空单身一数组
   CALL g_ltq.clear()
   #清空单身二数组
   CALL g_ltr.clear()
   #清空查询条件
   LET g_wc = NULL
   LET g_wc2= NULL
   LET g_wc3 = NULL
   IF s_shut(0) THEN
      RETURN
   END IF
   #初始化单头变量
   INITIALIZE g_ltp.* LIKE ltp_file.*
   LET g_ltp.ltp01 = g_plant
   LET g_ltp01_t = g_plant
   LET g_ltp.ltp021 = 0
   LET g_ltp.ltp08 = 'N'
   LET g_ltp.ltp11 = 'N'
   LET g_ltp.ltppos = '1'
   LET g_ltp.ltpacti  = 'Y'
   LET g_ltp.ltpconf  = 'N'
   LET g_ltp.ltpcrat  = g_today
   LET g_ltp.ltpgrup  = g_grup
   LET g_ltp.ltplegal = g_legal
   LET g_ltp.ltporig  = g_grup
   LET g_ltp.ltporiu  = g_user
   LET g_ltp.ltpplant = g_plant
   LET g_ltp.ltpuser  = g_user
   LET g_ltp_t.* = g_ltp.*

   WHILE TRUE
      #进入新增界面
      CALL i661_i("a")
      #中断 
      IF INT_FLAG THEN
         INITIALIZE g_ltp.* TO NULL
         CALL g_ltq.clear()
         CALL g_ltr.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
    
      IF cl_null(g_ltp.ltp02) THEN
         CONTINUE WHILE
      END IF
      #自动编号
      CALL s_auto_assign_no("alm",g_ltp.ltp02,g_today,g_gee02,"ltp_file","ltp02","","","")
        RETURNING li_result,g_ltp.ltp02
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ltp.ltp02
      BEGIN WORK
      INSERT INTO ltp_file VALUES (g_ltp.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ltp_file",g_ltp.ltp01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      
      SELECT * INTO g_ltp.* FROM ltp_file
       WHERE ltp02=g_ltp.ltp02
         AND ltp01 = g_ltp.ltp01
         AND ltpplant = g_ltp.ltpplant 
      #给旧值赋值
      LET g_ltp01_t = g_ltp.ltp01
      LET g_ltp_t.* = g_ltp.*
      #开启生效营运中心画面进行维护
     #CALL i555_sub(g_ltp.ltp01,g_ltp.ltp02,'3',g_ltp.ltp03)     #FUN-D10117 mark
      CALL i555_sub(g_ltp.ltp01,g_ltp.ltp02,'4',g_ltp.ltp03)     #FUN-D10117 add
      #清空单身一资料
      CALL g_ltq.clear()
      #清空单身二资料
      CALL g_ltr.clear()
      LET g_rec_b = 0
      LET g_rec_b1 = 0
      #单身
      CALL i661_b()
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i661_u()
            #计数器
   DEFINE   l_n      LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   #修改前检查是否可修改
   CALL i661_msg('mod') 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   #更新数据
   SELECT * INTO g_ltp.* FROM ltp_file
    WHERE ltpplant = g_ltp.ltpplant
      AND ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02

   MESSAGE ""
   LET g_ltp01_t = g_ltp.ltp01
   BEGIN WORK
   #开启锁
   OPEN i661_cl USING g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
   IF STATUS THEN
      CALL cl_err("OPEN i661_cl:", STATUS, 1)
      CLOSE i661_cl
      ROLLBACK WORK
      RETURN
   END IF
   #抓取锁住的资料
   FETCH i661_cl INTO g_ltp.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
       CLOSE i661_cl
       ROLLBACK WORK
       RETURN
   END IF
   #显示
   CALL i661_show()
   WHILE TRUE
      LET g_ltp01_t = g_ltp.ltp01
      #进入修改界面
      CALL i661_i("u")
      #中断
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ltp.*=g_ltp_t.*
         CALL i661_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      #单头主键有更改
      IF g_ltp.ltp01 != g_ltp_t.ltp01
         OR g_ltp.ltp02 != g_ltp_t.ltp02
         OR  g_ltp.ltpplant != g_ltp_t.ltpplant THEN

         SELECT COUNT(*) INTO l_n FROM ltq_file
          WHERE ltqplant = g_ltp_t.ltpplant
            AND ltq01 = g_ltp_t.ltp01
            AND ltq02 = g_ltp_t.ltp02
         #单身一有资料
         IF l_n > 0 THEN
            #更新单身一资料
            UPDATE ltq_file SET ltq01 = g_ltp.ltp01,
                                ltq02 = g_ltp.ltp02,
                                ltqplant = g_ltp.ltpplant
             WHERE ltqplant = g_ltp_t.ltpplant
               AND ltq01 = g_ltp_t.ltp01
               AND ltq02 = g_ltp_t.ltp02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","ltq_file",g_ltp01_t,"",SQLCA.sqlcode,"","ltq",1)
               CONTINUE WHILE
            END IF
         END IF
         SELECT COUNT(*) INTO l_n FROM ltr_file
          WHERE ltrplant = g_ltp_t.ltpplant
            AND ltr01 = g_ltp_t.ltp01
            AND ltr02 = g_ltp_t.ltp02
         #单身二有资料
         IF l_n > 0 THEN   
            #更新单身二资料 
            UPDATE ltr_file SET ltr01 = g_ltp.ltp01,
                                ltr02 = g_ltp.ltp02,
                                ltrplant = g_ltp.ltpplant
             WHERE ltrplant = g_ltp_t.ltpplant
               AND ltr01 = g_ltp_t.ltp01
               AND ltr02 = g_ltp_t.ltp02
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ltr_file",g_ltp01_t,"",SQLCA.sqlcode,"","ltr",1)
               CONTINUE WHILE
            END IF   
         END IF    
      END IF
      LET g_ltp.ltpmodu = g_user
      LET g_ltp.ltpdate = g_today
      #更新单头资料
      UPDATE ltp_file SET ltp_file.* = g_ltp.*
       WHERE ltpplant = g_ltp_t.ltpplant
         AND ltp01 = g_ltp_t.ltp01
         AND ltp02 = g_ltp_t.ltp02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ltp_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i661_cl
   COMMIT WORK
END FUNCTION

#用户操作界面
FUNCTION i661_i(p_cmd)
             #计数器 
   DEFINE    l_n         LIKE type_file.num5,
             #输入状态 
             p_cmd       LIKE type_file.chr1,
             #营运中心名称
             l_azp02     LIKE azp_file.azp02,
             #审核人员名称
             l_gen02     LIKE gen_file.gen02,
             #正确码
             li_result   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF
   #获取营运中心名称并显示   
   SELECT azp02 INTO l_azp02 
     FROM azp_file
    WHERE azp01 = g_ltp.ltp01
   DISPLAY l_azp02 TO azp02
   
   #获取审核人员名称
   SELECT gen02 INTO l_gen02
     FROM gen_file 
    WHERE gen01 = g_ltp.ltpconu
   DISPLAY l_gen02 TO gen02
   #显示预设值
   DISPLAY BY NAME g_ltp.ltp01,g_ltp.ltp021,g_ltp.ltp08,g_ltp.ltppos,g_ltp.ltpacti,g_ltp.ltpconf,g_ltp.ltpconu,
                   g_ltp.ltpcond,g_ltp.ltpcont,g_ltp.ltp11,g_ltp.ltp12,g_ltp.ltpcrat,g_ltp.ltpdate,
                   g_ltp.ltpgrup,g_ltp.ltpmodu,g_ltp.ltporig,g_ltp.ltpuser,g_ltp.ltporiu

   INPUT BY NAME g_ltp.ltp02,g_ltp.ltp03,g_ltp.ltp04,g_ltp.ltp05,g_ltp.ltp06,g_ltp.ltp07,
                 g_ltp.ltp08,g_ltp.ltp09,g_ltp.ltp10
           WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i661_set_entry(p_cmd)
         CALL i661_set_no_entry(p_cmd)
         IF g_ltp.ltp08 = 'Y' THEN
            CALL cl_set_comp_entry("ltp09,ltp10",TRUE)
            CALL cl_set_comp_required("ltp09,ltp10",TRUE)
         ELSE
            CALL cl_set_comp_entry("ltp09,ltp10",FALSE)
            CALL cl_set_comp_required("ltp09,ltp10",FALSE)
            LET g_ltp.ltp09 = ''
            LET g_ltp.ltp10 = ''
            DISPLAY BY NAME g_ltp.ltp09,g_ltp.ltp10
         END IF
         LET g_before_input_done = TRUE

      #规则单号
      AFTER FIELD ltp02
         IF NOT cl_null(g_ltp.ltp02) THEN
            #检查单别是否正确
            CALL s_check_no("alm",g_ltp.ltp02,g_ltp.ltp02,g_gee02,"ltp_file","ltp02","")
                 RETURNING li_result,g_ltp.ltp02
            IF (NOT li_result) THEN
               LET g_ltp.ltp02 = ''
               NEXT FIELD ltp02
            END IF
         END IF

      #备份券种编号
      BEFORE FIELD ltp03
         IF cl_null(g_ltp.ltp03) THEN 
            LET g_ltp03 = ' ' 
         ELSE
            LET g_ltp03 = g_ltp.ltp03 
         END IF 

      #券种
      AFTER FIELD ltp03
         IF NOT cl_null(g_ltp.ltp03) THEN
            #检查券种是否存在或有效并带出达成金额和收券金额
            CALL i661_ltp03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ltp03
            END IF
            #检查券种在有效时间是否重复
            CALL i661_ltp04_ltp05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ltp03
            END IF
         ELSE
            LET g_lpx03 = ''
            LET g_lpx04 = '' 
         END IF
      
      #生效日期
      AFTER FIELD ltp04
         IF NOT cl_null(g_ltp.ltp04) THEN
            #检查券种在有效时间是否重复
            CALL i661_ltp04_ltp05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ltp.ltp04=g_ltp_t.ltp04
               NEXT FIELD ltp04
            END IF
         END IF

      #失效日期
      AFTER FIELD ltp05
         IF NOT cl_null(g_ltp.ltp05) THEN
            #检查券种在有效时间是否重复
            CALL i661_ltp04_ltp05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ltp.ltp05=g_ltp_t.ltp05
               NEXT FIELD ltp05
            END IF
         END IF

      #收券规则
      AFTER FIELD ltp06
        #IF g_ltp.ltp06 != g_ltp_t.ltp06 AND NOT cl_null(g_ltp_t.ltp06) THEN                          #FUN-CC0058
         IF g_ltp.ltp06 != g_ltp_t.ltp06 AND NOT cl_null(g_ltp_t.ltp06) AND g_ltp_t.ltp06 <> '0' THEN #FUN-CC0058
            IF NOT cl_confirm('alm-816') THEN
               LET g_ltp.ltp06=g_ltp_t.ltp06
            ELSE
               #删除单身一资料
               DELETE FROM ltq_file
                WHERE ltq01 = g_ltp.ltp01
                  AND ltq02 = g_ltp.ltp02
                  AND ltqplant = g_ltp.ltpplant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ltq_file",g_ltp.ltp01,g_ltp.ltp02,SQLCA.sqlcode,"","",1)
                  NEXT FIELD ltp06
               ELSE
                  LET g_copy_flag = '2' 
                  #清空单身一资料
                  CALL g_ltq.clear()
                  #填充单身一
                  CALL i661_b_fill(g_wc2)
                  #刷新单身一资料
                  CALL i661_bp_refresh()
               END IF
            END IF
         END IF

      #排除规则
      AFTER FIELD ltp07
        #IF g_ltp.ltp07 != g_ltp_t.ltp07 AND NOT cl_null(g_ltp_t.ltp07) THEN                          #FUN-CC0058
         IF g_ltp.ltp07 != g_ltp_t.ltp07 AND NOT cl_null(g_ltp_t.ltp07) AND g_ltp_t.ltp07 <> '0' THEN #FUN-CC0058
            IF NOT cl_confirm('alm-816') THEN
               LET g_ltp.ltp07=g_ltp_t.ltp07
            ELSE
               #删除单身一资料
               DELETE FROM ltr_file
                WHERE ltr01 = g_ltp.ltp01
                  AND ltr02 = g_ltp.ltp02
                  AND ltrplant = g_ltp.ltpplant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ltr_file",g_ltp.ltp01,g_ltp.ltp02,SQLCA.sqlcode,"","",1)
                  NEXT FIELD ltp07
               ELSE
                  LET g_copy_flag1 = '2'
                  #清空单身二资料
                  CALL g_ltr.clear()
                  #填充单身二
                  CALL i661_b1_fill(g_wc3)
                  #刷新单身二资料
                  CALL i661_bp1_refresh()
               END IF
            END IF
         END IF

      
      #满额收券否
      ON CHANGE ltp08
         IF g_ltp.ltp08 = 'Y' THEN 
            CALL cl_set_comp_entry("ltp09,ltp10",TRUE)
            CALL cl_set_comp_required("ltp09,ltp10",TRUE)
         ELSE
            CALL cl_set_comp_entry("ltp09,ltp10",FALSE)
            CALL cl_set_comp_required("ltp09,ltp10",FALSE)
            LET g_ltp.ltp09 = ''
            LET g_ltp.ltp10 = ''
            DISPLAY BY NAME g_ltp.ltp09,g_ltp.ltp10
         END IF  


      #达成金额
      AFTER FIELD ltp09
         IF NOT cl_null(g_ltp.ltp09) THEN 
            IF g_ltp.ltp09 <= 0 THEN 
               CALL cl_err('','alm1639',0)
               LET g_ltp.ltp09 = g_ltp_t.ltp09
               NEXT FIELD ltp09
            END IF 
         END IF 

      #收券金额 
      AFTER FIELD ltp10
         IF NOT cl_null(g_ltp.ltp10) THEN
            IF g_ltp.ltp10 <= 0 THEN
               CALL cl_err('','alm1640',0)
               LET g_ltp.ltp10 = g_ltp_t.ltp10
               NEXT FIELD ltp10
            END IF
         END IF 

      AFTER INPUT 
         #中断
         IF INT_FLAG THEN
            RETURN
         ELSE
            #检查券种在有效时间是否重复
            CALL i661_ltp04_ltp05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ltp03
            END IF
         END IF 

      #显示必输栏位 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      #开启另一只作业
      ON ACTION CONTROLG
         CALL cl_cmdask()

      #开启字段说明
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      #开窗查询
      ON ACTION controlp
         CASE
            #规则编号
            WHEN INFIELD(ltp02)
               LET g_t1 = s_get_doc_no(g_ltp.ltp01)
               CALL q_oay(FALSE,FALSE,'',g_gee02,'ALM') RETURNING g_t1
               LET g_ltp.ltp02 = g_t1
               DISPLAY BY NAME g_ltp.ltp02
               NEXT FIELD ltp02
            #券种编号
            WHEN INFIELD(ltp03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpx"
               LET g_qryparam.default1 = g_ltp.ltp03
               LET g_qryparam.where = " lpx01 IN (SELECT lnk01 FROM lnk_file WHERE lnk02 = '2' AND lnk05 = 'Y' AND lnk03 = '",g_plant,"')"
               CALL cl_create_qry() RETURNING g_ltp.ltp03
               DISPLAY BY NAME g_ltp.ltp03
               CALL i661_ltp03('a')
               NEXT FIELD ltp03
            OTHERWISE EXIT CASE
          END CASE

      #时间管控
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      #关于
      ON ACTION about
         CALL cl_about()

      #帮助
      ON ACTION help
         CALL cl_show_help()

   END INPUT
   IF cl_null(g_ltp.ltp09) THEN 
      LET g_ltp.ltp09 = 0
   END IF 
   IF cl_null(g_ltp.ltp10) THEN
      LET g_ltp.ltp10 = 0
   END IF
   LET g_sel = '1'
END FUNCTION

#检查券种编号是否存在或是有效
FUNCTION i661_ltp03(p_cmd)
          #状态标志
   DEFINE p_cmd       LIKE type_file.chr1,
          #计数器
          l_cnt       LIKE type_file.num5,
          #券种名称
          l_lpx02     LIKE lpx_file.lpx02,
          #审核码
          l_lpx15     LIKE lpx_file.lpx15,
          #满额收券否
          l_lpx08     LIKE lpx_file.lpx08,
          #达成金额
          l_lpx10     LIKE lpx_file.lpx10,
          #收券金额
          l_lpx35     LIKE lpx_file.lpx35,
          #有效否
          l_lpxacti   LIKE lpx_file.lpxacti
          

   SELECT lpx02,lpx03,lpx04,lpx08,lpx10,lpx15,lpx35,lpxacti
     INTO l_lpx02,g_lpx03,g_lpx04,l_lpx08,l_lpx10,l_lpx15,l_lpx35,l_lpxacti
     FROM lpx_file
    WHERE lpx01 = g_ltp.ltp03

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-960'  #無此券類型編號
                                  LET l_lpx02 = NULL
        WHEN l_lpx15 = 'N'        LET g_errno = '9029'     #此筆資料尚未審核, 不可使用
        WHEN l_lpxacti = 'N'      LET g_errno = 'mfg0301'  #本筆資料無效
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) AND p_cmd != 'd' THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 = g_ltp.ltp03
         AND lnk02 = '2'
         AND lnk03 = g_ltp.ltpplant
         AND lnk05 = 'Y'
      #該券在當前門店中無生效資料,請檢查almi660的券使用範圍!
      IF l_cnt < 1 THEN 
         LET g_errno = 'alm-395'
      ELSE
         IF (p_cmd = 'u' AND g_ltp.ltp03 != g_ltp_t.ltp03)
            OR g_ltp03 != g_ltp.ltp03 THEN 
            LET g_ltp.ltp08 = l_lpx08
            LET g_ltp.ltp09 = l_lpx10
            LET g_ltp.ltp10 = l_lpx35
            DISPLAY BY NAME g_ltp.ltp08,g_ltp.ltp09,g_ltp.ltp10
            IF g_ltp.ltp08 = 'Y' THEN
               CALL cl_set_comp_entry("ltp09,ltp10",TRUE)
               CALL cl_set_comp_required("ltp09,ltp10",TRUE)
            ELSE
               CALL cl_set_comp_entry("ltp09,ltp10",FALSE)
               CALL cl_set_comp_required("ltp09,ltp10",FALSE)
               LET g_ltp.ltp09 = ''
               LET g_ltp.ltp10 = ''
               DISPLAY BY NAME g_ltp.ltp09,g_ltp.ltp10
            END IF
         END IF
      END IF
   END IF
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lpx02 TO lpx02
   END IF 
END FUNCTION

#检查同一券种在时间范围内有交集
FUNCTION i661_ltp04_ltp05(p_cmd)
          #状态
   DEFINE p_cmd LIKE type_file.chr1,
          #计数器
          l_n   LIKE type_file.num10
   
   LET g_errno = ''
   #失效日期不可小于生效日期
   IF g_ltp.ltp04 > g_ltp.ltp05 THEN
      LET g_errno = 'art-711'
      RETURN
   END IF
   IF cl_null(g_ltp.ltp01) THEN
      RETURN
   END IF
   #如果收券規則時間範圍在券種時間範圍之外
   IF g_ltp.ltp04 < g_lpx03 OR g_ltp.ltp04 > g_lpx04
      OR g_ltp.ltp05 < g_lpx03 OR g_ltp.ltp05 > g_lpx04 THEN
      LET g_errno = 'alm1995'
      RETURN
   END IF
   #券种为空则不需要判断重复
   IF cl_null(g_ltp.ltp03) OR cl_null(g_ltp.ltp04) OR cl_null(g_ltp.ltp05) THEN
      RETURN
   END IF
   IF p_cmd = 'a' THEN
      SELECT COUNT(*) INTO l_n
        FROM ltp_file
       WHERE ltpplant = g_ltp.ltpplant
         AND ltp03 = g_ltp.ltp03
         AND (ltp04 BETWEEN g_ltp.ltp04 AND g_ltp.ltp05
          OR  ltp05 BETWEEN g_ltp.ltp04 AND g_ltp.ltp05
          OR (ltp04 <= g_ltp.ltp04 AND ltp05 >= g_ltp.ltp05))
         AND ltp11 = 'Y'
         AND ltpconf = 'Y'
         AND ltpacti = 'Y'
   ELSE
      SELECT COUNT(*) INTO l_n
        FROM ltp_file
       WHERE ltpplant=g_ltp.ltpplant
         AND ltp03 = g_ltp.ltp03
         AND (ltp04 BETWEEN g_ltp.ltp04 AND g_ltp.ltp05
          OR  ltp05 BETWEEN g_ltp.ltp04 AND g_ltp.ltp05
          OR (ltp04 <= g_ltp.ltp04 AND ltp05 >= g_ltp.ltp05))
         AND ltp02 <> g_ltp.ltp02
         AND ltp11 = 'Y'
         AND ltpconf = 'Y'
         AND ltpacti = 'Y'
   END IF
   IF l_n>0 THEN
      LET g_errno = 'alm1645'
      RETURN
   END IF
END FUNCTION

#查询
FUNCTION i661_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   #清空画面
   CLEAR FORM
   #清空单身一
   CALL g_ltq.clear()
   #清空单身二
   CALL g_ltr.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i661_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ltp.* TO NULL
      RETURN
   END IF

   OPEN i661_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ltp.* TO NULL
   ELSE
      OPEN i661_count
      FETCH i661_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      #抓取资料
      CALL i661_fetch('F')
   END IF

END FUNCTION

#抓取查询结果
FUNCTION i661_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i661_cs INTO g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
      WHEN 'P' FETCH PREVIOUS i661_cs INTO g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
      WHEN 'F' FETCH FIRST    i661_cs INTO g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
      WHEN 'L' FETCH LAST     i661_cs INTO g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                #关于
                ON ACTION about
                   CALL cl_about()
                #帮助
                ON ACTION help
                   CALL cl_show_help()
                #开启另一只作业
                ON ACTION controlg
                   CALL cl_cmdask()

                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i661_cs INTO g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
      INITIALIZE g_ltp.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
   SELECT * INTO g_ltp.* FROM ltp_file WHERE ltp01 = g_ltp.ltp01
                                         AND ltp02 = g_ltp.ltp02
                                         AND ltpplant = g_ltp.ltpplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ltp_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ltp.* TO NULL
      RETURN
   END IF
   #显示资料
   CALL i661_show()

END FUNCTION

#显示
FUNCTION i661_show()
          #营运中心名称
   DEFINE l_azp02   LIKE azp_file.azp02,
          #员工名称
          l_gen02   LIKE gen_file.gen02

   LET g_ltp_t.* = g_ltp.*
   DISPLAY BY NAME g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltp021,g_ltp.ltp03,g_ltp.ltp04,g_ltp.ltp05,g_ltp.ltp06,
                   g_ltp.ltp07,g_ltp.ltp08,g_ltp.ltp09,g_ltp.ltp10,g_ltp.ltppos,g_ltp.ltpconf,
                   g_ltp.ltpconu,g_ltp.ltpcond,g_ltp.ltpcont,g_ltp.ltp11,g_ltp.ltp12,g_ltp.ltpuser,g_ltp.ltpgrup,
                   g_ltp.ltporiu,g_ltp.ltpmodu,g_ltp.ltpdate,g_ltp.ltporig,g_ltp.ltpacti,g_ltp.ltpcrat

   #抓取营运中心名称
   SELECT azp02 INTO l_azp02 FROM azp_file where azp01 = g_ltp.ltp01
   DISPLAY l_azp02 TO azp02
   #抓取员工名称
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ltp.ltpconu
   DISPLAY l_gen02 TO gen02
   #显示券种说明
   CALL i661_ltp03('d')
   #填充单身一 
   CALL i661_b_fill(g_wc2)
   #填充单身二
   CALL i661_b1_fill(g_wc3)
   CALL cl_show_fld_cont()
   #圖形顯示
   CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
END FUNCTION

#删除
FUNCTION i661_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   #删除前检查是否可删除
   CALL i661_msg('del')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   
   SELECT * INTO g_ltp.* FROM ltp_file
    WHERE ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02
      AND ltpplant = g_ltp.ltpplant

   LET g_ltp01_t=g_ltp.ltp01
   BEGIN WORK
   OPEN i661_cl USING g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
   IF STATUS THEN
      CALL cl_err("OPEN i661_cl:", STATUS, 1)
      CLOSE i661_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i661_cl INTO g_ltp.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   #显示资料
   CALL i661_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "ltpplant"
       LET g_doc.column2 = "ltp01"
       LET g_doc.column3 = "ltp02"
       LET g_doc.value1 = g_ltp.ltpplant
       LET g_doc.value2 = g_ltp.ltp01
       LET g_doc.value3 = g_ltp.ltp02
       CALL cl_del_doc()
       #删除单身一资料
       DELETE FROM ltq_file WHERE ltqplant = g_ltp.ltpplant AND ltq01 = g_ltp.ltp01 AND ltq02 = g_ltp.ltp02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("DELETE ","ltq_file",g_ltp_t.ltp01,"",SQLCA.sqlcode,"","ltq",1)
       END IF
       #删除单身二资料
       DELETE FROM ltr_file WHERE ltrplant = g_ltp.ltpplant AND ltr01 = g_ltp.ltp01 AND ltr02 = g_ltp.ltp02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("DELETE ","ltq_file",g_ltp_t.ltp01,"",SQLCA.sqlcode,"","ltq",1)
       END IF
       #删除生效营运中心资料
       DELETE FROM lso_file
             WHERE lso01 = g_ltp.ltp01
               AND lso02 = g_ltp.ltp02
              #AND lso03 = '3'      #FUN-D10117 mark
               AND lso03 = '4'      #FUN-D10117 add
               AND lsoplant = g_ltp.ltpplant
       #删除单头资料
       DELETE FROM ltp_file
             WHERE ltpplant = g_ltp.ltpplant
               AND ltp01 = g_ltp.ltp01
               AND ltp02 = g_ltp.ltp02
       INITIALIZE g_ltp.* TO NULL
       #清空画面
       CLEAR FORM 
       #清空单身一资料
       CALL g_ltq.clear()
       #清空单身二资料
       CALL g_ltr.clear()
       OPEN i661_count
       IF STATUS THEN
          CLOSE i661_cs
          CLOSE i661_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i661_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i661_cs
          CLOSE i661_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i661_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i661_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i661_fetch('/')
       END IF
    END IF
    CLOSE i661_cl
    COMMIT WORK

END FUNCTION

#复制
FUNCTION i661_copy()
          #新值
   DEFINE l_newno     LIKE ltp_file.ltp01,
          #旧值
          l_oldno     LIKE ltp_file.ltp01,
          #正确码
          li_result   LIKE type_file.num5,
          #计数器
          l_n         LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_ltp.ltp01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET l_oldno = g_ltp.ltp01
   CALL cl_set_head_visible("","YES")

   SELECT * INTO g_ltp.* 
     FROM ltp_file 
    WHERE ltpplant = g_ltp.ltpplant 
      AND ltp01 = g_ltp.ltp01 
      AND ltp02 = g_ltp.ltp02 
   LET g_ltp_o.* = g_ltp.*
   LET g_ltp.ltp01 = g_plant
   LET g_ltp.ltp02 = ''
   LET g_ltp.ltp021 = 0   
   LET g_ltp.ltppos  = '1'
   LET g_ltp.ltpconf = 'N'
   LET g_ltp.ltpconu = NULL
   LET g_ltp.ltpcond = NULL
   LET g_ltp.ltpcont = NULL
   LET g_ltp.ltp11 = 'N'
   LET g_ltp.ltp12 = NULL
   LET g_ltp.ltpplant = g_plant
   LET g_ltp.ltplegal = g_legal
   LET g_ltp.ltporiu  = g_user
   LET g_ltp.ltporig  = g_grup
   LET g_ltp.ltpuser  = g_user
   LET g_ltp.ltpcrat  = g_today
   LET g_ltp.ltpmodu  = NULL
   LET g_ltp.ltpdate  = NULL
   LET g_ltp.ltpgrup  = g_grup
   LET g_ltp.ltpacti  = 'Y'
   LET g_copy_flag = '1'
   LET g_copy_flag1 = '1'
   #圖形顯示
   CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
   CALL i661_i("a")
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_ltp.* = g_ltp_o.*
      #圖形顯示
      CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
      CALL i661_show()
      ROLLBACK WORK
      RETURN
   END IF
   #自动编号
   CALL s_auto_assign_no("alm",g_ltp.ltp02,g_today,g_gee02,"ltp_file","ltp02","","","")
     RETURNING li_result,g_ltp.ltp02
   IF (NOT li_result) THEN
      ROLLBACK WORK
      RETURN 
   END IF
   DISPLAY BY NAME g_ltp.ltp02

   DROP TABLE y
   SELECT * FROM ltp_file
    WHERE ltpplant = g_ltp_o.ltpplant
      AND ltp01 = g_ltp_o.ltp01
      AND ltp02 = g_ltp_o.ltp02
     INTO TEMP y
   #修改单头
   UPDATE y SET ltp01 = g_plant,
                ltp02 = g_ltp.ltp02,
                ltp021 = g_ltp.ltp021,
                ltp03 = g_ltp.ltp03,
                ltp04 = g_ltp.ltp04,
                ltp05 = g_ltp.ltp05, 
                ltp06 = g_ltp.ltp06,
                ltp07 = g_ltp.ltp07, 
                ltp08 = g_ltp.ltp08,
                ltp09 = g_ltp.ltp09,
                ltp10 = g_ltp.ltp10,
                ltp11 = g_ltp.ltp11,
                ltp12 = g_ltp.ltp12,
                ltppos  = '1',
                ltpconf = 'N',
                ltpconu = NULL,
                ltpcond = NULL,
                ltpcont = NULL,
                ltpplant = g_plant,
                ltplegal = g_legal,
                ltporiu = g_user,
                ltporig = g_grup,
                ltpuser = g_user,
                ltpcrat = g_today,
                ltpgrup = g_grup,
                ltpmodu = NULL,
                ltpdate = NULL,
                ltpacti = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   #将新值插入收券规则单头档
   INSERT INTO ltp_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ltp_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF

   IF g_copy_flag = '1' THEN 
      DROP TABLE x
      SELECT * FROM ltq_file
       WHERE ltqplant = g_ltp_o.ltpplant
         AND ltq01 = g_ltp_o.ltp01
         AND ltq02 = g_ltp_o.ltp02
        INTO TEMP x

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
      #修改收券规则单身档
      UPDATE x SET ltq01 = g_ltp.ltp01,
                   ltq02 = g_ltp.ltp02
      #新增收券规则单身档
      INSERT INTO ltq_file
          SELECT * FROM x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ltq_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      ELSE
          COMMIT WORK
      END IF
   END IF 

   IF g_copy_flag1 ='1' THEN 
      DROP TABLE y
      SELECT * FROM ltr_file
       WHERE ltrplant = g_ltp_o.ltpplant
         AND ltr01 = g_ltp_o.ltp01
         AND ltr02 = g_ltp_o.ltp02
        INTO TEMP y
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      UPDATE y SET ltr01 = g_ltp.ltp01,
                   ltr02 = g_ltp.ltp02
      INSERT INTO ltr_file SELECT * FROM y
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ltr_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF 
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lso_file WHERE lso01 = g_ltp_o.ltp01 AND lso02 = g_ltp_o.ltp02 AND lsoplant = g_ltp_o.ltpplant
   IF l_n > 0 THEN
      DROP TABLE z
      SELECT * FROM lso_file WHERE lso01 = g_ltp_o.ltp01 AND lso02 = g_ltp_o.ltp02 AND lsoplant = g_ltp_o.ltpplant
        INTO TEMP z

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
         RETURN
      END IF

      UPDATE z SET lso02 = g_ltp.ltp02,
                   lso01 = g_ltp.ltp01

      INSERT INTO lso_file SELECT * FROM z

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lrr_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
   SELECT ltp_file.* INTO g_ltp.* FROM ltp_file
    WHERE ltpplant = g_ltp.ltpplant
      AND ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02
   #进入单身
   CALL i661_b()
   #显示资料
   CALL i661_show()

END FUNCTION

#单身
FUNCTION i661_b()
            #单身一光标旧值
   DEFINE   l_ac_t          LIKE type_file.num5,
            #单身二光标旧值
            l_ac1_t         LIKE type_file.num5, 
            #计数器
            l_n             LIKE type_file.num5,
            #锁标签 
            l_lock_sw       LIKE type_file.chr1,
            #状态 
            p_cmd           LIKE type_file.chr1,
            #允许输入否
            l_allow_insert  LIKE type_file.num5,
            #第二个单身允许输入否
            l_allow_insert1 LIKE type_file.num5,   #FUN-CC0058 add
            #第二个单身允许删除否
            l_allow_delete1 LIKE type_file.num5,   #FUN-CC0058 add
            #允许删除否
            l_allow_delete  LIKE type_file.num5,
            #单身标记
            l_flag          LIKE type_file.chr1

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

   IF g_ltp.ltp01 IS NULL THEN
       RETURN
   END IF
   IF g_ltp.ltp06 = '0' AND g_ltp.ltp07 = '0' THEN     #FUN-CC0058 add
      RETURN                                           #FUN-CC0058 add
   END IF                                              #FUN-CC0058 add
   #制定营运中心不是当前营运中心
   IF g_ltp.ltp01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_ltp.ltpacti = 'N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF
   #已发布不可修改
   IF g_ltp.ltp11 = 'Y' THEN
      CALL cl_err('','alm-h55',0)
      RETURN
   END IF             
   
   #已確認時不允許修改
   IF g_ltp.ltpconf = 'Y' THEN
      CALL cl_err('','alm-027',0)
      RETURN
   END IF
   #单身一资料锁
   LET g_forupd_sql = " SELECT ltq01,ltq02,ltq03,'',ltqacti ",
                      "  FROM ltq_file ",
                      " WHERE ltqplant = ? AND ltq01 = ? AND ltq02 = ? AND ltq03 = ? FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i661_bcl CURSOR FROM g_forupd_sql
   #单身二资料锁
   LET g_forupd_sql = "SELECT ltr01,ltr02,ltr03,'',ltracti ",
                      "  FROM ltr_file",
                      " WHERE ltrplant=? AND ltr01=? AND ltr02 = ? AND ltr03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i661_bcl_1 CURSOR FROM g_forupd_sql   

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT ARRAY g_ltq FROM s_ltq.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
      
          BEFORE INPUT
             DISPLAY "BEFORE INPUT!"
             IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
             END IF
             IF g_ltp.ltp06 = '0' THEN          #FUN-CC0058 add
                CALL cl_err('','alm2005',0)     #FUN-CC0058 add
             END IF                             #FUN-CC0058 add
      
          BEFORE ROW
             DISPLAY "BEFORE ROW!"
             LET p_cmd = ''
             LET l_flag = '1'
             LET l_ac = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()
      
             BEGIN WORK
      
             OPEN i661_cl USING g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
             IF STATUS THEN
                CALL cl_err("OPEN i661_cl:", STATUS, 1)
                CLOSE i661_cl
                ROLLBACK WORK
                RETURN
             END IF
      
             FETCH i661_cl INTO g_ltp.*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
                CLOSE i661_cl
                ROLLBACK WORK
                RETURN
             END IF
      
             IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ltq_t.* = g_ltq[l_ac].*
                OPEN i661_bcl USING g_ltp.ltpplant,g_ltp.ltp01,g_ltp.ltp02,g_ltq_t.ltq03
                IF STATUS THEN
                   CALL cl_err("OPEN i661_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i661_bcl INTO g_ltq[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ltq_t.ltq02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      #显示编号说明
                      CALL i661_ltq03('d')
                   END IF
                END IF
                CALL cl_show_fld_cont()
             END IF
      
          BEFORE INSERT
             DISPLAY "BEFORE INSERT!"
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             INITIALIZE g_ltq[l_ac].* TO NULL
             #制定营运中心赋值
             LET g_ltq[l_ac].ltq01 = g_ltp.ltp01
             #规则单号赋值
             LET g_ltq[l_ac].ltq02 = g_ltp.ltp02
             LET g_ltq[l_ac].ltqacti = 'Y'
             LET g_ltq_t.* = g_ltq[l_ac].*
             CALL cl_show_fld_cont()
             LET g_before_input_done = FALSE
             LET g_before_input_done = TRUE
             NEXT FIELD ltq03
      
          AFTER INSERT
             DISPLAY "AFTER INSERT!"
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
             END IF
             #新增收券规则设置单身档 
             INSERT INTO ltq_file(ltq01,ltq02,ltq03,ltqacti,ltqlegal,ltqplant)
             VALUES(g_ltq[l_ac].ltq01,g_ltq[l_ac].ltq02,g_ltq[l_ac].ltq03,g_ltq[l_ac].ltqacti,
                    g_ltp.ltplegal,g_ltp.ltpplant)
             
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ltq_file",g_ltp.ltp01,g_ltq[l_ac].ltq02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
             
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF

         #FUN-CC0058 Begin---
          BEFORE FIELD ltq03,ltqacti
             IF g_ltp.ltp06 = '0' THEN
                NEXT FIELD ltr03
             END IF
         #FUN-CC0058 End-----
   
          #编号          
          AFTER FIELD ltq03
             IF NOT cl_null(g_ltq[l_ac].ltq03) THEN
                #检查编号是否存在或有效
                CALL i661_ltq03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_ltq[l_ac].ltq03=g_ltq_t.ltq03
                   NEXT FIELD ltq03
                END IF
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltq[l_ac].ltq03 != g_ltq_t.ltq03) THEN
                   SELECT COUNT(*) INTO l_n
                   FROM ltq_file
                   WHERE ltq01 = g_ltp.ltp01
                     AND ltq02 = g_ltp.ltp02
                     AND ltqplant = g_ltp.ltpplant
                     AND ltq03=g_ltq[l_ac].ltq03
                   #主键是否重复
                   IF l_n>0 THEN
                      CALL cl_err('','-239',1)
                      LET g_ltq[l_ac].ltq03=g_ltq_t.ltq03
                      NEXT FIELD ltq03
                   END IF
                END IF
                #收券规则和排除规则是否一致
                IF g_ltp.ltp06 = g_ltp.ltp07 THEN
                   SELECT COUNT(*) INTO l_n
                     FROM ltr_file
                    WHERE ltr01 = g_ltp.ltp01
                      AND ltr02 = g_ltp.ltp02
                      AND ltrplant = g_ltp.ltpplant
                      AND ltr03=g_ltq[l_ac].ltq03
                   IF l_n>0 THEN
                      CALL cl_err('','alm1997',0)
                      LET g_ltq[l_ac].ltq03=g_ltq_t.ltq03
                      LET g_ltq[l_ac].ltq03_desc=''
                      DISPLAY g_ltq[l_ac].ltq03_desc TO ltq03_desc
                      NEXT FIELD ltq03
                   END IF
                END IF
             END IF
             
          BEFORE DELETE
             DISPLAY "BEFORE DELETE"
             IF g_ltq_t.ltq02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ltq_file
                 WHERE ltq01 = g_ltp.ltp01
                   AND ltqplant = g_ltp.ltpplant
                   AND ltq02 = g_ltq_t.ltq02
                   AND ltq03 = g_ltq_t.ltq03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ltq_file",g_ltp.ltp01,g_ltq_t.ltq02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
             COMMIT WORK
      
          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_ltq[l_ac].* = g_ltq_t.*
                CLOSE i661_bcl
                ROLLBACK WORK
                EXIT DIALOG 
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_ltq[l_ac].ltq02,-263,1)
                LET g_ltq[l_ac].* = g_ltq_t.*
             ELSE
                UPDATE ltq_file SET ltq03 = g_ltq[l_ac].ltq03,
                                    ltqacti = g_ltq[l_ac].ltqacti
                 WHERE ltq01 = g_ltp_t.ltp01
                   AND ltqplant = g_ltp_t.ltpplant
                   AND ltq02 = g_ltq_t.ltq02
                   AND ltq03 = g_ltq_t.ltq03
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","ltq_file",g_ltp.ltp01,g_ltq_t.ltq02,SQLCA.sqlcode,"","",1)
                   LET g_ltq[l_ac].* = g_ltq_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
      
          AFTER ROW
             DISPLAY  "AFTER ROW!!"
             LET l_ac = ARR_CURR()
             LET l_ac_t = l_ac
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'a' THEN 
                   CALL g_ltq.deleteElement(l_ac)
                END IF 
                IF p_cmd = 'u' THEN
                   LET g_ltq[l_ac].* = g_ltq_t.*
                   CALL i661_delall()
                END IF
                CLOSE i661_bcl
                ROLLBACK WORK
                EXIT DIALOG  
             END IF
             CLOSE i661_bcl
             COMMIT WORK
      
          #开窗查询
          ON ACTION controlp
             CASE
                #收券规则编号
                WHEN INFIELD(ltq03)
                  IF g_ltp.ltp06 <> '1' THEN
                     CALL cl_init_qry_var()
                     CASE g_ltp.ltp06
                        WHEN "2"
                           LET g_qryparam.form ="q_oba1"
                        WHEN "3"
                           LET g_qryparam.form ="q_tqa"
                           LET g_qryparam.arg1='2'
                     END CASE
                     LET g_qryparam.default1 = g_ltq[l_ac].ltq03
                     CALL cl_create_qry() RETURNING g_ltq[l_ac].ltq03
                  ELSE
                     CALL q_sel_ima(FALSE, "q_ima", "", g_ltq[l_ac].ltq03, "", "", "", "" ,"",'' )
                     RETURNING g_ltq[l_ac].ltq03
                  END IF
                  DISPLAY BY NAME g_ltq[l_ac].ltq03
                  #显示编号说明
                  CALL i661_ltq03('d')
                  NEXT FIELD ltq03
                OTHERWISE EXIT CASE
             END CASE      

          #延用上一笔资料
          ON ACTION CONTROLO
             IF INFIELD(ltq03) AND l_ac > 1 THEN
                LET g_ltq[l_ac].* = g_ltq[l_ac-1].*
                NEXT FIELD ltq03
             END IF
          #显示必输栏位
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          #开启另一支作业
          ON ACTION CONTROLG
             CALL cl_cmdask()
          #开启栏位说明
          ON ACTION CONTROLF
             CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          #时间管控
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
          #关于
          ON ACTION about
             CALL cl_about()
          #帮助
          ON ACTION help
             CALL cl_show_help()
          #存储
          ON ACTION controls
             CALL cl_set_head_visible("","AUTO")
      END INPUT
      INPUT ARRAY g_ltr FROM s_ltr.*
            ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
      
          BEFORE INPUT
             DISPLAY "BEFORE INPUT!"
             IF g_rec_b1 != 0 THEN
                CALL fgl_set_arr_curr(l_ac1)
             END IF
             IF g_ltp.ltpconf = 'Y' THEN
                CALL cl_err('','1208',0)
                RETURN
             END IF
             IF g_ltp.ltp07 = '0' THEN         #FUN-CC0058 add
                CALL cl_err('','alm2006',0)    #FUN-CC0058 add
             END IF                            #FUN-CC0058 add
      
          BEFORE ROW
             DISPLAY "BEFORE ROW!"
             LET p_cmd = ''
             LET l_flag = '2'
             LET l_ac1 = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()
      
             BEGIN WORK
      
             OPEN i661_cl USING g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
             IF STATUS THEN
                CALL cl_err("OPEN i661_cl:", STATUS, 1)
                CLOSE i661_cl
                ROLLBACK WORK
                RETURN
             END IF
      
             FETCH i661_cl INTO g_ltp.*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
                CLOSE i661_cl
                ROLLBACK WORK
                RETURN
             END IF
      
             IF g_rec_b1 >= l_ac1 THEN
                LET p_cmd='u'
                LET g_ltr_t.* = g_ltr[l_ac1].*
                OPEN i661_bcl_1 USING g_ltp.ltpplant,g_ltp.ltp01,g_ltp.ltp02,g_ltr_t.ltr03
                IF STATUS THEN
                   CALL cl_err("OPEN i661_bcl_1:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i661_bcl_1 INTO g_ltr[l_ac1].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ltp.ltp03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL i661_ltr03('d')
                   END IF
                END IF
             END IF
      
          BEFORE INSERT
             DISPLAY "BEFORE INSERT!"
             LET p_cmd='a'
             LET l_n = ARR_COUNT()
             INITIALIZE g_ltr[l_ac1].* TO NULL
             #制定营运中心赋值
             LET g_ltr[l_ac1].ltr01 = g_ltp.ltp01
             #规则单号赋值
             LET g_ltr[l_ac1].ltr02 = g_ltp.ltp02
             LET g_ltr[l_ac1].ltracti = 'Y'
             LET g_ltr_t.* = g_ltr[l_ac1].*
             NEXT FIELD ltr03
      
          AFTER INSERT
             DISPLAY "AFTER INSERT!"
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
             END IF
      
             INSERT INTO ltr_file(ltr01,ltr02,ltr03,ltracti,ltrlegal,ltrplant)
             VALUES(g_ltr[l_ac1].ltr01,g_ltr[l_ac1].ltr02,g_ltr[l_ac1].ltr03,g_ltr[l_ac1].ltracti,
                    g_legal,g_plant)
      
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ltr_file",g_ltr[l_ac1].ltr03,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b1=g_rec_b1+1
                DISPLAY g_rec_b1 TO FORMONLY.cn3
             END IF

         #FUN-CC0058 Begin---
          BEFORE FIELD ltr03,ltracti
             IF g_ltp.ltp07 = '0' THEN
                NEXT FIELD ltq03
             END IF
         #FUN-CC0058 End-----

          #排除规则编号
          AFTER FIELD ltr03
             IF NOT cl_null(g_ltr[l_ac1].ltr03) THEN
                #检查排除规则编号是否存在
                CALL i661_ltr03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_ltr[l_ac1].ltr03=g_ltr_t.ltr03
                   NEXT FIELD ltr03
                END IF
                IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltr[l_ac1].ltr03 != g_ltr_t.ltr03) THEN
                   SELECT COUNT(*) INTO l_n
                     FROM ltr_file
                    WHERE ltr01 = g_ltp.ltp01
                      AND ltr02 = g_ltp.ltp02
                      AND ltrplant = g_ltp.ltpplant
                      AND ltr03=g_ltr[l_ac1].ltr03
                   IF l_n>0 THEN
                      CALL cl_err('','-239',0)
                      LET g_ltr[l_ac1].ltr03=g_ltr_t.ltr03
                      NEXT FIELD ltr03
                   END IF
                END IF
                #制定规则与排除规则相同时编号不可相同
                IF g_ltp.ltp06 = g_ltp.ltp07 THEN
                   SELECT COUNT(*) INTO l_n
                   FROM ltq_file
                   WHERE ltq01 = g_ltp.ltp01
                     AND ltq02 = g_ltp.ltp02
                     AND ltqplant = g_ltp.ltpplant
                     AND ltq03=g_ltr[l_ac1].ltr03
                   IF l_n>0 THEN
                      CALL cl_err('','alm1997',0)
                      LET g_ltr[l_ac1].ltr03=g_ltr_t.ltr03
                      LET g_ltr[l_ac1].ltr03_desc=''
                      DISPLAY g_ltr[l_ac1].ltr03_desc TO ltr03_desc
                      NEXT FIELD ltr03
                   END IF
                END IF
             END IF      

          BEFORE DELETE
             IF NOT cl_null(g_ltr_t.ltr03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ltr_file
                 WHERE ltrplant = g_ltp.ltpplant
                   AND ltr01 = g_ltp.ltp01
                   AND ltr02 = g_ltp.ltp02
                   AND ltr03 = g_ltr_t.ltr03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ltr_file","","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b1 = g_rec_b1-1
                DISPLAY g_rec_b1 TO FORMONLY.cn3
             END IF
             COMMIT WORK
      
          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_ltr[l_ac1].* = g_ltr_t.*
                CLOSE i661_bcl_1
                ROLLBACK WORK
                EXIT DIALOG 
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_ltr[l_ac1].ltr03,-263,1)
                LET g_ltr[l_ac1].* = g_ltr_t.*
             ELSE
                UPDATE ltr_file SET ltr03 = g_ltr[l_ac1].ltr03,
                                    ltracti = g_ltr[l_ac1].ltracti
                 WHERE ltrplant = g_ltp.ltpplant
                   AND ltr01 = g_ltp_t.ltp01
                   AND ltr02 = g_ltp_t.ltp02
                   AND ltr03 = g_ltr_t.ltr03
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","ltr_file",g_ltp.ltp01,"",SQLCA.sqlcode,"","",1)
                   LET g_ltr[l_ac1].* = g_ltr_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
      
          AFTER ROW
             DISPLAY  "AFTER ROW!!"
             LET l_ac1 = ARR_CURR()
             LET l_ac1_t = l_ac1
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'a' THEN
                   CALL g_ltr.deleteElement(l_ac1)
                END IF
                IF p_cmd = 'u' THEN
                   LET g_ltr[l_ac1].* = g_ltr_t.*
                   CALL i661_delall()
                END IF
                CLOSE i661_bcl_1
                ROLLBACK WORK
                EXIT DIALOG
             END IF
             CLOSE i661_bcl_1
             COMMIT WORK
      
          #开窗查询
          ON ACTION controlp
             CASE
                WHEN INFIELD(ltr03)
                  IF g_ltp.ltp07 <> '1' THEN
                     CALL cl_init_qry_var()
                     CASE g_ltp.ltp07
                        WHEN "2"
                           LET g_qryparam.form ="q_oba1"
                        WHEN "3"
                           LET g_qryparam.form ="q_tqa"
                           LET g_qryparam.arg1='2'
                     END CASE
                     LET g_qryparam.default1 = g_ltr[l_ac1].ltr03
                     CALL cl_create_qry() RETURNING g_ltr[l_ac1].ltr03
                  ELSE
                     CALL q_sel_ima(FALSE, "q_ima", "", g_ltr[l_ac1].ltr03, "", "", "", "" ,"",'' )
                     RETURNING g_ltr[l_ac1].ltr03
                  END IF
                  DISPLAY BY NAME g_ltr[l_ac1].ltr03
                  #显示编号说明
                  CALL i661_ltr03('d')
                  NEXT FIELD ltr03
                OTHERWISE EXIT CASE
             END CASE

          #延用上一笔资料
          ON ACTION CONTROLO
             IF INFIELD(ltr03) AND l_ac1 > 1 THEN
                LET g_ltr[l_ac1].* = g_ltr[l_ac1-1].*
                NEXT FIELD ltr03
             END IF
          #显示必输栏位
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          #开启另一只作业
          ON ACTION CONTROLG
             CALL cl_cmdask()
          #显示栏位说明
          ON ACTION CONTROLF
             CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          #时间管控
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG 
          #关于
          ON ACTION about
             CALL cl_about()
          #帮助
          ON ACTION help
             CALL cl_show_help()
      
      END INPUT

      BEFORE DIALOG
         IF g_sel = '1' THEN   
            NEXT FIELD ltq03
         ELSE
            NEXT FIELD ltr03
         END IF 

      ON ACTION accept
         ACCEPT DIALOG
      #取消
      ON ACTION cancel
         IF l_flag = '1' THEN
            IF p_cmd='u' THEN
               LET g_ltq[l_ac].* = g_ltq_t.*
            ELSE
               CALL g_ltq.deleteElement(l_ac)
            END IF
            CLOSE i661_bcl
            ROLLBACK WORK
         END IF 
         IF l_flag = '2' THEN
            IF p_cmd='u' THEN
               LET g_ltr[l_ac1].* = g_ltr_t.*
            ELSE
               CALL g_ltr.deleteElement(l_ac1)
            END IF
            CLOSE i661_bcl_1
            ROLLBACK WORK
         END IF 
         EXIT DIALOG    
   END DIALOG
   CLOSE i661_bcl
   CLOSE i661_bcl_1
   COMMIT WORK
   CALL i661_delall()
END FUNCTION

#检查收券规则编号
FUNCTION i661_ltq03(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
DEFINE   l_oba02         LIKE oba_file.oba02

    LET g_errno =''
    CASE g_ltp.ltp06
       WHEN "1"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file
          WHERE ima01=g_ltq[l_ac].ltq03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltq[l_ac].ltq03_desc=l_ima02
             DISPLAY g_ltq[l_ac].ltq03_desc TO ltq03_desc
          END IF
       WHEN "2"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
            FROM oba_file
           WHERE oba01=g_ltq[l_ac].ltq03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltq[l_ac].ltq03_desc=l_oba02
             DISPLAY g_ltq[l_ac].ltq03_desc TO ltq03_desc
          END IF
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file
          WHERE tqa01=g_ltq[l_ac].ltq03 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               #WHEN l_tqa03 !='2'     LET g_errno='alm-828'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltq[l_ac].ltq03_desc=l_tqa02
             DISPLAY g_ltq[l_ac].ltq03_desc TO ltq03_desc 
          END IF
    END CASE

END FUNCTION

#检查排除规则编号
FUNCTION i661_ltr03(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
DEFINE   l_oba02         LIKE oba_file.oba02

    LET g_errno =''
    CASE g_ltp.ltp07
       WHEN "1"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file
          WHERE ima01=g_ltr[l_ac1].ltr03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltr[l_ac1].ltr03_desc=l_ima02
             DISPLAY g_ltr[l_ac1].ltr03_desc TO ltr03_desc
          END IF
       WHEN "2"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
            FROM oba_file
           WHERE oba01=g_ltr[l_ac1].ltr03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltr[l_ac1].ltr03_desc=l_oba02
             DISPLAY g_ltr[l_ac1].ltr03_desc TO ltr03_desc
          END IF
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file
          WHERE tqa01=g_ltr[l_ac1].ltr03 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               #WHEN l_tqa03 !='2'     LET g_errno='alm-828'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltr[l_ac1].ltr03_desc=l_tqa02
             DISPLAY g_ltr[l_ac1].ltr03_desc TO ltr03_desc
          END IF

    END CASE

END FUNCTION


#删除单头、生效范围资料
FUNCTION i661_delall()
   DEFINE l_ltq_cnt LIKE type_file.num5,
          l_ltr_cnt LIKE type_file.num5

   SELECT COUNT(*) INTO l_ltq_cnt FROM ltq_file
    WHERE ltqplant = g_ltp.ltpplant
      AND ltq01 = g_ltp.ltp01
      AND ltq02 = g_ltp.ltp02

   SELECT COUNT(*) INTO l_ltr_cnt FROM ltr_file
    WHERE ltrplant = g_ltp.ltpplant
      AND ltr01 = g_ltp.ltp01
      AND ltr02 = g_ltp.ltp02

   IF l_ltq_cnt =0 AND l_ltr_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED

      DELETE FROM lso_file
            WHERE lso01 = g_ltp.ltp01
              AND lso02 = g_ltp.ltp02
             #AND lso03 = '3'     #FUN-D10117 mark
              AND lso03 = '4'     #FUN-D10117 add
              AND lsoplant = g_ltp.ltpplant

      DELETE FROM ltp_file
            WHERE ltpplant = g_ltp.ltpplant
              AND ltp01 = g_ltp.ltp01
              AND ltp02 = g_ltp.ltp02

      CLEAR FORM
      INITIALIZE g_ltp.* TO NULL

  END IF
END FUNCTION

FUNCTION i661_b_fill(p_wc2)
   DEFINE  p_wc2    STRING

   LET g_sql = "SELECT ltq01,ltq02,ltq03,'',ltqacti ",
               "  FROM ltq_file",
               " WHERE ltqplant = '", g_ltp.ltpplant,"' ",
               "   AND ltq01 = '", g_ltp.ltp01,"' ",
               "   AND ltq02 = '",g_ltp.ltp02,"' "
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltq03 "

   PREPARE i661_pb FROM g_sql
   DECLARE ltq_cs CURSOR FOR i661_pb

   CALL g_ltq.clear()
   LET g_cnt = 1

   FOREACH ltq_cs INTO g_ltq[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #显示收券规则编号说明
       CASE g_ltp.ltp06
          WHEN "1"
             SELECT ima02 INTO g_ltq[g_cnt].ltq03_desc FROM ima_file
              WHERE ima01=g_ltq[g_cnt].ltq03
          WHEN "2"
             SELECT oba02 INTO g_ltq[g_cnt].ltq03_desc
               FROM oba_file
              WHERE oba01=g_ltq[g_cnt].ltq03
          WHEN "3"
             SELECT tqa02 INTO g_ltq[g_cnt].ltq03_desc FROM tqa_file
              WHERE tqa01=g_ltq[g_cnt].ltq03 AND tqa03='2'
       END CASE
       DISPLAY g_ltq[g_cnt].ltq03_desc TO ltq03_desc
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b=g_cnt-1
   CALL g_ltq.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION

FUNCTION i661_b1_fill(p_wc2)
   DEFINE p_wc2   STRING

   LET g_sql = "SELECT ltr01,ltr02,ltr03,'',ltracti ",
               "  FROM ltr_file ",
               " WHERE ltrplant = '",g_ltp.ltpplant,"' ",
               "   AND ltr01 = '",g_ltp.ltp01,"' ",
               "   AND ltr02 = '",g_ltp.ltp02,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltr03 "

   DISPLAY g_sql

   PREPARE i661_pb_1 FROM g_sql
   DECLARE ltr_cs CURSOR FOR i661_pb_1

   CALL g_ltr.clear()
   LET g_cnt = 1

   FOREACH ltr_cs INTO g_ltr[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #显示排除规则编号说明
       CASE g_ltp.ltp07
          WHEN "1"
             SELECT ima02 INTO g_ltr[g_cnt].ltr03_desc FROM ima_file
              WHERE ima01=g_ltr[g_cnt].ltr03
          WHEN "2"
             SELECT oba02 INTO g_ltr[g_cnt].ltr03_desc
               FROM oba_file
              WHERE oba01=g_ltr[g_cnt].ltr03
          WHEN "3"
             SELECT tqa02 INTO g_ltr[g_cnt].ltr03_desc FROM tqa_file
              WHERE tqa01=g_ltr[g_cnt].ltr03 AND tqa03='2'
       END CASE
       DISPLAY g_ltr[g_cnt].ltr03_desc TO ltr03_desc
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b1=g_cnt-1
   CALL g_ltr.deleteElement(g_cnt)
   DISPLAY g_rec_b1 TO FORMONLY.cn3
END FUNCTION

#开启栏位
FUNCTION i661_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ltp02",TRUE)
   END IF
END FUNCTION

#关闭栏位
FUNCTION i661_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ltp02",FALSE)
   END IF

END FUNCTION


#审核前检查
FUNCTION i661_msg(p_cmd)
   DEFINE p_cmd LIKE type_file.chr30

   IF cl_null(g_ltp.ltp01) THEN
      LET g_errno = '-400'
      RETURN
   END IF

   IF p_cmd <> 'eff_plant' AND p_cmd <> 'x' AND p_cmd <> 'del' THEN
      #目前鎖在營運中心不是制定營運中心,不可修改
      IF g_ltp.ltp01 <> g_plant THEN
         LET g_errno = 'art-977'
         RETURN
      END IF
      #资料无效不可异动
      IF g_ltp.ltpacti = 'N' THEN 
         LET g_errno = 'alm1067'
         RETURN
      END IF 
      #已發佈,不可修改
      IF g_ltp.ltp11 = 'Y' THEN
         LET g_errno = 'alm-h55'
         RETURN
      END IF
   END IF
   #已確認
   IF p_cmd = 'conf' THEN
      IF g_ltp.ltpconf ='Y' THEN
         LET g_errno = '1208'
         RETURN
      END IF
   END IF

   #取消审核
   IF p_cmd = 'unconf' THEN
      #資料無效,不可取消確認
      IF g_ltp.ltpacti='N' THEN
         LET g_errno = 'alm-973'
         RETURN
      END IF
      #尚未確認,不可取消確認
      IF g_ltp.ltpconf ='N' THEN
         LET g_errno = '9025'
         RETURN
      END IF
   END IF
   #已發佈
   IF p_cmd = 'release' THEN
      IF g_ltp.ltp11 = 'Y' THEN
         LET g_errno = 'alm-h63'
         RETURN
      END IF
      #資料無效,不可發佈
      IF g_ltp.ltpacti = 'N' THEN
         LET g_errno = 'alm-h60'
         RETURN
      END IF
      #資料未確定,不可發佈
      IF g_ltp.ltpconf = 'N' THEN
         LET g_errno = 'alm-h64'
         RETURN
      END IF
   END IF
   
   #修改
   IF p_cmd = 'mod' OR p_cmd = 'x' AND p_cmd = 'del' THEN
      #已發佈時不允許修改
      IF g_ltp.ltp11 = 'Y' THEN
         LET g_errno = 'alm-h55'
         RETURN
      END IF
      #已確認時不允許修改
      IF g_ltp.ltpconf = 'Y' THEN
         LET g_errno = 'alm-027'
         RETURN
      END IF
   END IF

   LET g_errno = NULL
END FUNCTION

#审核
FUNCTION i661_conf()
          #计数器
   DEFINE l_cnt     LIKE type_file.num5,
          #审核人名称
          l_gen02   LIKE gen_file.gen02

   CALL i661_msg('conf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_ltp.ltp01
      AND lso02 = g_ltp.ltp02
     #AND lso03 = '3'           #FUN-D10117 mark
      AND lso03 = '4'           #FUN-D10117 add
   IF l_cnt = 0 THEN
      CALL cl_err('','art-546',0)
      RETURN
   END IF

   CALL i661_ckmult()
   IF g_success = 'N' THEN RETURN END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_ltp.ltp01
      AND lso02 = g_ltp.ltp02
     #AND lso03 = '3'          #FUN-D10117 mark
      AND lso03 = '4'           #FUN-D10117 add
      AND lso04 NOT IN (SELECT lnk03 FROM lnk_file
                         WHERE lnk01 = g_ltp.ltp03
                           AND lnk02 = '2'
                           AND lnk05 = 'Y' )

   IF l_cnt > 0 THEN
      CALL cl_err('','alm1641',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_ltp.ltp01
      AND lso02 = g_ltp.ltp02
     #AND lso03 = '3'       #FUN-D10117 mark
      AND lso03 = '4'           #FUN-D10117 add
      AND lso04 = g_ltp.ltpplant
      AND lsoplant = g_ltp.ltpplant

   IF l_cnt = 0 THEN
      CALL cl_err('','alm-h42',0)
      RETURN
   END IF

   LET g_action_choice = ""
   LET g_ltp.ltpcont = TIME
   UPDATE ltp_file
      SET ltpcond = g_today,
          ltpcont = g_ltp.ltpcont,
          ltpconf = 'Y',
          ltpconu = g_user,
          ltpuser = g_user,
          ltpdate = g_today,
          ltpmodu = g_user
    WHERE ltpplant = g_ltp.ltpplant
      AND ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02

    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ltp_file",g_ltp.ltp01,"",SQLCA.sqlcode,"","ltpplant",1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       LET g_ltp.ltpcond = g_today
       LET g_ltp.ltpconf = 'Y'
       LET g_ltp.ltpconu = g_user
       LET g_ltp.ltpdate = g_today
       LET g_ltp.ltpmodu = g_user
       LET g_ltp.ltpuser = g_user
       DISPLAY BY NAME g_ltp.ltpcond,g_ltp.ltpcont,g_ltp.ltpconf,g_ltp.ltpconu,g_ltp.ltpdate,g_ltp.ltpmodu,g_ltp.ltpuser
       SELECT gen02 INTO l_gen02 
         FROM gen_file
        WHERE gen01 = g_ltp.ltpconu
       DISPLAY l_gen02 TO gen02
      #圖形顯示
      CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
   END IF

END FUNCTION

#取消审核
FUNCTION i661_unconf()
          #计数器
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_gen02   LIKE gen_file.gen02  #CHI-D20015

   #取消审核检查
   CALL i661_msg('unconf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   IF cl_confirm('aap-224') THEN
      BEGIN WORK
      #UPDATE ltp_file SET ltpcond = null,   #CHI-D20015 mark
      UPDATE ltp_file SET ltpcond = g_today, #CHI-D20015 add
                          ltpcont = null,
                          ltpconf = 'N',
			  #ltpconu = NULL,   #CHI-D20015 mark
                          ltpconu = g_user,  #CHI-D20015 add
                          ltpdate = g_today,
                          ltpmodu = g_user
       WHERE ltpplant = g_ltp.ltpplant
         AND ltp01 = g_ltp.ltp01
         AND ltp02 = g_ltp.ltp02

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ltp_file",g_ltp.ltp01,"",SQLCA.sqlcode,"","ltpplant",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK

         #LET g_ltp.ltpcond = null   #CHI-D20015
         LET g_ltp.ltpcond = g_today #CHI-D20015
         LET g_ltp.ltpcont = null
         LET g_ltp.ltpconf = 'N'
         #LET g_ltp.ltpconu = NULL   #CHI-D20015
         LET g_ltp.ltpconu = g_user  #CHI-D20015
         LET g_ltp.ltpdate = g_today
         LET g_ltp.ltpmodu = g_user
         DISPLAY BY NAME g_ltp.ltpcond,g_ltp.ltpcont,g_ltp.ltpconf,g_ltp.ltpconu,g_ltp.ltpdate,g_ltp.ltpmodu
         #CHI-D20015--modify--str-- 
         #DISPLAY '' TO gen02
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ltp.ltpconu 
         DISPLAY l_gen02 TO gen02
         #CHI-D20015--modify--end-- 
         #圖形顯示
         CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
      END IF
   END IF

END FUNCTION

#生效营运中心
FUNCTION i661_eff_plant()
   CALL i661_msg('eff_plant')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""
   #开启生效营运中心画面进行维护
  #CALL i555_sub(g_ltp.ltp01,g_ltp.ltp02,'3',g_ltp.ltp03)     #FUN-D10117 mark
   CALL i555_sub(g_ltp.ltp01,g_ltp.ltp02,'4',g_ltp.ltp03)     #FUN-D10117 add
END FUNCTION

#无效
FUNCTION i661_x()
   DEFINE l_cnt LIKE type_file.num5,
          l_upd LIKE type_file.chr1

   LET l_cnt = 0
   LET l_upd = null

   IF s_shut(0) THEN
      RETURN
   END IF
   #无效前检查
   CALL i661_msg('x')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   BEGIN WORK
   OPEN i661_cl USING g_ltp.ltp01,g_ltp.ltp02,g_ltp.ltpplant
   IF STATUS THEN
      CALL cl_err("OPEN ltp_cl:", STATUS, 1)
      CLOSE i661_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i661_cl INTO g_ltp.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ltp.ltp01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL i661_show()

   IF cl_exp(0,0,g_ltp.ltpacti) THEN
      LET g_chr=g_ltp.ltpacti
      IF g_ltp.ltpacti='Y' THEN
         LET g_ltp.ltpacti = 'N'
         LET g_ltp.ltpmodu = g_user
      ELSE
         LET g_ltp.ltpacti = 'Y'
         LET g_ltp.ltpmodu = g_user
      END IF

      UPDATE ltp_file SET ltpacti=g_ltp.ltpacti,
                          ltpmodu=g_ltp.ltpmodu,
                          ltpdate=g_today
       WHERE ltpplant = g_ltp.ltpplant
         AND ltp01 = g_ltp.ltp01
         AND ltp02 = g_ltp.ltp02

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ltp_file",g_ltp.ltp01,"",SQLCA.sqlcode,"","",1)
         LET g_ltp.ltpacti=g_chr
      END IF
   END IF

   CLOSE i661_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT ltpacti,ltpmodu,ltpdate
     INTO g_ltp.ltpacti,g_ltp.ltpmodu,g_ltp.ltpdate 
     FROM ltp_file
    WHERE ltpplant = g_ltp.ltpplant
      AND ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02

   DISPLAY BY NAME g_ltp.ltpmodu,g_ltp.ltpdate,g_ltp.ltpacti
   #圖形顯示
   CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)

END FUNCTION

#判断生效营运中心是否已经存在单号且生效营运中心是否符合券种的生效范围
FUNCTION i661_ckmult()
   DEFINE l_sql        STRING,
          #生效营运中心
          l_lso04      LIKE lso_file.lso04,
          #计数器
          l_cnt        LIKE type_file.num5

   LET g_success = 'Y'
   #判断生效营运中心是否含有上级营运中心
   LET l_sql = " SELECT COUNT(*) ", 
               "   FROM lso_file ",
               "   WHERE lso01 = '",g_ltp.ltp01,"'",
               "     AND lso02 = '",g_ltp.ltp02,"'",
               "     AND lso04 NOT IN ",g_auth
   PREPARE sel_lso04 FROM l_sql
   EXECUTE sel_lso04 INTO l_cnt  
   IF l_cnt > 0 THEN 
      LET g_success = 'N'
      CALL cl_err('','alm1644',0)
      RETURN
   END IF 
   CALL s_showmsg_init()
   #抓取符合当前制定营运中心+规则单号的生效营运中心
   LET l_sql = "SELECT DISTINCT lso04 FROM lso_file  ",
               "  WHERE lso01 = '",g_ltp.ltp01,"' ",
               "    AND lso02 = '",g_ltp.ltp02,"' AND lso07 = 'Y' "
   PREPARE lso_pre3 FROM l_sql
   DECLARE lso_cs3 CURSOR FOR lso_pre3
   FOREACH lso_cs3 INTO l_lso04

      IF cl_null(l_lso04) THEN EXIT FOREACH END IF
      LET l_cnt = 0
      #判斷其他生效營運中心是否已存在单号
      IF NOT cl_null(g_ltp.ltp04) AND NOT cl_null(g_ltp.ltp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'ltp_file'),
                     "   WHERE ltp11 = 'Y' AND ltpconf = 'Y' ",
                     "     AND ltpacti = 'Y' AND ltp03 = '",g_ltp.ltp03,"' ",
                     "     AND (ltp04 BETWEEN '",g_ltp.ltp04,"' AND '",g_ltp.ltp05,"' ",
                     "      OR  ltp05 BETWEEN '",g_ltp.ltp04,"' AND '",g_ltp.ltp05,"' ",
                     "      OR (ltp04 <= '",g_ltp.ltp04,"' AND ltp05 >= '",g_ltp.ltp05,"'))"
      END IF

      IF NOT cl_null(g_ltp.ltp04) AND cl_null(g_ltp.ltp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'ltp_file'),
                     "   WHERE ltp11 = 'Y' AND ltpconf = 'Y' ",
                     "     AND ltpacti = 'Y' AND ltp03 = '",g_ltp.ltp03,"' ",
                     "     AND ltp04 >= '",g_ltp.ltp04,"' ",
                     "     AND ltp05 <= '",g_ltp.ltp04,"' "
      END IF

      IF cl_null(g_ltp.ltp04) AND NOT cl_null(g_ltp.ltp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'ltp_file'),
                     "   WHERE ltp11 = 'Y' AND ltpconf = 'Y' ",
                     "     AND ltpacti = 'Y' AND ltp03 = '",g_ltp.ltp03,"' ",
                     "     AND ltp04 <= '",g_ltp.ltp05,"' ",
                     "     AND ltp05 >= '",g_ltp.ltp05,"' "
      END IF

      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('lso04',l_lso04,l_lso04,'alm1642',1)
         LET g_success = 'N'
      END IF
      #判斷營運中心是否符合券種生效營運中心
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_ltp.ltp03,"'  AND lnk02 = '2' AND lnk05 = 'Y' ",
                  "     AND lnk03 = '",l_lso04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_lso04 ) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt

      IF l_cnt = 0 OR cl_null(l_cnt) THEN
         CALL s_errmsg('lso04',l_lso04,l_lso04,'alm1643',1)
         LET g_success = 'N'
      END IF
   END FOREACH

   CALL s_showmsg()
END FUNCTION

#发布
FUNCTION i661_release()
   DEFINE l_lso04                             LIKE lso_file.lso04,
          l_azw02                             LIKE azw_file.azw02,
          l_sql                               STRING,
          l_ltp    RECORD                     LIKE ltp_file.*,
          l_ltq    DYNAMIC ARRAY OF RECORD    LIKE ltq_file.*,
          l_ltr    DYNAMIC ARRAY OF RECORD    LIKE ltr_file.*,
          l_lso    DYNAMIC ARRAY OF RECORD    LIKE lso_file.*,
          l_cnt                               LIKE type_file.num5,
          l_max_rec                           LIKE type_file.num5,
          l_rec                               LIKE type_file.num5

   CALL i661_msg('release')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   CALL i661_ckmult()
   IF g_success = 'N' THEN RETURN END IF

   IF NOT cl_confirm('art-660') THEN
      RETURN
   END IF

   LET g_action_choice = ""
   LET g_success = 'Y'
   
   LET l_sql = "SELECT lso04 FROM lso_file WHERE lso01 = '",g_ltp.ltp01 CLIPPED,"' ",
               "   AND lso02 = '",g_ltp.ltp02 CLIPPED,"' " ,
               "   AND lso07 = 'Y'"

   PREPARE lso_pre1 FROM l_sql
   DECLARE lso_cs1 CURSOR FOR lso_pre1

   SELECT * INTO l_ltp.* FROM ltp_file
    WHERE ltpplant = g_ltp.ltpplant
      AND ltp01 = g_ltp.ltp01
      AND ltp02 = g_ltp.ltp02

   #初始化报错信息
   CALL s_showmsg_init()
   BEGIN WORK
   #生效营运中心
   FOREACH lso_cs1 INTO l_lso04
      IF cl_null(l_lso04) THEN
         EXIT FOREACH
      END IF
      DISPLAY 'Effective Plant: ',l_lso04

      SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_lso04

      IF g_success = 'Y' AND l_ltp.ltpplant <> l_lso04 THEN
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltp_file'),
                     "            (ltp01,ltp02,ltp021,ltp03,ltp04,ltp05,ltp06,ltp07,ltp08,ltp09,ltp10,",
                     "             ltp11,ltp12,ltppos,ltpacti,ltpcond,ltpcont,ltpconf,ltpconu,ltpcrat,ltpdate,ltpgrup,",
                     "             ltplegal,ltpmodu,ltporig,ltporiu,ltpplant,ltpuser)",
                     "  VALUES ('",l_ltp.ltp01,"','",l_ltp.ltp02,"','",l_ltp.ltp021,"','",l_ltp.ltp03,"','",l_ltp.ltp04,"',",
                     "          '",l_ltp.ltp05,"','",l_ltp.ltp06,"','",l_ltp.ltp07,"',",
                     "          '",l_ltp.ltp08,"','",l_ltp.ltp09,"','",l_ltp.ltp10,"','Y','",g_today,"',",
                     "          '",l_ltp.ltppos,"','",l_ltp.ltpacti,"','",l_ltp.ltpcond,"','",l_ltp.ltpcont,"','",l_ltp.ltpconf,"',",
                     "          '",l_ltp.ltpconu,"','",l_ltp.ltpcrat,"','",l_ltp.ltpdate,"','",l_ltp.ltpgrup,"','",l_azw02,"',",
                     "          '",l_ltp.ltpmodu,"','",l_ltp.ltporig,"','",l_ltp.ltporiu,"','",l_lso04,"','",l_ltp.ltpuser,"')"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
         PREPARE trans_ins_ltp FROM l_sql
         EXECUTE trans_ins_ltp
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg('','','INSERT INTO ltp_file:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         DISPLAY 'Insert: ltp_file: ',l_ltp.ltp01,' for plant:  ',l_lso04

         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec 
              FROM ltq_file 
             WHERE ltqplant = g_ltp.ltpplant 
               AND ltq01 = g_ltp.ltp01 
               AND ltq02 = g_ltp.ltp02
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_ltp.ltpplant, 'ltq_file'),
                        " WHERE ltqplant = '",l_ltp.ltpplant,"' ",
                        "  AND ltq01 = '",l_ltp.ltp01,"' ",
                        "  AND ltq02 = '",l_ltp.ltp02,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
            PREPARE ltq_sur FROM l_sql
            DECLARE ltq_ins_sur CURSOR FOR ltq_sur
            FOREACH ltq_ins_sur INTO l_ltq[l_rec].*
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltq_file'),
                           "           (ltq01,ltq02,ltq03,ltqacti,ltqlegal,ltqplant)",
                           "     values('",l_ltq[l_rec].ltq01,"','",l_ltq[l_rec].ltq02,"','",l_ltq[l_rec].ltq03,"',",
                           "            '",l_ltq[l_rec].ltqacti,"','",l_azw02,"','",l_lso04,"' )"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
               PREPARE trans_ins_ltq FROM l_sql
               EXECUTE trans_ins_ltq
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO ltq_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: ltq_file: ',l_ltq[l_rec].ltq01,' for plant:  ',l_lso04
               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec 
              FROM ltr_file 
             WHERE ltrplant = g_ltp.ltpplant
               AND ltr01 = g_ltp.ltp01 
               AND ltr02 = g_ltp.ltp02
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_ltp.ltpplant, 'ltr_file'),
                        " WHERE ltrplant = '",g_ltp.ltpplant,"' ",
                        "   AND ltr01 = '",g_ltp.ltp01,"' ",
                        "   AND ltr02 = '",g_ltp.ltp02,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
            PREPARE ltr_sur FROM l_sql
            DECLARE ltr_ins_sur CURSOR FOR ltr_sur
            FOREACH ltr_ins_sur INTO l_ltr[l_rec].*
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltr_file'),
                           "           (ltr01,ltr02,ltr03,ltracti,ltrlegal,ltrplant)",
                           "     VALUES('",l_ltr[l_rec].ltr01,"','",l_ltr[l_rec].ltr02,"','",l_ltr[l_rec].ltr03,"','",l_ltr[l_rec].ltracti,"',",
                           "            '",l_azw02,"','",l_lso04,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
               PREPARE trans_ins_ltr FROM l_sql
               EXECUTE trans_ins_ltr
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO ltr_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: ltr_file: ',l_ltr[l_rec].ltr01,' for plant:  ',l_lso04

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
           END FOREACH
         END IF
      END IF 
      #收券規則生效營運中心
      IF g_success = 'Y' THEN
         SELECT COUNT(*) INTO l_max_rec FROM lso_file WHERE lso01 = l_ltp.ltp01 AND lso02 = l_ltp.ltp02 AND lsoplant = l_ltp.ltpplant
         LET l_rec = 1
         LET l_sql = "SELECT * FROM ",cl_get_target_table(l_ltp.ltpplant, 'lso_file'),
                     " WHERE lso01 = '",l_ltp.ltp01,"' ",
                     "   AND lso02 = '",l_ltp.ltp02,"' ",
                     "   AND lsoplant = '", l_ltp.ltpplant,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_ltp.ltpplant) RETURNING l_sql
         PREPARE lso_sur FROM l_sql
         DECLARE lso_ins_sur CURSOR FOR lso_sur
         FOREACH lso_ins_sur INTO l_lso[l_rec].*
            IF g_success = 'Y' AND l_lso[l_rec].lsoplant <> l_lso04 THEN
               #收券規則生效營運中心檔
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lso_file'),
                           "           (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)",
                           "     VALUES('",l_lso[l_rec].lso01,"','",l_lso[l_rec].lso02,"','",l_lso[l_rec].lso03,"','",l_lso[l_rec].lso04,"',",
                           "            '",l_lso[l_rec].lso05,"','",l_lso[l_rec].lso06,"','",l_lso[l_rec].lso07,"','",l_azw02,"','",l_lso04,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
               PREPARE trans_ins_lso FROM l_sql
               EXECUTE trans_ins_lso
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO lso_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: lso_file: ',l_lso[l_rec].lso03,' for plant:  ',l_lso04
            END IF

            IF g_success = 'Y' THEN
               #收券規則生效營運中心變更檔
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltn_file'),
                           "      (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)",
                           "values('",l_lso[l_rec].lso01,"','",l_lso[l_rec].lso02,"','",l_lso[l_rec].lso03,"','",l_lso[l_rec].lso04,"',",
                           "       '",l_lso[l_rec].lso05,"','",l_lso[l_rec].lso06,"','",l_lso[l_rec].lso07,"',0,'",l_azw02,"','",l_lso04,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
               PREPARE trans_ins_ltn FROM l_sql
               EXECUTE trans_ins_ltn
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: ltn_file: ',l_lso[l_rec].lso03,' for plant:  ',l_lso04
            END IF

            IF l_rec = l_max_rec THEN
               EXIT FOREACH
            ELSE
               IF g_success = 'Y' THEN 
                  LET l_rec = l_rec + 1
               END IF
            END IF
         END FOREACH
      END IF   
      IF g_success = 'Y' THEN
         #新增一笔0版本资料到almt661
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lts_file'), 
                     "            (lts01,lts02,lts021,lts03,lts04,lts05,lts06,lts07,lts08,lts09,lts10,",
                     "             lts11,lts12,ltsacti,ltscond,ltscont,ltsconf,ltsconu,ltscrat,ltsdate,ltsgrup,",
                     "             ltslegal,ltsmodu,ltsorig,ltsoriu,ltsplant,ltsuser)",
                     "   VALUES('",l_ltp.ltp01,"','",l_ltp.ltp02,"',0,'",l_ltp.ltp03,"','",l_ltp.ltp04,"',",
                     "          '",l_ltp.ltp05,"','",l_ltp.ltp06,"','",l_ltp.ltp07,"',",
                     "          '",l_ltp.ltp08,"','",l_ltp.ltp09,"','",l_ltp.ltp10,"','Y','",g_today,"',",
                     "          '",l_ltp.ltpacti,"','",l_ltp.ltpcond,"','",l_ltp.ltpcont,"','",l_ltp.ltpconf,"',",
                     "          '",l_ltp.ltpconu,"','",l_ltp.ltpcrat,"','",l_ltp.ltpdate,"','",l_ltp.ltpgrup,"','",l_azw02,"',",
                     "          '",l_ltp.ltpmodu,"','",l_ltp.ltporig,"','",l_ltp.ltporiu,"','",l_lso04,"','",l_ltp.ltpuser,"')"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
         PREPARE trans_ins_lts FROM l_sql
         EXECUTE trans_ins_lts
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg('','','INSERT INTO lts_file:',SQLCA.sqlcode,1)
         END IF
         DISPLAY 'Insert: lts_file: ',l_ltp.ltp01,' for plant:  ',l_lso04
         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec
              FROM ltq_file
             WHERE ltqplant = l_ltp.ltpplant
               AND ltq01 = l_ltp.ltp01
               AND ltq02 = l_ltp.ltp02
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ltq_file ",
                        " WHERE ltqplant = '",l_ltp.ltpplant,"' ",
                        "  AND ltq01 = '",l_ltp.ltp01,"' ",
                        "  AND ltq02 = '",l_ltp.ltp02,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
            PREPARE ltq_sur_1 FROM l_sql
            DECLARE ltq_ins_sur_1 CURSOR FOR ltq_sur_1
            FOREACH ltq_ins_sur_1 INTO l_ltq[l_rec].*
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltt_file'), 
                           "           (ltt01,ltt02,ltt021,ltt03,lttacti,lttlegal,lttplant)",
                           "     values('",l_ltq[l_rec].ltq01,"','",l_ltq[l_rec].ltq02,"',0,'",l_ltq[l_rec].ltq03,"',",
                           "            '",l_ltq[l_rec].ltqacti,"','",l_azw02,"','",l_lso04,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_ltp.ltpplant) RETURNING l_sql
               PREPARE trans_ins_ltt FROM l_sql
               EXECUTE trans_ins_ltt
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO ltt_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: ltt_file: ',l_ltq[l_rec].ltq01,' for plant:  ',l_ltp.ltpplant
               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec
              FROM ltr_file
             WHERE ltrplant = l_ltp.ltpplant
               AND ltr01 = l_ltp.ltp01
               AND ltr02 = l_ltp.ltp02
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ltr_file",
                        " WHERE ltrplant = '",l_ltp.ltpplant,"' ",
                        "   AND ltr01 = '",l_ltp.ltp01,"' ",
                        "   AND ltr02 = '",l_ltp.ltp02,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
            PREPARE ltr_sur_1 FROM l_sql
            DECLARE ltr_ins_sur_1 CURSOR FOR ltr_sur_1
            FOREACH ltr_ins_sur_1 INTO l_ltr[l_rec].*
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltu_file'), 
                           "           (ltu01,ltu02,ltu021,ltu03,ltuacti,ltulegal,ltuplant)",
                           "     VALUES('",l_ltr[l_rec].ltr01,"','",l_ltr[l_rec].ltr02,"',0,'",l_ltr[l_rec].ltr03,"','",l_ltr[l_rec].ltracti,"',",
                           "            '",l_azw02,"','",l_lso04,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, g_ltp.ltpplant) RETURNING l_sql
               PREPARE trans_ins_ltu FROM l_sql
               EXECUTE trans_ins_ltu
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','INSERT INTO ltu_file:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               DISPLAY 'Insert: ltu_file: ',l_ltr[l_rec].ltr01,' for plant:  ',l_ltp.ltpplant

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE ltp_file
         SET ltp11 = 'Y',
             ltp12 = g_today,
             ltpmodu = g_user,
             ltpdate = g_today
       WHERE ltpplant = g_ltp.ltpplant
         AND ltp01 = g_ltp.ltp01
         AND ltp02 = g_ltp.ltp02
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','UPDATE ltp_file:',SQLCA.sqlcode,1)
      END IF
   END IF
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_ltp.ltp11 = 'Y'
      LET g_ltp.ltp12 = g_today
      LET g_ltp.ltpmodu = g_user
      LET g_ltp.ltpdate = g_today
      DISPLAY BY NAME g_ltp.ltp11
      DISPLAY BY NAME g_ltp.ltp12
      DISPLAY BY NAME g_ltp.ltpmodu
      DISPLAY BY NAME g_ltp.ltpdate
      #圖形顯示
      CALL cl_set_field_pic(g_ltp.ltpconf,"","","",'',g_ltp.ltpacti)
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF
END FUNCTION

#FUN-CB0025


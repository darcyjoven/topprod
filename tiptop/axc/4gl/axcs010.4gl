# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axcs010.4gl
# Descriptions...: 成會系統參數設定
# Date & Author..: 94/12/12 By Nick
# Modify.........: 95/02/24 By Danny
# Modify.........: 96/12/06 By Star add field cczuser,cczuser,cczgrup..
# Modify.........: 01/06/27 By Ostrich add field ccz08,ccz09
# Modify.........: 02/12/18 By Wiky add field ccz10,ccz11,ccz12 
# Modify.........: 03/05/14 By Jiunn (No.7268)
#                  新增聯產品分攤基準(ccz13)
# Modify.........: No.FUN-510041 05/01/24 By Carol 新增成本拋轉傳票功能 -- add ccz14 - ccz25 
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660174 06/06/26 By Sarah 增加欄位ccz26(成本計算庫存金額小數位數)
# Modify.........: No.FUN-680086 06/08/24 By Xufeng  兩帳套內容新增              
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/04 By kim 增加成本報表數量印出小數位數ccz27
# Modify.........: No.FUN-730057 07/03/30 By bnlent 會計科目加帳套
# Modify.........: No.TQC-790064 07/09/17 By destiny 營運中心編號和帳套編號該為開窗查詢
#                                                    修改"總帳管理系統使用帳套編號"沒有控管的BUG
#                                                    修改"現行成本結算月份"可以錄入負數的BUG 
# Modify.........: No.FUN-7C0101 08/01/14 By douzh   成本改善增加ccz28(成本計算類別)
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-930164 09/04/15 By jamie update ccz01ORccz02成功時，寫入azo_file
# Modify.........: No.TQC-970138 09/07/20 By xiaofeizhu 新增欄位ccz231
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-970017 09/11/03 By jan新增制費二--制費五的相關欄位
# Modify.........: No:CHI-980045 10/03/09 By kim 銷退成本視參數設定列入庫成本
# Modify.........: No:FUN-B10052 11/01/28 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/05 By xianghui 增加自訂欄位
# Modify.........: No.FUN-CC0002 12/12/03 By xujing   增加參數"當站報廢轉出方式"
# Modify.........: No.FUN-CB0120 12/12/28 By wangrr 增加委外加工相關欄位ccz43,ccz44,ccz441
# Modify.........: No.FUN-BC0062 13/02/17 By xujing 增加ccz28_6 :移動加權平均成本
# Modify.........: No.TQC-D20011 13/02/18 By wangrr 檔未勾選委外加工時委外加工科目清空
# Modify.........: No.TQC-D40012 13/04/02 By xujing 拿掉FUN-BC0062中部分對axcs010的ccc28='6'的控管
# Modify.........: No.FUN-D60091 13/06/25 By lixh1 如果當前成本計算方式是'6',在修改為其他值時,如果cfa_file有資料,则不允許修改
# Modify.........: No.FUN-D70101 13/07/22 By lixh1 1:只有業態是流通零售(azw04='2')選項'6'才可顯示并可選,否則隱藏起來
#                                                  2:當選擇'6'時給予提示

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
        g_ccz_t              RECORD LIKE ccz_file.*,  # 預留參數檔
        g_ccz_o              RECORD LIKE ccz_file.*   # 預留參數檔
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE  g_cnt                LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE  g_flag               LIKE type_file.chr1      #No.FUN-730057
DEFINE  g_bookno1            LIKE aza_file.aza81      #No.FUN-730057
DEFINE  g_bookno2            LIKE aza_file.aza82      #No.FUN-730057
DEFINE  g_msg                LIKE type_file.chr1000   #FUN-930164 add
DEFINE  g_msg2               LIKE type_file.chr1000   #FUN-930164 add
DEFINE  g_flag_01            LIKE type_file.chr1      #FUN-930164 add
 
MAIN
#   DEFINE l_time LIKE type_file.chr8          #No.FUN-6A0146
    DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-680122 smallint
   #DEFINE l_ccz28_target   ui.ComboBox 
  #FUN-D70101 -----Begin-----
    DEFINE lw_win   ui.Window
    DEFINE lf_form  ui.Form
    DEFINE ln_v6,lnode_group om.DomNode
  #FUN-D70101 -----End-------

    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    SELECT * FROM ccz_file WHERE ccz00='0'
    IF STATUS=100 THEN INSERT INTO ccz_file(ccz00,cczoriu,cczorig) VALUES(0, g_user, g_grup) END IF      #No.FUN-980030 10/01/04  insert columns oriu, orig
    #No.FUN-730057  --Begin
    CALL s_get_bookno(g_ccz.ccz01) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(g_ccz.ccz01,'aoo-081',1)
    END IF
    IF g_bookno1 != g_ccz.ccz12 OR g_bookno2 != g_ccz.ccz121 THEN
       CALL cl_err('','axc-531',0)
    END IF
    #No.FUN-730057  --End

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    OPEN WINDOW s010_w AT p_row,p_col
    WITH FORM "axc/42f/axcs010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #FUN-680086   --Begin--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("page03",FALSE)
       CALL cl_set_comp_visible("ccz121",FALSE)
    END IF
    #FUN-680086   --End--

  #FUN-D70101 ------Begin------
    IF g_azw.azw04 <> '2' THEN
       LET lw_win = ui.Window.getCurrent()
       LET lf_form = lw_win.getForm()
       LET lnode_group = lw_win.findNode("Group",'group12')
       LET lnode_group = lnode_group.getFirstChild()
       LET lnode_group = lnode_group.getFirstChild()
       LET ln_v6 = lnode_group.getLastChild()
       CALL lnode_group.removeChild(ln_v6)
    END IF
  #FUN-D70101 ------End--------
 
    CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s010_show()
  DEFINE l_aag02   LIKE aag_file.aag02
 
    LET g_ccz_t.* = g_ccz.*
    LET g_ccz_o.* = g_ccz.*
    DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz03,
                    g_ccz.ccz04,g_ccz.ccz05,g_ccz.ccz06,g_ccz.ccz07,
                    g_ccz.ccz08,g_ccz.ccz09,g_ccz.ccz10,g_ccz.ccz11,g_ccz.ccz12,
                    g_ccz.ccz13,
                    g_ccz.ccz31,g_ccz.ccz32,   #CHI-980045
                    g_ccz.cczuser,g_ccz.cczgrup,g_ccz.cczmodu,
                    g_ccz.cczdate, 
#FUN-510041 add
                    g_ccz.ccz14, 
                    g_ccz.ccz15, 
                    g_ccz.ccz16, 
                    g_ccz.ccz17, 
                    g_ccz.ccz18, 
                    g_ccz.ccz19, 
                    g_ccz.ccz20, 
                    g_ccz.ccz21, 
                    g_ccz.ccz22, 
                    g_ccz.ccz23, 
                    g_ccz.ccz24, 
                    g_ccz.ccz25, 
                    g_ccz.ccz26,   #FUN-660174 add
                    g_ccz.ccz27,   #CHI-690007 add
                    g_ccz.ccz45,        #FUN-CC0002 add
                    g_ccz.ccz28,   #FUN-7C0101 add
                    g_ccz.ccz29,  #FUN-8B0047 
                    g_ccz.ccz291, #FUN-8B0047
                    g_ccz.ccz33,g_ccz.ccz34,g_ccz.ccz35,g_ccz.ccz36,   #CHI-970017
                    g_ccz.ccz37,g_ccz.ccz38,g_ccz.ccz39,g_ccz.ccz40,   #CHI-970017
                    g_ccz.ccz331,g_ccz.ccz341,g_ccz.ccz351,g_ccz.ccz361,   #CHI-970017
                    g_ccz.ccz371,g_ccz.ccz381,g_ccz.ccz391,g_ccz.ccz401,   #CHI-970017
                    #FUN-680086   --Begin--
                    g_ccz.ccz121,
                    g_ccz.ccz141, 
                    g_ccz.ccz151, 
                    g_ccz.ccz161, 
                    g_ccz.ccz171, 
                    g_ccz.ccz181, 
                    g_ccz.ccz191, 
                    g_ccz.ccz201, 
                    g_ccz.ccz211, 
                    g_ccz.ccz221,
                    g_ccz.ccz231,   #TQC-970138 
                    g_ccz.ccz241, 
                    g_ccz.ccz251,
                    g_ccz.ccz43,g_ccz.ccz44,g_ccz.ccz441,  #FUN-CB0120 add
                    g_ccz.cczud01,g_ccz.cczud02,g_ccz.cczud03,g_ccz.cczud04,g_ccz.cczud05,       #FUN-B50039
                    g_ccz.cczud06,g_ccz.cczud07,g_ccz.cczud08,g_ccz.cczud09,g_ccz.cczud10,       #FUN-B50039
                    g_ccz.cczud11,g_ccz.cczud12,g_ccz.cczud13,g_ccz.cczud14,g_ccz.cczud15         #FUN-B50039  
                    #FUN-680086   --End--
    #No.FUN-730057  --Begin
    CALL s_get_bookno(g_ccz.ccz01) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(g_ccz.ccz01,'aoo-081',1)
    END IF
    IF g_bookno1 != g_ccz.ccz12 OR g_bookno2 != g_ccz.ccz121 THEN
       CALL cl_err('','axc-531',0)
    END IF
    #No.FUN-730057  --End
   
    CALL s010_aag02(g_ccz.ccz14,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_14
    CALL s010_aag02(g_ccz.ccz15,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_15
    CALL s010_aag02(g_ccz.ccz16,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_16
    CALL s010_aag02(g_ccz.ccz17,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_17
    CALL s010_aag02(g_ccz.ccz18,g_bookno1) RETURNING l_aag02  #No.FUN-730057 
    DISPLAY l_aag02 TO FORMONLY.aag02_18
    CALL s010_aag02(g_ccz.ccz19,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_19
    CALL s010_aag02(g_ccz.ccz20,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_20
    CALL s010_aag02(g_ccz.ccz21,g_bookno1) RETURNING l_aag02  #No.FUN-730057 
    DISPLAY l_aag02 TO FORMONLY.aag02_21
    CALL s010_aag02(g_ccz.ccz22,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_22
    CALL s010_aag02(g_ccz.ccz24,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_24
    CALL s010_aag02(g_ccz.ccz25,g_bookno1) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_25
 
    CALL s010_aag02(g_ccz.ccz29,g_bookno1) RETURNING l_aag02  #FUN-8B0047
    DISPLAY l_aag02 TO FORMONLY.aag02_23 #FUN-8B0047
    CALL s010_aag02(g_ccz.ccz291,g_bookno2) RETURNING l_aag02  #FUN-8B0047
    DISPLAY l_aag02 TO FORMONLY.aag02_231 #FUN-8B0047
     
    #CHI-970017--begin--add--------------
    CALL s010_aag02(g_ccz.ccz33,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_33
    CALL s010_aag02(g_ccz.ccz34,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_34
    CALL s010_aag02(g_ccz.ccz35,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_35
    CALL s010_aag02(g_ccz.ccz36,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_36
    CALL s010_aag02(g_ccz.ccz37,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_37
    CALL s010_aag02(g_ccz.ccz38,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_38
    CALL s010_aag02(g_ccz.ccz39,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_39
    CALL s010_aag02(g_ccz.ccz40,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_40
    CALL s010_aag02(g_ccz.ccz331,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_331
    CALL s010_aag02(g_ccz.ccz341,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_341
    CALL s010_aag02(g_ccz.ccz351,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_351
    CALL s010_aag02(g_ccz.ccz361,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_361
    CALL s010_aag02(g_ccz.ccz371,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_371
    CALL s010_aag02(g_ccz.ccz381,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_381
    CALL s010_aag02(g_ccz.ccz391,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_391
    CALL s010_aag02(g_ccz.ccz401,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_401
    #CHI-970017--end--add-------------------

    #FUN-680086   --Begin--
    CALL s010_aag02(g_ccz.ccz141,g_bookno2) RETURNING l_aag02 #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_141
    CALL s010_aag02(g_ccz.ccz151,g_bookno2) RETURNING l_aag02 #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_151
    CALL s010_aag02(g_ccz.ccz161,g_bookno2) RETURNING l_aag02 #No.FUN-730057 
    DISPLAY l_aag02 TO FORMONLY.aag02_161
    CALL s010_aag02(g_ccz.ccz171,g_bookno2) RETURNING l_aag02 #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_171
    CALL s010_aag02(g_ccz.ccz181,g_bookno2) RETURNING l_aag02 #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_181
    CALL s010_aag02(g_ccz.ccz191,g_bookno2) RETURNING l_aag02 #No.FUN-730057 
    DISPLAY l_aag02 TO FORMONLY.aag02_191
    CALL s010_aag02(g_ccz.ccz201,g_bookno2) RETURNING l_aag02 #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_201
    CALL s010_aag02(g_ccz.ccz211,g_bookno2) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_211
    CALL s010_aag02(g_ccz.ccz221,g_bookno2) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_221
    CALL s010_aag02(g_ccz.ccz241,g_bookno2) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_241
    CALL s010_aag02(g_ccz.ccz251,g_bookno2) RETURNING l_aag02  #No.FUN-730057
    DISPLAY l_aag02 TO FORMONLY.aag02_251
    #FUN-680086   --End--
    #FUN-CB0120--add--str--
    CALL s010_aag02(g_ccz.ccz44,g_bookno1) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_44
    CALL s010_aag02(g_ccz.ccz441,g_bookno2) RETURNING l_aag02
    DISPLAY l_aag02 TO FORMONLY.aag02_441
    #FUN-CB0120--add--end
    CALL s010_gem02('d')
 
#FUN-510041 end
 
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
       ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL s010_u()
          END IF
    
       ON ACTION help 
          CALL cl_show_help()
    
       ON ACTION locale
          CALL cl_dynamic_locale()
    
       #EXIT MENU
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
    
       ON ACTION CONTROLG
          CALL cl_cmdask()
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
          LET g_action_choice = "exit"
          CONTINUE MENU
    
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice = "exit"
          EXIT MENU
 
 END MENU
END FUNCTION
 
FUNCTION s010_u()
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM ccz_file      ",
                      " WHERE ccz00 = '0' FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ccz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN ccz_curl 
    IF STATUS THEN CALL cl_err('open cursor',STATUS,1) RETURN END IF
    FETCH ccz_curl INTO g_ccz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    CALL s010_show()   #FUN-D60091
    WHILE TRUE
        LET g_ccz.cczuser = g_user
        LET g_ccz.cczgrup = g_grup               #使用者所屬群
        LET g_ccz.cczdate = g_today
        LET g_ccz.cczmodu=g_user                     #修改者
        #CHI-690007....................begin
        IF g_ccz.ccz27 IS NULL THEN
           LET g_ccz.ccz27=0 
           DISPLAY BY NAME g_ccz.ccz27
        END IF
        #CHI-690007....................end
        #FUN-CC0002---add---str---
        IF cl_null(g_ccz.ccz45) THEN
           LET g_ccz.ccz45 = '1'
           DISPLAY BY NAME g_ccz.ccz45
        END IF
        #FUN-CC0002---add---end---
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_ccz.* = g_ccz_t.* CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE ccz_file SET * = g_ccz.* WHERE ccz00='0'
        IF STATUS THEN  
#          CALL cl_err('',STATUS,0)     #No.FUN-660127
           CALL cl_err3("upd","ccz_file","","",STATUS,"","",1)  #No.FUN-660127
           CONTINUE WHILE 
       #FUN-930164---add---str---
        ELSE 
           IF g_flag_01='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_ccz_t.ccz01,'/',g_ccz_t.ccz02,
                          ' new:',g_ccz.ccz01,'/',g_ccz.ccz02
              LET g_msg2= 'ccz01', ',' ,'ccz02'
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980009 add azoplant,azolegal
                 VALUES ('axcs010',g_user,g_today,g_errno,g_msg2,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","axcs010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
       #FUN-930164---add---end---
 
        END IF
        CLOSE ccz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
   DEFINE   l_aza      LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
   DEFINE   l_aag01    LIKE aag_file.aag01
   DEFINE   l_aag02    LIKE aag_file.aag02
  #FUN-BC0062---add---str---
   DEFINE   l_ryz08    LIKE ryz_file.ryz08
  #FUN-BC0062---add---end--- 
   DEFINE   l_cnt      LIKE type_file.num10     #FUN-D60091

   INPUT BY NAME
      g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz03, 
      g_ccz.ccz04,g_ccz.ccz05,g_ccz.ccz06,
      g_ccz.ccz45,    #FUN-CC0002 add
      g_ccz.ccz28,g_ccz.ccz07,                                         #FUN-7C0101 add 
      g_ccz.ccz08,g_ccz.ccz09,g_ccz.ccz26,g_ccz.ccz27,g_ccz.ccz10,g_ccz.ccz11,g_ccz.ccz12,g_ccz.ccz121,    #FUN-680086  #FUN-660174 add ccz26 #CHI-690007 add ccz27 
      g_ccz.ccz13,
      g_ccz.ccz31,g_ccz.ccz32,   #CHI-980045
#FUN-0510041 add
      g_ccz.ccz14, 
      g_ccz.ccz15,  
      g_ccz.ccz33,g_ccz.ccz34,g_ccz.ccz35,g_ccz.ccz36,   #CHI-970017
      g_ccz.ccz16, 
      g_ccz.ccz17, 
      g_ccz.ccz18, 
      g_ccz.ccz19, 
      g_ccz.ccz24, 
      g_ccz.ccz25, 
      g_ccz.ccz20, 
      g_ccz.ccz21, 
      g_ccz.ccz37,g_ccz.ccz38,g_ccz.ccz39,g_ccz.ccz40,   #CHI-970017
      g_ccz.ccz22, 
      g_ccz.ccz23, 
      g_ccz.ccz29, #FUN-8B0047 
#FUN-510041 end
      g_ccz.ccz43,g_ccz.ccz44,   #FUN-CB0120 add
#FUN-680086   --Begin--
      g_ccz.ccz141, 
      g_ccz.ccz151,  
      g_ccz.ccz331,g_ccz.ccz341,g_ccz.ccz351,g_ccz.ccz361,   #CHI-970017
      g_ccz.ccz161, 
      g_ccz.ccz171, 
      g_ccz.ccz181, 
      g_ccz.ccz191, 
      g_ccz.ccz241, 
      g_ccz.ccz251, 
      g_ccz.ccz201, 
      g_ccz.ccz211, 
      g_ccz.ccz371,g_ccz.ccz381,g_ccz.ccz391,g_ccz.ccz401,   #CHI-970017
      g_ccz.ccz221,
      g_ccz.ccz231, #TQC-970138 
      g_ccz.ccz291, #FUN-8B0047
      g_ccz.ccz441, #FUN-CB0120 add
#FUN-680086  --End--
      g_ccz.cczuser,g_ccz.cczgrup,g_ccz.cczmodu,
      g_ccz.cczdate,
      g_ccz.cczud01,g_ccz.cczud02,g_ccz.cczud03,g_ccz.cczud04,g_ccz.cczud05,       #FUN-B50039
      g_ccz.cczud06,g_ccz.cczud07,g_ccz.cczud08,g_ccz.cczud09,g_ccz.cczud10,       #FUN-B50039
      g_ccz.cczud11,g_ccz.cczud12,g_ccz.cczud13,g_ccz.cczud14,g_ccz.cczud15       #FUN-B50039 
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s010_set_entry('u')
         CALL s010_set_no_entry('u')
         LET g_before_input_done = TRUE
         LET g_flag_01='N'     #FUN-930164 add
         CALL cl_set_comp_entry("ccz44,ccz441",g_ccz.ccz43='Y')  #FUN-CB0120
 
#No.TQC-790064--start--
      AFTER FIELD ccz01
         IF g_ccz.ccz01 IS NOT NULL THEN 
            IF g_ccz.ccz01 <0 THEN 
               CALL cl_err('','afa-370',1) 
               NEXT FIELD ccz01
            END IF 
         END IF 
        #FUN-930164---add---str---
         IF g_ccz.ccz01 <> g_ccz_t.ccz01 THEN 
            LET g_flag_01='Y'
         END IF
        #FUN-930164---add---end---
 
      AFTER FIELD ccz02
         IF g_ccz.ccz02 IS NOT NULL THEN 
            IF g_ccz.ccz02 <1 OR g_ccz.ccz02>12 THEN 
#            IF g_ccz.ccz02 <1 AND g_ccz.ccz02>12 THEN 
               CALL cl_err('','axc-199',1)
               NEXT FIELD ccz02
            END IF 
         END IF 
        #FUN-930164---add---str---
         IF g_ccz.ccz02 <> g_ccz_t.ccz02 THEN 
            LET g_flag_01='Y'
         END IF
        #FUN-930164---add---end---
 
#No.TQC-790064--end--
      AFTER FIELD ccz10
         IF g_ccz.ccz10 IS NOT NULL THEN
            IF g_ccz.ccz10 NOT MATCHES '[12]' THEN
              NEXT FIELD ccz10
            END IF
         END IF
 
      AFTER FIELD ccz11
         IF NOT cl_null(g_ccz.ccz11) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ccz.ccz11
            IF g_cnt = 0 THEN
               CALL cl_err('',100,0)
               LET g_ccz.ccz11=g_ccz_t.ccz11
               DISPLAY BY NAME g_ccz.ccz11
               NEXT FIELD ccz11
            END IF
         ELSE                                           #No.TQC-790064
            NEXT FIELD ccz11                            #No.TQC-790064
         END IF
         LET g_ccz_t.ccz11=g_ccz.ccz11
 
      #FUN-680086    --Begin--
      AFTER FIELD ccz12
        IF NOT cl_null(g_ccz.ccz12) THEN
           SELECT COUNT(*) INTO g_cnt FROM aaa_file     #No.TQC-790064
            WHERE aaa01 = g_ccz.ccz12                   #No.TQC-790064
           IF g_cnt = 0 THEN                            #No.TQC-790064
              CALL cl_err('',100,0)                     #No.TQC-790064
              NEXT FIELD ccz12                          #No.TQC-790064 
           END IF                                       #No.TQC-790064
           IF g_ccz.ccz12=g_ccz.ccz121 THEN
              CALL cl_err('', 'axc-010',0)
              NEXT FIELD ccz12
           END IF
        END IF
       
      AFTER FIELD ccz121
        IF NOT cl_null(g_ccz.ccz121) THEN
           SELECT COUNT(*) INTO g_cnt FROM aaa_file     #No.TQC-790064                                                              
            WHERE aaa01 = g_ccz.ccz121                  #No.TQC-790064                                                              
           IF g_cnt = 0 THEN                            #No.TQC-790064                                                              
              CALL cl_err('',100,0)                     #No.TQC-790064                                                              
              NEXT FIELD ccz121                         #No.TQC-790064 
           END IF                                       #No.TQC-790064   
           IF g_ccz.ccz121=g_ccz.ccz12 THEN
              CALL cl_err('', 'axc-010',0)
              NEXT FIELD ccz121
           END IF
        END IF
      #FUN-680086   --End--
      
      BEFORE FIELD ccz13
         CALL s010_set_entry('u')
 
      AFTER FIELD ccz13
         CALL s010_set_no_entry('u')

##FUN-510041 add
      AFTER FIELD ccz14
         IF NOT cl_null(g_ccz.ccz14) THEN 
            CALL s010_aag02(g_ccz.ccz14,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_14 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz14,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz14=g_ccz_t.ccz14
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"               
                LET g_qryparam.default1 = g_ccz.ccz14
                LET g_qryparam.arg1 = g_bookno1     
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz14 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz14
                DISPLAY BY NAME g_ccz.ccz14                                     
#FUN-B10052 --end--
               NEXT FIELD ccz14
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_14
         END IF
 
      AFTER FIELD ccz15
         IF NOT cl_null(g_ccz.ccz15) THEN 
            CALL s010_aag02(g_ccz.ccz15,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_15 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz15,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz15=g_ccz_t.ccz15
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"               
                LET g_qryparam.default1 = g_ccz.ccz15
                LET g_qryparam.arg1 = g_bookno1     
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz15 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz15
                DISPLAY BY NAME g_ccz.ccz15 
#FUN-B10052 --end--
               NEXT FIELD ccz15
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_15
         END IF
      AFTER FIELD ccz16
         IF NOT cl_null(g_ccz.ccz16) THEN 
            CALL s010_aag02(g_ccz.ccz16,g_bookno1) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_16 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz16,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz16=g_ccz_t.ccz16
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz16
                LET g_qryparam.arg1 = g_bookno1     
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz16 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz16
                DISPLAY BY NAME g_ccz.ccz16                                            
#FUN-B10052 --end--
               NEXT FIELD ccz16
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_16 
         END IF
      AFTER FIELD ccz17
         IF NOT cl_null(g_ccz.ccz17) THEN 
            CALL s010_aag02(g_ccz.ccz17,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_17 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz17,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz17=g_ccz_t.ccz17
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz17
                LET g_qryparam.arg1 = g_bookno1            
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz17 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz17
                DISPLAY BY NAME g_ccz.ccz17
#FUN-B10052 --end--
               NEXT FIELD ccz17
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_17 
         END IF
      AFTER FIELD ccz18
         IF NOT cl_null(g_ccz.ccz18) THEN 
            CALL s010_aag02(g_ccz.ccz18,g_bookno1) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_18 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz18,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz18=g_ccz_t.ccz18
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz18
                LET g_qryparam.arg1 = g_bookno1         
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz18 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz18
                DISPLAY BY NAME g_ccz.ccz18
#FUN-B10052 --end--
               NEXT FIELD ccz18
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_18 
         END IF
      AFTER FIELD ccz19
         IF NOT cl_null(g_ccz.ccz19) THEN 
            CALL s010_aag02(g_ccz.ccz19,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_19 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz19,g_errno,0)
#FUN-B10052 --begin--
#              LET g_ccz.ccz19=g_ccz_t.ccz19
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"               
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz19
                LET g_qryparam.arg1 = g_bookno1    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz19 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz19
                DISPLAY BY NAME g_ccz.ccz19
#FUN-B10052 --end--
               NEXT FIELD ccz19
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_19 
         END IF
      AFTER FIELD ccz20
         IF NOT cl_null(g_ccz.ccz20) THEN 
            CALL s010_aag02(g_ccz.ccz20,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_20 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz20,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz20=g_ccz_t.ccz20
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N' 
                LET g_qryparam.default1 = g_ccz.ccz20
                LET g_qryparam.arg1 = g_bookno1 
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz20 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz20
                DISPLAY BY NAME g_ccz.ccz20
#FUN-B10052 --end--
               NEXT FIELD ccz20
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_20 
         END IF
      AFTER FIELD ccz21
         IF NOT cl_null(g_ccz.ccz21) THEN 
            CALL s010_aag02(g_ccz.ccz21,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_21 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz21,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz20=g_ccz_t.ccz21
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz21
                LET g_qryparam.arg1 = g_bookno1   
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz21 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz21
                DISPLAY BY NAME g_ccz.ccz21
#FUN-B10052 --end--
               NEXT FIELD ccz21
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_21 
         END IF
      AFTER FIELD ccz22
         IF NOT cl_null(g_ccz.ccz22) THEN 
            CALL s010_aag02(g_ccz.ccz22,g_bookno1) RETURNING l_aag02   #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_22 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz22,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz20=g_ccz_t.ccz22
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz22
                LET g_qryparam.arg1 = g_bookno1   
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz22 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz22
                DISPLAY BY NAME g_ccz.ccz22
#FUN-B10052 --end--
               NEXT FIELD ccz22
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_22 
         END IF
 
      AFTER FIELD ccz23          #u
         IF NOT cl_null(g_ccz.ccz23) THEN 
            CALL s010_gem02('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz23,g_errno,0)
               LET g_ccz.ccz20=g_ccz_t.ccz23
               NEXT FIELD ccz23
            END IF
         END IF
      AFTER FIELD ccz24
         IF NOT cl_null(g_ccz.ccz24) THEN 
            CALL s010_aag02(g_ccz.ccz24,g_bookno1) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_24 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz24,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz24=g_ccz_t.ccz24
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz24
                LET g_qryparam.arg1 = g_bookno1    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz24 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz24
                DISPLAY BY NAME g_ccz.ccz24
#FUN-B10052 --end--
               NEXT FIELD ccz24
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_24 
         END IF
      AFTER FIELD ccz25
         IF NOT cl_null(g_ccz.ccz25) THEN 
            CALL s010_aag02(g_ccz.ccz25,g_bookno1) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_25 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz25,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz25=g_ccz_t.ccz25
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz25
                LET g_qryparam.arg1 = g_bookno1    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz25 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz25
                DISPLAY BY NAME g_ccz.ccz25
#FUN-B10052 --end--
               NEXT FIELD ccz25
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_25 
         END IF
      #FUN-BC0062---str---
      AFTER FIELD ccz28
         IF g_ccz.ccz28 = '6' THEN
            SELECT ryz08  INTO l_ryz08  FROM ryz_file
               WHERE ryz01 = '0'
           #TQC-D40012--mod---str
            IF l_ryz08 = 'N' THEN
               CALL cl_err('','axc-905',1)
               LET g_ccz.ccz28 = g_ccz_t.ccz28
               NEXT FIELD ccz28
            END IF
           #TQC-D40012--mod-end
            CALL cl_err('','axc-029',1)   #FUN-D70101
         END IF
      #FUN-BC0062---end--- 
       #FUN-8B0047
       #FUN-D60091 ------Begin--------
         IF g_ccz_t.ccz28 = '6' AND g_ccz_t.ccz28 <> g_ccz.ccz28 THEN
            SELECT COUNT(*) INTO l_cnt FROM cfa_file
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
               CALL cl_err('','axc-028',1)
               LET g_ccz.ccz28 = g_ccz_t.ccz28
               NEXT FIELD ccz28
            END IF
         END IF
         LET g_ccz_t.ccz28 = g_ccz.ccz28
       #FUN-D60091 ------End----------

      AFTER FIELD ccz29
         IF NOT cl_null(g_ccz.ccz29) THEN 
            CALL s010_aag02(g_ccz.ccz29,g_bookno1) RETURNING l_aag02   #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_23 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz29,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz29=g_ccz_t.ccz29    
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz29
                LET g_qryparam.arg1 = g_bookno1                   
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz29 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz29 
                DISPLAY BY NAME g_ccz.ccz29 
#FUN-B10052 --end--
               NEXT FIELD ccz29
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_23 
         END IF
 
      AFTER FIELD ccz291
         IF NOT cl_null(g_ccz.ccz291) THEN 
            CALL s010_aag02(g_ccz.ccz291,g_bookno2) RETURNING l_aag02   #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_231 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz291,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz291=g_ccz_t.ccz291      
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"                
                LET g_qryparam.default1 = g_ccz.ccz291
                LET g_qryparam.arg1 = g_bookno2 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz291 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz291
                DISPLAY BY NAME g_ccz.ccz291
#FUN-B10052 --end--
               NEXT FIELD ccz291
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_231
         END IF 
      #FUN-8B0047..end
 
      #FUN-680086   --Begin--
      AFTER FIELD ccz141
         IF NOT cl_null(g_ccz.ccz141) THEN 
            CALL s010_aag02(g_ccz.ccz141,g_bookno2) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_141 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz141,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz141=g_ccz_t.ccz141
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz141
                LET g_qryparam.arg1 = g_bookno2  
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz141 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz141
                DISPLAY BY NAME g_ccz.ccz141                
#FUN-B10052 --end--
               NEXT FIELD ccz141
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_141
         END IF
 
      AFTER FIELD ccz151
         IF NOT cl_null(g_ccz.ccz151) THEN 
            CALL s010_aag02(g_ccz.ccz151,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_151 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz151,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz151=g_ccz_t.ccz151
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz151
                LET g_qryparam.arg1 = g_bookno2    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz151 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz151 
                DISPLAY BY NAME g_ccz.ccz151
#FUN-B10052 --end--
               NEXT FIELD ccz151
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_151
         END IF
      AFTER FIELD ccz161
         IF NOT cl_null(g_ccz.ccz161) THEN 
            CALL s010_aag02(g_ccz.ccz161,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_161 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz161,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz161=g_ccz_t.ccz161
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz161
                LET g_qryparam.arg1 = g_bookno2       
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz161 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz161
                DISPLAY BY NAME g_ccz.ccz161
#FUN-B10052 --end--
               NEXT FIELD ccz161
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_161 
         END IF
      AFTER FIELD ccz171
         IF NOT cl_null(g_ccz.ccz171) THEN 
            CALL s010_aag02(g_ccz.ccz171,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_171 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz171,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz17=g_ccz_t.ccz171
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz171
                LET g_qryparam.arg1 = g_bookno2            
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz171 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz171
                DISPLAY BY NAME g_ccz.ccz171
#FUN-B10052 --end--
               NEXT FIELD ccz171
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_171 
         END IF
         
      AFTER FIELD ccz181
         IF NOT cl_null(g_ccz.ccz181) THEN 
            CALL s010_aag02(g_ccz.ccz181,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_181 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz181,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz181=g_ccz_t.ccz181
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"           
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz181
                LET g_qryparam.arg1 = g_bookno2   
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz181 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz181
                DISPLAY BY NAME g_ccz.ccz181
#FUN-B10052 --end--
               NEXT FIELD ccz181
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_181 
         END IF
      AFTER FIELD ccz191
         IF NOT cl_null(g_ccz.ccz191) THEN 
            CALL s010_aag02(g_ccz.ccz191,g_bookno2) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_191 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz191,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz191=g_ccz_t.ccz191
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz191
                LET g_qryparam.arg1 = g_bookno2                                  
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz191 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz191
                DISPLAY BY NAME g_ccz.ccz191
#FUN-B10052 --end--
               NEXT FIELD ccz191
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_191 
         END IF
      AFTER FIELD ccz201
         IF NOT cl_null(g_ccz.ccz201) THEN 
            CALL s010_aag02(g_ccz.ccz201,g_bookno2) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_201 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz201,g_errno,0)
#FUN-B10052 --begin-
#               LET g_ccz.ccz201=g_ccz_t.ccz201
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz201
                LET g_qryparam.arg1 = g_bookno2    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz201 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz201
                DISPLAY BY NAME g_ccz.ccz201
#FUN-B10052 --end--
               NEXT FIELD ccz201
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_201 
         END IF
      AFTER FIELD ccz211
         IF NOT cl_null(g_ccz.ccz211) THEN 
            CALL s010_aag02(g_ccz.ccz211,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_211 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz211,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz211=g_ccz_t.ccz211
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'  
                LET g_qryparam.default1 = g_ccz.ccz211
                LET g_qryparam.arg1 = g_bookno2      
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz211 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz211
                DISPLAY BY NAME g_ccz.ccz211
#FUN-B10052 --end--
               NEXT FIELD ccz211
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_211 
         END IF
      AFTER FIELD ccz221
         IF NOT cl_null(g_ccz.ccz221) THEN 
            CALL s010_aag02(g_ccz.ccz221,g_bookno2) RETURNING l_aag02  #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_221 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz221,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz221=g_ccz_t.ccz221
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N' 
                LET g_qryparam.default1 = g_ccz.ccz221
                LET g_qryparam.arg1 = g_bookno2             
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz221 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz221
                DISPLAY BY NAME g_ccz.ccz221
#FUN-B10052 --end--
               NEXT FIELD ccz221
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_221 
         END IF
         
      #TQC-970138--Add--Begin--#   
      AFTER FIELD ccz231
         IF NOT cl_null(g_ccz.ccz231) THEN 
            CALL s010_gem02a('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz231,g_errno,0)
               LET g_ccz.ccz201=g_ccz_t.ccz231
               NEXT FIELD ccz231
            END IF
         END IF
      #TQC-970138--Add--End--#         
 
      AFTER FIELD ccz241
         IF NOT cl_null(g_ccz.ccz241) THEN 
            CALL s010_aag02(g_ccz.ccz241,g_bookno2) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_241 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz241,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz241=g_ccz_t.ccz241               
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz241
                LET g_qryparam.arg1 = g_bookno2              
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz241 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz241
                DISPLAY BY NAME g_ccz.ccz241
#FUN-B10052 --end--
               NEXT FIELD ccz241
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_241 
         END IF
      AFTER FIELD ccz251
         IF NOT cl_null(g_ccz.ccz251) THEN 
            CALL s010_aag02(g_ccz.ccz251,g_bookno2) RETURNING l_aag02 #No.FUN-730057
            DISPLAY l_aag02 TO FORMONLY.aag02_251 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz251,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz251=g_ccz_t.ccz251                
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz251
                LET g_qryparam.arg1 = g_bookno2   
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz251 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz251
                DISPLAY BY NAME g_ccz.ccz251
#FUN-B10052 --end--
               NEXT FIELD ccz251
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_251 
         END IF
      #FUN-680086   --End--
     #start FUN-660174 add
      AFTER FIELD ccz26
         IF cl_null(g_ccz.ccz26) THEN
            SELECT azi03 INTO g_ccz.ccz26 FROM azi_file WHERE azi01=g_aza.aza17
            IF STATUS THEN  
               CALL cl_err3("sel","azi_file","","",STATUS,"","",1)
               NEXT FIELD ccz26
            ELSE
               DISPLAY BY NAME g_ccz.ccz26
            END IF
         ELSE
            IF g_ccz.ccz26 < 0 THEN
               CALL cl_err("","mfg3291",1)
               NEXT FIELD ccz26
            END IF
         END IF
     #end FUN-660174 add
#wujie 130627 --begin
      BEFORE FIELD ccz31
         CALL s010_set_entry('u')
      AFTER FIELD ccz31
         IF g_ccz.ccz31 = '1' THEN 
            CALL s010_set_no_entry('u')
         END IF 
#wujie 130627 --end 
      #CHI-970017--begin--add--------------------
      AFTER FIELD ccz33
         IF NOT cl_null(g_ccz.ccz33) THEN 
            CALL s010_aag02(g_ccz.ccz33,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_33 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz33,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz33=g_ccz_t.ccz33
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz33
                LET g_qryparam.arg1 = g_bookno1                
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz33 clipped,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz33
                DISPLAY BY NAME g_ccz.ccz33
#FUN-B10052 --end--
               NEXT FIELD ccz33
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_33
         END IF

      AFTER FIELD ccz34
         IF NOT cl_null(g_ccz.ccz34) THEN 
            CALL s010_aag02(g_ccz.ccz34,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_34 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz34,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz34=g_ccz_t.ccz34
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz34
                LET g_qryparam.arg1 = g_bookno1 
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz34 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz34
                DISPLAY BY NAME g_ccz.ccz34
#FUN-B10052 --end--
               NEXT FIELD ccz34
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_34
         END IF

      AFTER FIELD ccz35
         IF NOT cl_null(g_ccz.ccz35) THEN 
            CALL s010_aag02(g_ccz.ccz35,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_35 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz35,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz35=g_ccz_t.ccz35
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz35
                LET g_qryparam.arg1 = g_bookno1  
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz35 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz35
                DISPLAY BY NAME g_ccz.ccz35               
#FUN-B10052 --end--
               NEXT FIELD ccz35
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_35
         END IF
      AFTER FIELD ccz36
         IF NOT cl_null(g_ccz.ccz36) THEN 
            CALL s010_aag02(g_ccz.ccz36,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_36 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz36,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz36=g_ccz_t.ccz36
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"                   
                LET g_qryparam.default1 = g_ccz.ccz36
                LET g_qryparam.construct = 'N'
                LET g_qryparam.arg1 = g_bookno1    
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz36 clipped,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz36
                DISPLAY BY NAME g_ccz.ccz36
#FUN-B10052 --end--
               NEXT FIELD ccz36
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_36
         END IF

      AFTER FIELD ccz37
         IF NOT cl_null(g_ccz.ccz37) THEN 
            CALL s010_aag02(g_ccz.ccz37,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_37 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz37,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz37=g_ccz_t.ccz37
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"  
                LET g_qryparam.default1 = g_ccz.ccz37
                LET g_qryparam.arg1 = g_bookno1
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz37 clipped,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz37
                DISPLAY BY NAME g_ccz.ccz37
#FUN-B10052 --end--
               NEXT FIELD ccz37
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_37
         END IF

      AFTER FIELD ccz38
         IF NOT cl_null(g_ccz.ccz38) THEN 
            CALL s010_aag02(g_ccz.ccz38,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_38 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz38,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz38=g_ccz_t.ccz38
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"             
                LET g_qryparam.default1 = g_ccz.ccz38
                LET g_qryparam.arg1 = g_bookno1  
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz38 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz38 
                DISPLAY BY NAME g_ccz.ccz38
#FUNB-10052 --end--
               NEXT FIELD ccz38
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_38
         END IF

      AFTER FIELD ccz39
         IF NOT cl_null(g_ccz.ccz39) THEN 
            CALL s010_aag02(g_ccz.ccz39,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_39 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz39,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz39=g_ccz_t.ccz39
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_ccz.ccz39
                LET g_qryparam.arg1 = g_bookno1
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz39 clipped,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz39 
                DISPLAY BY NAME g_ccz.ccz39
#FUN-B10052 --end--
               NEXT FIELD ccz39
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_39
         END IF

      AFTER FIELD ccz40
         IF NOT cl_null(g_ccz.ccz40) THEN 
            CALL s010_aag02(g_ccz.ccz40,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_40 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz40,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz40=g_ccz_t.ccz40
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_ccz.ccz40
                LET g_qryparam.arg1 = g_bookno1                
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz40 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz40
                DISPLAY BY NAME g_ccz.ccz40
#FUN-B10052 --end--
               NEXT FIELD ccz40
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_40
         END IF

      AFTER FIELD ccz331
         IF NOT cl_null(g_ccz.ccz331) THEN 
            CALL s010_aag02(g_ccz.ccz331,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_331 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz331,g_errno,0)
#FUN-B10052 --begin--
#              LET g_ccz.ccz331=g_ccz_t.ccz331
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag" 
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ccz.ccz331
               LET g_qryparam.arg1 = g_bookno2            
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz331 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz331
               DISPLAY BY NAME g_ccz.ccz331
#FUN-B10052 --end--
               NEXT FIELD ccz331
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_331
         END IF

      AFTER FIELD ccz341
         IF NOT cl_null(g_ccz.ccz341) THEN 
            CALL s010_aag02(g_ccz.ccz341,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_341 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz341,g_errno,0)
#FUN-B10052 --begin--
#               LET g_ccz.ccz341=g_ccz_t.ccz341
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag" 
               LET g_qryparam.construct = 'N'                 
               LET g_qryparam.default1 = g_ccz.ccz341
               LET g_qryparam.arg1 = g_bookno2             
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz341 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz341
               DISPLAY BY NAME g_ccz.ccz341
#FUN-B10052 --end--
               NEXT FIELD ccz341
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_341
         END IF

      AFTER FIELD ccz351
         IF NOT cl_null(g_ccz.ccz351) THEN 
            CALL s010_aag02(g_ccz.ccz351,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_351 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz351,g_errno,0)
#FUN-B10052 --begin--               
#              LET g_ccz.ccz351=g_ccz_t.ccz351
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag" 
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ccz.ccz351
               LET g_qryparam.arg1 = g_bookno2              
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz351 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz351
               DISPLAY BY NAME g_ccz.ccz351 
#FUN-B10052 --end--
               NEXT FIELD ccz351
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_351
         END IF

      AFTER FIELD ccz361
         IF NOT cl_null(g_ccz.ccz361) THEN 
            CALL s010_aag02(g_ccz.ccz361,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_361
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz361,g_errno,0)
#FUN-B10052 --begin--               
#              LET g_ccz.ccz361=g_ccz_t.ccz361
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag" 
               LET g_qryparam.default1 = g_ccz.ccz361
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz361 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz361
               DISPLAY BY NAME g_ccz.ccz361
#FUN-B10052 --end--
               NEXT FIELD ccz361
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_361
         END IF

      AFTER FIELD ccz371
         IF NOT cl_null(g_ccz.ccz371) THEN 
            CALL s010_aag02(g_ccz.ccz371,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_371 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz371,g_errno,0)
#FUNB-10052 --begin--               
#               LET g_ccz.ccz371=g_ccz_t.ccz371
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz371
                LET g_qryparam.arg1 = g_bookno2               
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz371 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz371
                DISPLAY BY NAME g_ccz.ccz371
#FUN-B10052 --end--
               NEXT FIELD ccz371
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_371
         END IF

      AFTER FIELD ccz381
         IF NOT cl_null(g_ccz.ccz381) THEN 
            CALL s010_aag02(g_ccz.ccz381,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_381 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz381,g_errno,0)
#FUN-B10052 --begin--               
#               LET g_ccz.ccz381=g_ccz_t.ccz381
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz381
                LET g_qryparam.arg1 = g_bookno2               
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz381 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz381 
                DISPLAY BY NAME g_ccz.ccz381
#FUN-B10052 --end--
               NEXT FIELD ccz381
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_381
         END IF

      AFTER FIELD ccz391
         IF NOT cl_null(g_ccz.ccz391) THEN 
            CALL s010_aag02(g_ccz.ccz391,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_391 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz391,g_errno,0)
#FUN-B10052 --begin--               
#              LET g_ccz.ccz391=g_ccz_t.ccz391
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"   
                LET g_qryparam.default1 = g_ccz.ccz391
                LET g_qryparam.arg1 = g_bookno2
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz391 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz391 
                DISPLAY BY NAME g_ccz.ccz391
#FUN-B10052 --end--
               NEXT FIELD ccz391
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_391
         END IF

      AFTER FIELD ccz401
         IF NOT cl_null(g_ccz.ccz401) THEN 
            CALL s010_aag02(g_ccz.ccz401,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_401 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz401,g_errno,0)
#FUN-B10052 --begin--               
#              LET g_ccz.ccz401=g_ccz_t.ccz401
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ccz.ccz401
                LET g_qryparam.arg1 = g_bookno2
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz401 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ccz.ccz401
                DISPLAY BY NAME g_ccz.ccz401
#FUN-B10052 --end--
               NEXT FIELD ccz401
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_401
         END IF
      #CHI-970017--end--add---------------------
      #FUN-CB0120--add--str--
      ON CHANGE ccz43
         IF NOT cl_null(g_ccz.ccz43) THEN
            CALL cl_set_comp_entry("ccz44,ccz441",g_ccz.ccz43='Y')
         END IF
         #TQC-D20011--add--str--
         IF g_ccz.ccz43<>'Y' THEN
            LET g_ccz.ccz44=NULL
            LET g_ccz.ccz441=NUll
            DISPLAY BY NAME g_ccz.ccz44,g_ccz.ccz441
            DISPLAY '' TO FORMONLY.aag02_44
            DISPLAY '' TO FORMONLY.aag02_441
         END IF
         #TQC-D20011--add--end
      AFTER FIELD ccz44
         IF NOT cl_null(g_ccz.ccz44) THEN
            CALL s010_aag02(g_ccz.ccz44,g_bookno1) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_44
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz44,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ccz.ccz44
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz44 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz44
               DISPLAY BY NAME g_ccz.ccz44
               NEXT FIELD ccz44
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_44
         END IF
      AFTER FIELD ccz441
         IF NOT cl_null(g_ccz.ccz441) THEN
            CALL s010_aag02(g_ccz.ccz441,g_bookno2) RETURNING l_aag02
            DISPLAY l_aag02 TO FORMONLY.aag02_441
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ccz.ccz441,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ccz.ccz441
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_ccz.ccz441 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ccz.ccz441
               DISPLAY BY NAME g_ccz.ccz441
               NEXT FIELD ccz441
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.aag02_441
         END IF
      #FUN-CB0120--add--end
      #FUN-B50039-add-str--
      AFTER FIELD cczud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD cczud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--




      ON ACTION CONTROLP
#No.TQC-790064--start--
         IF INFIELD(ccz11)THEN
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = 'q_azp'
            LET g_qryparam.default1 = g_ccz.ccz11
            CALL cl_create_qry() RETURNING g_ccz.ccz11
            DISPLAY g_ccz.ccz11 TO czz11
            NEXT FIELD ccz11
         END IF 
         IF INFIELD(ccz12)THEN                                                                                                      
            CALL cl_init_qry_var()                                                                                                  
            LET g_qryparam.form = 'q_aaa4'                                                                                           
            LET g_qryparam.default1 = g_ccz.ccz12                                                                                   
            CALL cl_create_qry() RETURNING g_ccz.ccz12                                                                              
            DISPLAY BY NAME g_ccz.ccz12                                                                                             
            NEXT FIELD ccz12                                                                                                        
         END IF 
         IF INFIELD(ccz121)THEN                                                                                                      
            CALL cl_init_qry_var()                                                                                                  
            LET g_qryparam.form = 'q_aaa4'                                                                                           
            LET g_qryparam.default1 = g_ccz.ccz121                                                                                   
            CALL cl_create_qry() RETURNING g_ccz.ccz121                                                                              
            DISPLAY BY NAME g_ccz.ccz121                                                                                             
            NEXT FIELD ccz121                                                                                                        
         END IF 
#No.TQC-790064--end--
         CASE
             WHEN INFIELD(ccz14) OR     #查詢科目代號不為統制帳戶'1'
                  INFIELD(ccz15) OR
                  INFIELD(ccz16) OR
                  INFIELD(ccz17) OR
                  INFIELD(ccz18) OR
                  INFIELD(ccz19) OR
                  INFIELD(ccz20) OR
                  INFIELD(ccz21) OR
                  INFIELD(ccz22) OR
                  INFIELD(ccz24) OR
                  INFIELD(ccz25) OR
                  INFIELD(ccz29) OR #FUN-8B0047
                  INFIELD(ccz291) OR #FUN-8B0047
                  INFIELD(ccz44)  OR #FUN-CB0120
                  INFIELD(ccz441) OR #FUN-CB0120  
                #CHI-970017--begin--add---
                  INFIELD(ccz33) OR
                  INFIELD(ccz34) OR
                  INFIELD(ccz35) OR
                  INFIELD(ccz36) OR
                  INFIELD(ccz37) OR
                  INFIELD(ccz38) OR
                  INFIELD(ccz39) OR
                  INFIELD(ccz40) OR
                  INFIELD(ccz331) OR
                  INFIELD(ccz341) OR
                  INFIELD(ccz351) OR
                  INFIELD(ccz361) OR
                  INFIELD(ccz371) OR
                  INFIELD(ccz381) OR
                  INFIELD(ccz391) OR
                  INFIELD(ccz401) OR
                #CHI-970017--end--ad-----
                #FUN-680086  --Begin--
                  INFIELD(ccz141) OR     #查詢科目代號不為統制帳戶'1'
                  INFIELD(ccz151) OR
                  INFIELD(ccz161) OR
                  INFIELD(ccz171) OR
                  INFIELD(ccz181) OR
                  INFIELD(ccz191) OR
                  INFIELD(ccz201) OR
                  INFIELD(ccz211) OR
                  INFIELD(ccz221) OR
                  INFIELD(ccz241) OR
                  INFIELD(ccz251) 
                #FUN-680086  --End--
                 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                CASE WHEN INFIELD(ccz14) 
                          LET g_qryparam.default1 = g_ccz.ccz14
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz15) 
                          LET g_qryparam.default1 = g_ccz.ccz15
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz16) 
                          LET g_qryparam.default1 = g_ccz.ccz16
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz17) 
                          LET g_qryparam.default1 = g_ccz.ccz17
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz18) 
                          LET g_qryparam.default1 = g_ccz.ccz18
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz19) 
                          LET g_qryparam.default1 = g_ccz.ccz19
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz20) 
                          LET g_qryparam.default1 = g_ccz.ccz20
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz21) 
                          LET g_qryparam.default1 = g_ccz.ccz21
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz22) 
                          LET g_qryparam.default1 = g_ccz.ccz22
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz24) 
                          LET g_qryparam.default1 = g_ccz.ccz24
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz25) 
                          LET g_qryparam.default1 = g_ccz.ccz25
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
 
                     #FUN-8B0047
                     WHEN INFIELD(ccz29) 
                          LET g_qryparam.default1 = g_ccz.ccz29
                          LET g_qryparam.arg1 = g_bookno1     #No.FUN-730057
                     WHEN INFIELD(ccz291) 
                          LET g_qryparam.default1 = g_ccz.ccz291
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     #FUN-8B0047..end
                    
                   #FUN-680086   --Begin--
                     WHEN INFIELD(ccz141) 
                          LET g_qryparam.default1 = g_ccz.ccz141
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz151) 
                          LET g_qryparam.default1 = g_ccz.ccz151
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz161) 
                          LET g_qryparam.default1 = g_ccz.ccz161
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz171) 
                          LET g_qryparam.default1 = g_ccz.ccz171
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz181) 
                          LET g_qryparam.default1 = g_ccz.ccz181
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz191) 
                          LET g_qryparam.default1 = g_ccz.ccz191
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz201) 
                          LET g_qryparam.default1 = g_ccz.ccz201
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz211) 
                          LET g_qryparam.default1 = g_ccz.ccz211
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz221) 
                          LET g_qryparam.default1 = g_ccz.ccz221
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz241) 
                          LET g_qryparam.default1 = g_ccz.ccz241
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                     WHEN INFIELD(ccz251) 
                          LET g_qryparam.default1 = g_ccz.ccz251
                          LET g_qryparam.arg1 = g_bookno2     #No.FUN-730057
                   #FUN-680086   --Begin--
                   #CHI-970017--begin--add---  
                     WHEN INFIELD(ccz33) 
                          LET g_qryparam.default1 = g_ccz.ccz33
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz34) 
                          LET g_qryparam.default1 = g_ccz.ccz34
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz35) 
                          LET g_qryparam.default1 = g_ccz.ccz35
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz36) 
                          LET g_qryparam.default1 = g_ccz.ccz36
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz37) 
                          LET g_qryparam.default1 = g_ccz.ccz37
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz38) 
                          LET g_qryparam.default1 = g_ccz.ccz38
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz39) 
                          LET g_qryparam.default1 = g_ccz.ccz39
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz40) 
                          LET g_qryparam.default1 = g_ccz.ccz40
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz331) 
                          LET g_qryparam.default1 = g_ccz.ccz331
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz341) 
                          LET g_qryparam.default1 = g_ccz.ccz341
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz351) 
                          LET g_qryparam.default1 = g_ccz.ccz351
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz361) 
                          LET g_qryparam.default1 = g_ccz.ccz361
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz371) 
                          LET g_qryparam.default1 = g_ccz.ccz371
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz381) 
                          LET g_qryparam.default1 = g_ccz.ccz381
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz391) 
                          LET g_qryparam.default1 = g_ccz.ccz391
                          LET g_qryparam.arg1 = g_bookno2
                     WHEN INFIELD(ccz401) 
                          LET g_qryparam.default1 = g_ccz.ccz401
                          LET g_qryparam.arg1 = g_bookno2
                     #CHI-970017--end--add-------
                     #FUN-CB0120--add--str--
                     WHEN INFIELD(ccz44)
                          LET g_qryparam.default1 = g_ccz.ccz44
                          LET g_qryparam.arg1 = g_bookno1
                     WHEN INFIELD(ccz441)
                          LET g_qryparam.default1 = g_ccz.ccz441
                          LET g_qryparam.arg1 = g_bookno2
                     #FUN-CB0120--add--end
                END CASE
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                CALL cl_create_qry() RETURNING l_aag01
                CASE WHEN INFIELD(ccz14) 
                          LET g_ccz.ccz14 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz14 
                          NEXT FIELD ccz14
                     WHEN INFIELD(ccz15) 
                          LET g_ccz.ccz15 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz15 
                          NEXT FIELD ccz15
                     WHEN INFIELD(ccz16) 
                          LET g_ccz.ccz16 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz16 
                          NEXT FIELD ccz16
                     WHEN INFIELD(ccz17) 
                          LET g_ccz.ccz17 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz17 
                          NEXT FIELD ccz17
                     WHEN INFIELD(ccz18) 
                          LET g_ccz.ccz18 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz18 
                          NEXT FIELD ccz18
                     WHEN INFIELD(ccz19) 
                          LET g_ccz.ccz19 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz19 
                          NEXT FIELD ccz19
                     WHEN INFIELD(ccz20) 
                          LET g_ccz.ccz20 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz20 
                          NEXT FIELD ccz20
                     WHEN INFIELD(ccz21) 
                          LET g_ccz.ccz21 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz21 
                          NEXT FIELD ccz21
                     WHEN INFIELD(ccz22) 
                          LET g_ccz.ccz22 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz22 
                          NEXT FIELD ccz22
                     WHEN INFIELD(ccz24) 
                          LET g_ccz.ccz24 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz24 
                          NEXT FIELD ccz24
                     WHEN INFIELD(ccz25) 
                          LET g_ccz.ccz25 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz25 
                          NEXT FIELD ccz25
 
                      #FUN-8B0047
                     WHEN INFIELD(ccz29) 
                          LET g_ccz.ccz29 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz29 
                          NEXT FIELD ccz29
                     WHEN INFIELD(ccz291) 
                          LET g_ccz.ccz291= l_aag01
                          DISPLAY BY NAME g_ccz.ccz291
                          NEXT FIELD ccz291
                      #FUN-8B0047..end
 
                   #FUN-680086   --Begin--
                     WHEN INFIELD(ccz141) 
                          LET g_ccz.ccz141 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz141 
                          NEXT FIELD ccz141
                     WHEN INFIELD(ccz151) 
                          LET g_ccz.ccz151 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz151 
                          NEXT FIELD ccz151
                     WHEN INFIELD(ccz161) 
                          LET g_ccz.ccz161 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz161 
                          NEXT FIELD ccz161
                     WHEN INFIELD(ccz171) 
                          LET g_ccz.ccz171 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz171 
                          NEXT FIELD ccz171
                     WHEN INFIELD(ccz181) 
                          LET g_ccz.ccz181 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz181 
                          NEXT FIELD ccz181
                     WHEN INFIELD(ccz191) 
                          LET g_ccz.ccz191 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz191 
                          NEXT FIELD ccz191
                     WHEN INFIELD(ccz201) 
                          LET g_ccz.ccz201 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz201 
                          NEXT FIELD ccz201
                     WHEN INFIELD(ccz211) 
#                         LET g_ccz.ccz21 = l_aag01            #TQC-970138 Mark
                          LET g_ccz.ccz211 = l_aag01           #TQC-970138                          
                          DISPLAY BY NAME g_ccz.ccz211 
                          NEXT FIELD ccz211
                     WHEN INFIELD(ccz221) 
                          LET g_ccz.ccz221 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz221 
                          NEXT FIELD ccz221
                     WHEN INFIELD(ccz241) 
                          LET g_ccz.ccz241 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz241 
                          NEXT FIELD ccz241
                     WHEN INFIELD(ccz251) 
                          LET g_ccz.ccz251 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz251 
                          NEXT FIELD ccz251
                   #FUN-680086   --End--
                   #CHI-970017--begin--add----
                     WHEN INFIELD(ccz33) 
                          LET g_ccz.ccz33 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz33 
                          NEXT FIELD ccz33
                     WHEN INFIELD(ccz34) 
                          LET g_ccz.ccz34 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz34 
                          NEXT FIELD ccz34
                     WHEN INFIELD(ccz35) 
                          LET g_ccz.ccz35 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz35 
                          NEXT FIELD ccz35
                     WHEN INFIELD(ccz36) 
                          LET g_ccz.ccz36 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz36 
                          NEXT FIELD ccz36
                     WHEN INFIELD(ccz37) 
                          LET g_ccz.ccz37 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz37 
                          NEXT FIELD ccz37
                     WHEN INFIELD(ccz38) 
                          LET g_ccz.ccz38 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz38 
                          NEXT FIELD ccz38
                     WHEN INFIELD(ccz39) 
                          LET g_ccz.ccz39 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz39 
                          NEXT FIELD ccz39
                     WHEN INFIELD(ccz40) 
                          LET g_ccz.ccz40 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz40 
                          NEXT FIELD ccz40
                     WHEN INFIELD(ccz331) 
                          LET g_ccz.ccz331 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz331 
                          NEXT FIELD ccz331
                     WHEN INFIELD(ccz341) 
                          LET g_ccz.ccz341 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz341 
                          NEXT FIELD ccz341
                     WHEN INFIELD(ccz351) 
                          LET g_ccz.ccz351 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz351 
                          NEXT FIELD ccz351
                     WHEN INFIELD(ccz361) 
                          LET g_ccz.ccz361 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz361 
                          NEXT FIELD ccz361
                     WHEN INFIELD(ccz371) 
                          LET g_ccz.ccz371 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz371 
                          NEXT FIELD ccz371
                     WHEN INFIELD(ccz381) 
                          LET g_ccz.ccz381 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz381 
                          NEXT FIELD ccz381
                     WHEN INFIELD(ccz391) 
                          LET g_ccz.ccz391 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz391 
                          NEXT FIELD ccz391
                     WHEN INFIELD(ccz401) 
                          LET g_ccz.ccz401 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz401
                          NEXT FIELD ccz401
                   #CHI-970017--end--add----
                   #FUN-CB0120--add--str--
                     WHEN INFIELD(ccz44)
                          LET g_ccz.ccz44 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz44
                          NEXT FIELD ccz44
                     WHEN INFIELD(ccz441)
                          LET g_ccz.ccz441 = l_aag01
                          DISPLAY BY NAME g_ccz.ccz441
                          NEXT FIELD ccz441
                   #FUN-CB0120--add--end
                   OTHERWISE
                END CASE
 
           WHEN INFIELD(ccz23) 
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_gem"
                LET g_qryparam.default1 = g_ccz.ccz23 
                CALL cl_create_qry() RETURNING g_ccz.ccz23
                DISPLAY BY NAME g_ccz.ccz23
                NEXT FIELD ccz23
                
           #TQC-970138--Add--Begin--#     
           WHEN INFIELD(ccz231) 
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_gem"
                LET g_qryparam.default1 = g_ccz.ccz231 
                CALL cl_create_qry() RETURNING g_ccz.ccz231
                DISPLAY BY NAME g_ccz.ccz231
                NEXT FIELD ccz231
           #TQC-970138--Add--End--#                
           OTHERWISE
         END CASE
 
##FUN-510041 END ## 
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
END FUNCTION
 
FUNCTION s010_aag02(p_code,p_bookno)
  DEFINE p_code     LIKE aag_file.aag01  
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag02    LIKE aag_file.aag02
  DEFINE p_bookno   LIKE aag_file.aag00
 
   LET l_aag02 = ''
   LET l_aag07 = ''
   LET l_aag09 = ''
   LET l_aagacti = ''
   LET g_errno = ''
   SELECT aag02,aag07,aag09,aagacti
     INTO l_aag02,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno    #No.FUN-730057
 
   CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
        WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        WHEN l_aag09  = 'N'     LET g_errno = 'agl-214'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   
   RETURN l_aag02
 
END FUNCTION
 
FUNCTION s010_gem02(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
 DEFINE l_gem02    LIKE gem_file.gem02,
        l_gemacti  LIKE gem_file.gemacti
 
   LET l_gem02 = ''
   LET l_gemacti = ''
   LET g_errno = ''
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
    WHERE gem01=g_ccz.ccz23
 
   CASE WHEN STATUS=100         LET g_errno='mfg3097'
        WHEN l_gemacti='N'      LET g_errno='9028'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
      DISPLAY l_gem02 TO FORMONLY.gem02 
   END IF
 
END FUNCTION
 
#TQC-970138--Add--Begin--#
FUNCTION s010_gem02a(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1    
 DEFINE l_gem02    LIKE gem_file.gem02,
        l_gemacti  LIKE gem_file.gemacti
 
   LET l_gem02 = ''
   LET l_gemacti = ''
   LET g_errno = ''
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
    WHERE gem01=g_ccz.ccz231
 
   CASE WHEN STATUS=100         LET g_errno='mfg3097'
        WHEN l_gemacti='N'      LET g_errno='9028'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
      DISPLAY l_gem02 TO FORMONLY.gem02a 
   END IF
 
END FUNCTION
#TQC-970138--Add--End--#
 
FUNCTION s010_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
 
 IF INFIELD(ccz13) OR ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ccz13",TRUE)
 END IF
#wujie 130627 --begin
 IF INFIELD(ccz31) OR ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ccz32",TRUE)
 END IF
#wujie 130627 --end
 
END FUNCTION
 
FUNCTION s010_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
         l_n     LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
 
    IF INFIELD(ccz13) OR ( NOT g_before_input_done ) THEN
       IF g_sma.sma104 = 'N' THEN
          CALL cl_set_comp_entry("ccz13",FALSE)
       END IF
    END IF
#wujie 130627 --begin
    IF INFIELD(ccz31) OR ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("ccz32",FALSE)
    END IF
#wujie 130627 --end 
END FUNCTION

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi600.4gl
# Descriptions...: 積分換物設定作業 
# Date & Author..: 08/11/12 By hongmei                                                                                                
# Modify.........: No:FUN-960134 09/07/17 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960134 09/10/21 By dxfwo 市场修改
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-A80022 10/09/15 BY suncx add lpqpos,lprpos已傳POS否
# Modify.........: No:FUN-A90049 10/09/27 By shaoyong 全部抓取ima_file 需調整改為 ima_file 且料件性質='2.商戶料號'
# Modify.........: No:FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0059 10/11/15 By huangtao 添加料號after field 管控
# Modify.........: No:MOD-AC0207 10/12/20 By huangtao 去掉簽核 
# Modify.........: No:TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:FUN-B50011 11/05/04 By shiwuying 单身增加单位和数量
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60077 11/06/09 By baogc 將lpqpos給值 '1'
# Modify.........: No.FUN-B60059 11/06/13 By baogc 將程式由t類改成i類
# Modify.........: No.TQC-B70030 11/07/05 By guoch 兌換積分中唯一判斷去掉，現在做兌換積分和贈品代號不能重復的控管
# Modify.........: No.FUN-B70037 11/07/19 By yangxf lprpos 的預設值須改成 '1'
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode,是另外一組的,在五行以外
# Modify.........: No.FUN-BC0058 11/12/16 By yangxf 加入兌換源類型
# Modify.........: No.FUN-BC0058 11/12/19 By xumm 加入纍計消費的部分
# Modify.........: No:FUN-BB0086 12/01/11 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-C30070 12/03/05 By pauline 單身開窗不可選取到為券的商品
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50137 12/06/05 By pauline 積分換券優化處理
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60089 12/07/23 By pauline 將兌換來源納入PK值
# Modify.........: No.CHI-C80047 12/08/22 By pauline 將卡種納入PK值
# Modify.........: No.FUN-C90067 12/09/26 By pauline 調整單身的PK值,同一兌換方案代碼的積分達/累計消費額+產品編號不可重複
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_lpq           RECORD LIKE lpq_file.*,        
    g_lpq_t         RECORD LIKE lpq_file.*,       
    g_lpq_o         RECORD LIKE lpq_file.*,
    g_lpq01         LIKE lpq_file.lpq01,      
    g_lpq01_t       LIKE lpq_file.lpq01,            
    g_ydate         DATE,                                
    g_lpr           DYNAMIC ARRAY OF RECORD       #
        lpr06       LIKE lpr_file.lpr06,     #TQC-B70030  add
        lpr02       LIKE lpr_file.lpr02,          #積分達
        lpr07       LIKE lpr_file.lpr07,          #纍計消費額       #FUN-BC0058  add
        lpr03       LIKE lpr_file.lpr03,          #贈品編號
        ima02       LIKE ima_file.ima02,          #贈品名稱         #No.FUN-A90049 mod
        ima021       LIKE ima_file.ima021,        #贈品規格
       #FUN-B50011 Begin---
       #ima31       LIKE ima_file.ima31           #贈品金額
        lpr04       LIKE lpr_file.lpr04,
        gfe02       LIKE gfe_file.gfe02,
        lpr05       LIKE lpr_file.lpr05
       #FUN-B50011 End-----
                    END RECORD,
    g_lpr_t         RECORD                        #
        lpr06       LIKE lpr_file.lpr06,     #TQC-B70030 add
        lpr02       LIKE lpr_file.lpr02,
        lpr07       LIKE lpr_file.lpr07,          #FUN-BC0058  add
        lpr03       LIKE lpr_file.lpr03,
        ima02       LIKE ima_file.ima02,
        ima021       LIKE ima_file.ima021,
       #FUN-B50011 Begin---
       #ima31       LIKE ima_file.ima31
        lpr04       LIKE lpr_file.lpr04,
        gfe02       LIKE gfe_file.gfe02,
        lpr05       LIKE lpr_file.lpr05
       #FUN-B50011 End-----
                    END RECORD, 
    g_lpr_o         RECORD                        #
        lpr06       LIKE lpr_file.lpr06,     #TQC-B70030  add
        lpr02       LIKE lpr_file.lpr02,
        lpr07       LIKE lpr_file.lpr07,          #FUN-BC0058  add
        lpr03       LIKE lpr_file.lpr03,
        ima02       LIKE ima_file.ima02,
        ima021       LIKE ima_file.ima021,
       #FUN-B50011 Begin---
       #ima31       LIKE ima_file.ima31
        lpr04       LIKE lpr_file.lpr04,
        gfe02       LIKE gfe_file.gfe02,
        lpr05       LIKE lpr_file.lpr05
       #FUN-B50011 End-----
                    END RECORD,
    g_sql           STRING,                       #CURSOR
    g_wc            STRING,                       #
    g_wc2           STRING,                       #
    g_rec_b         LIKE type_file.num5,          
    l_ac            LIKE type_file.num5          
                                             
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE 
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5  
DEFINE g_argv1             LIKE lpq_file.lpq01 
DEFINE g_argv2             STRING             
DEFINE g_lpr04_t           LIKE lpr_file.lpr04
DEFINE g_lni02             LIKE lni_file.lni02 
DEFINE g_lpq03_t           LIKE lpq_file.lpq03   #CHI-C80047 add
MAIN
    OPTIONS                             
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                
   LET g_argv1 = ARG_VAL(1)       #FUN-BC0058 ADD

   #FUN-BC0058-----add-----str----
   IF cl_null(g_argv1) THEN 
      LET g_argv1 = '0' 
      LET g_lni02 = '3'   #FUN-C60089 add
   END IF  
   IF g_argv1 = '1' THEN
      LET g_prog = "almi601"
      LET g_lni02 = '4'   #FUN-C60089 add
   END IF
   #FUN-BC0058-----add-----end----

  #FUN-C60089 add START
   IF g_argv1 = '0' THEN
      LET g_lpq.lpq00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lpq.lpq00 = '1'
      END IF
   END IF
  #FUN-C60089 add END

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM lpq_file WHERE lpq00 = '",g_lpq.lpq00,"' AND lpq01 = ? ",  #FUN-C60089 add lpq00
                      "                         AND lpq13 = ? AND lpq03 = ? FOR UPDATE"  #FUN-C50137 add lpq13  #CHI-C80047 add lpq03
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i600_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i600_w WITH FORM "alm/42f/almi600"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   #TQC-B30004 ------mark begin---------------
   ##FUN-A80022 --------------------add start-----------------------------
   #IF g_aza.aza88 = 'Y' THEN
   #   CALL cl_set_comp_visible("lpqpos",TRUE)
   # ELSE
   #   CALL cl_set_comp_visible("lpqpos",FALSE)
   # END IF
   # #FUN-A80022 ----------------add end by vealxu ----------------------
   #TQC-B30004 ------mark--end----------------
   CALL cl_set_comp_visible("lpqpos",FALSE)  #TQC-B30004 add
   #FUN-BC0058 add begin ---
   IF g_argv1 = '0' THEN
      CALL cl_set_comp_visible("lpq12,lpr07",FALSE)
   END IF  
   IF g_argv1 = '1' THEN
      CALL cl_set_comp_visible("lpr02",FALSE)
   END IF
   #FUN-BC0058 add end -----

   DISPLAY BY NAME g_lpq.lpq00   #FUN-C60089 add

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL i600_menu()
   CLOSE WINDOW i600_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i600_cs()
 
 CLEAR FORM          
 CALL g_lpr.clear()  
   #FUN-BC0058 ---begin---
   IF g_argv1 = '0' THEN
      LET g_lpq.lpq00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lpq.lpq00 = '1'
      END IF
   END IF
   DISPLAY BY NAME g_lpq.lpq00
   #FUN-BC0058 ---END --- 
#   CONSTRUCT BY NAME g_wc ON lpqplant,lpqlegal,lpq01,lpq02,lpq03,lpq04,lpq05,lpq06,lpqpos,#FUN-A80022 add lpqpos 
#                             lpq07,lpq08,lpq09,lpq10,lpq11,
#   CONSTRUCT BY NAME g_wc ON lpqplant,lpqlegal,lpq01,lpq02,lpq03,lpq04,lpq05,           #MOD-AC0207 #FUN-B50042 remove POS #FUN-BC0058 MARK
#   CONSTRUCT BY NAME g_wc ON lpq01,lpq02,lpq03,lpq04,lpq05,                             #FUN-BC0058 #FUN-BC0058 mark
    CONSTRUCT BY NAME g_wc ON lpq13,lpq01,lpq02,lpq14,lpq03,lpq04,lpq05,                 #FUN-C50137 add lpq13,lpq14
                              lpq12,lpq17,lpq18,lpq08,lpq09,lpq10,                       #FUN-C50137 add lpq17,lpq18
                              lpq15,lpq16,lpq11,                                         #MOD-AC0207 #FUN-C50137 add lpq15,lpq16 
                              lpqplant,lpqlegal,                                         #FUN-BC0058 add lpqplant,lpqlegal
                              lpquser,lpqgrup,lpqoriu,lpqorig,lpqcrat,lpqmodu,lpqdate,lpqacti
      ON ACTION controlp
         CASE
          #add START
           WHEN INFIELD(lpq13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpq13"
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lpq13
              NEXT FIELD lpq13
          #add END
           WHEN INFIELD(lpqplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpqplant"
              LET g_qryparam.state = "c"              
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lpqplant
              NEXT FIELD lpqplant                     
      
           WHEN INFIELD(lpqlegal)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpqlegal"
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lpqlegal
              NEXT FIELD lpqlegal
            WHEN INFIELD(lpq01)   #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpq01"
               LET g_qryparam.arg1= g_argv1
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpq01
               NEXT FIELD lpq01
            WHEN INFIELD(lpq03)   #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpq03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpq03
               CALL i600_lpq03('d')
               NEXT FIELD lpq03
            WHEN INFIELD(lpq09)  #審核人
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpq09"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpq09
               NEXT FIELD lpq09    
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpquser', 'lpqgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN       
   #      LET g_wc = g_wc clipped," AND lpquser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN      
   #      LET g_wc = g_wc clipped," AND lpqgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
      CONSTRUCT g_wc2 ON lpr02,lpr07,lpr03,lpr04,lpr05  #FUN-B50011    #FUN-BA0058 add lpr07 
           FROM s_lpr[1].lpr02,s_lpr[1].lpr07,s_lpr[1].lpr03,s_lpr[1].lpr04,s_lpr[1].lpr05 #FUN-B50011  #FUN-BA0058 add lpr07
      ON ACTION CONTROLP 
         CASE 
           WHEN INFIELD(lpr03)  #贈品編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
#             LET g_qryparam.form ="q_lmu"     #mark by hellen 090709
              LET g_qryparam.form ="q_lpr03"   #add by hellen 090709
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lpr03
              NEXT FIELD lpr03
          #FUN-B50011 Begin---
           WHEN INFIELD(lpr04)  #贈品編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form ="q_lpr04"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lpr04
              NEXT FIELD lpr04
           #FUN-B50011 End-----
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION about
            CALL cl_about() 
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
 
   #FUN-BC0058 ---begin--
   LET g_wc = " lpq00 = '",g_lpq.lpq00,"' AND ",g_wc CLIPPED
   #FUN-BC0058 ---end---
   IF g_wc2 = " 1=1" THEN     
      LET g_sql = "SELECT lpq01,lpq13,lpqplant,lpq03 FROM lpq_file ",  #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
                  " WHERE ", g_wc CLIPPED,
                  "   AND lpqplant = '",g_plant,"' ",   #FUN-C60089 add
                  " ORDER BY lpq01"
   ELSE                      
      LET g_sql = "SELECT UNIQUE lpq01,lpq13,lpqplant,lpq03  ",       #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
                  "  FROM lpq_file, lpr_file ",
                  " WHERE lpq01 = lpr01 ",
                  "   AND lpq00 = lpr00 ",    #FUN-C60089 add
                  "   AND lpq03 = lpr09 ",    #CHI-C80047 add
                  "   AND lpqplant = lprplant ",          #FUN-C60089 add
                  "   AND lpqplant = '",g_plant,"' ",     #FUN-C60089 add
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lpq01"
   END IF
 
   PREPARE i600_prepare FROM g_sql
   DECLARE i600_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i600_prepare
 
   IF g_wc2 = " 1=1" THEN   
      LET g_sql=" SELECT COUNT(*) FROM lpq_file ", 
                "   WHERE ",g_wc CLIPPED,
                "   AND lpqplant = '",g_plant,"' "      #FUN-C60089 add
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lpq01) FROM lpq_file,lpr_file WHERE ",
                " lpr01=lpq01 ",
                " AND lpq00 = lpr00 ",  #FUN-C60089 add
                " AND lpq03 = lpr09 ",  #CHI-C80047 add
                " AND lpqplant = lprplant ",          #FUN-C60089 add
                " AND lpqplant = '",g_plant,"' ",     #FUN-C60089 add
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i600_precount FROM g_sql
   DECLARE i600_count CURSOR FOR i600_precount
 
END FUNCTION
 
FUNCTION i600_menu()
   DEFINE l_str  LIKE type_file.chr1000
   DEFINE l_msg  LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i600_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i600_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i600_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i600_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i600_x()
            END IF

        #FUN-C50137 add START 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i600_copy()
            END IF
        #FUN-C50137 add END

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
#         WHEN "output"                                                        
#            IF cl_chk_act_auth() THEN
#               CALL i600_out()
#            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpq),'','')
            END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
  #      WHEN "ef_approval"   #簽核
  #         IF cl_chk_act_auth() THEN
  #            CALL i600_ef()
  #         END IF 
                       
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i600_y()
            END IF
         
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i600_z()
           END IF

         WHEN "category"
           IF cl_chk_act_auth() THEN
              IF g_lpq.lpq01 IS NULL THEN
                 CALL cl_err('',-400,0)
              ELSE
                #LET l_msg = "almi553  '",g_lpq.lpq01 CLIPPED,"'  '2' '",g_lpq.lpq13 CLIPPED,"' "   #FUN-C60089 mark
                 LET l_msg = "almi553  '",g_lpq.lpq01 CLIPPED,"'  '",g_lni02 CLIPPED,"' '",g_lpq.lpq13 CLIPPED,"' '",g_lpq.lpq03 CLIPPED,"' "   #FUN-C60089 add  #CHI-C80047 add lpq03
                 CALL cl_cmdrun_wait(l_msg)
              END IF
           END IF

       #FUN-C50137 add START
         WHEN "issued"
           IF cl_chk_act_auth() THEN
              CALL i600_iss()
           END IF
       #FUN-C50137 add END

      #  WHEN "volid"
      #    IF cl_chk_act_auth() THEN
      #       CALL i600_v()
      #    END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("ACCEPT,cancel", FALSE)
   DISPLAY ARRAY g_lpr TO s_lpr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
#      ON ACTION output                                                          
#           LET g_action_choice="output"                                           
#           EXIT DISPLAY
           
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION previous
         CALL i600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION jump
         CALL i600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION next
         CALL i600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION last
         CALL i600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
#     ON ACTION reproduce
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
  #   ON ACTION ef_approval    #簽核 
  #      LET g_action_choice="ef_approval"
  #      IF cl_chk_act_auth() THEN
  #         CALL i600_ef()
  #      END IF
          
      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i600_y()
         END IF 
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i600_z()
         END IF

      ON ACTION category
         LET g_action_choice = "category"
         EXIT DISPLAY

   #  ON ACTION volid
   #     LET g_action_choice="volid"
   #     IF cl_chk_act_auth() THEN
   #        CALL i600_v()
   #     END IF   
     #FUN-C50137 add START
      ON ACTION issued
         LET g_action_choice = "issued"
         EXIT DISPLAY 

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY 
     #FUN-C50137 add END
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i600_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_lpr.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lpq.* LIKE lpq_file.*    
   LET g_lpq01_t = NULL
 
   LET g_lpq.lpq08 = 'N'
   LET g_lpq_t.* = g_lpq.*
   LET g_lpq_o.* = g_lpq.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      #FUN-BC0058 ---begin---
      IF g_argv1 = '0' THEN
         LET g_lpq.lpq00 = '0'
         LET g_lpq.lpq12 = ' '
      ELSE
         IF g_argv1 = '1' THEN
            LET g_lpq.lpq00 = '1'
            LET g_lpq.lpq12 = '0'
         END IF
      END IF
      #FUN-BC0058 ---END---
      LET g_lpq.lpq06='N'
      LET g_lpq.lpq07='0'
      LET g_lpq.lpq08='N'
      #LET g_lpq.lpqpos = 'N'        #FUN-A80022 add by vealxu #FUN-B50042 mark
      LET g_lpq.lpqpos = '1'         #MOD-B60077 ADD
      LET g_lpq.lpqplant = g_plant
      LET g_lpq.lpqlegal = g_legal
      LET g_data_plant = g_plant    #No.FUN-A10060
      LET g_lpq.lpqoriu = g_user    #No.FUN-A10060
      LET g_lpq.lpqorig = g_grup    #No.FUN-A10060
      LET g_lpq.lpquser=g_user
      LET g_lpq.lpqcrat=g_today
      LET g_lpq.lpqgrup=g_grup
#     LET g_lpq.lpqdate=g_today
      LET g_lpq.lpqacti='Y' 
     #FUN-C50137 add START
      LET g_lpq.lpq13 = g_plant      #制定營運中心
      LET g_lpq.lpq14 = 0            #版本號
      LET g_lpq.lpq15 = 'N'          #發佈否
      LET g_lpq.lpq17 = '1'          #兌換限制
      LET g_lpq.lpq18 = 0            #兌換次數
      CALL i600_lpq13()
     #FUN-C50137 add END
      CALL i600_i("a")  
 
      IF INT_FLAG THEN 
         INITIALIZE g_lpq.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lpq.lpq01) THEN  
         CONTINUE WHILE
      END IF
 
      LET g_lpq.lpqoriu = g_user      #No.FUN-980030 10/01/04
      LET g_lpq.lpqorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO lpq_file VALUES (g_lpq.*)
 
      IF SQLCA.sqlcode THEN        
      #   ROLLBACK WORK       # FUN-B80060 下移兩行
         CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,1)  
         ROLLBACK WORK       # FUN-B80060 
         CONTINUE WHILE
      ELSE
         COMMIT WORK         
         CALL cl_flow_notify(g_lpq.lpq01,'I')
      END IF
 
     #SELECT lpq01 INTO g_lpq.* FROM lpq_file   #FUN-C60089 mark
      SELECT * INTO g_lpq.* FROM lpq_file       #FUN-C60089 add
       WHERE lpq01 = g_lpq.lpq01
         AND lpq00 = g_lpq.lpq00   #FUN-C60089 add 
         AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
         AND lpq13 = g_lpq.lpq13   #FUN-C50137 add
         AND lpqplant = g_plant    #FUN-C60089 add
      LET g_lpq01_t = g_lpq.lpq01   
      LET g_lpq_t.* = g_lpq.*
      LET g_lpq_o.* = g_lpq.*
      CALL g_lpr.clear()
 
      LET g_rec_b = 0  
      CALL i600_b() 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i600_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpq.lpq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lpq.* FROM lpq_file
    WHERE lpq01=g_lpq.lpq01
      AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13    #FUN-C60089 add
      AND lpq03 = g_lpq.lpq03    #CHI-C80047 add
      AND lpqplant = g_plant     #FUN-C60089 add
     #AND lpq01=g_lpq.lpq13  #FUN-C50137 add  #FUN-C60089 mark
 
   IF g_lpq.lpqacti ='N' THEN  
      CALL cl_err(g_lpq.lpq01,'mfg1000',0)
      RETURN
   END IF
    IF g_lpq.lpq08 = 'Y' OR g_lpq.lpq08 = 'X' THEN 
       CALL cl_err('',9022,0) 
       RETURN 
    END IF
  #FUN-C50137 add START
   IF g_plant <> g_lpq.lpq13 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF  
  #FUN-C50137 add END
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lpq01_t = g_lpq.lpq01
   LET g_lpq03_t = g_lpq.lpq03   #CHI-C80047 add
   BEGIN WORK
 
   OPEN i600_cl USING g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpq03   #FUN-C50137 add lpq13  #CHI-C80047 add lpq03
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i600_cl INTO g_lpq.* 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,0) 
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i600_show()
 
   WHILE TRUE
      LET g_lpq01_t = g_lpq.lpq01
      LET g_lpq_o.* = g_lpq.*
      LET g_lpq.lpqmodu=g_user
      LET g_lpq.lpqdate=g_today
      IF g_lpq.lpq07 MATCHES '[Ss11WwRr]' THEN 
         LET g_lpq.lpq07 = '0'
      END IF  
      CALL i600_i("u")  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lpq.*=g_lpq_t.*
         CALL i600_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lpq.lpq01 != g_lpq01_t THEN    
         UPDATE lpr_file SET lpr01 = g_lpq.lpq01
          WHERE lpr01 = g_lpq01_t
            AND lpr00 = g_lpq.lpq00    #FUN-C60089 add
            AND lpr08 = g_lpq_o.lpq13     #FUN-C50137 add
            AND lpr09 = g_lpq03_t         #CHI-C80047 add
            AND lprplant = g_plant        #FUN-C60089 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lpr_file",g_lpq01_t,"",SQLCA.sqlcode,"","lpr",1) 
            CONTINUE WHILE
         END IF
      END IF
     #CHI-C80047 add START
      IF g_lpq.lpq03 <> g_lpq03_t THEN
         UPDATE lpr_file 
            SET lpr09 = g_lpq.lpq03
          WHERE lpr00 = g_lpq.lpq00
            AND lpr01 = g_lpq01_t
            AND lpr08 = g_lpq.lpq13  
            AND lpr09 = g_lpq03_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpr_file",g_lpq01_t,"",SQLCA.sqlcode,"","lpr",1)
            CONTINUE WHILE
         END IF
         UPDATE lni_file
            SET lni15 = g_lpq.lpq03
          WHERE lni01 = g_lpq01_t
            AND lni02 = g_lni02
            AND lni14 = g_lpq.lpq13
            AND lni15 = g_lpq03_t
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lpq_file",g_lpq01_t,"",SQLCA.sqlcode,"","lpq",1)
            CONTINUE WHILE
         END IF
      END IF
     #CHI-C80047 add END
 
      #FUN-A80022 ------------add start-----------------
      #IF g_aza.aza88 = 'Y' THEN         #FUN-B50042 mark 
      #   LET g_lpq.lpqpos = 'N'         #FUN-B50042 mark
      #   DISPLAY g_lpq.lpqpos TO lpqpos #FUN-B50042 mark
      #END IF                            #FUN-B50042 mark
      #FUN-A80022 ------------add end by vealxu -------------  
      UPDATE lpq_file SET lpq_file.* = g_lpq.*
       WHERE lpq01 = g_lpq01_t
         AND lpq00 = g_lpq.lpq00    #FUN-C60089 add
         AND lpq03 = g_lpq03_t      #CHI-C80047 add
         AND lpq13 = g_lpq_o.lpq13  #FUN-C50137 add
         AND lpqplant = g_plant     #FUN-C60089 add
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lpq_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lpq.lpq01,'U')
 
END FUNCTION
 
FUNCTION i600_i(p_cmd)
 
DEFINE l_n,l_n1    LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr8  
DEFINE li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lpq.lpqplant,g_lpq.lpqlegal,g_lpq.lpq01,g_lpq.lpq02,g_lpq.lpq03,
                   g_lpq.lpq04,g_lpq.lpq05,g_lpq.lpq00,                    #FUN-BC0058 add lpq00
 #                  g_lpq.lpq06,g_lpq.lpqpos,g_lpq.lpq07,g_lpq.lpq08,      #FUN-A80022 add lpqpos    #MOD-AC0207 mark
                   g_lpq.lpq12,g_lpq.lpq08,                                #MOD-AC0207 #FUN-B50042 remove POS   #FUN-BC0058 add lpq12
                   g_lpq.lpq09,g_lpq.lpq10,g_lpq.lpq11,
                   g_lpq.lpquser,g_lpq.lpqcrat,g_lpq.lpqmodu,
                   g_lpq.lpqgrup,g_lpq.lpqdate,g_lpq.lpqacti,
                   g_lpq.lpqoriu,g_lpq.lpqorig,
                   g_lpq.lpq13,g_lpq.lpq14,g_lpq.lpq15,g_lpq.lpq16,        #FUN-C50137 add
                   g_lpq.lpq17,g_lpq.lpq18                                 #FUN-C50137 add
 
   INPUT BY NAME  #g_lpq.lpq01,g_lpq.lpq02,g_lpq.lpq03,                   #FUN-C50137 mark
                   g_lpq.lpq01,g_lpq.lpq03,                               #FUN-C50137 add 
                   g_lpq.lpq04,g_lpq.lpq05,
                   g_lpq.lpq17,g_lpq.lpq18,                               #FUN-C50137 add
 #                 g_lpq.lpq06,g_lpq.lpqpos,g_lpq.lpq07,g_lpq.lpq08,      #FUN-A80022 add lpqpos     #MOD-AC0207 mark
                   g_lpq.lpq12,g_lpq.lpq08,                               #MOD-AC0207 #FUN-B50042 remove POS   #FUN-BC0058 add lpq12
                   g_lpq.lpq09,g_lpq.lpq10,g_lpq.lpq11,
                   g_lpq.lpquser,g_lpq.lpqcrat,g_lpq.lpqmodu,
                   g_lpq.lpqgrup,g_lpq.lpqdate,g_lpq.lpqacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i600_set_entry(p_cmd)
         CALL i600_set_no_entry(p_cmd)
         CALL i600_entry_lpq17()
         CALL i600_lpqplant()
         LET g_before_input_done = TRUE
         #LET g_lpq.lpqpos = 'N'    #FUN-A80022 add 已傳POS否
 
      AFTER FIELD lpq01
         #CHI-C80047 mark START
         #IF cl_null(g_lpq.lpq01) THEN
         #   CALL cl_err('','alm-809',0)
         #   NEXT FIELD lpq01
         #END IF
         #CHI-C80047 mark END
          IF g_lpq.lpq01 IS NOT NULL THEN
             LET l_n = 0      #CHI-C80047 add 
             IF p_cmd="a" OR (p_cmd="u" AND g_lpq.lpq01 !=g_lpq01_t) THEN
                IF NOT cl_null(g_lpq.lpq03) THEN   #CHI-C80047 add
                   SELECT COUNT(*) INTO l_n FROM lpq_file
                    WHERE lpq01 = g_lpq.lpq01
                      AND lpq00 = g_lpq.lpq00  #FUN-C60089 add
                      AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
                      AND lpq13 = g_lpq.lpq13  #FUN-C50137 add
                      AND lpqplant = g_plant   #FUN-C60089 add  
                END IF                             #CHI-C80047 add
                IF l_n>0 THEN
                   CALL cl_err(g_lpq.lpq01,-239,0)
                   NEXT FIELD lpq01
                END IF
               #FUN-C50137 add START
                CALL i600_lpq01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lpq01
                END IF
               #FUN-C50137 add END
             END IF
          END IF
          
   #   AFTER FIELD lpq02
   #      IF cl_null(g_lpq.lpq02) THEN 
   #         CALL cl_err('','alm-809',0)
   #         NEXT FIELD lpq02 
   #      END IF 
                                                                                
      AFTER FIELD lpq03
         IF cl_null(g_lpq.lpq03) THEN
            DISPLAY '' TO FORMONLY.lph02  
            CALL cl_err('','alm-809',0)
            NEXT FIELD lpq03
         ELSE          
            SELECT COUNT(*) INTO l_n1 FROM lph_file
                WHERE lph01 = g_lpq.lpq03
            IF l_n1=0 THEN
              #CALL cl_err(g_lpq.lpq03,'alm-802',0) #TQC-C30070 mark
               CALL cl_err(g_lpq.lpq03,'alm-h46',0) #TQC-C30070 
               NEXT FIELD lpq03
            END IF
           #CHI-C80047 add START
             LET l_n = 0 
             IF p_cmd="a" OR (p_cmd="u" AND g_lpq.lpq03 !=g_lpq03_t) THEN
                IF NOT cl_null(g_lpq.lpq01) THEN
                   SELECT COUNT(*) INTO l_n FROM lpq_file
                    WHERE lpq01 = g_lpq.lpq01
                      AND lpq00 = g_lpq.lpq00  
                      AND lpq03 = g_lpq.lpq03  
                      AND lpq13 = g_lpq.lpq13  
                      AND lpqplant = g_plant   
                END IF
                IF l_n>0 THEN
                   CALL cl_err(g_lpq.lpq01,-239,0)
                   NEXT FIELD lpq03
                END IF
            END IF 
           #CHI-C80047 add END
            CALL i600_lpq03(p_cmd) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lpq03
            END IF
         END IF
      
      AFTER FIELD lpq04
         IF cl_null(g_lpq.lpq04) THEN
            CALL cl_err('','alm-809',0)
            NEXT FIELD lpq04
         ELSE           
            IF g_lpq.lpq04 < g_today THEN 
               CALL cl_err('','alm-804',0)
               NEXT FIELD lpq04
            END IF 
         END IF 
      
      AFTER FIELD lpq05
         IF cl_null(g_lpq.lpq05) THEN
            CALL cl_err('','alm-809',0)
            NEXT FIELD lpq05
         ELSE                            
            IF g_lpq.lpq05 < g_lpq.lpq04 THEN 
               CALL cl_err('','alm-805',0)
               NEXT FIELD lpq05
            END IF 
         END IF

     #FUN-C50085 add START
      ON CHANGE lpq17
         CALL i600_entry_lpq17()
         IF g_lpq.lpq17 <> '1' THEN
            IF g_lpq.lpq18 < 1 THEN
               CALL cl_err('','aec-042',0)
               NEXT FIELD lpq18
            END IF
         ELSE
            LET g_lpq.lpq18 = 0
            DISPLAY BY NAME g_lpq.lpq18
         END IF
     
      AFTER FIELD lpq18
         IF NOT cl_null(g_lpq.lpq18) THEN
            IF g_lpq.lpq17 <> '1' THEN
               IF g_lpq.lpq18 < 1 THEN
                  CALL cl_err('','aec-042',0)
                  NEXT FIELD lpq18
               END IF
            END IF
         END IF
     #FUN-C50085 add END
       
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF   
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
 
      ON ACTION controlp
         CASE                                                              
           #FUN-C50137 add START
            WHEN INFIELD(lpq01) #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lsl02"
               LET g_qryparam.arg1 = g_plant
               LET g_qryparam.default1 = g_lpq.lpq01
               CALL cl_create_qry() RETURNING g_lpq.lpq01
               DISPLAY g_lpq.lpq01 TO lpq01
               CALL i600_lpq01('a')
               NEXT FIELD lpq01 
           #FUN-C50137 add END
            WHEN INFIELD(lpq03) #卡種編號
               CALL cl_init_qry_var()                                     
#              LET g_qryparam.form ="q_lph01"   #mark by hellen 090709                          
#              LET g_qryparam.form ="q_lph01_1"   #add by hellen 090709  #No.FUN-960134 mark                          
               LET g_qryparam.form ="q_lph01_2"   #No.FUN-960134 
               LET g_qryparam.default1 = g_lpq.lpq03                      
               CALL cl_create_qry() RETURNING g_lpq.lpq03                 
               DISPLAY g_lpq.lpq03 TO lpq03 
               CALL i600_lpq03('d')                               
               NEXT FIELD lpq03
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION i600_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lpr.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i600_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lpq.* TO NULL
      RETURN
   END IF
 
   OPEN i600_cs  
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lpq.* TO NULL
   ELSE
      OPEN i600_count
      FETCH i600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i600_fetch('F')   
   END IF
 
END FUNCTION
 
FUNCTION i600_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1   
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i600_cs INTO g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpqplant,g_lpq.lpq03       #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
      WHEN 'P' FETCH PREVIOUS i600_cs INTO g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpqplant,g_lpq.lpq03       #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
      WHEN 'F' FETCH FIRST    i600_cs INTO g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpqplant,g_lpq.lpq03       #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
      WHEN 'L' FETCH LAST     i600_cs INTO g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpqplant,g_lpq.lpq03       #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i600_cs INTO g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpqplant,g_lpq.lpq03    #FUN-C50137 add lpq13,lpqplant  #CHI-C80047 add lpq03
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,0)
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
   END IF
 
   SELECT * INTO g_lpq.* FROM lpq_file 
     WHERE lpq01 = g_lpq.lpq01
       AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
       AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
       AND lpq13 = g_lpq.lpq13 
       AND lpqplant = g_lpq.lpqplant 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lpq_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lpq.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lpq.lpquser       
   LET g_data_group = g_lpq.lpqgrup       
   LET g_data_plant = g_lpq.lpqplant  #No.FUN-A10060
   CALL i600_show()
 
END FUNCTION
 
FUNCTION i600_show()
   LET g_lpq_t.* = g_lpq.* 
   LET g_lpq_o.* = g_lpq.*  
   DISPLAY BY NAME g_lpq.lpqplant,g_lpq.lpqlegal,g_lpq.lpq01,g_lpq.lpq02,g_lpq.lpq03,
                   g_lpq.lpq04,g_lpq.lpq05,g_lpq.lpq00,                      #FUN-BC0058 add lpq00  
  #                 g_lpq.lpq06,g_lpq.lpqpos,g_lpq.lpq07,g_lpq.lpq08,        #FUN-A80022 add lpqpos   #MOD-AC0207 mark
                   g_lpq.lpq12,g_lpq.lpq08,                                  #MOD-AC0207 #FUN-B50042 remove POS  #FUN-BC0058 add lpq12
                   g_lpq.lpq09,g_lpq.lpq10,g_lpq.lpq11, 
                   g_lpq.lpquser,g_lpq.lpqgrup,
                   g_lpq.lpqcrat,g_lpq.lpqmodu,
                   g_lpq.lpqdate,g_lpq.lpqacti,g_lpq.lpqoriu,g_lpq.lpqorig,
                   g_lpq.lpq13,g_lpq.lpq14,g_lpq.lpq15,g_lpq.lpq16,           #FUN-C50137 add
                   g_lpq.lpq17,g_lpq.lpq18                                    #FUN-C50137 add
   CALL i600_lpq13()       #FUN-C50137 add
   CALL i600_lpqplant()   
   CALL i600_lpq01('d')
   CALL i600_lpq03('d')
   CALL i600_b_fill(g_wc2)  
   CALL i600_field_pic()
END FUNCTION
 
FUNCTION i600_x()
DEFINE l_n      LIKE type_file.num5   #FUN-C50137  add 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpq.lpq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lpq.lpq08 != 'N' THEN CALL cl_err('',9065,0) RETURN END IF
   BEGIN WORK

  #FUN-C50137 add START
   IF g_plant <> g_lpq.lpq13 THEN 
      CALL cl_err('','art-977',0)
      RETURN 
   END IF
   IF g_lpq.lpqacti='Y' THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lpq_file
        WHERE lpq01 = g_lpq.lpq01 AND lpq08 = 'Y'
          AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
          AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
          AND lpqplant = g_plant    #FUN-C60089 add
          AND lpqacti = 'Y'
      IF l_n > 0 THEN
         CALL cl_err('','alm-h40',0)
         RETURN
      END IF
   END IF
  #FUN-C50137 add END
 
   OPEN i600_cl USING g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpq03    #FUN-C50137 add lpq13  #CHI-C80047 add lpq03
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i600_cl INTO g_lpq.*     
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,0)   
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i600_show()
 
   IF cl_exp(0,0,g_lpq.lpqacti) THEN  
      LET g_chr=g_lpq.lpqacti
      IF g_lpq.lpqacti='Y' THEN
         LET g_lpq.lpqacti='N'
      ELSE
         LET g_lpq.lpqacti='Y'
      END IF
 
      UPDATE lpq_file SET lpqacti=g_lpq.lpqacti,
                          lpqmodu=g_user,
                          lpqdate=g_today
       WHERE lpq01=g_lpq.lpq01
         AND lpq00 = g_lpq.lpq00  #FUN-C60089 add
         AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
        #AND lpr08 = g_lpq.lpq13  #FUN-C50137 add  #FUN-C60089 mark
         AND lpq13 = g_lpq.lpq13  #FUN-C60089 add
         AND lpqplant = g_plant   #FUN-C60089 add
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lpq_file",g_lpq.lpq01,"",SQLCA.sqlcode,"","",1)  
         LET g_lpq.lpqacti=g_chr
      END IF
   END IF
 
   CLOSE i600_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lpq.lpq01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lpqacti,lpqmodu,lpqdate,lpqcrat
     INTO g_lpq.lpqacti,g_lpq.lpqmodu,g_lpq.lpqdate,g_lpq.lpqcrat
     FROM lpq_file
    WHERE lpq01=g_lpq.lpq01
      AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
      AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
      AND lpq13 = g_lpq.lpq13   #FUN-C50137 add
      AND lpqplant = g_plant    #FUN-C60089 add
   DISPLAY BY NAME g_lpq.lpqacti,g_lpq.lpqmodu,g_lpq.lpqdate,g_lpq.lpqcrat
   CALL i600_field_pic() 
END FUNCTION
 
FUNCTION i600_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lpq.lpq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lpq.* FROM lpq_file
    WHERE lpq01=g_lpq.lpq01
      AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
      AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
      AND lpq13 = g_lpq.lpq13   #FUN-C50137 add
      AND lpqplant = g_plant    #FUN-C60089 add
   IF g_lpq.lpqacti ='N' THEN  
      CALL cl_err(g_lpq.lpq01,'mfg1000',0)
      RETURN
   END IF
   IF g_lpq.lpq07 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
   END IF 
   IF g_lpq.lpq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_lpq.lpq08 = 'X' THEN CALL cl_err('',9028,0) RETURN END IF
 
   BEGIN WORK
 
   OPEN i600_cl USING g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpq03    #FUN-C50137 add lpq13  #CHI-C80047 lpq03
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i600_cl INTO g_lpq.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,0)    
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i600_show()
 
   IF cl_delh(0,0) THEN     
      DELETE FROM lpq_file 
       WHERE lpq01 = g_lpq.lpq01
         AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
         AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
         AND lpq13 = g_lpq.lpq13   #FUN-C50137 add 
         AND lpqplant = g_plant    #FUN-C60089 add
      DELETE FROM lpr_file 
       WHERE lpr01 = g_lpq.lpq01
         AND lpr00 = g_lpq.lpq00      #FUN-C60089 add
         AND lpr08 = g_lpq.lpq13      #FUN-C50137 add  
         AND lpr09 = g_lpq.lpq03      #CHI-C80047 add
         AND lprplant = g_plant       #FUN-C60089 add
      DELETE FROM lni_file            #FUN-C50137 add 
       WHERE lni01 = g_lpq.lpq01      #FUN-C50137 add
        #AND lni02 = '2'              #FUN-C50137 add  #FUN-C60089 mark
         AND lni02 = g_lni02          #FUN-C60089 add
         AND lni14 = g_lpq.lpq13      #FUN-C50137 add 
         AND lni15 = g_lpq.lpq03      #CHI-C80047 add
         AND lniplant = g_plant       #FUN-C60089 add
      CLEAR FORM
      CALL g_lpr.clear()
      OPEN i600_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i600_cs
         CLOSE i600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i600_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i600_cs
         CLOSE i600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i600_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i600_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i600_fetch('/')
      END IF
   END IF
 
   CLOSE i600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lpq.lpq01,'D')
 
END FUNCTION
 
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,  
    l_n,l_n1,l_n2   LIKE type_file.num5, 
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
#DEFINE l_lprpos     LIKE lpr_file.lprpos                #NO.FUN-A80022 已傳POS否    
DEFINE l_rtz04_except LIKE type_file.num5         #營運中心是否尋在商品策略  #TQC-C30070 add 
DEFINE l_rtz04      LIKE rtz_file.rtz04           #商品策略   #TQC-C30070 add
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lpq.lpq01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_lpq.* FROM lpq_file
     WHERE lpq01=g_lpq.lpq01
       AND lpq00 = g_lpq.lpq00  #FUN-C60089 add
       AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
       AND lpq13 = g_lpq.lpq13  #FUN-C50137 add
       AND lpqplant = g_plant   #FUN-C60089 add
 
    IF g_lpq.lpqacti ='N' THEN   
       CALL cl_err(g_lpq.lpq01,'mfg1000',0)
       RETURN
    END IF
    IF g_lpq.lpq08 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lpq.lpq08 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   #FUN-C50137 add START
    IF g_plant <> g_lpq.lpq13 THEN 
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   #FUN-C50137 add END
 
    CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT lpr02,lpr03,'','','' ",          #FUN-B50011
    LET g_forupd_sql = "SELECT lpr06,lpr02,lpr07,lpr03,'','',lpr04,'',lpr05 ", #FUN-B50011  #TQC-B70030 add lpr06   #FUN-BC0058 add lpr07
                       "  FROM lpr_file",
                       " WHERE lpr00 = '",g_lpq.lpq00,"' AND lpr01=? AND lpr06=?  ",  #FUN-C60089 add lpq00
                       "   AND lpr08 = '",g_lpq.lpq13,"' AND lpr09 = '",g_lpq.lpq03,"' FOR UPDATE"  #FUN-C50137 add lpr08  #CHI-C80047 add lpr09
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_lpr WITHOUT DEFAULTS FROM s_lpr.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_lpr04_t = NULL   #No.FUN-BB0086
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i600_cl USING g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpq03    #FUN-C50137 add lpq13  #CHI-C80047 add lpq03
           IF STATUS THEN
              CALL cl_err("OPEN i600_cl:", STATUS, 1)
              CLOSE i600_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i600_cl INTO g_lpq.*     
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lpq.lpq01,SQLCA.sqlcode,0)   
              CLOSE i600_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lpr_t.* = g_lpr[l_ac].*  #BACKUP
              LET g_lpr_o.* = g_lpr[l_ac].*  #BACKUP
              LET g_lpr04_t = g_lpr[l_ac].lpr04   #No.FUN-BB0086 
       #       OPEN i600_bcl USING g_lpq.lpq01,g_lpr[l_ac].lpr02  #TQC-B70030  mark
              OPEN i600_bcl USING g_lpq.lpq01,g_lpr[l_ac].lpr06  #TQC-B70030
              IF STATUS THEN
                 CALL cl_err("OPEN i600_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i600_bcl INTO g_lpr[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lpq.lpq02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                #FUN-B50011 Begin---
                #SELECT ima02,ima021,ima31 INTO g_lpr[l_ac].ima02,
                #                              g_lpr[l_ac].ima021,
                #                              g_lpr[l_ac].ima31
                 SELECT ima02,ima021 INTO g_lpr[l_ac].ima02,
                                          g_lpr[l_ac].ima021
                #FUN-B50011 End-----
                    FROM ima_file WHERE ima01=g_lpr[l_ac].lpr03
              END IF
              CALL i600_set_entry_b(p_cmd)     
              CALL i600_lpr04('d') #FUN-B50011
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lpr[l_ac].* TO NULL
           #LET l_lprpos = 'N'      #NO.FUN-A80022 已傳POS否的值為'N'      
           #FUN-BC0058  add begin ---
           IF g_argv1 = '0' THEN
              LET g_lpr[l_ac].lpr07 = 0 
           END IF 
           IF g_argv1 = '1' THEN
              LET g_lpr[l_ac].lpr02 = 0
           END IF
           #FUN-BC0058  add end -----
           LET g_lpr_t.* = g_lpr[l_ac].*    
           LET g_lpr_o.* = g_lpr[l_ac].*   
           LET g_lpr04_t = g_lpr[l_ac].lpr04   #No.FUN-BB0086
           CALL i600_set_entry_b(p_cmd)
          # NEXT FIELD lpr02   #TQC-B70030 mark
           NEXT FIELD lpr06   #TQC-B70030
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lpr_file(lprplant,lprlegal,lpr00,lpr01,lpr02,lpr03,lpr04,lpr05,lpr06,     #FUN-B50011  #TQC-B70030 add lpr06   #FUN-C60089 lpr00
                                lpr07,lpr08,lprpos,lpr09)   #FUN-B70037 add lprpos  #FUN-BC0058 add lpr07   #FUN-C50137 add lpr08  #CHI-C80047 add lpr09
                 VALUES(g_lpq.lpqplant,g_lpq.lpqlegal,g_lpq.lpq00,g_lpq.lpq01,     #FUN-C60089 add lpq00 
                        g_lpr[l_ac].lpr02,g_lpr[l_ac].lpr03,g_lpr[l_ac].lpr04,g_lpr[l_ac].lpr05,g_lpr[l_ac].lpr06,  #FUN-B50011 #TQC-B70030 add lpr06
                        g_lpr[l_ac].lpr07,g_plant,1,g_lpq.lpq03) #FUN-B70037 add lprpos = 1 #FUN-BC0058 add lpr07  #FUN-C50137 add g_plant  #CHI-C80047 add lpq03
                        
           #INSERT INTO lpr_file(lprplant,lprlegal,lpr01,lpr02,lpr03,lprpos) #NO.FUN-A80022 add lprpos
           #      VALUES(g_lpq.lpqplant,g_lpq.lpqlegal,g_lpq.lpq01,
           #             g_lpr[l_ac].lpr02,g_lpr[l_ac].lpr03,l_lprpos)       #NO.FUN-A80022 add lprpos
 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lpr_file",g_lpq.lpq01,g_lpr[l_ac].lpr06,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           
       #TQC-B70030 --begin
       BEFORE FIELD lpr06                        #default 序號
       #    IF g_lpr[l_ac].lpr06 IS NULL OR g_lpr[l_ac].lpr06 = 0 THEN
          IF g_lpr[l_ac].lpr06 IS NULL THEN
              SELECT max(lpr06)+1 INTO g_lpr[l_ac].lpr06 FROM lpr_file
               WHERE lpr01 = g_lpq.lpq01
                 AND lpr00 = g_lpq.lpq00   #FUN-C60089 add
                 AND lpr08 = g_lpq.lpq13   #FUN-C50137 add
                 AND lpr09 = g_lpq.lpq03   #CHI-C80047 ad
                 AND lprplant = g_plant    #FUN-C60089 add
              IF g_lpr[l_ac].lpr06 IS NULL THEN
                 LET g_lpr[l_ac].lpr06 = 1
              END IF
           END IF
       
       AFTER FIELD lpr06                        #check 序號是否重複
           LET l_ac = ARR_CURR()
           IF NOT cl_null(g_lpr[l_ac].lpr06) THEN
              IF g_lpr[l_ac].lpr06 != g_lpr_t.lpr06 OR
                 g_lpr_t.lpr06 IS NULL THEN
                 SELECT count(*) INTO l_n FROM lpr_file
                  WHERE lpr01 = g_lpq.lpq01 AND lpr06 = g_lpr[l_ac].lpr06
                    AND lpr00 = g_lpq.lpq00   #FUN-C60089 add
                    AND lpr09 = g_lpq.lpq03   #CHI-C80047 add
                    AND lpr08 = g_lpq.lpq13   #FUN-C50137 add
                    AND lprplant = g_plant    #FUN-C60089 add
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lpr[l_ac].lpr06 = g_lpr_t.lpr06
                    NEXT FIELD lpr06
                 END IF
              END IF
           END IF
       #TQC-B70030 --end

       #FUN-BC0058------add----str---
       AFTER FIELD lpr07
          IF NOT cl_null(g_lpr[l_ac].lpr07) THEN
             IF g_lpr[l_ac].lpr07 < 0 THEN
                CALL cl_err('','alm-342',0)
                LET g_lpr[l_ac].lpr07 = g_lpr_t.lpr07
                NEXT FIELD lpr07
             END IF
            #FUN-C90067 add START
             CALL i600_chk_lprpk()
             IF NOT cl_null(g_errno ) THEN 
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
            #FUN-C90067 add END
          END IF
       #FUN-BC0058------add----end---

       AFTER FIELD lpr02
          IF NOT cl_null(g_lpr[l_ac].lpr02) THEN
#            CALL cl_err('','alm-809',0)
#            NEXT FIELD lpr02
#          ELSE
      #TQC-B70030  --begin mark
         #    IF (g_lpr[l_ac].lpr02 !=g_lpr_t.lpr02) OR 
         #       g_lpr_t.lpr02 IS NULL  THEN
         #       SELECT COUNT(*) INTO l_n FROM lpr_file 
         #        WHERE lpr01=g_lpq.lpq01
         #          AND lpr02=g_lpr[l_ac].lpr02
         #       IF l_n > 0 THEN                         
         #          CALL cl_err("",-239,1)
         #          LET g_lpr[l_ac].lpr02=g_lpr_t.lpr02  
         #          NEXT FIELD lpr02
         #       END IF
         #    END IF  
      #TQC-B70030  --end mark
             IF g_lpr[l_ac].lpr02 < 0 THEN 
                CALL cl_err("","alm-808",0)
                NEXT FIELD lpr02
             END IF    
            #FUN-C90067 add START
             CALL i600_chk_lprpk()
             IF NOT cl_null(g_errno ) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
            #FUN-C90067 add END
          END IF
      
        AFTER FIELD lpr03
          IF cl_null(g_lpr[l_ac].lpr03) THEN
             LET g_lpr[l_ac].ima02 = '' 
             LET g_lpr[l_ac].ima021 = ''
            #LET g_lpr[l_ac].ima31 = ''           #FUN-B50011
             DISPLAY g_lpr[l_ac].ima02 TO ima02
             DISPLAY g_lpr[l_ac].ima021 TO ima021
            #DISPLAY g_lpr[l_ac].ima31 TO ima31   #FUN-B50011
#             CALL cl_err('','alm-809',0)
#             NEXT FIELD lpr03
          ELSE 
#FUN-AB0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_lpr[l_ac].lpr03,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_lpr[l_ac].lpr03= g_lpr_t.lpr03
                NEXT FIELD lpr03
             END IF
#FUN-AB0059 ---------------------end-------------------------------
             SELECT COUNT(*) INTO l_n2 FROM ima_file
                 WHERE ima01 = g_lpr[l_ac].lpr03
                   AND ima154 = 'N'  #TQC-C30070 add
                IF l_n2=0 THEN
                  #CALL cl_err(g_lpr[l_ac].lpr03,'alm-802',0) #TQC-C30070 mark
                   CALL cl_err(g_lpr[l_ac].lpr03,'alm-h22',0) #TQC-C30070 add
                   NEXT FIELD lpr03
                END IF
                CALL i600_lpr03('d')
                
          #TQC-B70030  --begin mark
            #FUN-C90067 mark START
            #IF (g_lpr[l_ac].lpr02 !=g_lpr_t.lpr02) OR 
            #   g_lpr_t.lpr02 IS NULL  THEN
            #   SELECT COUNT(*) INTO l_n FROM lpr_file 
            #    WHERE lpr01 = g_lpq.lpq01
            #      AND lpr00 = g_lpq.lpq00   #FUN-C60089 add
            #      AND lpr02 = g_lpr[l_ac].lpr02
            #      AND lpr03 = g_lpr[l_ac].lpr03
            #      AND lpr08 = g_lpq.lpq13   #FUN-C50137 add
            #      AND lpr09 = g_lpq.lpq03   #CHI-C80047 add
            #      AND lprplant = g_plant    #FUN-C60089 add
            #   IF l_n > 0 THEN                         
            #      CALL cl_err("",-239,1)
            #      LET g_lpr[l_ac].lpr02 = g_lpr_t.lpr02  
            #      LET g_lpr[l_ac].lpr03 = g_lpr_t.lpr03  
            #      LET g_lpr[l_ac].ima02 = '' 
            #      LET g_lpr[l_ac].ima021 = ''
            #      LET g_lpr[l_ac].lpr04 = g_lpr_t.lpr04
            #      NEXT FIELD lpr02
            #   END IF
            #END IF  
            #FUN-C90067 mark END
          #TQC-B70030  --end mark
            #FUN-C90067 add START
             CALL i600_chk_lprpk()
             IF NOT cl_null(g_errno ) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
            #FUN-C90067 add END
          END IF 

       #FUN-B50011 Begin---
        AFTER FIELD lpr04
           IF NOT cl_null(g_lpr[l_ac].lpr04) THEN
              CALL i600_lpr04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                LET g_lpr[l_ac].lpr04= g_lpr_t.lpr04
                NEXT FIELD lpr04
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT i600_lpr05_check() THEN 
                 LET g_lpr04_t = g_lpr[l_ac].lpr04   
                 NEXT FIELD lpr05 
              END IF  
              LET g_lpr04_t = g_lpr[l_ac].lpr04    
              #No.FUN-BB0086--add--end--
             #FUN-C90067 add START
              CALL i600_chk_lprpk()
              IF NOT cl_null(g_errno ) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
              END IF
             #FUN-C90067 add END
           END IF
       #FUN-B50011 End-----
                   
       #FUN-BC0058 ---begin---
       AFTER FIELD lpr05
          IF NOT i600_lpr05_check() THEN NEXT FIELD lpr05 END IF   #No.FUN-BB0086
          #No.FUN-BB0086--mark--add--
          #IF NOT cl_null(g_lpr[l_ac].lpr05) THEN
          #   IF g_lpr[l_ac].lpr05 <= 0 THEN
          #      CALL cl_err('','alm1368',0)
          #      LET g_lpr[l_ac].lpr05= g_lpr_t.lpr05
          #      NEXT FIELD lpr05   
          #   END IF 
          #END IF
          #No.FUN-BB0086--mark--end--
         #FUN-C90067 add START
          CALL i600_chk_lprpk()
          IF NOT cl_null(g_errno ) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD CURRENT
          END IF
         #FUN-C90067 add END

       #FUN-BC0058 ---end ---
        BEFORE DELETE    
       #    IF NOT cl_null(g_lpr_t.lpr02) THEN  #TQC-B70030 mark
           IF NOT cl_null(g_lpr_t.lpr06) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
#          DISPLAY "BEFORE DELETE"
#          IF g_lpr_t.lpr02 IS NOT NULL THEN
#              IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lpr_file
               WHERE lpr01 = g_lpq.lpq01
                 AND lpr00 = g_lpq.lpq00    #FUN-C60089 add
                 AND lpr06 = g_lpr_t.lpr06  #TQC-B70030
                 AND lpr08 = g_lpq.lpq13    #FUN-C60089 add
                 AND lpr09 = g_lpq.lpq03    #CHI-C80047 ad
                 AND lprplant = g_plant     #FUN-C60089 add
               #  AND lpr02 = g_lpr_t.lpr02  #TQC-B70030 mark
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lpr_file","","",SQLCA.sqlcode,"","",1)   
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
              LET g_lpr[l_ac].* = g_lpr_t.*
              CLOSE i600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lpr[l_ac].lpr06,-263,1)  #TQC-B70030
            #  CALL cl_err(g_lpr[l_ac].lpr02,-263,1) #TQC-B70030  mark
              LET g_lpr[l_ac].* = g_lpr_t.*
           ELSE
              UPDATE lpr_file SET lpr06=g_lpr[l_ac].lpr06,  #TQC-B70030
                                  lpr07=g_lpr[l_ac].lpr07,  #FUN-C60089 add
                                  lpr02=g_lpr[l_ac].lpr02,
                                  lpr04=g_lpr[l_ac].lpr04, #FUN-B50011
                                  lpr05=g_lpr[l_ac].lpr05, #FUN-B50011
                                  lpr03=g_lpr[l_ac].lpr03
               WHERE lpr01=g_lpq.lpq01
                 AND lpr00 = g_lpq.lpq00   #FUN-C60089 add
                 AND lpr06=g_lpr_t.lpr06   #TQC-B70030
                 AND lpr08 = g_plant       #FUN-C50137 add
                 AND lpr09 = g_lpq.lpq03   #CHI-C80047 add
                 AND lprplant = g_plant    #FUN-C60089 add
             #    AND lpr02=g_lpr_t.lpr02  #TQC-B70030 mark
    
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lpr_file",g_lpq.lpq01,g_lpr_t.lpr02,SQLCA.sqlcode,"","",1)  
                 LET g_lpr[l_ac].* = g_lpr_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lpr[l_ac].* = g_lpr_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lpr.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 Add
           CLOSE i600_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO     
           IF INFIELD(lpr) AND l_ac > 1 THEN
              LET g_lpr[l_ac].* = g_lpr[l_ac-1].*
              LET g_lpr[l_ac].lpr02 = g_rec_b + 1
              NEXT FIELD lpr02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lpr03)  #贈品編號
#FUN-AB0025---------mod---------------str----------------
#                CALL cl_init_qry_var()
##               LET g_qryparam.form ="q_lmu"      #No.FUN-A90049 mark
#                LET g_qryparam.form ="q_ima01_6"      #No.FUN-A90049 mod
#                LET g_qryparam.default1 = g_lpr[l_ac].lpr03
#                CALL cl_create_qry() RETURNING g_lpr[l_ac].lpr03
                #CALL q_sel_ima(FALSE, "q_ima01_6","",g_lpr[l_ac].lpr03,"","","","","",'' )  #TQC-C30070 mark
                #RETURNING g_lpr[l_ac].lpr03   #TQC-C30070 mark
#FUN-AB0025--------mod---------------end----------------
               #TQC-C30070 add START
                 CALL cl_init_qry_var()
                 CALL s_rtz04_except(g_plant) RETURNING l_rtz04_except,l_rtz04
                 IF NOT l_rtz04_except THEN
                    LET g_qryparam.form ="q_ima01_6" 
                 ELSE
                    LET g_qryparam.form ="q_rte00"     
                    LET g_qryparam.arg1= l_rtz04 
                 END IF
                 LET g_qryparam.default1 = g_lpr[l_ac].lpr03
                 LET g_qryparam.where = " ima154 = 'N' "
                 CALL cl_create_qry() RETURNING g_lpr[l_ac].lpr03
                #TQC-C30070 add END
                 DISPLAY BY NAME g_lpr[l_ac].lpr03
                 CALL i600_lpr03('d')
                 NEXT FIELD lpr03
            #FUN-B50011 Begin---
             WHEN INFIELD(lpr04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.default1 = g_lpr[l_ac].lpr04
                CALL cl_create_qry() RETURNING g_lpr[l_ac].lpr04
                DISPLAY BY NAME g_lpr[l_ac].lpr04
                CALL i600_lpr04('d')
                NEXT FIELD lpr04
           #FUN-B50011 End-----
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
    END INPUT
 
  #  LET g_lpq.lpqmodu = g_user
  #  LET g_lpq.lpqdate = g_today
  #  UPDATE lpq_file 
  #     SET lpqmodu = g_lpq.lpqmodu,
  #         lpqdate = g_lpq.lpqdate
  #   WHERE lpq01 = g_lpq.lpq01
    DISPLAY BY NAME g_lpq.lpqcrat,g_lpq.lpqmodu,g_lpq.lpqdate
 
    CLOSE i600_bcl
    COMMIT WORK
#   CALL i600_delall() #CHI-C30002 mark
    CALL i600_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i600_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         #CHI-C80041---begin
         DELETE FROM lni_file           
          WHERE lni01 = g_lpq.lpq01     
            AND lni02 = g_lni02         
            AND lni14 = g_lpq.lpq13     
            AND lni15 = g_lpq.lpq03      
            AND lniplant = g_plant  
         #CHI-C80041---end
         DELETE FROM lpq_file WHERE lpq01 = g_lpq.lpq01
                                AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13   #FUN-C60089 add
                                AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
                                AND lpqplant = g_plant   #FUN-C60089 add
         INITIALIZE g_lpq.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#FUN-B50011 Begin---
FUNCTION i600_lpr04(p_cmd)
 DEFINE p_cmd          LIKE type_file.chr1
 DEFINE l_gfe02        LIKE  gfe_file.gfe02
 DEFINE l_gfeacti      LIKE  gfe_file.gfeacti

   LET g_errno = ''

   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_lpr[l_ac].lpr04
   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'art-061'
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lpr[l_ac].gfe02 = l_gfe02
      DISPLAY BY NAME g_lpr[l_ac].gfe02
   END IF
END FUNCTION
#FUN-B50011 End-----
 
#CHI-C30002 -------- mark -------- begin
#FUNCTION i600_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM lpr_file
#    WHERE lpr01 = g_lpq.lpq01
#
#   IF g_cnt = 0 THEN      
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM lpq_file WHERE lpq01 = g_lpq.lpq01
#   END IF
 
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i600_b_askkey()
 
    DEFINE l_wc2           STRING
 
   #CONSTRUCT l_wc2 ON lpr02,lpr03,ima02,ima021,ima31       #FUN-B50011
    CONSTRUCT l_wc2 ON lpr02,lpr03,ima02,ima021,lpr04,lpr05 #FUN-B50011
            FROM s_lpr[1].lpr02,s_lpr[1].lpr03,
                #s_lpr[1].ima02,s_lpr[1].ima021,s_lpr[1].ima31                #FUN-B50011
                 s_lpr[1].ima02,s_lpr[1].ima021,s_lpr[1].lpr04,s_lpr[1].lpr05 #FUN-B50011
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()     
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i600_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
   #LET g_sql = "SELECT lpr02,lpr03,ima02,ima021,ima31",       #FUN-B50011
    LET g_sql = "SELECT lpr06,lpr02,lpr07,lpr03,ima02,ima021,lpr04,'',lpr05", #FUN-B50011 #TQC-B70030 add lpr06  #FUN-BC0058 add lpr07
                " FROM lpr_file,ima_file",   
                " WHERE lpr01 ='",g_lpq.lpq01,"' ",
                "  AND lpr00 = '",g_lpq.lpq00,"' ",   #FUN-C60089 add
                "  AND lpr08 = '",g_lpq.lpq13,"' ",   #FUN-C50137 add
                "  AND lpr09 = '",g_lpq.lpq03,"' ",   #CHI-C80047 add
               #"  AND lprplant = '",g_plant,"' ",    #FUN-C60089 add   #CHI-C80047 mark
                "  AND lprplant = '",g_lpq.lpqplant,"' ",               #CHI-C80047 add
                "  AND ima01= lpr03 "      # and ",p_wc2 CLIPPED,
 #              " ORDER BY 1,2 "
    
   IF NOT cl_null(p_wc2) THEN                                                   
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
   END IF                                                                       
  #LET g_sql=g_sql CLIPPED," ORDER BY 1,2 "           #FUN-C60089 mark
  #LET g_sql=g_sql CLIPPED," ORDER BY lpr02 "           #FUN-C60089 add    #CHI-C80047 mark
   LET g_sql=g_sql CLIPPED," ORDER BY lpr06 "           #CHI-C80047 add
   
   DISPLAY g_sql 
     
    PREPARE i600_pb FROM g_sql
    DECLARE lpr_cs                       #CURSOR
        CURSOR FOR i600_pb
 
    CALL g_lpr.clear()
    LET g_cnt = 1
 
    FOREACH lpr_cs INTO g_lpr[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gfe02 INTO g_lpr[g_cnt].gfe02 FROM gfe_file WHERE gfe01=g_lpr[g_cnt].lpr04 #FUN-B50011
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
    END FOREACH
    CALL g_lpr.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
#FUN-C50137 add START 
FUNCTION i600_copy()
DEFINE
    l_newno         LIKE lpq_file.lpq01,
    l_newdate       LIKE lpq_file.lpq02,
    l_n             LIKE type_file.num5,
    l_oldno         LIKE lpq_file.lpq01
DEFINE   li_result   LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF g_lpq.lpq01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i600_set_entry('a')
    LET g_before_input_done = TRUE
    LET l_newdate= NULL                                                                                                             

    SELECT * INTO g_lpq.* FROM lpq_file
     WHERE lpq01 = g_lpq.lpq01 AND lpq13 = g_lpq.lpq13
       AND lpq03 = g_lpq.lpq03 AND lpqplant = g_plant   #CHI-C80047 add
  
      LET g_lpq_o.* = g_lpq.*                                                                                                                               
      IF g_argv1 = '0' THEN
         LET g_lpq.lpq00 = '0'
         LET g_lpq.lpq12 = ' '
      ELSE
         IF g_argv1 = '1' THEN
            LET g_lpq.lpq00 = '1'
            LET g_lpq.lpq12 = '0'
         END IF
      END IF
      LET g_lpq.lpq01 = NULL    #CHI-C80047 add
      LET g_lpq.lpq02 = NULL    #CHI-C80047 add
      LET g_lpq.lpq06='N'
      LET g_lpq.lpq07='0'
      LET g_lpq.lpq08='N'
      LET g_lpq.lpqpos = '1'         #MOD-B60077 ADD
      LET g_lpq.lpqplant = g_plant
      LET g_lpq.lpqlegal = g_legal
      LET g_data_plant = g_plant    #No.FUN-A10060
      LET g_lpq.lpqoriu = g_user    #No.FUN-A10060
      LET g_lpq.lpqorig = g_grup    #No.FUN-A10060
      LET g_lpq.lpquser=g_user
      LET g_lpq.lpqcrat=g_today
      LET g_lpq.lpqgrup=g_grup
      LET g_lpq.lpqacti='Y'
      LET g_lpq.lpq13 = g_plant      #制定營運中心
      LET g_lpq.lpq14 = 0            #版本號
      LET g_lpq.lpq15 = 'N'          #發佈否
      LET g_lpq.lpq17 = '1'          #兌換限制
      LET g_lpq.lpq18 = 0            #兌換次數
      CALL i600_lpq13()

    CALL i600_field_pic()

    CALL i600_i("a")
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_lpq.* = g_lpq_o.*
       CALL i600_lpq13()
       CALL i600_show() 
       ROLLBACK WORK
       RETURN
    END IF

    INSERT INTO lpq_file VALUES (g_lpq.*)

    DROP TABLE x

    SELECT * FROM lpr_file 
        WHERE lpr01 = g_lpq_o.lpq01 AND lpr08 = g_lpq_o.lpq13
          AND lpr00 = g_lpq.lpq00   #FUN-C60089 add
          AND lpr09 = g_lpq_o.lpq03   #CHI-C80047 add
          AND lprplant = g_plant    #FUN-C60089 add
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err("",SQLCA.sqlcode,1)  
        RETURN
    END IF

    UPDATE x
        SET lpr01 = g_lpq.lpq01,
            lpr08 = g_lpq.lpq13,
            lpr09 = g_lpq.lpq03,  #CHI-C80047 add
            lprplant = g_plant

    INSERT INTO lpr_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)  
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK 
    END IF

   #CHI-C80047 add START
    DROP TABLE y
    SELECT * FROM lni_file
      WHERE lni01 = g_lpq_o.lpq01
        AND lni02 = g_lni02
        AND lni14 = g_lpq_o.lpq13
        AND lni15 = g_lpq_o.lpq03
        AND lniplant = g_plant  
      INTO TEMP y
    UPDATE y SET lni01 = g_lpq.lpq01,
                 lni14 = g_lpq.lpq13,
                 lni15 = g_lpq.lpq03
    INSERT INTO lni_file
       SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF  
   #CHI-C80047 add END

    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    SELECT * INTO g_lpq.* FROM lpq_file
     WHERE lpq01 = g_lpq.lpq01 AND lpq13 = g_lpq.lpq13
       AND lpq03 = g_lpq.lpq03 AND lpqplant = g_plant  #CHI-C80047 add
       AND lpq00 = g_lpq.lpq00       #CHI-C80047 add
     CALL i600_b()
     CALL i600_show()

END FUNCTION
#FUN-C50137 add END 
 
FUNCTION i600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lpq01,",TRUE)
  END IF
 
END FUNCTION
FUNCTION i600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
#  CALL cl_set_comp_entry("lpq06,lpq07,lpq08,lpq09,lpq10",FALSE)                  #MOD-AC0207 mark
  CALL cl_set_comp_entry("lpq08,lpq09,lpq10",FALSE)                               #MOD-AC0207
 
  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lpq01",FALSE)
  END IF
   
END FUNCTION
 
FUNCTION i600_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
END FUNCTION
 
 
FUNCTION i600_y()
  DEFINE l_n LIKE type_file.num5      #FUN-BC0058 add

   IF g_lpq.lpq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 --------------------- add ----------------------- begin
   IF g_lpq.lpq08 !='N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF
   IF g_lpq.lpqacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF
   IF g_lpq.lpq06 = 'Y'AND (cl_null(g_lpq.lpq07) OR  g_lpq.lpq07  ! = '1') THEN
      CALL cl_err('','alm-029',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_lpq.* FROM lpq_file WHERE lpq01 = g_lpq.lpq01
                                         AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13   #FUN-C60089 add
                                         AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
                                         AND lpqplant = g_plant    #FUN-C60089 add
#CHI-C30107 --------------------- add ----------------------- end
   IF g_lpq.lpq08 !='N' THEN
      CALL cl_err('','8888',0)      
      RETURN
   END IF
   IF g_lpq.lpqacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF g_lpq.lpq06 = 'Y'AND (cl_null(g_lpq.lpq07) OR  g_lpq.lpq07  ! = '1') THEN
      CALL cl_err('','alm-029',0)  
      RETURN
   END IF 
  #FUN-B50011 Begin---
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lni_file
    WHERE lni01 = g_lpq.lpq01
     #AND lni02 = '2'       #FUN-C60089 mark
      AND lni02 = g_lni02   #FUN-C60089 add
      AND lniplant = g_lpq.lpqplant  #FUN-BC0058 add
      AND lni14 = g_lpq.lpq13  #FUN-BC0058 add
      AND lni15 = g_lpq.lpq03  #CHI-C80047 add
      AND lni13 = 'Y'        #FUN-BC0058  add
   IF g_cnt = 0 THEN
#      CALL cl_err('','alm-851',0)   #FUN-BC0058 mark
      CALL cl_err('','alm1367',0)    #FUN-BC0058 
      RETURN
   END IF

  #FUN-C50137 add START
   SELECT COUNT(*) INTO l_n FROM lni_file
    WHERE lni01 = g_lpq.lpq01 
      AND lniplant = g_lpq.lpqplant 
     #AND lni02 = '2'       #FUN-C60089 mark 
      AND lni02 = g_lni02   #FUN-C60089 add
      AND lni13 = 'Y'
      AND lni14 = g_lpq.lpq13  
      AND lni15 = g_lpq.lpq03   #CHI-C80047 add
      AND lni04 = g_lpq.lpq13  
   IF l_n = 0 THEN
      CALL cl_err('','alm-h42',0)
      RETURN
   END IF
   CALL i600_chk_lni04()   #判斷生效營運中心是否與卡生效營運中心符合
   IF g_success = 'N' THEN
      RETURN
   END IF
   IF g_plant <> g_lpq.lpq13 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
  #FUN-C50137 add END

#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
 
   OPEN i600_cl USING g_lpq.lpq01,g_lpq.lpq13,g_lpq.lpq03    #FUN-C50137 add lpq13   #CHI-C80047 add lpq03
   IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_lpq.*      
    LET g_lpq.lpq08 = 'Y'
    LET g_lpq.lpq09=g_user
    LET g_lpq.lpq10=g_today
    UPDATE lpq_file SET lpq08 = g_lpq.lpq08,
                        lpq09 = g_lpq.lpq09,
                        lpq10 = g_lpq.lpq10
                     WHERE lpq01 = g_lpq.lpq01
                       AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13   #FUN-C60089 add
                       AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
                       AND lpqplant = g_plant   #FUN-C60089 add
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lpq_file",g_lpq.lpq01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i600_cl
    COMMIT WORK
    DISPLAY BY NAME g_lpq.lpq08
    DISPLAY BY NAME g_lpq.lpq09
    DISPLAY BY NAME g_lpq.lpq10
    CALL i600_field_pic()
END FUNCTION 
 
FUNCTION i600_z()
DEFINE l_cnt LIKE type_file.num5
   IF g_lpq.lpq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  #FUN-C90067 mark START
  #SELECT count(*) INTO l_cnt FROM lrl_file WHERE lrl05 = g_lpq.lpq01 
  #                                         
  #  IF l_cnt > 0 THEN
  #     CALL cl_err('','alm-810',0)
  #     RETURN
  #  END IF
  #FUN-C90067 mark END
  #FUN-C50137 add START
    IF g_plant <> g_lpq.lpq13 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    IF g_lpq.lpq15 = 'Y' THEN
       CALL cl_err('','art-888',0)
       RETURN
    END IF
  #FUN-C50137 add END
   IF g_lpq.lpq08="N" OR g_lpq.lpqacti="N" OR g_lpq.lpq08="X" THEN
      CALL cl_err("",'atm-365',1)
   ELSE
      IF cl_confirm('aap-224') THEN
         BEGIN WORK
         UPDATE lpq_file SET lpq08="N",
                            #CHI-D20015--modify--str--
                            #lpq09='',
                            #lpq10=''
                             lpq09= g_user,
                             lpq10= g_today
                            #CHI-D20015--modify--end--
                            #,lpqpos='N' #No.FUN-A80022 #FUN-B50042 mark
                         WHERE lpq01=g_lpq.lpq01
                           AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
                           AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
                           AND lpq13 = g_plant       #FUN-C50137 add
                           AND lpqplant = g_plant    #FUN-C60089 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpq_file",g_lpq.lpq01,"",SQLCA.sqlcode,"","lpq08",1)
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            LET g_lpq.lpq08="N"
            #CHI-D20015--modify--str--
            #LET g_lpq.lpq09=''
            #LET g_lpq.lpq10=''
            LET g_lpq.lpq09= g_user
            LET g_lpq.lpq10= g_today
            #CHI-D20015--modify--end--
            #LET g_lpq.lpqpos = 'N'       #No.FUN-A80022 #FUN-B50042 mark
            #DISPLAY BY NAME g_lpq.lpqpos #No.FUN-A80022 #FUN-B50042 mark
            DISPLAY BY NAME g_lpq.lpq08
            DISPLAY BY NAME g_lpq.lpq09
            DISPLAY BY NAME g_lpq.lpq10
            CALL i600_field_pic()
         END IF
      END IF
   END IF
END FUNCTION
 
#FUNCTION i600_v()
#DEFINE l_cnt LIKE type_file.num5
#  IF g_lpq.lpq01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  IF g_lpq.lpq08 ='Y' THEN
#     CALL cl_err('','8889',0)      
#     RETURN
#  END IF
#  IF g_lpq.lpqacti = 'N' THEN
#     CALL cl_err('','9028',0)      
#     RETURN
#  END IF
#  
#  IF g_lpq.lpq07 MATCHES '[Ss11WwRr]' THEN 
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF 
#  
#  SELECT count(*) INTO l_cnt FROM lrl_file WHERE lrl05 = g_lpq.lpq01
#    IF l_cnt > 0 THEN
#       CALL cl_err('','alm-810',0)
#       RETURN
#    END IF
##  IF NOT cl_confirm('lib-016') THEN RETURN END IF
#  BEGIN WORK
 
#  OPEN i600_cl USING g_lpq.lpq01
#  IF STATUS THEN
#      CALL cl_err("OPEN i600_cl:", STATUS, 1)
#      CLOSE i600_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i600_cl INTO g_lpq.*      
#   IF g_lpq.lpq08 != 'X' THEN 
#      IF NOT cl_confirm('alm-085') THEN RETURN END IF
#      LET g_lpq.lpq08 = 'X'
#      LET g_lpq.lpq09 =g_user
#      LET g_lpq.lpq10 =g_today
#   ELSE 
#   	 IF NOT cl_confirm('alm-086') THEN RETURN END IF
#      LET g_lpq.lpq08 = 'N'
#      LET g_lpq.lpq09 =''
#      LET g_lpq.lpq10 =''
#   END IF     
#   UPDATE lpq_file SET lpq07 = g_lpq.lpq07,
#                       lpq08 = g_lpq.lpq08,
#                       lpqmodu=g_user,
#                       lpqdate=g_today
#                 WHERE lpq01 = g_lpq.lpq01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lpq_file",g_lpq.lpq01,"",SQLCA.sqlcode,"","",0)
#      ROLLBACK WORK
#      RETURN
#   END IF
#   CLOSE i600_cl
#   COMMIT WORK
#   SELECT lpq07,lpqmodu,lpqdate
#    INTO g_lpq.lpq07,g_lpq.lpqmodu,g_lpq.lpqdate
#    FROM lpq_file 
#    WHERE lpq01=g_lpq.lpq01
#   DISPLAY BY NAME g_lpq.lpq07
#   DISPLAY BY NAME g_lpq.lpq08
#   DISPLAY BY NAME g_lpq.lpq09
#   DISPLAY BY NAME g_lpq.lpq10
#   DISPLAY BY NAME g_lpq.lpqmodu
#   DISPLAY BY NAME g_lpq.lpqdate
#END FUNCTION  
 
FUNCTION i600_lpq03(p_cmd) #卡種編號 
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lph02     LIKE lph_file.lph02 
    DEFINE l_lph03     LIKE lph_file.lph03
    DEFINE l_lph06     LIKE lph_file.lph06
    DEFINE l_lph24     LIKE lph_file.lph24
    DEFINE l_lphacti   LIKE lph_file.lphacti
    LET g_errno = ' '
    SELECT lph02,lph03,lph06,lph24,lphacti
      INTO l_lph02,l_lph03,l_lph06,l_lph24,l_lphacti                               
      FROM lph_file WHERE lph01 = g_lpq.lpq03
                      AND lphacti='Y' 
   #CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'     #FUN-C50137 mark                      
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-h43'     #FUN-C50137 add
         WHEN l_lphacti='N'      LET g_errno = 'mfg9028'       
#        WHEN l_lph03 <> '0'     LET g_errno = 'alm-565'  #No.FUN-960134 mark
         WHEN l_lph06 = 'N'      LET g_errno = 'alm-628'
         WHEN l_lph24 <> 'Y'     LET g_errno = '9029'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'    
    END CASE                                                                    
    IF p_cmd = 'd' OR cl_null(g_errno) THEN                                                         
    DISPLAY l_lph02 TO FORMONLY.lph02                                           
    END IF                                                     
END FUNCTION
 
FUNCTION i600_lpr03(p_cmd)  #贈品編號
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_ima02     LIKE ima_file.ima02
    DEFINE l_ima021     LIKE ima_file.ima021
    DEFINE l_ima31     LIKE ima_file.ima31
    DEFINE l_imaacti     LIKE ima_file.imaacti
    
    LET g_errno = ' '
    SELECT ima02,ima021,ima31,imaacti INTO l_ima02,l_ima021,l_ima31,l_imaacti
      FROM ima_file WHERE ima01 = g_lpr[l_ac].lpr03
                      AND imaacti = 'Y'
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006' 
         WHEN l_imaacti='N'        LET g_errno = 'mfg9028'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'        END CASE
   #FUN-B50011 Begin---
    IF cl_null(g_errno) AND cl_null(g_lpr[l_ac].lpr04) THEN
       LET g_lpr[l_ac].lpr04 = l_ima31
       DISPLAY BY NAME g_lpr[l_ac].lpr04
    END IF
   #FUN-B50011 End-----
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_lpr[l_ac].ima02 = l_ima02 
       LET g_lpr[l_ac].ima021 = l_ima021
      #LET g_lpr[l_ac].ima31 = l_ima31      #FUN-B50011
       DISPLAY g_lpr[l_ac].ima02 TO ima02
       DISPLAY g_lpr[l_ac].ima021 TO ima021
      #DISPLAY g_lpr[l_ac].ima31 TO ima31   #FUN-B50011
    END IF
END FUNCTION
 
#MOD-AC0207 -------------------mark
#FUNCTION i600_ef()   #簽核
#  IF cl_null(g_lpq.lpq01) THEN 
#     CALL cl_err('','-400',0) 
#     RETURN 
#  END IF
#  
#  SELECT * INTO g_lpq.* FROM lpq_file
#   WHERE lpq01=g_lpq.lpq01
#
#  IF g_lpq.lpq08 ='Y' THEN    
#     CALL cl_err(g_lpq.lpq01,'alm-005',0)
#     RETURN
#  END IF
#
#   IF g_lpq.lpq08 = 'S' THEN
#      CALL cl_err('','alm-934',0)
#      RETURN
#   END IF
#  
#  IF g_lpq.lpq08='X' THEN 
#     CALL cl_err('','9024',0)
#     RETURN
#  END IF
#  
#  IF g_lpq.lpq07 MATCHES '[Ss1WwRr]' THEN 
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF
# 
#  IF g_lpq.lpq06='N' THEN 
#     CALL cl_err('','mfg3549',0)
#     RETURN
#  END IF
#
#  IF g_success = "N" THEN
#     RETURN
#  END IF
#
#  #  CALL aws_condition() 
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#
#  IF aws_efcli2(base.TypeInfo.create(g_lpq),'','','','','')
#  
#  THEN
#      LET g_success = 'Y'
#      LET g_lpq.lpq07 = 'S'
#      LET g_lpq.lpq06 = 'Y' 
#      DISPLAY BY NAME g_lpq.lpq09,g_lpq.lpq10
#  ELSE
#      LET g_success = 'N'
#  END IF
#END FUNCTION 
#MOD-AC0207 ----------------------------mark
 
 FUNCTION i600_field_pic()
    DEFINE l_flag   LIKE type_file.chr1
 
    CASE
      WHEN g_lpq.lpqacti = 'N' 
         CALL cl_set_field_pic("","","","","","N")
      WHEN g_lpq.lpq08 = 'Y' 
         CALL cl_set_field_pic("Y","","","","","")
      OTHERWISE
         CALL cl_set_field_pic("","","","","","")
    END CASE
 END FUNCTION
 
#FUNCTION i600_out()
#  DEFINE l_cmd  LIKE type_file.chr1000   
#
#     IF cl_null(g_wc) AND NOT cl_null(g_lpq01) THEN                         
#        LET g_wc = " lpq01 = '",g_lpq01,"'"                                 
#     END IF   
#     IF g_wc IS NULL THEN  
#        CALL cl_err('','9057',0)   
#        RETURN   
#     END IF     
#     LET l_cmd = 'p_query "almi600" "',g_wc CLIPPED,'"'  
#     CALL cl_cmdrun(l_cmd)      
#END FUNCTION


FUNCTION i600_lpqplant()
DEFINE l_rtz13      LIKE rtz_file.rtz13        #FUN-A80148  
DEFINE l_azt02      LIKE azt_file.azt02
 
  DISPLAY '' TO FORMONLY.rtz13
  
  IF NOT cl_null(g_lpq.lpqplant) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file  #FUN-A80148  
       WHERE rtz01 = g_lpq.lpqplant
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   
     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lpq.lpqlegal
     DISPLAY l_azt02 TO FORMONLY.azt02
  END IF 
END FUNCTION

#FUN-B60059 將程式由t類改成i類

#No.FUN-BB0086---add---begin---
FUNCTION i600_lpr05_check()
   IF NOT cl_null(g_lpr[l_ac].lpr05) AND NOT cl_null(g_lpr[l_ac].lpr04) THEN
      IF cl_null(g_lpr_t.lpr05) OR cl_null(g_lpr04_t) OR g_lpr_t.lpr05 != g_lpr[l_ac].lpr05 OR g_lpr04_t != g_lpr[l_ac].lpr04 THEN
         LET g_lpr[l_ac].lpr05=s_digqty(g_lpr[l_ac].lpr05,g_lpr[l_ac].lpr04)
         DISPLAY BY NAME g_lpr[l_ac].lpr05
      END IF
   END IF
   IF NOT cl_null(g_lpr[l_ac].lpr05) THEN
      IF g_lpr[l_ac].lpr05 <= 0 THEN
         CALL cl_err('','alm1368',0)
         LET g_lpr[l_ac].lpr05= g_lpr_t.lpr05
         RETURN FALSE 
      END IF 
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
#FUN-C50137 add START
FUNCTION i600_lpq13()  #制定營運中心名稱
DEFINE l_rtz13      LIKE rtz_file.rtz13

   DISPLAY '' TO FORMONLY.lst14_desc

   IF NOT cl_null(g_lpq.lpq13) THEN
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lpq.lpq13
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.lpq13_desc

   END IF
END FUNCTION

FUNCTION i600_iss()  #發佈
DEFINE l_sql         STRING
DEFINE l_lni04       LIKE lni_file.lni04
DEFINE l_lnilegal    LIKE lni_file.lnilegal
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5

   LET g_success = 'Y'  #FUN-C60089 add 

  #CHI-C80047 add START
   SELECT * INTO g_lpq.* FROM lpq_file
    WHERE lpq01=g_lpq.lpq01
      AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13  
      AND lpq03 = g_lpq.lpq03    
      AND lpqplant = g_plant   
  #CHI-C80047 add END

   IF cl_null(g_lpq.lpq01) THEN
      RETURN
      CALL cl_err('','-400',0)
   END IF

   IF g_lpq.lpq08 <> 'Y' THEN
      CALL cl_err('','art-656',0)
      RETURN
   END IF
   IF g_plant <> g_lpq.lpq13 THEN
      CALL cl_err('','art-663',0)
      RETURN
   END IF
   IF g_lpq.lpq15 = 'Y' THEN
      CALL cl_err('','art-662',0)
      RETURN
   END IF

   CALL i600_chk_lni04()  #判斷其他生效營運中心是否已存在此兌換單號
   IF g_success = 'N' THEN
      RETURN
   END IF

   IF NOT cl_confirm('art-660') THEN
      RETURN
   END IF

   DROP TABLE lpq_temp
   SELECT * FROM lpq_file WHERE 1 = 0 INTO TEMP lpq_temp
   DROP TABLE lpr_temp
   SELECT * FROM lpr_file WHERE 1 = 0 INTO TEMP lpr_temp
   DROP TABLE lni_temp
   SELECT * FROM lni_file WHERE 1 = 0 INTO TEMP lni_temp

   BEGIN WORK
   LET g_success = 'Y'
   LET l_sql="SELECT DISTINCT lni04 FROM lni_file ",
            #" WHERE lni01=? AND lni02='2' "                 #FUN-C60089 mark
             " WHERE lni01 = ? AND lni02 = '",g_lni02,"'",   #FUN-C60089 add
             "   AND lni15 = '",g_lpq.lpq03,"' ",            #CHI-C80047 add
             "   AND lniplant = '",g_plant,"' "              #FUN-C60089 add
   PREPARE lni_pre FROM l_sql
   DECLARE lni_cs CURSOR FOR lni_pre 
   FOREACH lni_cs USING g_lpq.lpq01
                  INTO l_lni04
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach lni_cs:',SQLCA.sqlcode,1)
      END IF
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF
     #FUN-C60089 mark START 
     #IF g_lpq.lpq13 <> l_lni04 THEN
     #   SELECT COUNT(*) INTO l_cnt FROM azw_file
     #    WHERE azw07 = g_lpq.lpq13
     #      AND azw01 = l_lni04
     #   IF l_cnt = 0 THEN
     #      CONTINUE FOREACH
     #   END IF
     #END IF
     #FUN-C60089 mark END
      LET g_plant_new = l_lni04

      DELETE FROM lpq_temp
      DELETE FROM lpr_temp
      DELETE FROM lni_temp

      SELECT azw02 INTO l_lnilegal FROM azw_file
       WHERE azw01 = l_lni04 AND azwacti='Y'

      IF g_lpq.lpq13 = l_lni04 THEN     #與當前機構相同則不拋
         UPDATE lpq_file SET lpq15 = 'Y', lpq16 = g_today
          WHERE lpq01 =g_lpq.lpq01
            AND lpq00 = g_lpq.lpq00   #FUN-C60089 add
            AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
            AND lpq13 = g_lpq.lpq13
            AND lpqplant = g_plant    #FUN-C60089 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpq_file",g_lpq.lpq01,"",STATUS,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      ELSE
      #將數據放入臨時表中處理
         INSERT INTO lpq_temp SELECT lpq_file.* FROM lpq_file
                               WHERE lpq01 = g_lpq.lpq01
                                 AND lpq00 = g_lpq.lpq00
                                 AND lpq03 = g_lpq.lpq03      #CHI-C80047 add
                                 AND lpq13 = g_lpq.lpq13
                                 AND lpqplant = g_lpq.lpq13   #FUN-C60089 add
         UPDATE lpq_temp SET lpq15 = 'Y',
                             lpq16 = g_today,
                             lpqplant = l_lni04,
                             lpqlegal = l_lnilegal

         INSERT INTO lpr_temp SELECT lpr_file.* FROM lpr_file
                               WHERE lpr01 = g_lpq.lpq01 AND lpr08 = g_lpq.lpq13
                                 AND lpr00 = g_lpq.lpq00    #FUN-C60089 add
                                 AND lpr09 = g_lpq.lpq03    #CHI-C80047 add
                                 AND lprplant = g_plant     #FUN-C60089 add
         UPDATE lpr_temp SET lprplant = l_lni04,
                             lprlegal = l_lnilegal

         INSERT INTO lni_temp SELECT lni_file.* FROM lni_file
                              #WHERE lni01 = g_lpq.lpq01 AND lni02 = '2' AND lni14 = g_lpq.lpq13          #FUN-C60089 mark
                               WHERE lni01 = g_lpq.lpq01 AND lni02 = g_lni02 AND lni14 = g_lpq.lpq13      #FUN-C60089 add
                                 AND lni15 = g_lpq.lpq03   #CHI-C80047 add
                                 AND lniplant = g_plant    #FUN-C60089 add
         UPDATE lni_temp SET lniplant = l_lni04,
                             lnilegal = l_lnilegal


         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lpq_file'),   #單頭
                     " SELECT * FROM lpq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lpq FROM l_sql
         EXECUTE trans_ins_lpq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lpq_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lpr_file'),   #第一單身
                     " SELECT * FROM lpr_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lpr FROM l_sql
         EXECUTE trans_ins_lpr
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lpr_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lni_file'),   #生效營運中心
                     " SELECT * FROM lni_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lni FROM l_sql
         EXECUTE trans_ins_lni
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lni_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF

      END IF
   END FOREACH

   CALL i600_isn_lpq()

   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF

   IF g_success = 'Y' THEN #拋磚成功
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF

   UPDATE lpq_file SET lpq15 = 'Y',
                       lpq16 = g_today
    WHERE lpq01=g_lpq.lpq01
      AND lpq00 = g_lpq.lpq00 AND lpq13 = g_lpq.lpq13   #FUN-C60089 add
      AND lpq03 = g_lpq.lpq03   #CHI-C80047 add
      AND lpqplant = g_plant    #FUN-C60089 add
     #AND lpr08 = g_lpq.lpq13   #FUN-C60089 mark 

   DROP TABLE lpq_temp
   DROP TABLE lpr_temp
   DROP TABLE lni_temp

   SELECT DISTINCT lpq15,lpq16 
      INTO g_lpq.lpq15,g_lpq.lpq16
      FROM lpq_file
      WHERE lpq01 = g_lpq.lpq01 AND lpq13 = g_lpq.lpq13 
        AND lpq00 = g_lpq.lpq00  #FUN-C60089 add
        AND lpq03 = g_lpq.lpq03  #CHI-C80047 add
        AND lpqplant = g_plant   #FUN-C60089 add

   DISPLAY BY NAME g_lpq.lpq15,g_lpq.lpq16

END FUNCTION

#發佈確認後,將資料複製一份到almt600內,版號預計為0
FUNCTION i600_isn_lpq()
DEFINE l_sql           STRING
DEFINE l_lni04         LIKE lni_file.lni04
DEFINE l_lnilegal      LIKE lni_file.lnilegal
DEFINE l_lpq           RECORD LIKE lpq_file.*
DEFINE l_lpr           RECORD LIKE lpr_file.*
DEFINE l_lni           RECORD LIKE lni_file.*

   LET l_sql="SELECT DISTINCT lni04 FROM lni_file ",
            #" WHERE lni01=? AND lni02='2' ",      #FUN-C60089 mark
             " WHERE lni01 = ? AND lni02 = '",g_lni02,"'",   #FUN-C60089 add
             "   AND lni14 = '",g_lpq.lpq13,"' ",
             "   AND lni15 = '",g_lpq.lpq03,"' ",            #CHI-C80047 add
             "   AND lniplant = '",g_plant,"' "              #FUN-C60089 add
   PREPARE lni_pre1 FROM l_sql
   DECLARE lni_cs1 CURSOR FOR lni_pre1
   FOREACH lni_cs1 USING g_lpq.lpq01
                  INTO l_lni04
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF
                  
      SELECT azw02 INTO l_lnilegal FROM azw_file
       WHERE azw01 = l_lni04 AND azwacti='Y'
      
      SELECT * INTO l_lpq.* FROM lpq_file
        WHERE lpq00 = g_lpq.lpq00 AND lpq01 = g_lpq.lpq01
          AND lpq03 = g_lpq.lpq03                                #CHI-C80047 add
          AND lpq13 = g_lpq.lpq13 AND lpqplant = g_lpq.lpqplant

      #單頭          
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lqx_file'),
                  "        (lqx00,lqx01,lqx02,lqx03,lqx04,lqx05,lqx06,lqx07,lqx08,lqx09, ",
                  "         lqx10,lqx11,lqx12,lqx13,lqxacti,lqxcrat,lqxdate,lqxgrup, ",
                  "         lqxlegal,lqxmodu,lqxorig,lqxoriu,lqxplant,lqxuser ) ",
                  " VALUES( '",l_lpq.lpq00,"', '",l_lpq.lpq01,"', '",l_lpq.lpq03,"','",l_lpq.lpq04,"', ",
                  "         '",l_lpq.lpq05,"', 'Y', '",g_user,"','",g_today,"','",l_lpq.lpq11,"',",
                  "         '",l_lpq.lpq12,"','",l_lpq.lpq13,"',0,'",l_lpq.lpq17,"','",l_lpq.lpq18,"', ",
                  "         '",l_lpq.lpqacti,"','",l_lpq.lpqcrat,"', ",
                  "         '', '",l_lpq.lpqgrup,"', '",l_lnilegal,"','",l_lpq.lpqmodu,"', ",
                  "         '",l_lpq.lpqorig,"', '",l_lpq.lpqoriu,"','",l_lni04,"','",l_lpq.lpquser,"')"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
      PREPARE trans_ins_lqx FROM l_sql
      EXECUTE trans_ins_lqx
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lqx_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
      END IF
      #第一單身
      LET l_sql = " SELECT * FROM lpr_file ",
                  "    WHERE lpr01 = '",g_lpq.lpq01,"' ",
                  "      AND lpr00 = '",g_lpq.lpq00,"' ",   #FUN-C60089 add
                  "      AND lpr08 = '",g_lpq.lpq13,"' ",
                  "      AND lpr09 = '",g_lpq.lpq03,"' ",   #CHI-C80047 add
                  "      AND lprplant = '",g_lpq.lpq13,"' "
      PREPARE lpr_pre FROM l_sql
      DECLARE lpr_cs1 CURSOR FOR lpr_pre
      FOREACH lpr_cs1 INTO l_lpr.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lqy_file'),
                     "        (lqy00,lqy01,lqy02,lqy03,lqy04,lqy05,lqy06,lqy07,lqy08,lqy09,lqylegal,lqyplant ,lqy10)",   #FUN-C60089 add lqy00  #CHI-C80047 add lqy10
                     " VALUES( '",l_lpr.lpr00,"', '",l_lpr.lpr01,"', '",l_lpr.lpr02,"', '",l_lpr.lpr03,"','",l_lpr.lpr04,"', ",    #FUN-C60089 add lpr00
                     "         '",l_lpr.lpr05,"', '",l_lpr.lpr06,"','",l_lpr.lpr07,"','",l_lpr.lpr08,"', ",
                     "          0,'",l_lnilegal,"','",l_lni04,"','",l_lpr.lpr09,"')"      #CHI-C80047 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lqy FROM l_sql
         EXECUTE trans_ins_lqy
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lqy_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF
      END FOREACH
      #生效營運中心
      LET l_sql = " SELECT * FROM lni_file ",
                 #"    WHERE  lni01 = '",g_lpq.lpq01,"' AND lni02 = '2' ",             #FUN-C60089 mark
                  "    WHERE  lni01 = '",g_lpq.lpq01,"' AND lni02 = '",g_lni02,"' ",   #FUN-C60089 add 
                  "      AND lni14 = '",g_lpq.lpq13,"' ",
                  "      AND lni15 = '",g_lpq.lpq03,"' ",    #CHI-C80047 add
                  "      AND lniplant = '",g_lpq.lpq13,"' "
      PREPARE lni_pre2 FROM l_sql
      DECLARE lni_cs2 CURSOR FOR lni_pre2
      FOREACH lni_cs2 INTO l_lni.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsz_file'),
                     "        (lsz01,lsz02,lsz03,lsz04,lsz05,lsz06,lsz07,lsz08,",
                     "         lsz09,lsz10,lsz11,lsz12,lszlegal,lszplant,lsz13 ) ",   #CHI-C80047 add lsz13
                     " VALUES( '",l_lni.lni01,"', '",l_lni.lni02,"', '",l_lni.lni04,"','",l_lni.lni07,"', ",
                     "         '",l_lni.lni08,"','','','",l_lni.lni11,"','','",l_lni.lni13,"',",
                     "         '",l_lni.lni14,"',0,'",l_lnilegal,"','",l_lni04,"','",l_lni.lni15,"')"   #CHI-C80047 add lni15
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lsz FROM l_sql
         EXECUTE trans_ins_lsz
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsz_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF
      END FOREACH


   END FOREACH
END FUNCTION

FUNCTION i600_chk_lni04()
   DEFINE l_sql        STRING
   DEFINE l_lni04      LIKE lni_file.lni04
   DEFINE l_cnt        LIKE type_file.num5

  #CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL s_showmsg_init()
   LET l_sql = "SELECT DISTINCT lni04 FROM lni_file  ",
              #"  WHERE lni01 = '",g_lpq.lpq01,"' AND lni02 = '2' "               #FUN-C60089 mark
               "  WHERE lni01 = '",g_lpq.lpq01,"' AND lni02 = '",g_lni02,"' ",    #FUN-C60089 add
               "    AND lni14 = '",g_lpq.lpq13,"' AND lni13 = 'Y' ",
               "    AND lni15 = '",g_lpq.lpq03,"' ",                              #CHI-C80047 add
               "    AND lniplant = '",g_plant,"' "                                #FUN-C60089 add
   PREPARE lni_pre3 FROM l_sql
   DECLARE lni_cs3 CURSOR FOR lni_pre3
   FOREACH lni_cs3 INTO l_lni04
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF
      LET l_cnt = 0
      #判斷其他生效營運中心是否已存在此兌換單號
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lpq_file'),
                  "   WHERE lpq01 = '",g_lpq.lpq01,"'  AND lpq08 = 'Y' AND lpq15 = 'Y' ",
                  "     AND lpqacti = 'Y' ",
                  "     AND lpq03 = '",g_lpq.lpq03,"' ",  #CHI-C80047 add
                  "     AND lpq00 = '",g_lpq.lpq00,"' "   #FUN-C60089 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('lni04',l_lni04,l_lni04,'alm-h32',1)
         LET g_success = 'N'
      END IF

      #判斷營運中心是否符合卡種生效營運中心
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lpq.lpq03,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_lni04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_lni04 ) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt

      IF l_cnt = 0 OR cl_null(l_cnt) THEN
         CALL s_errmsg('lni04',l_lni04,l_lni04,'alm-h33',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   CALL s_showmsg()
  #CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION

FUNCTION i600_lpq01(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lsl01     LIKE lsl_file.lsl01
    DEFINE l_lsl02     LIKE lsl_file.lsl02
    DEFINE l_lsl03     LIKE lsl_file.lsl03
    DEFINE l_lsl04     LIKE lsl_file.lsl04
    DEFINE l_lsl05     LIKE lsl_file.lsl05
    DEFINE l_lslconf   LIKE lsl_file.lslconf

    LET g_errno = ' '
    SELECT lsl01,lsl02,lsl03,lsl04,lsl05,lslconf
      INTO l_lsl01,l_lsl02,l_lsl03,l_lsl04,l_lsl05,l_lslconf
      FROM lsl_file WHERE lsl02 = g_lpq.lpq01
                      AND lsl01 = g_lpq.lpq13 

   #CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'     #FUN-C50137 add
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-h59'     #FUN-C50137 add
         WHEN l_lslconf='N'      LET g_errno = 'mfg9028'
         WHEN l_lsl01 <> g_plant LET g_errno = 'art-663'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_lpq.lpq02 = l_lsl03
   #IF p_cmd = 'a' THEN   #CHI-C80047 mark
    IF p_cmd = 'a' AND g_action_choice <> 'reproduce' THEN         #CHI-C80047 add
       LET g_lpq.lpq04 = l_lsl04
       LET g_lpq.lpq05 = l_lsl05
    END IF
    DISPLAY BY NAME g_lpq.lpq02, g_lpq.lpq04, g_lpq.lpq05
END FUNCTION

FUNCTION i600_entry_lpq17()
  IF g_lpq.lpq17 = '1' THEN   #當兌換限制為1.不限兌換次數時,兌換次數不可編輯
     LET g_lpq.lpq18 = 0
     DISPLAY BY NAME g_lpq.lpq18
     CALL cl_set_comp_entry("lpq18",FALSE)
  ELSE
     CALL cl_set_comp_entry("lpq18",TRUE)
     CALL cl_set_comp_required("lpq18",TRUE) 
  END IF
END FUNCTION

#FUN-C50137 add END
#FUN-C90067 add START
FUNCTION i600_chk_lprpk()
DEFINE l_n      LIKE type_file.num5

   LET l_n = 0 
   LET g_errno = ' ' 
   IF cl_null(l_ac) OR l_ac = 0 THEN RETURN END IF
   IF cl_null(g_lpr[l_ac].lpr06) THEN RETURN END IF
   
   IF g_argv1 = '0' AND NOT cl_null(g_lpr[l_ac].lpr02) AND NOT cl_null(g_lpr[l_ac].lpr03) THEN 
      SELECT COUNT(*) INTO l_n FROM lpr_file
       WHERE lpr00 = g_lpq.lpq00
         AND lpr01 = g_lpq.lpq01   
         AND lpr02 = g_lpr[l_ac].lpr02
         AND lpr03 = g_lpr[l_ac].lpr03
         AND lpr06 <> g_lpr[l_ac].lpr06
         AND lpr08 = g_lpq.lpq13   
         AND lpr09 = g_lpq.lpq03   
         AND lprplant = g_plant    
      IF l_n > 0 THEN
         LET g_errno = 'alm-h73'
      END IF
   END IF

   IF g_argv1 = '1' AND NOT cl_null(g_lpr[l_ac].lpr07) AND NOT cl_null(g_lpr[l_ac].lpr03) THEN
      SELECT COUNT(*) INTO l_n FROM lpr_file
       WHERE lpr00 = g_lpq.lpq00
         AND lpr01 = g_lpq.lpq01   
         AND lpr03 = g_lpr[l_ac].lpr03
         AND lpr06 <> g_lpr[l_ac].lpr06
         AND lpr07 = g_lpr[l_ac].lpr07
         AND lpr08 = g_lpq.lpq13   
         AND lpr09 = g_lpq.lpq03   
         AND lprplant = g_plant    
      IF l_n > 0 THEN
         LET g_errno = 'alm-h75'
      END IF
   END IF

  IF NOT cl_null(g_errno) THEN RETURN END IF

  IF NOT cl_null(g_lpr[l_ac].lpr02) AND NOT cl_null(g_lpr[l_ac].lpr03) 
   AND NOT cl_null(g_lpr[l_ac].lpr04) AND NOT cl_null(g_lpr[l_ac].lpr05) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lpr_file
       WHERE lpr00 = g_lpq.lpq00
         AND lpr01 = g_lpq.lpq01
         AND lpr03 = g_lpr[l_ac].lpr03
         AND lpr04 = g_lpr[l_ac].lpr04
         AND lpr05 = g_lpr[l_ac].lpr05
         AND lpr06 <> g_lpr[l_ac].lpr06
         AND lpr08 = g_lpq.lpq13
         AND lpr09 = g_lpq.lpq03
         AND lprplant = g_plant
      IF l_n > 0 THEN
         IF g_argv1 = '0' THEN
            LET g_errno = 'alm-h74'
         ELSE
            LET g_errno = 'alm-h76'
         END IF
      END IF
  END IF

END FUNCTION   
#FUN-C90067 add END

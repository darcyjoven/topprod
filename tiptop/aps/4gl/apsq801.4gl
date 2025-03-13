# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsq801.4gl
# Descriptions...: APS規劃結果查詢作業
# Date & Author..: 97/05/05 By Derrick  
# Modify.........: No.FUN-840214 08/05/05 By Derrick 功能新增
# Modify.........: No.FUN-840209 08/05/26 By Duke APS版本開窗並以多筆顯示,change vzu to vzu
# Modify.........: No.FUN-860060 08/06/27 BY DUKE
# Modify.........: No.FUN-870027 08/07/02 BY DUKE
# Modify...........No.TQC-890023 08/09/18 BY DUKE 無資料時，按下加班資訊action，畫面會被關掉
# Modify.........: NO.TQC-940098 09/05/07 BY destiny 1.將嵌套sql改臨時表的形式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50050 11/05/11 By Mandy APS GP5.25 追版---str---
# Modify.........: No.FUN-940012 09/04/29 By Duke 調整APS版本開窗模式
# Modify.........: No.FUN-A30099 10/03/26 By Lilan 加班資訊串加班資訊按鈕apsi320時沒有關聯顯示出相關資料
# Modify.........: No:FUN-B50050 11/05/11 By Mandy ------------------end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_arr1         DYNAMIC ARRAY OF RECORD #FUN-840214
            vol08         LIKE  vol_file.vol08,  #FUN-860060
            vol09         LIKE  vol_file.vol09,  #FUN-860060
            vol03         LIKE  vol_file.vol03,
            vol10         LIKE  vol_file.vol10,  #FUN-860060
            vol04         LIKE  vol_file.vol04,
            vol05         LIKE  vol_file.vol05,
            vol06         LIKE  vol_file.vol06,
            vol07         LIKE  vol_file.vol07
                        END RECORD
DEFINE   g_arr2         DYNAMIC ARRAY OF RECORD
            vom03       LIKE  vom_file.vom03,  #FUN-860060  vom00-->vom03
            vom04       LIKE  vom_file.vom04,
            vom05       LIKE  vom_file.vom05,
            vom06       LIKE  vom_file.vom06,
            vom07       LIKE  vom_file.vom07,
            vom08       LIKE  vom_file.vom08,
            vom09       LIKE  vom_file.vom09,
            vom10       LIKE  vom_file.vom10,
            vom11       LIKE  vom_file.vom11,
            vom12       LIKE  vom_file.vom12
                        END RECORD
DEFINE   g_arr3         DYNAMIC ARRAY OF RECORD
            von03       LIKE  von_file.von03,
            von04       LIKE  von_file.von04,
            von05       LIKE  von_file.von05,
            von06       LIKE  von_file.von06,
            von07       LIKE  von_file.von07,
            von08       LIKE  von_file.von08,
            von09       LIKE  von_file.von09
                        END RECORD
DEFINE   g_arr4         DYNAMIC ARRAY OF RECORD
            voo03       LIKE  voo_file.voo03,
            voo04       LIKE  voo_file.voo04,
            voo05       LIKE  voo_file.voo05,
            voo06       LIKE  voo_file.voo06,
            voo07       LIKE  voo_file.voo07,
            voo08       LIKE  voo_file.voo08,
            voo09       LIKE  voo_file.voo09
                        END RECORD
DEFINE   g_arr5         DYNAMIC ARRAY OF RECORD
            vop03       LIKE  vop_file.vop03,
            vop04       LIKE  vop_file.vop04,
            vop05       LIKE  vop_file.vop05,
            vop06       LIKE  vop_file.vop06,
            vop07       LIKE  vop_file.vop07,
            vop08       LIKE  vop_file.vop08,
            vop09       LIKE  vop_file.vop09,
            vop10       LIKE  vop_file.vop10,
            vop11       LIKE  vop_file.vop11,
            vop12       LIKE  vop_file.vop12,
            vop13       LIKE  vop_file.vop13,
            vop14       LIKE  vop_file.vop14
                        END RECORD
                        
DEFINE   g_vol              RECORD LIKE vol_file.*,
         g_vom              RECORD LIKE vom_file.*,
         g_von              RECORD LIKE von_file.*,
         g_voo              RECORD LIKE voo_file.*,
         g_vop              RECORD LIKE vop_file.*,
         g_vzu              RECORD LIKE vzu_file.*,
 
         g_bbb_flag         LIKE type_file.chr1,          
         g_bbb              ARRAY[600] of LIKE type_file.chr1000,      
          g_wc,g_wc2         string,  
          g_sql              string,  
         g_rec_b            LIKE type_file.num5          
DEFINE   g_b_flag           LIKE type_file.num5          
DEFINE   g_row_count        LIKE type_file.num10        
DEFINE   g_curs_index       LIKE type_file.num10         
DEFINE   g_msg              LIKE type_file.chr1000    
DEFINE   l_ac               LIKE type_file.num5
DEFINE   g_cnt              LIKE type_file.num5       
DEFINE   g_jump             LIKE type_file.num10        
DEFINE   mi_no_ask          LIKE type_file.num5
DEFINE   g_confirm          LIKE type_file.chr1    
DEFINE   g_close            LIKE type_file.chr1  
DEFINE   g_void             LIKE type_file.chr1      
DEFINE   g_vzu01            LIKE vzu_file.vzu01
DEFINE   g_vzu02            LIKE vzu_file.vzu02
DEFINE   g_temp             STRING                  #No.TQC-940098
MAIN
   DEFINE   p_row,p_col   LIKE type_file.num5
      OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW t801_w AT p_row,p_col WITH FORM "aps/42f/apsq801"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL q801_q()
   LET g_b_flag='1'  #FUN-870027  LET PAGE NO DEFAULT 1
   CALL q801_menu()
   CLOSE WINDOW t801_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q801_cs()
   INITIALIZE g_vzu.* TO NULL  
      CONSTRUCT BY NAME g_wc ON vzu01, vzu02
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
           WHEN INFIELD(vzu01)
              CALL cl_init_qry_var()
             #FUN-940012 MOD --STR----------------------------
             #LET g_qryparam.form = "q_vzu01"
             #LET g_qryparam.state = "c"
             #LET g_qryparam.default1 = g_vzu01
             #CALL cl_create_qry() RETURNING g_qryparam.multiret
             #DISPLAY g_qryparam.multiret TO vzu01
              LET g_qryparam.form = "q_vzu02"
              LET g_qryparam.default1 = g_vzu.vzu01
              LET g_qryparam.arg1 = g_plant CLIPPED
              CALL cl_create_qry() RETURNING g_vzu.vzu01,g_vzu.vzu02
              DISPLAY BY NAME g_vzu.vzu01,g_vzu.vzu02
             #FUN-940012 MOD --END-----------------------------
         END CASE
 
 
 
 
         ON ACTION info
            LET g_b_flag = "1"
 
         ON ACTION lock_sys
            LET g_b_flag = "2"
 
         ON ACTION lock_equ
            LET g_b_flag = "3"
 
         ON ACTION outsource
            LET g_b_flag = "4"
 
         ON ACTION out_pro
            LET g_b_flag = "5"
 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG OR g_action_choice = "exit" THEN   
         RETURN
      END IF
 
   LET g_sql = "SELECT  vzu01,vzu02,vzu03 FROM vzu_file", #FUN-B50050 add vzu03
               " WHERE vzu02<>'0' AND vzu03=10 AND ", g_wc CLIPPED,
               " ORDER BY vzu01"
 
   PREPARE q801_prepare FROM g_sql
   DECLARE q801_cs SCROLL CURSOR WITH HOLD FOR q801_prepare
 
   LET g_temp="SELECT DISTINCT vzu01,vzu02 from vzu_file INTO TEMP x"                                                               
   DROP TABLE x                                                                                                                     
   PREPARE q801_pre_x FROM g_temp                                                                                                   
   EXECUTE q801_pre_x                                                                                                               
   LET g_sql="SELECT COUNT(*) FROM x WHERE vzu02!='0' AND ",g_wc CLIPPED                                                            
   PREPARE q801_precount FROM g_sql
   DECLARE q801_count CURSOR FOR q801_precount
END FUNCTION
 
FUNCTION q801_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
         WHEN '1'
            CALL q801_bp1("G")
         WHEN '2'
            CALL q801_bp2("G")
         WHEN '3'
            CALL q801_bp3("G")
         WHEN '4'
            CALL q801_bp4("G")
         WHEN '5'
            CALL q801_bp5("G")
         OTHERWISE
            CALL q801_bp1("G")
      END CASE
 
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         #@WHEN "查詢"
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q801_q()
            END IF
 
#        #@WHEN "加班資訊"
         WHEN "info"
            CALL q801_1()
            LET g_b_flag = "1"
 
#        #@WHEN "鎖定製程時間"
         WHEN "lock_sys"
            CALL q801_2()
            LET g_b_flag = "2"
 
#        #@WHEN "鎖定使用設備"
         WHEN "lock_equ"
            CALL q801_3()
            LET g_b_flag = "3"
 
#        #@WHEN "工單外包"
         WHEN "outsource"
            CALL q801_4()
            LET g_b_flag = "4"
 
#        #@WHEN "工單外包"
         WHEN "out_pro"
            CALL q801_5()
            LET g_b_flag = "5"
 
         #@WHEN "加班資訊--按鈕"
         WHEN "b1"
            if g_b_flag="1" THEN   #FUN-870027
              #FUN-A30099 mod str ------
              #LET g_msg="apsi320  '",g_arr1[l_ac].vol03,"' '",g_arr1[l_ac].vol04,"' '",g_arr1[l_ac].vol05,"' '",g_arr1[l_ac].vol08,"' '",g_arr1[l_ac].vol09,"'"
               LET g_msg="apsi320  '",g_arr1[l_ac].vol03,"' '",g_arr1[l_ac].vol04,"' '' '",g_arr1[l_ac].vol08,"' '",g_arr1[l_ac].vol09,"' '",g_arr1[l_ac].vol10,"' '' ''"
              #FUN-A30099 mod end ------
               CALL cl_cmdrun(g_msg)
            end if
 
         #@WHEN "工單維護作業—按鈕"
         WHEN "b2"
           if g_b_flag="2" and l_ac>0 THEN
              LET g_msg="asfi301 '",g_arr2[l_ac].vom03,"' query"
              CALL cl_cmdrun(g_msg)
           end if
          if g_b_flag="3" and l_ac>0 THEN
             LET g_msg="asfi301 '",g_arr3[l_ac].von03,"' query"
             CALL cl_cmdrun(g_msg)
          end if
          if g_b_flag="5" and l_ac>0 THEN
             LET g_msg="asfi301 '",g_arr5[l_ac].vop03,"' query"
             CALL cl_cmdrun(g_msg)
          end if
          if g_b_flag="4" and l_ac>0 THEN
             LET g_msg="asfi301 '",g_arr4[l_ac].voo03,"' query"
             CALL cl_cmdrun(g_msg)
          end if
 
      END CASE
   END WHILE
END FUNCTION
FUNCTION q801_show()
   DISPLAY BY NAME   g_vzu.vzu01, g_vzu.vzu02
   
   
   CASE g_b_flag
      WHEN '1'
         CALL g_arr1.clear()
         CALL q801_1()
      WHEN '2'
         CALL g_arr2.clear()
         CALL q801_2()
      WHEN '3'
         CALL g_arr3.clear()
         CALL q801_3()
      WHEN '4'
         CALL g_arr4.clear()
         CALL q801_4()
      WHEN '5'
         CALL g_arr5.clear()
         CALL q801_5()
       OTHERWISE
         CALL q801_1()
   END CASE
    CALL cl_show_fld_cont()             
END FUNCTION
FUNCTION q801_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,          #處理方式          
            l_abso   LIKE type_file.num10          #絕對的筆數        
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q801_cs INTO g_vzu.vzu01,g_vzu.vzu02,g_vzu.vzu03 #FUN-B50050 add vzu03
      WHEN 'P' FETCH PREVIOUS q801_cs INTO g_vzu.vzu01,g_vzu.vzu02,g_vzu.vzu03 #FUN-B50050 add vzu03
      WHEN 'F' FETCH FIRST    q801_cs INTO g_vzu.vzu01,g_vzu.vzu02,g_vzu.vzu03 #FUN-B50050 add vzu03
      WHEN 'L' FETCH LAST     q801_cs INTO g_vzu.vzu01,g_vzu.vzu02,g_vzu.vzu03 #FUN-B50050 add vzu03
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump q801_cs INTO g_vzu.vzu01,g_vzu.vzu02,g_vzu.vzu03  #FUN-840209 add vzu02 #FUN-B50050 add vzu03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
 
      INITIALIZE g_vzu.* TO NULL
      CALL g_arr1.clear()
      CALL g_arr2.clear()
      CALL g_arr3.clear()
      CALL g_arr4.clear()
      CALL g_arr5.clear()
 
 
      CALL cl_err(g_vzu.vzu01,SQLCA.sqlcode,0)
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
   END IF
   SELECT * INTO g_vzu.* FROM vzu_file WHERE vzu00=g_plant AND vzu01=g_vzu.vzu01 AND vzu02=g_vzu.vzu02 AND vzu03=g_vzu.vzu03
   IF SQLCA.sqlcode THEN
 
      INITIALIZE g_vzu.* TO NULL
      CALL g_arr1.clear()
      CALL g_arr2.clear()
      CALL g_arr3.clear()
      CALL g_arr4.clear()
      CALL g_arr5.clear()
 
      CALL cl_err3("sel","vzu_file",g_vzu.vzu01,"",SQLCA.sqlcode,"","",0)   
 
      RETURN
   END IF
   CALL q801_show()
END FUNCTION
FUNCTION q801_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_b_flag = ""
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q801_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_vzu.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN q801_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vzu.* TO NULL
   ELSE
      OPEN q801_count
      FETCH q801_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q801_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION q801_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr1 TO s_arr1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q801_fetch('F')
         EXIT DISPLAY
         CALL q801_bp1_refresh()
 
      ON ACTION previous
         CALL q801_fetch('P')
         EXIT DISPLAY
         CALL q801_bp1_refresh()
 
      ON ACTION jump
         CALL q801_fetch('/')
         EXIT DISPLAY
         CALL q801_bp1_refresh()
 
      ON ACTION next
         CALL q801_fetch('N')
         EXIT DISPLAY
         CALL q801_bp1_refresh()
 
      ON ACTION last
         CALL q801_fetch('L')
         EXIT DISPLAY
         CALL q801_bp1_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 加班資訊
      ON ACTION info
         IF cl_null(g_rec_b) or g_rec_b=0 THEN 
            LET g_action_choice = ''
            CALL cl_err('','ain-070',0)
         ELSE 
            LET g_action_choice="info"
         END IF
         EXIT DISPLAY
 
      #@ON ACTION 鎖定製程時間
      ON ACTION lock_sys
         LET g_action_choice="lock_sys"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定使用設備
      ON ACTION lock_equ
         LET g_action_choice="lock_equ"
         EXIT DISPLAY
 
      #@ON ACTION 工單外包
      ON ACTION outsource
         LET g_action_choice="outsource"
         EXIT DISPLAY
 
      #@ON ACTION 製程外包
      ON ACTION out_pro
         LET g_action_choice="out_pro"
         EXIT DISPLAY
 
      #@ON ACTION加班資訊--按鈕
      ON ACTION b1
         IF cl_null(g_rec_b) or g_rec_b =0 THEN
            LET g_action_choice = ''
            CALL cl_err('','ain-070',0) 
         ELSE LET g_action_choice="b1"
         END IF 
         EXIT DISPLAY
 
      #@ON ACTION工單維護作業—按鈕
      ON ACTION b2
         LET g_action_choice="b2"
         EXIT DISPLAY
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
                                                                                                    
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q801_bp1_refresh()
   DISPLAY ARRAY g_arr1 TO s_arr1.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION q801_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr2 TO s_arr2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q801_fetch('F')
         EXIT DISPLAY
         CALL q801_bp2_refresh()
 
      ON ACTION previous
         CALL q801_fetch('P')
         EXIT DISPLAY
         CALL q801_bp2_refresh()
 
      ON ACTION jump
         CALL q801_fetch('/')
         EXIT DISPLAY
         CALL q801_bp2_refresh()
 
      ON ACTION next
         CALL q801_fetch('N')
         EXIT DISPLAY
         CALL q801_bp2_refresh()
 
      ON ACTION last
         CALL q801_fetch('L')
         EXIT DISPLAY
         CALL q801_bp2_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 加班資訊
      ON ACTION info
         LET g_action_choice="info"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定製程時間
      ON ACTION lock_sys
         LET g_action_choice="lock_sys"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定使用設備
      ON ACTION lock_equ
         LET g_action_choice="lock_equ"
         EXIT DISPLAY
 
      #@ON ACTION 工單外包
      ON ACTION outsource
         LET g_action_choice="outsource"
         EXIT DISPLAY
 
      #@ON ACTION 製程外包
      ON ACTION out_pro
         LET g_action_choice="out_pro"
         EXIT DISPLAY
 
      #@ON ACTION加班資訊--按鈕
      ON ACTION b1
         LET g_action_choice="b1"
         EXIT DISPLAY
 
      #@ON ACTION工單維護作業—按鈕
      ON ACTION b2
         LET g_action_choice="b2"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
                                                                                                    
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q801_bp2_refresh()
   DISPLAY ARRAY g_arr2 TO s_arr2.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION q801_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr3 TO s_arr3.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q801_fetch('F')
         EXIT DISPLAY
         CALL q801_bp3_refresh()
 
      ON ACTION previous
         CALL q801_fetch('P')
         EXIT DISPLAY
         CALL q801_bp3_refresh()
 
      ON ACTION jump
         CALL q801_fetch('/')
         EXIT DISPLAY
         CALL q801_bp3_refresh()
 
      ON ACTION next
         CALL q801_fetch('N')
         EXIT DISPLAY
         CALL q801_bp3_refresh()
 
      ON ACTION last
         CALL q801_fetch('L')
         EXIT DISPLAY
         CALL q801_bp3_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 加班資訊
      ON ACTION info
         LET g_action_choice="info"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定製程時間
      ON ACTION lock_sys
         LET g_action_choice="lock_sys"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定使用設備
      ON ACTION lock_equ
         LET g_action_choice="lock_equ"
         EXIT DISPLAY
 
      #@ON ACTION 工單外包
      ON ACTION outsource
         LET g_action_choice="outsource"
         EXIT DISPLAY
 
      #@ON ACTION 製程外包
      ON ACTION out_pro
         LET g_action_choice="out_pro"
         EXIT DISPLAY
 
      #@ON ACTION加班資訊--按鈕
      ON ACTION b1
         LET g_action_choice="b1"
         EXIT DISPLAY
 
      #@ON ACTION工單維護作業—按鈕
      ON ACTION b2
         LET g_action_choice="b2"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
                                                                                                    
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q801_bp3_refresh()
   DISPLAY ARRAY g_arr3 TO s_arr3.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION q801_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr4 TO s_arr4.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q801_fetch('F')
         EXIT DISPLAY
         CALL q801_bp4_refresh()
 
      ON ACTION previous
         CALL q801_fetch('P')
         EXIT DISPLAY
         CALL q801_bp4_refresh()
 
      ON ACTION jump
         CALL q801_fetch('/')
         EXIT DISPLAY
         CALL q801_bp4_refresh()
 
      ON ACTION next
         CALL q801_fetch('N')
         EXIT DISPLAY
         CALL q801_bp4_refresh()
 
      ON ACTION last
         CALL q801_fetch('L')
         EXIT DISPLAY
         CALL q801_bp4_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 加班資訊
      ON ACTION info
         LET g_action_choice="info"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定製程時間
      ON ACTION lock_sys
         LET g_action_choice="lock_sys"
         EXIT DISPLAY
 
      #@ON ACTION 鎖定使用設備
      ON ACTION lock_equ
         LET g_action_choice="lock_equ"
         EXIT DISPLAY
 
      #@ON ACTION 工單外包
      ON ACTION outsource
         LET g_action_choice="outsource"
         EXIT DISPLAY
 
      #@ON ACTION 製程外包
      ON ACTION out_pro
         LET g_action_choice="out_pro"
         EXIT DISPLAY
 
      #@ON ACTION加班資訊--按鈕
      ON ACTION b1
         LET g_action_choice="b1"
         EXIT DISPLAY
 
      #@ON ACTION工單維護作業—按鈕
      ON ACTION b2
         LET g_action_choice="b2"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
                                                                                                    
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q801_bp4_refresh()
   DISPLAY ARRAY g_arr4 TO s_arr4.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION q801_bp5(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr5 TO s_arr5.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q801_fetch('F')
         EXIT DISPLAY
         CALL q801_bp5_refresh()
 
      ON ACTION previous
         CALL q801_fetch('P')
         EXIT DISPLAY
         CALL q801_bp5_refresh()
 
      ON ACTION jump
         CALL q801_fetch('/')
         EXIT DISPLAY
         CALL q801_bp5_refresh()
 
      ON ACTION next
         CALL q801_fetch('N')
         EXIT DISPLAY
         CALL q801_bp5_refresh()
 
      ON ACTION last
         CALL q801_fetch('L')
         EXIT DISPLAY
         CALL q801_bp5_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 加班資訊
      ON ACTION info
         LET g_action_choice="info"
         LET g_b_flag=1
         EXIT DISPLAY
 
      #@ON ACTION 鎖定製程時間
      ON ACTION lock_sys
         LET g_action_choice="lock_sys"
         LET g_b_flag=2
         EXIT DISPLAY
 
      #@ON ACTION 鎖定使用設備
      ON ACTION lock_equ
         LET g_action_choice="lock_equ"
         LET g_b_flag=3
         EXIT DISPLAY
 
      #@ON ACTION 工單外包
      ON ACTION outsource
         LET g_action_choice="outsource"
         LET g_b_flag=4
         EXIT DISPLAY
 
      #@ON ACTION 製程外包
      ON ACTION out_pro
         LET g_action_choice="out_pro"
         LET g_b_flag=5
         EXIT DISPLAY
 
      #@ON ACTION加班資訊--按鈕
      ON ACTION b1
         LET g_action_choice="b1"
         EXIT DISPLAY
 
      #@ON ACTION工單維護作業—按鈕
      ON ACTION b2
         LET g_action_choice="b2"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
                                                                                                    
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q801_bp5_refresh()
   DISPLAY ARRAY g_arr5 TO s_arr5.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q801_1()
   DEFINE   l_vol      RECORD LIKE vol_file.*
 
 
   DECLARE q801_1_c CURSOR FOR
      SELECT * FROM vol_file
      WHERE vol01 = g_vzu.vzu01
        AND vol02 = g_vzu.vzu02
       ORDER BY vol01
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q801_1_c INTO l_vol.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr1[g_cnt].vol08  = l_vol.vol08  #FUN-860060
      LET g_arr1[g_cnt].vol09  = l_vol.vol09  #FUN-860060
      LET g_arr1[g_cnt].vol03  = l_vol.vol03
      LET g_arr1[g_cnt].vol10  = l_vol.vol10  #FUN-860060
      LET g_arr1[g_cnt].vol04  = l_vol.vol04
      LET g_arr1[g_cnt].vol05  = l_vol.vol05
      LET g_arr1[g_cnt].vol06  = l_vol.vol06
      LET g_arr1[g_cnt].vol07  = l_vol.vol07
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   IF g_rec_b = 0 THEN CALL g_arr1.clear() END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
FUNCTION q801_2()
   DEFINE   l_vom      RECORD LIKE vom_file.*
 
 
   DECLARE q801_2_c CURSOR FOR
      SELECT * FROM vom_file
      WHERE vom01 = g_vzu.vzu01
        AND vom02 = g_vzu.vzu02
       ORDER BY vom01
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q801_2_c INTO l_vom.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr2[g_cnt].vom03  = l_vom.vom03
      LET g_arr2[g_cnt].vom04  = l_vom.vom04
      LET g_arr2[g_cnt].vom05  = l_vom.vom05
      LET g_arr2[g_cnt].vom06  = l_vom.vom06
      LET g_arr2[g_cnt].vom07  = l_vom.vom07
      LET g_arr2[g_cnt].vom08  = l_vom.vom08
      LET g_arr2[g_cnt].vom09  = l_vom.vom09
      LET g_arr2[g_cnt].vom10  = l_vom.vom10
      LET g_arr2[g_cnt].vom11  = l_vom.vom11
      LET g_arr2[g_cnt].vom12  = l_vom.vom12
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
FUNCTION q801_3()
   DEFINE   l_von      RECORD LIKE von_file.*
 
 
   DECLARE q801_3_c CURSOR FOR
      SELECT * FROM von_file
      WHERE von01 = g_vzu.vzu01
        AND von02 = g_vzu.vzu02
       ORDER BY von01
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q801_3_c INTO l_von.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr3[g_cnt].von03  = l_von.von03
      LET g_arr3[g_cnt].von04  = l_von.von04
      LET g_arr3[g_cnt].von05  = l_von.von05
      LET g_arr3[g_cnt].von06  = l_von.von06
      LET g_arr3[g_cnt].von07  = l_von.von07
      LET g_arr3[g_cnt].von08  = l_von.von08
      LET g_arr3[g_cnt].von09  = l_von.von09
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
FUNCTION q801_4()
   DEFINE   l_voo      RECORD LIKE voo_file.*
 
 
   DECLARE q801_4_c CURSOR FOR
      SELECT * FROM voo_file
      WHERE voo01 = g_vzu.vzu01
        AND voo02 = g_vzu.vzu02
 
       ORDER BY voo01
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q801_4_c INTO l_voo.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr4[g_cnt].voo03  = l_voo.voo03
      LET g_arr4[g_cnt].voo04  = l_voo.voo04
      LET g_arr4[g_cnt].voo05  = l_voo.voo05
      LET g_arr4[g_cnt].voo06  = l_voo.voo06
      LET g_arr4[g_cnt].voo07  = l_voo.voo07
      LET g_arr4[g_cnt].voo08  = l_voo.voo08
      LET g_arr4[g_cnt].voo09  = l_voo.voo09
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
FUNCTION q801_5()
   DEFINE   l_vop      RECORD LIKE vop_file.*
 
   CALL g_arr5.clear() #FUN-870027
 
   DECLARE q801_5_c CURSOR FOR
      SELECT * FROM vop_file
      WHERE vop01 = g_vzu.vzu01
        AND vop02 = g_vzu.vzu02
       ORDER BY vop01
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q801_5_c INTO l_vop.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr5[g_cnt].vop03  = l_vop.vop03
      LET g_arr5[g_cnt].vop04  = l_vop.vop04
      LET g_arr5[g_cnt].vop05  = l_vop.vop05
      LET g_arr5[g_cnt].vop06  = l_vop.vop06
      LET g_arr5[g_cnt].vop07  = l_vop.vop07
      LET g_arr5[g_cnt].vop08  = l_vop.vop08
      LET g_arr5[g_cnt].vop09  = l_vop.vop09
      LET g_arr5[g_cnt].vop10  = l_vop.vop10
      LET g_arr5[g_cnt].vop11  = l_vop.vop11
      LET g_arr5[g_cnt].vop12  = l_vop.vop12
      LET g_arr5[g_cnt].vop13  = l_vop.vop13
      LET g_arr5[g_cnt].vop14  = l_vop.vop14
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
#No.FUN-9C0072 精簡程式碼

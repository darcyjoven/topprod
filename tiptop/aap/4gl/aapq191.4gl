# Prog. Version..: '5.30.30-19.08.21(00000)'     #
#
# Pattern name...: aapq191.4gl
# Descriptions...: 廠商應付帳齡分析查询
# Date & Author..: #FUN-B60071   11/06/21 By suncx
# Modify.........: No.FUN-B60129 11/06/24 By suncx 增加按鈕串查明細
# Modify.........: No.FUN-BB0038 11/11/14 By elva 简称由单据抓取
# Modify.........: No.TQC-C30333 12/03/30 By zhangll 日期默認帶出月底日期
# Modify.........: No.TQC-C30349 12/04/06 By lujh 增加幣別欄位
# Modify.........: No.FUN-C80102 12/10/10 By yangtt 報表改善
# Modify.........: No.FUN-CB0146 12/12/04 By wangrr 程序優化
# Modify.........: No.FUN-D10142 13/01/31 By yangtt 取消打印功能
# Modify.........: No.TQC-D60017 13/06/05 By wangrr 增加apa36開窗
# Modify.........: No:FUN-D70118 13/07/29 By lujh 會計年期會不按照自然年月設置,修改全系統邏輯，年期的判斷需要按照aooq011的設置來
# Modify.........: No:MOD-G10097 16/01/18 By doris 相關 alz07<'",tm.edate,"'"條件 ,改為 <=
# Modify.........: No:MOD-G10167 16/01/28 By doris 1.q191_b_fill函式,組g_sql的SELECT 順序有誤
#                                                  2.q191_get_tmp函式,tm.org為'N'時,l_sql 應判斷tm.a決定WHERE 條件是 立帳日(alz06)或收付款日(alz07)
# Modify.........: No:MOD-G10179 16/02/01 By doris aly03/aly04格式化USING調整為<<<<<(同schema欄位長度)

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_alz DYNAMIC ARRAY OF RECORD             
               apa06   LIKE apa_file.apa06,
              #FUN-C80102-----add----str---
               apa07   LIKE apa_file.apa07,
               apa34f  LIKE apa_file.apa34f,
               apa35f  LIKE apa_file.apa35f,
               apa13   LIKE apa_file.apa13,
               apa14   LIKE apa_file.apa14,
               amt_1   LIKE apa_file.apa34,
               sum1    LIKE alz_file.alz09,
               sum3    LIKE alz_file.alz09,
               apa34   LIKE apa_file.apa34,
               apa35   LIKE apa_file.apa35,
               amt_2   LIKE apa_file.apa34,              
               sum2    LIKE alz_file.alz09,               
               sum4    LIKE alz_file.alz09, 
              #FUN-C80102-----add----end---
               amt1    LIKE alz_file.alz09,
               bamt1   LIKE alz_file.alz09, 
               amt2    LIKE alz_file.alz09,
               bamt2   LIKE alz_file.alz09,
               amt3    LIKE alz_file.alz09,
               bamt3   LIKE alz_file.alz09,
               amt4    LIKE alz_file.alz09,
               bamt4   LIKE alz_file.alz09,
               amt5    LIKE alz_file.alz09,
               bamt5   LIKE alz_file.alz09,
               amt6    LIKE alz_file.alz09,
               bamt6   LIKE alz_file.alz09,
               amt7    LIKE alz_file.alz09,
               bamt7   LIKE alz_file.alz09,
               amt8    LIKE alz_file.alz09,
               bamt8   LIKE alz_file.alz09,
               amt9    LIKE alz_file.alz09,
               bamt9   LIKE alz_file.alz09,
               amt10   LIKE alz_file.alz09,
               bamt10  LIKE alz_file.alz09,
               amt11   LIKE alz_file.alz09,
               bamt11  LIKE alz_file.alz09,
               amt12   LIKE alz_file.alz09,
               bamt12  LIKE alz_file.alz09,
               amt13   LIKE alz_file.alz09,
               bamt13  LIKE alz_file.alz09,
               amt14   LIKE alz_file.alz09,
               bamt14  LIKE alz_file.alz09,
               amt15   LIKE alz_file.alz09,
               bamt15  LIKE alz_file.alz09,
               amt16   LIKE alz_file.alz09,
               bamt16  LIKE alz_file.alz09,
               amt17   LIKE alz_file.alz09,
               bamt17  LIKE alz_file.alz09,
              #FUN-C80102-----add----str---
               sum5    LIKE alz_file.alz09,
               apa15   LIKE apa_file.apa15,
               apa16   LIKE apa_file.apa16,
               net1    LIKE type_file.num5,
               net2    LIKE type_file.num5,
               apa21   LIKE apa_file.apa21,
               gen02   LIKE gen_file.gen02,
               apa22   LIKE apa_file.apa22,
               gem02   LIKE gem_file.gem02,
               apa08   LIKE apa_file.apa08,
               apa00   LIKE apa_file.apa00,
               apa01   LIKE apa_file.apa01,
               apa02   LIKE apa_file.apa02,
               alz12   LIKE alz_file.alz12,
               alz07   LIKE alz_file.alz07,
               apa11   LIKE apa_file.apa11,
               pma02   LIKE pma_file.pma02,
               apa36   LIKE apa_file.apa36,
               apr02   LIKE apr_file.apr02,
               apa44   LIKE apa_file.apa44,         
               apa54   LIKE apa_file.apa54,
               aag02   LIKE aag_file.aag02,      
              #FUN-C80102-----add----end---
              #FUN-C80102-----mark---str---
              #pmc03   LIKE pmc_file.pmc03,  
              #apa01   LIKE apa_file.apa01, 
              #apa02   LIKE apa_file.apa02,
              #apa13   LIKE apa_file.apa01,   #TQC-C30349  add  #用apa01的字段類型，方便單身"統計"2個字的正常顯示
              #FUN-C80102-----mark---str--- 
              #FUN-C80102----add---str--
               apa05   LIKE apa_file.apa05,  
               pmc03   LIKE pmc_file.pmc03, 
               pmy01   LIKE pmy_file.pmy01,
               pmy02   LIKE pmy_file.pmy02,
               apa41   LIKE apa_file.apa41,   
               column  LIKE type_file.chr100
              #FUN-C80102----add---end-- 
              #sum     LIKE type_file.num20_6   #FUN-C80102 mark
             END RECORD 
#FUN-C80102-----add---str--
DEFINE g_alz_1 DYNAMIC ARRAY OF RECORD
               apa05   LIKE apa_file.apa05,   
               pmc03   LIKE pmc_file.pmc03, 
               apa22   LIKE apa_file.apa22,
               gem02   LIKE gem_file.gem02, 
               apa21   LIKE apa_file.apa21,
               gen02   LIKE gen_file.gen02, 
               apa54   LIKE apa_file.apa54,
               aag02   LIKE aag_file.aag02,                
               apa13   LIKE apa_file.apa01,
               apa34f  LIKE apa_file.apa34f,
               apa35f  LIKE apa_file.apa35f,
               amt_1   LIKE apa_file.apa34,
               sum1    LIKE alz_file.alz09,
               sum3    LIKE alz_file.alz09,
               apa34   LIKE apa_file.apa34,
               apa35   LIKE apa_file.apa35,
               amt_2   LIKE apa_file.apa34,               
               sum2    LIKE alz_file.alz09,               
               sum4    LIKE alz_file.alz09,               
               amt1    LIKE alz_file.alz09,
               bamt1   LIKE alz_file.alz09, 
               amt2    LIKE alz_file.alz09,
               bamt2   LIKE alz_file.alz09,
               amt3    LIKE alz_file.alz09,
               bamt3   LIKE alz_file.alz09,
               amt4    LIKE alz_file.alz09,
               bamt4   LIKE alz_file.alz09,
               amt5    LIKE alz_file.alz09,
               bamt5   LIKE alz_file.alz09,
               amt6    LIKE alz_file.alz09,
               bamt6   LIKE alz_file.alz09,
               amt7    LIKE alz_file.alz09,
               bamt7   LIKE alz_file.alz09,
               amt8    LIKE alz_file.alz09,
               bamt8   LIKE alz_file.alz09,
               amt9    LIKE alz_file.alz09,
               bamt9   LIKE alz_file.alz09,
               amt10   LIKE alz_file.alz09,
               bamt10  LIKE alz_file.alz09,
               amt11   LIKE alz_file.alz09,
               bamt11  LIKE alz_file.alz09,
               amt12   LIKE alz_file.alz09,
               bamt12  LIKE alz_file.alz09,
               amt13   LIKE alz_file.alz09,
               bamt13  LIKE alz_file.alz09,
               amt14   LIKE alz_file.alz09,
               bamt14  LIKE alz_file.alz09,
               amt15   LIKE alz_file.alz09,
               bamt15  LIKE alz_file.alz09,
               amt16   LIKE alz_file.alz09,
               bamt16  LIKE alz_file.alz09,
               amt17   LIKE alz_file.alz09,
               bamt17  LIKE alz_file.alz09,
               sum5    LIKE alz_file.alz09,
               apa06   LIKE apa_file.apa06,
               apa07   LIKE apa_file.apa07,
               pmy01   LIKE pmy_file.pmy01,
               pmy02   LIKE pmy_file.pmy02
             END RECORD 
#FUN-C80102-----add---end--
DEFINE tm    RECORD                         
              #wc     LIKE type_file.chr1000,     # Where condition   #MOD-G10097 mark
               wc     STRING,                                         #MOD-G10097 add 
               aly01  LIKE aly_file.aly01,
               a      LIKE type_file.chr1,
               edate  LIKE type_file.dat,   
               detail LIKE type_file.chr1,  
               zr     LIKE type_file.chr1,
               u      LIKE type_file.chr1,        #FUN-C80102 add
               org    LIKE type_file.chr1,        #TQC-C30349  add
               d      LIKE type_file.chr1,        #FUN-C80102 add
               pay1   LIKE type_file.chr1,       #FUN-C80102 add
               b      LIKE type_file.chr1,       #FUN-C80102 add
               more   LIKE type_file.chr1         # Input more condition(Y/N)
             END RECORD
DEFINE   g_field STRING,
         g_sql   STRING
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   l_ac           LIKE type_file.num5 
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_rec_b2       LIKE type_file.num10   #FUN-C80102 add
DEFINE   g_flag         LIKE type_file.chr1  #FUN-C80102 
DEFINE   g_action_flag  LIKE type_file.chr100  #FUN-C80102
DEFINE   g_filter_wc    STRING  #FUN-C80102 
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_aly   DYNAMIC ARRAY OF RECORD LIKE aly_file.*
#FUN-C80102---add--str--
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
#FUN-C80102---add--end--
DEFINE g_flag1         LIKE type_file.chr1  #FUN-D70118 add
DEFINE g_bookno1       LIKE aza_file.aza81  #FUN-D70118 add
DEFINE g_bookno2       LIKE aza_file.aza82  #FUN-D70118 add

MAIN
   OPTIONS
   INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-B60129--add--str-- 
   INITIALIZE tm.* TO NULL 
   LET tm.wc = ARG_VAL(1)
   LET tm.aly01 = ARG_VAL(2)
   LET tm.a = ARG_VAL(3)
   LET tm.edate = ARG_VAL(4)
   LET tm.detail = ARG_VAL(5)  
   LET tm.zr = ARG_VAL(6) 
   #FUN-B60129--add--str--
   LET tm.org = ARG_VAL(7)   #TQC-C30349  add
   OPEN WINDOW q191_w AT 5,10
        WITH FORM "aap/42f/aapq191" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
#FUN-C80102----mark---str---
#  IF cl_null(tm.wc) THEN
#     CALL q191_tm(0,0)             # Input print condition
#  ELSE
#     CALL q191()
#     CALL aapq191_t()
#  END IF
#FUN-C80102----mark---end---
   LET g_flag = ' '  #FUN-C80102add
   CALL cl_set_comp_visible("amt1,amt2,amt3,amt4,amt5,amt6,amt7,amt8,amt9,amt10",FALSE)  #FUN-C80102 add
   CALL cl_set_comp_visible("amt11,amt12,amt13,amt14,amt15,amt16,amt17",FALSE)  #FUN-C80102 add
   CALL cl_set_comp_visible("bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8,bamt9,bamt10",FALSE)  #FUN-C80102 add
   CALL cl_set_comp_visible("bamt11,bamt12,bamt13,bamt14,bamt15,bamt16,bamt17",FALSE)  #FUN-C80102 add
   CALL cl_set_comp_entry("d",FALSE)  #FUN-C80102 add
   CALL cl_set_act_visible("revert_filter",FALSE)  #FUN-C80102
   CALL q191_table2()  #FUN-CB0146
   CALL q191_tm(0,0)  #FUN-C80102 
   CALL q191_menu()
   #DROP TABLE aapq191_tmp; #FUN-CB0146 mark
   DROP TABLE q191_tmp; #FUN-CB0146 
   CLOSE WINDOW q191_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q191_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      #FUN-C80102--add--str--
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page2" THEN  
            CALL q191_bp("G")
         END IF
         IF g_action_flag = "page3" THEN  
            CALL q191_bp2()
         END IF
      END IF 
#FUN-C80102--add--end--
      CASE g_action_choice
#FUN-C80102--add--str--
      WHEN "page2"
            CALL q191_bp("G")
         
      WHEN "page3"
            CALL q191_bp2()

      WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q191_filter_askkey()
               CALL q191_show()
            ELSE                                 #FUN-C80102
               LET g_action_choice = " "         #FUN-C80102
            END IF            

      WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q191_show() 
            ELSE                                 #FUN-C80102
               LET g_action_choice = " "         #FUN-C80102
            END IF

#FUN-C80102--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q191_tm(0,0)
            ELSE                                 #FUN-C80102
               LET g_action_choice = " "         #FUN-C80102
            END IF
        #FUN-D10142----mark---str---
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL q191_out()
        #   END IF
        #   LET g_action_choice = " "  #FUN-C80102
        #FUN-D10142----mark---end---
        #FUN-C80102---mark----str---
        ##FUN-B60129--add--srt--
        #WHEN "find_detail"
        #   IF cl_chk_act_auth() THEN
        #      CALL q191_detail()
        #   END IF
        ##FUN-B60129--add--end--
        #FUN-C80102---mark----str---
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-C80102
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "  #FUN-C80102
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()      #FUN-C80102 add
            LET f = w.getForm()                 #FUN-C80102 add
            IF g_action_flag = "page2" THEN  #FUN-C80102 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page2")   #FUN-C80102 add
                  CALL cl_export_to_excel
                  (ui.Interface.getRootNode(),base.TypeInfo.create(g_alz),'','')
               END IF
            END IF  #FUN-C80102
#FUN-C80120--add--str--
             IF g_action_flag = "page3" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page3")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_alz_1),'','')
                END IF
             END IF
#FUN-C80120--add--end--
            LET g_action_choice = " "  #FUN-C80102
#        WHEN "related_document"  #相關文件
#           LET g_action_choice = " "  #FUN-C80102

      END CASE
   END WHILE
END FUNCTION

FUNCTION q191_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page2'  #FUN-C80102 
  
   #FUN-C80102--add--str---  #匯總條件不為空時，點擊明細頁簽時顯示input條件下的資料
   IF g_action_choice = "page2"  AND NOT cl_null(tm.u) AND g_flag != '1' THEN
      CALL q191_b_fill()
   END IF
   #FUN-C80102--add--end---
 
   LET g_action_choice = " "
   LET g_flag = " "   #FUN-C80102 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#  CALL cl_set_act_visible("find_detail", tm.detail <> 'Y')  #FUN-C80102 mark
   
   #FUN-C80102--add--str--
   DISPLAY BY NAME tm.u,tm.org,tm.d
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.u,tm.org,tm.d ATTRIBUTES(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("d",TRUE)
            ELSE
               CALL cl_set_comp_entry("d",FALSE)
            END IF
            
            IF NOT cl_null(tm.u)  THEN 
               CALL q191_b_fill_2()
               CALL q191_set_visible()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page3"
            ELSE
               CALL q191_b_fill()
               CALL g_alz_1.clear()
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.apa34_tot
               DISPLAY 0  TO FORMONLY.apa35_tot
               DISPLAY 0  TO FORMONLY.apa34_apa35_tot
               DISPLAY 0  TO FORMONLY.sum_2_tot
               DISPLAY 0  TO FORMONLY.sum_4_tot
            END IF
            DISPLAY BY NAME tm.u
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("d",TRUE)
             ELSE
                CALL cl_set_comp_entry("d",FALSE)
             END IF
             #CALL q191()         #FUN-CB0146 mark
             CALL q191_get_tmp()  #FUN-CB0146
             CALL aapq191_t()
             EXIT DIALOG

          ON CHANGE d
             CALL  q191_b_fill_2()
             CALL q191_set_visible()
             CALL cl_set_comp_visible("page2", FALSE)
             CALL ui.interface.refresh()
             CALL cl_set_comp_visible("page2", TRUE)
             LET g_action_choice = "page3"

      END INPUT  
   #FUN-C80102--add--end-- 
   
  #DISPLAY ARRAY g_alz TO s_alz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-C80102 mark
   DISPLAY ARRAY g_alz TO s_alz.* ATTRIBUTE(COUNT=g_rec_b)            #FUN-C80102 add
 
#FUN-C80102----mark----str----
#     BEFORE DISPLAY
#        CALL cl_navigator_setting( g_curs_index, g_row_count )
#        IF g_rec_b != 0 AND l_ac != 0 THEN  
#           CALL fgl_set_arr_curr(l_ac)     
#        END IF                            
#FUN-C80102----mark----end----
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
   END DISPLAY  #FUN-C80102 add 
   #FUN-C80102--add--str--                       
      ON ACTION page3
         LET g_action_choice = 'page3'
         EXIT DIALOG 
        #EXIT DISPLAY

      ON ACTION refresh_detail
         CALL q191_b_fill()
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_choice = 'page2' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG
#FUN-C80102--add--end--                   
 
      ON ACTION query
         LET g_action_choice="query"
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
     #FUN-D10142----mark---str---
     #ON ACTION output
     #   LET g_action_choice="output"
     # # EXIT DISPLAY                 #FUN-C80102 mark
     #   EXIT DIALOG                  #FUN-C80102 add
     #FUN-D10142----mark---end---
      
      #FUN-B60129--add--str--
     #ON ACTION find_detail                  #FUN-C80102 mark
     #   LET g_action_choice="find_detail"   #FUN-C80102 mark
     #   EXIT DISPLAY                 #FUN-C80102 mark
      #FUN-B60129--add--end--
      #ON ACTION first
      #   CALL q191_fetch('F')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)
      #   IF g_rec_b != 0 THEN
      #      CALL fgl_set_arr_curr(1)
      #   END IF
      #   ACCEPT DISPLAY
      #
      #ON ACTION previous
      #   CALL q191_fetch('P')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)
      #   IF g_rec_b != 0 THEN
      #      CALL fgl_set_arr_curr(1)
      #   END IF
      #   ACCEPT DISPLAY
      #
      #ON ACTION jump
      #   CALL q191_fetch('/')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)
      #   IF g_rec_b != 0 THEN
      #      CALL fgl_set_arr_curr(1)
      #   END IF
      #   ACCEPT DISPLAY
      #
      #ON ACTION next
      #   CALL q191_fetch('N')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)
      #   IF g_rec_b != 0 THEN
      #      CALL fgl_set_arr_curr(1)
      #   END IF
      #   ACCEPT DISPLAY
      #
      #ON ACTION last
      #   CALL q191_fetch('L')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)
      #   IF g_rec_b != 0 THEN
      #      CALL fgl_set_arr_curr(1)
      #   END IF
      #   ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
      ON ACTION controlg
         LET g_action_choice="controlg"
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
       # CONTINUE DISPLAY             #FUN-C80102 mark
       # CONTINUE DIALOG              #FUN-C80102 add
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
       # EXIT DISPLAY                 #FUN-C80102 mark
         EXIT DIALOG                  #FUN-C80102 add
 
#     ON ACTION related_document
#        LET g_action_choice="related_document"
       # EXIT DISPLAY                 #FUN-C80102 mark
#        EXIT DIALOG                  #FUN-C80102 add
  
    # AFTER DISPLAY                   #FUN-C80102 mark
    #    CONTINUE DISPLAY             #FUN-C80102 mark
        
      AFTER DIALOG                    #FUN-C80102 add
         IF tm.org = 'Y' THEN
            CALL cl_set_comp_visible("apa13,apa14,apa34f,apa35f,amt_1,sum1,sum3",FALSE)
         ELSE
            CALL cl_set_comp_visible("apa13,apa14,apa34f,apa35f,amt_1,sum1,sum3",TRUE)
         END IF
         #FUN-C80102----add---end--
         CONTINUE DIALOG              #FUN-C80102 add
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
 # END DISPLAY                 #FUN-C80102 mark
   END DIALOG                  #FUN-C80102 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C80102--add--str---
FUNCTION q191_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_tot11   LIKE alz_file.alz09 
DEFINE l_tot21   LIKE alz_file.alz09 
DEFINE l_tot31   LIKE alz_file.alz09 
DEFINE l_tot41   LIKE alz_file.alz09 
DEFINE l_tot51   LIKE alz_file.alz09 

   LET l_tot11 = 0
   LET l_tot21 = 0
   LET l_tot31 = 0
   LET l_tot41 = 0
   LET l_tot51 = 0
  #FUN-CB0146--add--str--
  LET g_sql=" SELECT apa06,apa07,apa34f,apa35f,apa13,apa14,",
            "        amt_1,sum1,sum3,apa34,apa35,amt_2,sum2,sum4,",
            "        num01,num02,num03,num04,num05,num06,num07,num08,num09,",
            "        num010,num011,num012,num013,num014,num015,num016,num017,",
            "        num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,",
            "        num12,num13,num14,num15,num16,num17,",
            "        sum5,apa15,apa16,net1,net2,apa21,gen02,apa22,gem02,apa08,",
            "        apa00,apa01,apa02,alz12,alz07,apa11,pma02,apa36,apr02,apa44,",
            "        apa54,aag02,apa05,pmc03,pmy01,pmy02,apa41 ",
            "  FROM q191_tmp "
   #FUN-CB0146--add--end
   CASE tm.u
      WHEN '1'
        # LET g_sql = "SELECT * FROM aapq191_tmp ", #FUN-CB0146 mark
          LET g_sql = g_sql,  #FUN-CB0146
                     " WHERE apa05 = '",g_alz_1[p_ac].apa05,"'"
          IF tm.org = 'Y' THEN #FUN-C80102
            LET g_sql = g_sql CLIPPED,  #FUN-C80102
                        " AND apa13 = '",g_alz_1[p_ac].apa13,"'"   #FUN-C80102
          END IF  #FUN-C80102
          LET g_sql = g_sql CLIPPED," ORDER BY apa05,apa13,apa06,apa07,pmy01 "

        PREPARE aapq191_pb_detail1 FROM g_sql
        DECLARE alz_curs_detail1  CURSOR FOR aapq191_pb_detail1        #CURSOR
        CALL g_alz.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH alz_curs_detail1 INTO g_alz[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_alz[g_cnt].apa34
           LET l_tot21 = l_tot21 + g_alz[g_cnt].apa35
           LET l_tot31 = l_tot31 + g_alz[g_cnt].amt_2
           LET l_tot41 = l_tot41 + g_alz[g_cnt].sum2
           LET l_tot51 = l_tot51 + g_alz[g_cnt].sum4
           LET g_cnt = g_cnt + 1
        END FOREACH

      WHEN '2'
         #LET g_sql = "SELECT * FROM aapq191_tmp ", #FUN-CB0146 mark
          LET g_sql = g_sql,  #FUN-CB0146 
                     " WHERE apa22 = '",g_alz_1[p_ac].apa22,"'"
          IF tm.org = 'Y' THEN #FUN-C80102
             LET g_sql = g_sql CLIPPED,  #FUN-C80102
                        " AND apa13 = '",g_alz_1[p_ac].apa13,"'"   #FUN-C80102
          END IF  #FUN-C80102
          LET g_sql = g_sql CLIPPED," ORDER BY apa22,apa13,apa06,apa07,pmy01 "

        PREPARE aapq191_pb_detail2 FROM g_sql
        DECLARE alz_curs_detail2  CURSOR FOR aapq191_pb_detail2        #CURSOR
        CALL g_alz.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH alz_curs_detail2 INTO g_alz[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_alz[g_cnt].apa34
           LET l_tot21 = l_tot21 + g_alz[g_cnt].apa35
           LET l_tot31 = l_tot31 + g_alz[g_cnt].amt_2
           LET l_tot41 = l_tot41 + g_alz[g_cnt].sum2
           LET l_tot51 = l_tot51 + g_alz[g_cnt].sum4
           LET g_cnt = g_cnt + 1
        END FOREACH

      WHEN '3'
        # LET g_sql = "SELECT * FROM aapq191_tmp ", #FUN-CB0146 mark
         LET g_sql = g_sql,  #FUN-CB0146 
                     " WHERE apa21 = '",g_alz_1[p_ac].apa21,"'"
         IF tm.org = 'Y' THEN #FUN-C80102
            LET g_sql = g_sql CLIPPED,  #FUN-C80102
                        " AND apa13 = '",g_alz_1[p_ac].apa13,"'"   #FUN-C80102
         END IF  #FUN-C80102
         LET g_sql = g_sql CLIPPED," ORDER BY apa21,apa13,apa06,apa07,pmy01 "

        PREPARE aapq191_pb_detail3 FROM g_sql
        DECLARE alz_curs_detail3  CURSOR FOR aapq191_pb_detail3        #CURSOR
        CALL g_alz.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH alz_curs_detail3 INTO g_alz[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_alz[g_cnt].apa34
           LET l_tot21 = l_tot21 + g_alz[g_cnt].apa35
           LET l_tot31 = l_tot31 + g_alz[g_cnt].amt_2
           LET l_tot41 = l_tot41 + g_alz[g_cnt].sum2
           LET l_tot51 = l_tot51 + g_alz[g_cnt].sum4
           LET g_cnt = g_cnt + 1
        END FOREACH

      WHEN '4'
        # LET g_sql = "SELECT * FROM aapq191_tmp ", #FUN-CB0146 mark
         LET g_sql = g_sql,  #FUN-CB0146 
                     " WHERE apa05 = '",g_alz_1[p_ac].apa05,"' AND apa54 = '",g_alz_1[p_ac].apa54,"'"
         IF tm.org = 'Y' THEN #FUN-C80102
            LET g_sql = g_sql CLIPPED,  #FUN-C80102
                        " AND apa13 = '",g_alz_1[p_ac].apa13,"'"   #FUN-C80102
         END IF  #FUN-C80102
         LET g_sql = g_sql CLIPPED," ORDER BY apa05,apa54,apa13,apa06,apa07,pmy01 "

        PREPARE aapq191_pb_detail4 FROM g_sql
        DECLARE alz_curs_detail4  CURSOR FOR aapq191_pb_detail4        #CURSOR
        CALL g_alz.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH alz_curs_detail4 INTO g_alz[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_alz[g_cnt].apa34
           LET l_tot21 = l_tot21 + g_alz[g_cnt].apa35
           LET l_tot31 = l_tot31 + g_alz[g_cnt].amt_2
           LET l_tot41 = l_tot41 + g_alz[g_cnt].sum2
           LET l_tot51 = l_tot51 + g_alz[g_cnt].sum4
           LET g_cnt = g_cnt + 1
        END FOREACH
   END CASE
   DISPLAY l_tot11 TO FORMONLY.apa34_tot1
   DISPLAY l_tot21 TO FORMONLY.apa35_tot1
   DISPLAY l_tot31 TO FORMONLY.apa34_apa35_tot1
   DISPLAY l_tot41 TO FORMONLY.sum_2_tot1
   DISPLAY l_tot51 TO FORMONLY.sum_4_tot1
   CALL g_alz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q191_bp2()
DEFINE l_ac1      LIKE type_file.num5

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.u TO u
   LET g_flag = ' ' 
   LET g_action_flag = 'page3'  
   LET g_action_choice = " "    #FUN-C80102
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.org,tm.d FROM u,org,d ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("d",TRUE)
            ELSE
               CALL cl_set_comp_entry("d",FALSE)
            END IF
            IF NOT cl_null(tm.u)  THEN
               CALL q191_b_fill_2()
               CALL q191_set_visible()
               LET g_action_choice = "page3"
            ELSE
               CALL q191_b_fill()
               CALL cl_set_comp_visible("page3", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page3", TRUE)
               LET g_action_choice = "page2"
               CALL g_alz_1.clear()  
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.apa34_tot
               DISPLAY 0  TO FORMONLY.apa35_tot
               DISPLAY 0  TO FORMONLY.apa34_apa35_tot
               DISPLAY 0  TO FORMONLY.sum_2_tot
               DISPLAY 0  TO FORMONLY.sum_4_tot
            END IF
            DISPLAY tm.u TO u 
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("d",TRUE)
             ELSE
               CALL cl_set_comp_entry("d",FALSE)
             END IF
             #CALL q191()         #FUN-CB0146 mark
             CALL q191_get_tmp()  #FUN-CB0146
             CALL aapq191_t()
             EXIT DIALOG

          ON CHANGE d
             CALL  q191_b_fill_2()
             CALL q191_set_visible()
             LET g_action_choice = "page3"

      END INPUT

      DISPLAY ARRAY g_alz_1 TO s_alz_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION page2
         LET g_action_choice="page2"
         EXIT DIALOG 

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         IF l_ac1 > 0  THEN
            CALL q191_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page3", TRUE)
            LET g_action_choice= "page2"   
            LET g_flag = '1'               
            EXIT DIALOG 
         END IF
        
      
      ON ACTION refresh_detail
         CALL q191_b_fill()
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_choice = "page2"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

     #FUN-D10142----mark---str---
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DIALOG 
     #FUN-D10142----mark---end---

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

#     ON ACTION related_document
#        LET g_action_choice="related_document"
#        EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about
         CALL cl_about()


      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
    
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q191_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_alz.clear()
   CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34f,apa35f,amt_1,apa34f_1,apa35f_1,amt_1_1,sum1,sum3,sum1_1,sum3_1",TRUE)
   DISPLAY BY NAME tm.u,tm.aly01,tm.a,tm.edate,tm.org,tm.d,tm.pay1,tm.b
   CONSTRUCT l_wc ON  apa06,apa07,apa13,apa14,apa15,apa16,apa21,apa22,apa08,apa00,apa01,apa02,alz12,alz07,apa11,
                      apa36,apa44,apa54,apa05,pmy01,apa41
                 FROM s_alz[1].apa06,s_alz[1].apa07,s_alz[1].apa13,s_alz[1].apa14,s_alz[1].apa15,s_alz[1].apa16,
                      s_alz[1].apa21,s_alz[1].apa22,s_alz[1].apa08,s_alz[1].apa00,s_alz[1].apa01,s_alz[1].apa02,
                      s_alz[1].alz12,s_alz[1].alz07,s_alz[1].apa11,
                      s_alz[1].apa36,s_alz[1].apa44,s_alz[1].apa54,s_alz[1].apa05,s_alz[1].pmy01,s_alz[1].apa41
   
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
    
      AFTER CONSTRUCT
         IF tm.org = 'Y' THEN
            CALL cl_set_comp_visible("aap13,apa34f,apa35f,amt_1,sum1,sum3",TRUE)
         ELSE
            CALL cl_set_comp_visible("aap13,apa34f,apa35f,amt_1,sum1,sum3",FALSE)
         END IF

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(apa22)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem3"
             LET g_qryparam.plant = g_plant 
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa22
             NEXT FIELD apa22
 
          WHEN INFIELD(apa21)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen5"
             LET g_qryparam.plant = g_plant 
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa21
             NEXT FIELD apa21

          WHEN INFIELD(pmy01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmy"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmy01
             NEXT FIELD pmy01

          WHEN INFIELD(apa06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa06
             NEXT FIELD apa06
             
          WHEN INFIELD(apa05)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa05
             NEXT FIELD apa05
             
          WHEN INFIELD(apa11)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pma"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa11
             NEXT FIELD apa11
             
          WHEN INFIELD(apa15)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa15"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa15
             NEXT FIELD apa15
             
          WHEN INFIELD(apa13)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa13"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa13
             NEXT FIELD apa13

         WHEN INFIELD(apa36)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apr"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa36
             NEXT FIELD apa36
             
         WHEN INFIELD(apa54)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aag03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa54
             NEXT FIELD apa54
      END CASE
             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()
	 
   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
  
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION
#FUN-C80102--add--end---

FUNCTION q191_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   LET p_row = 6 LET p_col = 16

#FUN-C80102-----mark---str---
#  OPEN WINDOW aapq191_w AT p_row,p_col WITH FORM "aap/42f/aapr191" 
#      ATTRIBUTE (STYLE = g_win_style CLIPPED)
#      
#  CALL cl_ui_locale("aapr191")
#FUN-C80102-----mark---end---
   CLEAR FORM   #FUN-C80102 add
   CALL g_alz.clear()  #FUN-C80102 add
   CALL cl_opmsg('p')     
   INITIALIZE tm.* TO NULL            # Default condition
   CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34f,apa35f,amt_1,apa34f_1,apa35f_1,amt_1_1,sum1,sum3,sum1_1,sum3_1",TRUE)                     #FUN-C80102 add
  #LET tm.a    = '1'    #FUN-C80102 mark
   LET tm.a    = '2'    #FUN-C80102 add
   LET tm.more = 'N'
  #LET tm.edate = g_today
   LET tm.edate = s_last(g_today)  #TQC-C30333 mod
   LET tm.detail = 'N'
   LET tm.zr = 'N' 
   LET tm.org = 'N'                #TQC-C30349  add
   LET tm.d = 'N'                  #FUN-C80102 add
   LET tm.pay1 = '2'               #FUN-C80102 add
   LET tm.b = 'Y'                  #FUN-C80102 add
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT MIN(aly01) INTO tm.aly01 FROM aly_file
   #FUN-D70118--add--str--      
   CALL s_get_bookno(YEAR(tm.edate)) RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1 = '1' THEN 
      CALL cl_err(tm.edate,'aoo-081',1)
   END IF
   #FUN-D70118--add--end--  
  #FUN-C80102---mark----str---
  #DISPLAY tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more  #TQC-C30349  add  tm.org
  #     TO tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more  #TQC-C30349  add  tm.org
  #DIALOG ATTRIBUTE(UNBUFFERED)
  #   CONSTRUCT BY NAME tm.wc ON apa22,apa21,pmy01,apa06,apa00   #TQC-C30349  add  apa00
  #
  #      BEFORE CONSTRUCT
  #         CALL cl_qbe_init()
  #            
  #      ON ACTION CONTROLP
  #         CASE
  #            WHEN INFIELD(apa22)
  #               CALL cl_init_qry_var()
  #               LET g_qryparam.form = "q_gem3"
  #               LET g_qryparam.plant = g_plant 
  #               LET g_qryparam.state = "c"
  #               CALL cl_create_qry() RETURNING g_qryparam.multiret
  #               DISPLAY g_qryparam.multiret TO apa22
  #               NEXT FIELD apa22
  #
  #            WHEN INFIELD(apa21)
  #               CALL cl_init_qry_var()
  #               LET g_qryparam.form = "q_gen5"
  #               LET g_qryparam.plant = g_plant 
  #               LET g_qryparam.state = "c"
  #               CALL cl_create_qry() RETURNING g_qryparam.multiret
  #               DISPLAY g_qryparam.multiret TO apa21
  #               NEXT FIELD apa21
  #
  #            WHEN INFIELD(pmy01)
  #               CALL cl_init_qry_var()
  #               LET g_qryparam.form = "q_pmy"
  #               LET g_qryparam.state = "c"
  #               CALL cl_create_qry() RETURNING g_qryparam.multiret
  #               DISPLAY g_qryparam.multiret TO pmy01
  #               NEXT FIELD pmy01
  #
  #            WHEN INFIELD(apa06)
  #               CALL cl_init_qry_var()
  #               LET g_qryparam.form = "q_pmc"
  #               LET g_qryparam.state = "c"
  #               CALL cl_create_qry() RETURNING g_qryparam.multiret
  #               DISPLAY g_qryparam.multiret TO apa06
  #               NEXT FIELD apa06
  #               
  #         END CASE 
  #   END CONSTRUCT 
  #FUN-C80102---mark----end---
      
     #INPUT BY NAME tm.aly01,tm.a,tm.edate,tm.detail,tm.zr,tm.org,tm.more  #TQC-C30349  tm.org  #FUN-C80102 mark
      DISPLAY BY NAME tm.aly01,tm.a,tm.edate,tm.u,tm.org,tm.d,tm.pay1,tm.b   #FUN-C80102 add
      DIALOG ATTRIBUTE(UNBUFFERED)                              #FUN-C80102 add
      INPUT BY NAME tm.aly01,tm.a,tm.edate,tm.u,tm.org,tm.d,tm.pay1,tm.b     #TQC-C30349  add  tm.org #FUN-C80102 add
         ATTRIBUTES (WITHOUT DEFAULTS)
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         AFTER FIELD edate
            IF tm.edate IS NULL THEN
               CALL cl_err('','aap1000',0)
               NEXT FIELD edate
            END IF
            #IF MONTH(tm.edate) = MONTH(tm.edate+1) THEN   #FUN-D70118 mark
            IF s_get_aznn(g_plant,g_bookno1,tm.edate,3) = s_get_aznn(g_plant,g_bookno1,tm.edate+1,3) THEN   #FUN-D70118 add
               CALL cl_err('','aap-993',1)
               NEXT FIELD edate
            END IF

       #FUN-C80102-----add------str----
       # AFTER FIELD org   #TQC-D60017 mark
       ON CHANGE org       #TQC-D60017
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("d",TRUE)
             ELSE
                CALL cl_set_comp_entry("d",FALSE)
             END IF

         # AFTER FIELD u  #TQC-D60017 mark
         ON CHANGE u      #TQC-D60017
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("d",TRUE)
             ELSE
                CALL cl_set_comp_entry("d",FALSE)
             END IF

         AFTER FIELD pay1
            IF tm.pay1 = '2' THEN
               CALL cl_set_comp_entry("b",TRUE)
            ELSE
               CALL cl_set_comp_entry("b",FALSE)
            END IF
       #FUN-C80102-----add------end----

       #FUN-C80102-----mark-----str----    
       # AFTER FIELD MORE
       #    IF tm.more = 'Y' THEN 
       #       CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
       #                     g_bgjob,g_time,g_prtway,g_copies)
       #           RETURNING g_pdate,g_towhom,g_rlang,
       #                     g_bgjob,g_time,g_prtway,g_copies
       #    END IF
       # ON ACTION CONTROLP
       #   CASE
       #      WHEN INFIELD(aly01)
       #      CALL cl_init_qry_var()
       #      LET g_qryparam.form = 'q_aly01'
       #      LET g_qryparam.default1 = tm.aly01
       #      CALL cl_create_qry() RETURNING tm.aly01
       #      DISPLAY BY NAME tm.aly01
       #      NEXT FIELD aly01
       #   END CASE
       #FUN-C80102-----mark-----str----
      END INPUT

#FUN-C80102------add----str--
      CONSTRUCT tm.wc ON apa06,apa07,apa13,apa14,apa15,apa16,apa21,apa22,apa08,apa00,apa01,apa02,alz12,alz07,apa11,
                      apa36,apa44,apa54,apa05,pmy01,apa41
                 FROM s_alz[1].apa06,s_alz[1].apa07,s_alz[1].apa13,s_alz[1].apa14,s_alz[1].apa15,s_alz[1].apa16,
                      s_alz[1].apa21,s_alz[1].apa22,s_alz[1].apa08,s_alz[1].apa00,s_alz[1].apa01,s_alz[1].apa02,
                      s_alz[1].alz12,s_alz[1].alz07,s_alz[1].apa11,
                      s_alz[1].apa36,s_alz[1].apa44,s_alz[1].apa54,s_alz[1].apa05,s_alz[1].pmy01,s_alz[1].apa41 

   BEFORE CONSTRUCT
      CALL cl_qbe_init()
   END CONSTRUCT

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aly01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_aly01'
             LET g_qryparam.default1 = tm.aly01
             CALL cl_create_qry() RETURNING tm.aly01
             DISPLAY BY NAME tm.aly01
             NEXT FIELD aly01
          WHEN INFIELD(apa22)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem3"
             LET g_qryparam.plant = g_plant
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa22
             NEXT FIELD apa22

          WHEN INFIELD(apa21)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen5"
             LET g_qryparam.plant = g_plant
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa21
             NEXT FIELD apa21

          WHEN INFIELD(pmy01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmy"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmy01
             NEXT FIELD pmy01

          WHEN INFIELD(apa06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa06
             NEXT FIELD apa06

          WHEN INFIELD(apa05)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa05
             NEXT FIELD apa05

          WHEN INFIELD(apa11)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pma"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa11
             NEXT FIELD apa11

          WHEN INFIELD(apa15)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa15"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa15
             NEXT FIELD apa15

          WHEN INFIELD(apa13)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa13"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa13
             NEXT FIELD apa13
            
         #TQC-D60017--add--str--
         WHEN INFIELD(apa36)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apr"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa36
             NEXT FIELD apa36
         #TQC-D60017--add--end

         WHEN INFIELD(apa54)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aag03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa54
             NEXT FIELD apa54
      END CASE
#FUN-C80102------add----str--

      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         CALL cl_dynamic_locale()

      ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()
         EXIT DIALOG

      ON ACTION help
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION close
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION qbe_select
         CALL cl_qbe_select()

      AFTER DIALOG 
         IF NOT q191_chk_datas() THEN
            IF g_field = "edate" THEN
               NEXT FIELD edate
            END IF
            IF g_field = "aly01" THEN
               NEXT FIELD aly01 
            END IF
           #FUN-C80102-----mark---str---
           #IF g_field = "apa22" THEN
           #   NEXT FIELD apa22
           #END IF                
           #FUN-C80102-----mark---end---
            LET g_field = ''
         END IF  
   END DIALOG 
   
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM  
   END IF 
#  CLOSE WINDOW aapq191_w    #FUN-C80102 mark
   #CALL q191()         #FUN-CB0146 mark
   CALL q191_get_tmp()  #FUN-CB0146
   CALL aapq191_t()
END FUNCTION

#FUN-C80102--add--str---
FUNCTION q191_b_askkey()

   CONSTRUCT tm.wc ON apa05,apa06,apa07,pmy01,apa21,apa22,apa08,apa00,apa01,apa02,alz12,alz07,apa11,
                      apa36,apa44,apa54,apa16,apa13,apa14,apa41
                 FROM s_alz[1].apa05,s_alz[1].apa06,s_alz[1].apa07,s_alz[1].pmy01,s_alz[1].apa21,
                      s_alz[1].apa22,s_alz[1].apa08,s_alz[1].apa00,s_alz[1].apa01,s_alz[1].apa02,s_alz[1].alz12,s_alz[1].alz07,s_alz[1].apa11,
                      s_alz[1].apa36,s_alz[1].apa44,s_alz[1].apa54,s_alz[1].apa16,s_alz[1].apa13,s_alz[1].apa14,
                      s_alz[1].apa41 

   BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(apa22)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem3"
             LET g_qryparam.plant = g_plant 
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa22
             NEXT FIELD apa22
 
          WHEN INFIELD(apa21)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen5"
             LET g_qryparam.plant = g_plant 
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa21
             NEXT FIELD apa21

          WHEN INFIELD(pmy01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmy"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmy01
             NEXT FIELD pmy01

          WHEN INFIELD(apa06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa06
             NEXT FIELD apa06
             
          WHEN INFIELD(apa05)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa05
             NEXT FIELD apa05
             
          WHEN INFIELD(apa11)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmq"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa11
             NEXT FIELD apa11
             
          WHEN INFIELD(apa15)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa15"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa15
             NEXT FIELD apa15
             
          WHEN INFIELD(apa13)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apa13"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa13
             NEXT FIELD apa13 
            
         #TQC-D60017--add--str--
         WHEN INFIELD(apa36)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_apr"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa36
             NEXT FIELD apa36
         #TQC-D60017--add--end
 
         WHEN INFIELD(apa54)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aag03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO apa54
             NEXT FIELD apa54
      END CASE
    END CONSTRUCT          
END FUNCTION 
#FUN-C80102--add--end---

FUNCTION q191()
   DEFINE l_sql    STRING,
          l_alz09  LIKE alz_file.alz09,   #金额 
          l_alz09f LIKE alz_file.alz09f,  #原幣金额   #TQC-C30349
          l_alz06  LIKE alz_file.alz06,   #立账日期
          l_alz07  LIKE alz_file.alz07,   #付款日期
          l_date   LIKE type_file.dat,
          l_bucket LIKE type_file.num5
   DEFINE sr RECORD 
               apa06   LIKE apa_file.apa06,
              #FUN-C80102-----add----str---
               apa07   LIKE apa_file.apa07,
               apa34f  LIKE apa_file.apa34f,
               apa35f  LIKE apa_file.apa35f,
               apa13   LIKE apa_file.apa13,
               apa14   LIKE apa_file.apa14,
               amt_1   LIKE type_file.num5,
               sum1    LIKE alz_file.alz09,
               sum3    LIKE alz_file.alz09,
               apa34   LIKE apa_file.apa34,
               apa35   LIKE apa_file.apa35,
               amt_2   LIKE type_file.num5,              
               sum2    LIKE alz_file.alz09,               
               sum4    LIKE alz_file.alz09, 
              #FUN-C80102-----add----end---
              #FUN-C80102-----mark---str---
              #pmc03   LIKE pmc_file.pmc03,  
              #apa01   LIKE apa_file.apa01, 
              #apa02   LIKE apa_file.apa02,
              #apa13   LIKE apa_file.apa01,   #TQC-C30349  add  #用apa01的字段類型，方便單身"統計"2個字的正常顯示
              #FUN-C80102-----mark---str---
               num01    LIKE alz_file.alz09,
               num1   LIKE alz_file.alz09, 
               num02    LIKE alz_file.alz09,
               num2   LIKE alz_file.alz09,
               num03    LIKE alz_file.alz09,
               num3   LIKE alz_file.alz09,
               num04    LIKE alz_file.alz09,
               num4   LIKE alz_file.alz09,
               num05    LIKE alz_file.alz09,
               num5   LIKE alz_file.alz09,
               num06    LIKE alz_file.alz09,
               num6   LIKE alz_file.alz09,
               num07    LIKE alz_file.alz09,
               num7   LIKE alz_file.alz09,
               num08    LIKE alz_file.alz09,
               num8   LIKE alz_file.alz09,
               num09    LIKE alz_file.alz09,
               num9   LIKE alz_file.alz09,
               num010   LIKE alz_file.alz09,
               num10  LIKE alz_file.alz09,
               num011   LIKE alz_file.alz09,
               num11  LIKE alz_file.alz09,
               num012   LIKE alz_file.alz09,
               num12  LIKE alz_file.alz09,
               num013   LIKE alz_file.alz09,
               num13  LIKE alz_file.alz09,
               num014   LIKE alz_file.alz09,
               num14  LIKE alz_file.alz09,
               num015   LIKE alz_file.alz09,
               num15  LIKE alz_file.alz09,
               num016   LIKE alz_file.alz09,
               num16  LIKE alz_file.alz09,
               num017   LIKE alz_file.alz09,
               num17  LIKE alz_file.alz09,
              #FUN-C80102-----add----str---
               sum5    LIKE alz_file.alz09,
               apa15   LIKE apa_file.apa15,
               apa16   LIKE apa_file.apa16,
               net1    LIKE type_file.num5,
               net2    LIKE type_file.num5,
               apa21   LIKE apa_file.apa21,
               gen02   LIKE gen_file.gen02,
               apa22   LIKE apa_file.apa22,
               gem02   LIKE gem_file.gem02,
               apa08   LIKE apa_file.apa08,
               apa00   LIKE apa_file.apa00,
               apa01   LIKE apa_file.apa01,
               apa02   LIKE apa_file.apa02,
               alz12   LIKE alz_file.alz12,
               alz07   LIKE alz_file.alz07,
               apa11   LIKE apa_file.apa11,
               pma02   LIKE pma_file.pma02,
               apa36   LIKE apa_file.apa36,
               apr02   LIKE apr_file.apr02,
               apa44   LIKE apa_file.apa44,         
               apa54   LIKE apa_file.apa54,
               aag02   LIKE aag_file.aag02,      
              #FUN-C80102-----add----end---
              #FUN-C80102----add---str--
               apa05   LIKE apa_file.apa05,  
               pmc03   LIKE pmc_file.pmc03, 
               pmy01   LIKE pmy_file.pmy01,
               pmy02   LIKE pmy_file.pmy02,
               apa41   LIKE apa_file.apa41   
              #FUN-C80102----add---end-- 
              #sum     LIKE type_file.num20_6   #FUN-C80102 mark
             END RECORD 
#FUN-C80102-----add---str--
DEFINE g_alz_1 DYNAMIC ARRAY OF RECORD
            #FUN-C80102----add---str----
             apa05   LIKE apa_file.apa05,   
             pmc03   LIKE pmc_file.pmc03, 
             apa22   LIKE apa_file.apa22,
             gem02   LIKE gem_file.gem02, 
             apa21   LIKE apa_file.apa21,
             gen02   LIKE gen_file.gen02, 
             apa54   LIKE apa_file.apa54,
             aag02   LIKE aag_file.aag02,                
             apa13   LIKE apa_file.apa01,
             apa34f  LIKE apa_file.apa34f,
             apa35f  LIKE apa_file.apa35f,
             amt_1   LIKE type_file.num5,
             sum1    LIKE alz_file.alz09,
             sum3    LIKE alz_file.alz09,
             apa34   LIKE apa_file.apa34,
             apa35   LIKE apa_file.apa35,
             amt_2   LIKE type_file.num5,               
             sum2    LIKE alz_file.alz09,               
             sum4    LIKE alz_file.alz09,               
            #FUN-C80102----add----end----
            #FUN-C80102----mark---str----
            #apa06 LIKE apa_file.apa06,  #客戶
            #apa07 LIKE apa_file.apa07,  #簡稱
            #apa01 LIKE apa_file.apa01,
            #apa02 LIKE apa_file.apa02,  #Date
            #apa13 LIKE apa_file.apa13,  #TQC-C30349  add     
            #FUN-C80102----mark---end----
             num01 LIKE alz_file.alz09,
             num02 LIKE alz_file.alz09,
             num03 LIKE alz_file.alz09,
             num04 LIKE alz_file.alz09,
             num05 LIKE alz_file.alz09,
             num06 LIKE alz_file.alz09,
             num07 LIKE alz_file.alz09,
             num08 LIKE alz_file.alz09,
             num09 LIKE alz_file.alz09,
             num010 LIKE alz_file.alz09,
             num011 LIKE alz_file.alz09,
             num012 LIKE alz_file.alz09,
             num013 LIKE alz_file.alz09,
             num014 LIKE alz_file.alz09,
             num015 LIKE alz_file.alz09,
             num016 LIKE alz_file.alz09,
             num017 LIKE alz_file.alz09,
             num1 LIKE alz_file.alz09,
             num2 LIKE alz_file.alz09,
             num3 LIKE alz_file.alz09,
             num4 LIKE alz_file.alz09,
             num5 LIKE alz_file.alz09,
             num6 LIKE alz_file.alz09,
             num7 LIKE alz_file.alz09,
             num8 LIKE alz_file.alz09,
             num9 LIKE alz_file.alz09,
             num10 LIKE alz_file.alz09,
             num11 LIKE alz_file.alz09,
             num12 LIKE alz_file.alz09,
             num13 LIKE alz_file.alz09,
             num14 LIKE alz_file.alz09,
             num15 LIKE alz_file.alz09,
             num16 LIKE alz_file.alz09,
             num17 LIKE alz_file.alz09,
            #FUN-C80102-----add---str---
             sum5    LIKE alz_file.alz09, 
             apa06   LIKE apa_file.apa06, 
             apa07   LIKE apa_file.apa07, 
             pmy01   LIKE pmy_file.pmy01, 
             pmy02   LIKE pmy_file.pmy02   
            #FUN-C80102-----add---end---
         END RECORD
   DEFINE l_apa64 LIKE apa_file.apa64  #FUN-C80102 add
   DEFINE l_azi07 LIKE azi_file.azi07  #FUN-C80102 add
   DEFINE l_azi04 LIKE azi_file.azi04  #FUN-C80102 add
   DEFINE l_num01 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num02 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num03 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num04 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num05 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num06 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num07 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num08 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num09 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num010 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num011 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num012 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num013 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num014 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num015 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num016 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num017 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num1 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num2 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num3 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num4 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num5 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num6 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num7 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num8 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num9 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num10 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num11 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num12 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num13 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num14 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num15 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num16 LIKE alz_file.alz09   #FUN-C80102 add
   DEFINE l_num17 LIKE alz_file.alz09   #FUN-C80102 add

   #FUN-C80102-add--str--
   LET l_num01 = 0
   LET l_num02 = 0
   LET l_num03 = 0
   LET l_num04 = 0
   LET l_num05 = 0
   LET l_num06 = 0
   LET l_num07 = 0
   LET l_num08 = 0
   LET l_num09 = 0
   LET l_num010 = 0
   LET l_num011 = 0
   LET l_num012 = 0
   LET l_num013 = 0
   LET l_num014 = 0
   LET l_num015 = 0
   LET l_num016 = 0
   LET l_num017 = 0
   LET l_num1 = 0
   LET l_num2 = 0
   LET l_num3 = 0
   LET l_num4 = 0
   LET l_num5 = 0
   LET l_num6 = 0
   LET l_num7 = 0
   LET l_num8 = 0
   LET l_num9 = 0
   LET l_num10 = 0
   LET l_num11 = 0
   LET l_num12 = 0
   LET l_num13 = 0
   LET l_num14 = 0
   LET l_num15 = 0
   LET l_num16 = 0
   LET l_num17 = 0
   #FUN-C80102-add--end--

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   CALL q191_get_datas()
   CALL q191_table()
   LET g_sql = "INSERT INTO aapq191_tmp ",                                                                 
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",       #TQC-C30349  add ?    
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",       #FUN-C80102 add 10? 
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",       #FUN-C80102 add 10? 
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",       #FUN-C80102 add 10?  
               "        ?, ?, ?, ?, ?)"                           #FUN-C80102 add 2?                                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM                                                                                                                 
   END IF
    
   #抓報表列印資料
   #--TQC-C30349--add--str--
   IF tm.org = 'Y' THEN
     #LET l_sql = "SELECT apa06, apa07,apa01,apa02,apa13,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,",  #FUN-C80102 mark
     #FUN-C80102----add---str---
      LET l_sql = "SELECT apa06, apa07,0,0,apa13,apa14, 0,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,",
                  "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0, apa15,",
                  "       apa16,0,0,apa21,'',apa22,'',apa08,apa00,apa01,apa02,alz12,alz07,apa11,'',",
                  "       apa36,'',apa44,apa54,'',apa05,'',",
                  "       pmy01,pmy02,apa41,alz09,alz09f,alz06,alz07 ",
     #FUN-C80102----add---end---
        #         "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,alz09f,alz06,alz07 ",		#FUN-C80102 mark								
                  "  FROM apc_file,apa_file,alz_file,pmc_file ",
                  "  LEFT OUTER JOIN pmy_file ON(pmc_file.pmc02=pmy_file.pmy01)",										
                  " WHERE ",tm.wc CLIPPED," AND apa06 = pmc01 AND apa01 = apc01 ",
                  "   AND apa06 = alz01 AND alz00 = '1' AND alz02 = ",YEAR(tm.edate),
                  "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = apa01 ",
                  "   AND alz05 = apc02"
      #選擇扣除折讓資料            
     #IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09f>0" END IF   #FUN-C80102 mark
     #IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<'",tm.edate,"'" END IF    #MOD-G10097 mark
      IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<='",tm.edate,"'" END IF   #MOD-G10097 add	
      CASE tm.pay1
         WHEN '1' LET l_sql = l_sql CLIPPED
         WHEN '2' 
            IF tm.b = 'Y' THEN
               LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24','16','26') "
            ELSE
               LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24') "
            END IF  
         WHEN '3' LET l_sql = l_sql CLIPPED," AND apa00 IN('17','13','25','24')"
      END CASE
      PREPARE r191_prepare_01 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('r191_prepare_01:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r191_curs_01 CURSOR FOR r191_prepare_01
      FOREACH r191_curs_01 INTO sr.*,l_alz09,l_alz09f,l_alz06,l_alz07   #FUN-C80120 add l_alz09
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
         #FUN-C80102--add--str----
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc02 = sr.apa05
         SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.apa21
         SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.apa22
         SELECT pma02 INTO sr.pma02 FROM pma_file WHERE pma01 = sr.apa11
         SELECT apr02 INTO sr.apr02 FROM apr_file WHERE apr01 = sr.apa36
         SELECT unique aag02 INTO sr.aag02 FROM aag_file WHERE aag01 = sr.apa54
         
         IF tm.a = '1' THEN CALL s_curr3(sr.apa13,sr.apa02,'M') RETURNING sr.net1   #應付款日匯率
         ELSE CALL s_curr3(sr.apa13,sr.alz12,'M') RETURNING sr.net1  END IF

         SELECT apa64 INTO l_apa64 FROM apa_file WHERE apa01 = sr.apa01
         CALL s_curr3(sr.apa13,l_apa64,'M') RETURNING sr.net2           #當月匯率

         SELECT azi04,azi07 INTO l_azi04,l_azi07 FROM azi_file WHERE azi01 = sr.apa13
         LET sr.net1 = cl_digcut(sr.net1,l_azi07)
         LET sr.net2 = cl_digcut(sr.net2,l_azi07)
         #FUN-C80102--add--end-- 
         
         #判斷應付賬款基準日期
         IF tm.a = '2' THEN LET l_date = l_alz07 ELSE LET l_date = l_alz06 END IF
         #LET sr.apa02 = l_date  
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04 LET sr.num01=l_alz09f LET sr.num1=l_alz09f * g_aly[1].aly05/100
                                            LET l_num01=l_alz09   LET l_num1=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[2].aly04 LET sr.num02=l_alz09f LET sr.num2=l_alz09f * g_aly[2].aly05/100
                                            LET l_num02=l_alz09   LET l_num2=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[3].aly04 LET sr.num03=l_alz09f LET sr.num3=l_alz09f * g_aly[3].aly05/100
                                            LET l_num03=l_alz09   LET l_num3=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[4].aly04 LET sr.num04=l_alz09f LET sr.num4=l_alz09f * g_aly[4].aly05/100
                                            LET l_num04=l_alz09   LET l_num4=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[5].aly04 LET sr.num05=l_alz09f LET sr.num5=l_alz09f * g_aly[5].aly05/100
                                            LET l_num05=l_alz09   LET l_num5=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[6].aly04 LET sr.num06=l_alz09f LET sr.num6=l_alz09f * g_aly[6].aly05/100
                                            LET l_num06=l_alz09   LET l_num6=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[7].aly04 LET sr.num07=l_alz09f LET sr.num7=l_alz09f * g_aly[7].aly05/100
                                            LET l_num07=l_alz09   LET l_num7=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[8].aly04 LET sr.num08=l_alz09f LET sr.num8=l_alz09f * g_aly[8].aly05/100
                                            LET l_num08=l_alz09   LET l_num8=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[9].aly04 LET sr.num09=l_alz09f LET sr.num9=l_alz09f * g_aly[9].aly05/100
                                            LET l_num09=l_alz09   LET l_num9=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09f LET sr.num10=l_alz09f * g_aly[10].aly05/100
                                            LET l_num010=l_alz09    LET l_num10=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09f LET sr.num11=l_alz09f * g_aly[11].aly05/100
                                            LET l_num011=l_alz09    LET l_num11=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09f LET sr.num12=l_alz09f * g_aly[12].aly05/100
                                            LET l_num012=l_alz09    LET l_num12=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09f LET sr.num13=l_alz09f * g_aly[13].aly05/100
                                            LET l_num013=l_alz09    LET l_num13=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09f LET sr.num14=l_alz09f * g_aly[14].aly05/100
                                            LET l_num014=l_alz09    LET l_num14=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09f LET sr.num15=l_alz09f * g_aly[15].aly05/100
                                            LET l_num015=l_alz09    LET l_num15=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09f LET sr.num16=l_alz09f * g_aly[16].aly05/100
                                            LET l_num016=l_alz09    LET l_num16=l_alz09 * g_aly[1].aly05/100  #FUN-C80102 add
             OTHERWISE            LET sr.num017=l_alz09f LET sr.num17=l_alz09f
                                  LET l_num017=l_alz09 LET l_num17=l_alz09  #FUN-C80102 add 
         END CASE
         #FUN-C80102--add--str---        
         LET sr.sum1 = sr.num01+sr.num02+sr.num03+sr.num04+sr.num05+sr.num06+sr.num07+sr.num08+sr.num09+sr.num010+
                        sr.num011+sr.num012+sr.num013+sr.num014+sr.num015+sr.num016+sr.num017    
 
         LET sr.sum3 = sr.num1+sr.num2+sr.num3+sr.num4+sr.num5+sr.num6+sr.num7+sr.num8+sr.num9+sr.num10+
                       sr.num11+sr.num12+sr.num13+sr.num14+sr.num15+sr.num16+sr.num17    
         LET sr.sum5 = (sr.net2 - sr.net1) * sr.sum3
 
         LET sr.sum2 = l_num01+l_num02+l_num03+l_num04+l_num05+l_num06+l_num07+l_num08+l_num09+l_num010+
                       l_num011+l_num012+l_num013+l_num014+l_num015+l_num016+l_num017

         LET sr.sum4 = l_num1+l_num2+l_num3+l_num4+l_num5+l_num6+l_num7+l_num8+l_num9+l_num10+
                       l_num11+l_num12+l_num13+l_num14+l_num15+l_num16+l_num17

         LET sr.sum1  = cl_digcut(sr.sum1,l_azi04)
         LET sr.sum2  = cl_digcut(sr.sum2,l_azi04)
         LET sr.sum3  = cl_digcut(sr.sum3,l_azi04)
         LET sr.sum4  = cl_digcut(sr.sum4,l_azi04)
         LET sr.sum5  = cl_digcut(sr.sum5,l_azi04)
         LET sr.num1  = cl_digcut(sr.num1,l_azi04)
         LET sr.num2  = cl_digcut(sr.num2,l_azi04)
         LET sr.num3  = cl_digcut(sr.num3,l_azi04)
         LET sr.num4  = cl_digcut(sr.num4,l_azi04)
         LET sr.num5  = cl_digcut(sr.num5,l_azi04)
         LET sr.num6  = cl_digcut(sr.num6,l_azi04)
         LET sr.num7  = cl_digcut(sr.num7,l_azi04)
         LET sr.num8  = cl_digcut(sr.num8,l_azi04)
         LET sr.num9  = cl_digcut(sr.num9,l_azi04)
         LET sr.num10 = cl_digcut(sr.num10,l_azi04)
         LET sr.num11 = cl_digcut(sr.num11,l_azi04)
         LET sr.num12 = cl_digcut(sr.num12,l_azi04)
         LET sr.num13 = cl_digcut(sr.num13,l_azi04)
         LET sr.num14 = cl_digcut(sr.num14,l_azi04)
         LET sr.num15 = cl_digcut(sr.num15,l_azi04)
         LET sr.num16 = cl_digcut(sr.num16,l_azi04)
         LET sr.num17 = cl_digcut(sr.num17,l_azi04)
         LET sr.num01  = cl_digcut(sr.num01,l_azi04)
         LET sr.num02  = cl_digcut(sr.num02,l_azi04)
         LET sr.num03  = cl_digcut(sr.num03,l_azi04)
         LET sr.num04  = cl_digcut(sr.num04,l_azi04)
         LET sr.num05  = cl_digcut(sr.num05,l_azi04)
         LET sr.num06  = cl_digcut(sr.num06,l_azi04)
         LET sr.num07  = cl_digcut(sr.num07,l_azi04)
         LET sr.num08  = cl_digcut(sr.num08,l_azi04)
         LET sr.num09  = cl_digcut(sr.num09,l_azi04)
         LET sr.num010 = cl_digcut(sr.num010,l_azi04)
         LET sr.num011 = cl_digcut(sr.num011,l_azi04)
         LET sr.num012 = cl_digcut(sr.num012,l_azi04)
         LET sr.num013 = cl_digcut(sr.num013,l_azi04)
         LET sr.num014 = cl_digcut(sr.num014,l_azi04)
         LET sr.num015 = cl_digcut(sr.num015,l_azi04)
         LET sr.num016 = cl_digcut(sr.num016,l_azi04)
         LET sr.num017 = cl_digcut(sr.num017,l_azi04)
        #FUN-C80102--add--end---  
        #EXECUTE insert_prep USING sr.*,'0'    #FUN-C80102 mark
         EXECUTE insert_prep USING sr.*        #FUN-C80102 add
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('insert_prep:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      END FOREACH 	
   ELSE
      #  LET l_sql = "SELECT apa06, pmc03,apa01,apa02,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,", #FUN-BB0038
     #LET l_sql = "SELECT apa06, apa07,apa01,apa02,apa13,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,",#FUN-BB0038   #TQC-C30349  add  apa13  #FUN-C80102 mark
     #FUN-C80102----add---str---
      LET l_sql = "SELECT apa06, apa07,0,0,apa13,apa14, 0,0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,",
                  "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0, apa15,",
                  "       apa16,0,0,apa21,'',apa22,'',apa08,apa00,apa01,apa02,alz12,alz07,apa11,'',",
                  "       apa36,'',apa44,apa54,'',apa05,'',",
                  "       pmy01,pmy02,apa41,alz09,alz09f,alz06,alz07 ",
     #FUN-C80102----add---end---
     #            "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,alz09,alz06,alz07 ",		#FUN-C80102 mark								
                  "  FROM apc_file,apa_file,alz_file,pmc_file ",
                  "  LEFT OUTER JOIN pmy_file ON(pmc_file.pmc02=pmy_file.pmy01)",										
                  " WHERE ",tm.wc CLIPPED," AND apa06 = pmc01 AND apa01 = apc01 ",
                  "   AND apa06 = alz01 AND alz00 = '1' AND alz02 = ",YEAR(tm.edate),
                  "   AND alz03 = ",MONTH(tm.edate)," AND alz04 = apa01 ",
                  "   AND alz05 = apc02"
      #選擇扣除折讓資料            
     #IF tm.zr = 'Y' THEN LET l_sql=l_sql CLIPPED," AND alz09>0" END IF  #FUN-C80102 mark
     #IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<'",tm.edate,"'" END IF    #MOD-G10097 mark
      IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<='",tm.edate,"'" END IF   #MOD-G10097 add		 
      CASE tm.pay1
         WHEN '1' LET g_sql = g_sql CLIPPED
         WHEN '2' 
            IF tm.b = 'Y' THEN
               LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24','16','26') "
            ELSE
               LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24') "
            END IF  
         WHEN '3' LET l_sql = l_sql CLIPPED," AND apa00 IN('17','13','25','24')"
      END CASE
      PREPARE r191_prepare FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('r191_prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r191_curs1 CURSOR FOR r191_prepare
      FOREACH r191_curs1 INTO sr.*,l_alz09,l_alz09f,l_alz06,l_alz07
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
        #FUN-C80102--add--str----
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc02 = sr.apa05
         SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.apa21
         SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.apa22
         SELECT pma02 INTO sr.pma02 FROM pma_file WHERE pma01 = sr.apa11
         SELECT apr02 INTO sr.apr02 FROM apr_file WHERE apr01 = sr.apa36
         SELECT unique aag02 INTO sr.aag02 FROM aag_file WHERE aag01 = sr.apa54
        
        IF tm.a = '1' THEN CALL s_curr3(sr.apa13,sr.apa02,'M') RETURNING sr.net1
        ELSE CALL s_curr3(sr.apa13,sr.alz12,'M') RETURNING sr.net1  END IF

        SELECT apa64 INTO l_apa64 FROM apa_file WHERE apa01 = sr.apa01
        CALL s_curr3(sr.apa13,l_apa64,'M') RETURNING sr.net2    

        SELECT azi04,azi07 INTO l_azi04,l_azi07 FROM azi_file WHERE azi01 = sr.apa13
        LET sr.net1 = cl_digcut(sr.net1,l_azi07)
        LET sr.net2 = cl_digcut(sr.net2,l_azi07)
        #FUN-C80102--add--end--
         
         #判斷應付賬款基準日期
         IF tm.a = '2' THEN LET l_date = l_alz07 ELSE LET l_date = l_alz06 END IF
         #LET sr.apa02 = l_date  
         LET l_bucket = tm.edate-l_date
         CASE WHEN l_bucket<=g_aly[1].aly04 LET sr.num01=l_alz09 LET sr.num1=l_alz09 * g_aly[1].aly05/100
                                            LET l_num01=l_alz09f LET l_num1=l_alz09f * g_aly[1].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[2].aly04 LET sr.num02=l_alz09 LET sr.num2=l_alz09 * g_aly[2].aly05/100
                                            LET l_num02=l_alz09f LET l_num2=l_alz09f * g_aly[2].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[3].aly04 LET sr.num03=l_alz09 LET sr.num3=l_alz09 * g_aly[3].aly05/100
                                            LET l_num03=l_alz09f LET l_num3=l_alz09f * g_aly[3].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[4].aly04 LET sr.num04=l_alz09 LET sr.num4=l_alz09 * g_aly[4].aly05/100
                                            LET l_num04=l_alz09f LET l_num4=l_alz09f * g_aly[4].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[5].aly04 LET sr.num05=l_alz09 LET sr.num5=l_alz09 * g_aly[5].aly05/100
                                            LET l_num05=l_alz09f LET l_num5=l_alz09f * g_aly[5].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[6].aly04 LET sr.num06=l_alz09 LET sr.num6=l_alz09 * g_aly[6].aly05/100
                                            LET l_num06=l_alz09f LET l_num6=l_alz09f * g_aly[6].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[7].aly04 LET sr.num07=l_alz09 LET sr.num7=l_alz09 * g_aly[7].aly05/100
                                            LET l_num07=l_alz09f LET l_num7=l_alz09f * g_aly[7].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[8].aly04 LET sr.num08=l_alz09 LET sr.num8=l_alz09 * g_aly[8].aly05/100
                                            LET l_num08=l_alz09f LET l_num8=l_alz09f * g_aly[8].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[9].aly04 LET sr.num09=l_alz09 LET sr.num9=l_alz09 * g_aly[9].aly05/100
                                            LET l_num09=l_alz09f LET l_num9=l_alz09f * g_aly[9].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[10].aly04 LET sr.num010=l_alz09 LET sr.num10=l_alz09 * g_aly[10].aly05/100
                                             LET l_num010=l_alz09f LET l_num10=l_alz09f * g_aly[10].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[11].aly04 LET sr.num011=l_alz09 LET sr.num11=l_alz09 * g_aly[11].aly05/100
                                             LET l_num011=l_alz09f LET l_num11=l_alz09f * g_aly[11].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[12].aly04 LET sr.num012=l_alz09 LET sr.num12=l_alz09 * g_aly[12].aly05/100
                                             LET l_num012=l_alz09f LET l_num12=l_alz09f * g_aly[12].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[13].aly04 LET sr.num013=l_alz09 LET sr.num13=l_alz09 * g_aly[13].aly05/100
                                             LET l_num013=l_alz09f LET l_num13=l_alz09f * g_aly[13].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[14].aly04 LET sr.num014=l_alz09 LET sr.num14=l_alz09 * g_aly[14].aly05/100
                                             LET l_num014=l_alz09f LET l_num14=l_alz09f * g_aly[14].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[15].aly04 LET sr.num015=l_alz09 LET sr.num15=l_alz09 * g_aly[15].aly05/100
                                             LET l_num015=l_alz09f LET l_num15=l_alz09f * g_aly[15].aly05/100  #FUN-C80102 add
              WHEN l_bucket<=g_aly[16].aly04 LET sr.num016=l_alz09 LET sr.num16=l_alz09 * g_aly[16].aly05/100
                                             LET l_num016=l_alz09f LET l_num16=l_alz09f * g_aly[16].aly05/100  #FUN-C80102 add
              OTHERWISE            LET sr.num017=l_alz09 LET sr.num17=l_alz09
                                   LET l_num017=l_alz09f LET l_num17=l_alz09f  #FUN-C80102 add 
         END CASE
         
         #FUN-C80102--add--str---
        LET sr.sum2 = sr.num01+sr.num02+sr.num03+sr.num04+sr.num05+sr.num06+sr.num07+sr.num08+sr.num09+sr.num010+
                      sr.num011+sr.num012+sr.num013+sr.num014+sr.num015+sr.num016+sr.num017    

        LET sr.sum4 = sr.num1+sr.num2+sr.num3+sr.num4+sr.num5+sr.num6+sr.num7+sr.num8+sr.num9+sr.num10+
                      sr.num11+sr.num12+sr.num13+sr.num14+sr.num15+sr.num16+sr.num17    

        LET sr.sum1 = l_num01+l_num02+l_num03+l_num04+l_num05+l_num06+l_num07+l_num08+l_num09+l_num010+
                      l_num011+l_num012+l_num013+l_num014+l_num015+l_num016+l_num017

        LET sr.sum3 = l_num1+l_num2+l_num3+l_num4+l_num5+l_num6+l_num7+l_num8+l_num9+l_num10+
                      l_num11+l_num12+l_num13+l_num14+l_num15+l_num16+l_num17
        LET sr.sum5 = 0
        LET sr.sum1  = cl_digcut(sr.sum1,l_azi04)
        LET sr.sum2  = cl_digcut(sr.sum2,l_azi04)
        LET sr.sum3  = cl_digcut(sr.sum3,l_azi04)
        LET sr.sum4  = cl_digcut(sr.sum4,l_azi04)
        LET sr.sum5  = cl_digcut(sr.sum5,l_azi04)
        LET sr.num1  = cl_digcut(sr.num1,l_azi04)
        LET sr.num2  = cl_digcut(sr.num2,l_azi04)
        LET sr.num3  = cl_digcut(sr.num3,l_azi04)
        LET sr.num4  = cl_digcut(sr.num4,l_azi04)
        LET sr.num5  = cl_digcut(sr.num5,l_azi04)
        LET sr.num6  = cl_digcut(sr.num6,l_azi04)
        LET sr.num7  = cl_digcut(sr.num7,l_azi04)
        LET sr.num8  = cl_digcut(sr.num8,l_azi04)
        LET sr.num9  = cl_digcut(sr.num9,l_azi04)
        LET sr.num10 = cl_digcut(sr.num10,l_azi04)
        LET sr.num11 = cl_digcut(sr.num11,l_azi04)
        LET sr.num12 = cl_digcut(sr.num12,l_azi04)
        LET sr.num13 = cl_digcut(sr.num13,l_azi04)
        LET sr.num14 = cl_digcut(sr.num14,l_azi04)
        LET sr.num15 = cl_digcut(sr.num15,l_azi04)
        LET sr.num16 = cl_digcut(sr.num16,l_azi04)
        LET sr.num17 = cl_digcut(sr.num17,l_azi04)
        LET sr.num01  = cl_digcut(sr.num01,l_azi04)
        LET sr.num02  = cl_digcut(sr.num02,l_azi04)
        LET sr.num03  = cl_digcut(sr.num03,l_azi04)
        LET sr.num04  = cl_digcut(sr.num04,l_azi04)
        LET sr.num05  = cl_digcut(sr.num05,l_azi04)
        LET sr.num06  = cl_digcut(sr.num06,l_azi04)
        LET sr.num07  = cl_digcut(sr.num07,l_azi04)
        LET sr.num08  = cl_digcut(sr.num08,l_azi04)
        LET sr.num09  = cl_digcut(sr.num09,l_azi04)
        LET sr.num010 = cl_digcut(sr.num010,l_azi04)
        LET sr.num011 = cl_digcut(sr.num011,l_azi04)
        LET sr.num012 = cl_digcut(sr.num012,l_azi04)
        LET sr.num013 = cl_digcut(sr.num013,l_azi04)
        LET sr.num014 = cl_digcut(sr.num014,l_azi04)
        LET sr.num015 = cl_digcut(sr.num015,l_azi04)
        LET sr.num016 = cl_digcut(sr.num016,l_azi04)
        LET sr.num017 = cl_digcut(sr.num017,l_azi04)
        #FUN-C80102--add--end---
         
        #EXECUTE insert_prep USING sr.*,'0'  #FUN-C80102 mark
         EXECUTE insert_prep USING sr.*      #FUN-C80102 add
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('insert_prep:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      END FOREACH 	
   END IF 
END FUNCTION 

FUNCTION aapq191_t()

   #FUN-C80102----add---str--
   CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34,apa35,amt_2,apa34_1,apa35_1,amt_2_1,sum2,sum4,sum2_1,sum4_1",TRUE)
   CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34f,apa35f,amt_1,apa34f_1,apa35f_1,amt_1_1,sum1,sum3,sum1_1,sum3_1",TRUE)
   IF tm.org = 'Y' THEN
      CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34f,apa35f,amt_1,apa34f_1,apa35f_1,amt_1_1,sum1,sum3,sum1_1,sum3_1",TRUE)
   ELSE
      CALL cl_set_comp_visible("apa13,apa13_1,apa14,apa34f,apa35f,amt_1,apa34f_1,apa35f_1,amt_1_1,sum1,sum3,sum1_1,sum3_1",FALSE)
   END IF
   #FUN-C80102----add---end--

   CLEAR FORM
   CALL g_alz.clear()
   CALL q191_show()
   CALL q191_set_title()    #FUN-C80102 add
   CALL q191_set_title_1()  #FUN-C80102 add
END FUNCTION

#FUNCTION aapq191_cs()                                                                
#     LET g_sql = "SELECT UNIQUE type,edate FROM aapq191_tmp ",   
#                 " ORDER BY type,edate"                                                                                                                              
#     PREPARE aapq191_ps FROM g_sql
#     DECLARE aapq191_curs SCROLL CURSOR WITH HOLD FOR aapq191_ps
#     
#
#     LET g_sql = "SELECT UNIQUE type,edate FROM aapq191_tmp ",
#                 "  INTO TEMP x "                                                                                                   #FUN-980119     
# 
#     DROP TABLE x
#     PREPARE aapq191_ps1 FROM g_sql
#     EXECUTE aapq191_ps1
# 
#     LET g_sql = "SELECT COUNT(*) FROM x"
#     PREPARE aapq191_ps2 FROM g_sql
#     DECLARE aapq191_cnt CURSOR FOR aapq191_ps2
# 
#     OPEN aapq191_curs
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('OPEN aapq191_curs',SQLCA.sqlcode,0)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#        EXIT PROGRAM
#     ELSE
#        OPEN aapq191_cnt
#        FETCH aapq191_cnt INTO g_row_count
#        DISPLAY g_row_count TO FORMONLY.cnt
#        CALL q191_fetch('F')
#     END IF
#END FUNCTION
#
#FUNCTION q191_fetch(p_flag)
#DEFINE
#   p_flag          LIKE type_file.chr1,                 #處理方式       
#   l_abso          LIKE type_file.num10                 #絕對的筆數   
#   
#   CASE p_flag
#      WHEN 'N' FETCH NEXT     aapq191_curs INTO g_apa.type,g_apa.edate
#      WHEN 'P' FETCH PREVIOUS aapq191_curs INTO g_apa.type,g_apa.edate
#      WHEN 'F' FETCH FIRST    aapq191_curs INTO g_apa.type,g_apa.edate
#      WHEN 'L' FETCH LAST     aapq191_curs INTO g_apa.type,g_apa.edate
#      WHEN '/'
#         IF (NOT mi_no_ask) THEN
#             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#             LET INT_FLAG = 0
#             PROMPT g_msg CLIPPED,': ' FOR g_jump 
#                ON IDLE g_idle_seconds
#                   CALL cl_on_idle()
# 
#                ON ACTION about        
#                   CALL cl_about()      
# 
#                ON ACTION help          
#                   CALL cl_show_help()  
# 
#                ON ACTION controlg     
#                   CALL cl_cmdask()     
# 
#             END PROMPT
#             IF INT_FLAG THEN
#                LET INT_FLAG = 0
#                EXIT CASE
#             END IF
#         END IF
#         FETCH ABSOLUTE g_jump aapq191_curs INTO g_apa.type,g_apa.edate
#         LET mi_no_ask = FALSE
#   END CASE  	                                                    
# 
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)
#      INITIALIZE g_apa.* TO NULL                                                             
#      RETURN
#   ELSE
#      CASE p_flag
#         WHEN 'F' LET g_curs_index = 1
#         WHEN 'P' LET g_curs_index = g_curs_index - 1
#         WHEN 'N' LET g_curs_index = g_curs_index + 1
#         WHEN 'L' LET g_curs_index = g_row_count
#         WHEN '/' LET g_curs_index = g_jump #CKP3
#      END CASE
# 
#      CALL cl_navigator_setting( g_curs_index, g_row_count )
#   END IF
# 
#   CALL q191_show()
#END FUNCTION
 
FUNCTION q191_show()
 # DISPLAY tm.a  TO type    #FUN-C80102 mark
   DISPLAY tm.edate TO edate
   #FUN-C80102-----add----str---
   DISPLAY tm.a  TO a 
   DISPLAY tm.u TO u
   DISPLAY tm.aly01 TO aly01 
   DISPLAY tm.org TO org 
   DISPLAY tm.d TO d 
   DISPLAY tm.pay1 TO pay1
   DISPLAY tm.b TO b
   #FUN-C80102-----add----end---
   
   CALL q191_b_fill()
   CALL q191_b_fill_2()  #FUN-C80102 add
   #FUN-C80102-----add----str---
   IF cl_null(tm.u)  THEN   
      LET g_action_choice = "page2" 
      CALL cl_set_comp_visible("page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page3", TRUE)
      LET g_action_flag = "page2"
   ELSE
      LET g_action_choice = "page3"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   END IF

   CALL q191_set_visible()
   #FUN-C80102-----add------end----
 
   CALL cl_show_fld_cont()
END FUNCTION

#FUN-C80102--add--str---
FUNCTION q191_set_visible()

  CALL cl_set_comp_visible("apa22_1,gem02_1,apa21_1,gen02_1,apa54_1,aag02_1,apa05_1,pmc03_1,apa34_tot,apa35_tot",TRUE)

  CASE tm.u
    WHEN '1' CALL cl_set_comp_visible("apa22_1,gem02_1,apa21_1,gen02_1,apa54_1,aag02_1,apa34_tot,apa35_tot",FALSE)
             CALL q191_set_title_1()
    WHEN '2' CALL cl_set_comp_visible("apa05_1,pmc03_1,apa21_1,gen02_1,apa54_1,aag02_1,apa34_tot,apa35_tot",FALSE)
             CALL q191_set_title_1()
    WHEN '3' CALL cl_set_comp_visible("apa05_1,pmc03_1,apa22_1,gem02_1,apa54_1,aag02_1,apa34_tot,apa35_tot",FALSE)
             CALL q191_set_title_1()
    WHEN '4' CALL cl_set_comp_visible("apa22_1,gem02_1,apa21_1,gen02_1,apa34_tot,apa35_tot",FALSE)
             CALL q191_set_title_1()
  END CASE
END FUNCTION

FUNCTION q191_b_fill()
DEFINE l_apa13   LIKE apa_file.apa13
DEFINE g_tot11   LIKE alz_file.alz09 
DEFINE g_tot21   LIKE alz_file.alz09 
DEFINE g_tot31   LIKE alz_file.alz09 
DEFINE g_tot41   LIKE alz_file.alz09 
DEFINE g_tot51   LIKE alz_file.alz09

   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aza.aza17

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   #LET g_sql = "SELECT * FROM aapq191_tmp ", #FUN-CB0146 mark
 #MOD-G10167---mark---str-- 
 ##FUN-CB0146--add--str--
 #LET g_sql=" SELECT apa06,apa07,apa34f,apa35f,apa13,apa14,",
 #          "        amt_1,sum1,sum3,apa34,apa35,amt_2,sum2,sum4,",
 #          "        num01,num02,num03,num04,num05,num06,num07,num08,num09,",
 #          "        num010,num011,num012,num013,num014,num015,num016,num017,",
 #          "        num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,",
 #          "        num12,num13,num14,num15,num16,num17,",
 #          "        sum5,apa15,apa16,net1,net2,apa21,gen02,apa22,gem02,apa08,",
 #          "        apa00,apa01,apa02,alz12,alz07,apa11,pma02,apa36,apr02,apa44,",         
 #          "        apa54,aag02,apa05,pmc03,pmy01,pmy02,apa41 ",
 #          "  FROM q191_tmp ",
 # #FUN-CB0146--add--end
 #MOD-G10167---mark---str--
 #MOD-G10167---add---str--
  LET g_sql=" SELECT apa06,apa07,apa34f,apa35f,apa13,",
            "        apa14,amt_1,sum1,sum3,apa34,",
            "        apa35,amt_2,sum2,sum4,num01,",
            "        num1,num02,num2,num03,num3,",
            "        num04,num4,num05,num5,num06,",
            "        num6,num07,num7,num08,num8,",
            "        num09,num9,num010,num10,num011,",
            "        num11,num012,num12,num013,num13,",
            "        num014,num14,num015,num15,num016,",
            "        num16,num017,num17,sum5,apa15,",
            "        apa16,net1,net2,apa21,gen02,",
            "        apa22,gem02,apa08,apa00,apa01,",
            "        apa02,alz12,alz07,apa11,pma02,",
            "        apa36,apr02,apa44,apa54,aag02,",
            "        apa05,pmc03,pmy01,pmy02,apa41 ",
            "  FROM q191_tmp ",
 #MOD-G10167---add---end-- 
            " WHERE ",g_filter_wc CLIPPED,  
            " ORDER BY apa05,apa21,apa22,apa54 "

   PREPARE aapq191_pb FROM g_sql
   DECLARE alz_curs  CURSOR FOR aapq191_pb        #CURSOR

   CALL g_alz.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0

   FOREACH alz_curs INTO g_alz[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_tot11 = g_tot11 + g_alz[g_cnt].apa34
      LET g_tot21 = g_tot21 + g_alz[g_cnt].apa35
      LET g_tot31 = g_tot31 + g_alz[g_cnt].amt_2
      LET g_tot41 = g_tot41 + g_alz[g_cnt].sum2
      LET g_tot51 = g_tot51 + g_alz[g_cnt].sum4      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   LET g_tot11 = cl_digcut(g_tot11,t_azi05)
   LET g_tot21 = cl_digcut(g_tot21,t_azi05)
   LET g_tot31 = cl_digcut(g_tot31,t_azi05)
   LET g_tot41 = cl_digcut(g_tot41,t_azi05)
   LET g_tot51 = cl_digcut(g_tot51,t_azi05)
   DISPLAY g_tot11 TO FORMONLY.apa34_tot1
   DISPLAY g_tot21 TO FORMONLY.apa35_tot1
   DISPLAY g_tot31 TO FORMONLY.apa34_apa35_tot1
   DISPLAY g_tot41 TO FORMONLY.sum_2_tot1
   DISPLAY g_tot51 TO FORMONLY.sum_4_tot1
   CALL g_alz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q191_b_fill_2()
DEFINE l_apa13   LIKE apa_file.apa13
DEFINE g_tot1    LIKE apa_file.apa34
DEFINE g_tot2    LIKE apa_file.apa34 
DEFINE g_tot3    LIKE apa_file.apa34 
DEFINE g_tot4    LIKE apa_file.apa34 
DEFINE g_tot5    LIKE apa_file.apa34

   CALL q191_set_title_1()
   CALL g_alz_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   LET g_tot1 = 0
   LET g_tot2 = 0
   LET g_tot3 = 0
   LET g_tot4 = 0
   LET g_tot5 = 0

   IF tm.d = 'Y' THEN 
      #LET g_sql = " SELECT distinct apa13 FROM aapq191_tmp ORDER BY apa13" #FUN-CB0146 mark
       LET g_sql = " SELECT distinct apa13 FROM q191_tmp ORDER BY apa13" #FUN-CB0146

      PREPARE q191_bp_d FROM g_sql
      DECLARE q191_curs_d CURSOR FOR q191_bp_d
      FOREACH q191_curs_d INTO l_apa13
         CALL q191_get_sum(l_apa13)
         LET g_tot1 = g_tot1 + g_alz_1[g_cnt].apa34
         LET g_tot2 = g_tot2 + g_alz_1[g_cnt].apa35
         LET g_tot3 = g_tot3 + g_alz_1[g_cnt].amt_2
         LET g_tot4 = g_tot4 + g_alz_1[g_cnt].sum2
         LET g_tot5 = g_tot5 + g_alz_1[g_cnt].sum4
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF 
      END FOREACH
      DISPLAY g_tot1  TO FORMONLY.apa34_tot
      DISPLAY g_tot2  TO FORMONLY.apa35_tot
      DISPLAY g_tot3  TO FORMONLY.apa34_apa35_tot
      DISPLAY g_tot4  TO FORMONLY.sum_2_tot
      DISPLAY g_tot5  TO FORMONLY.sum_4_tot
   ELSE
      CALL q191_get_sum('')
   END IF     
END FUNCTION

FUNCTION q191_get_sum(p_apa13)
DEFINE p_apa13 LIKE apa_file.apa01
DEFINE l_tot1 LIKE alz_file.alz09  
DEFINE l_tot2 LIKE alz_file.alz09 
DEFINE l_tot3 LIKE alz_file.alz09 
DEFINE l_tot4 LIKE alz_file.alz09 
DEFINE l_tot5 LIKE alz_file.alz09 
DEFINE l_tot6 LIKE alz_file.alz09 
DEFINE l_tot7 LIKE alz_file.alz09 
DEFINE l_tot8 LIKE alz_file.alz09 
DEFINE l_tot9 LIKE alz_file.alz09 
DEFINE l_tot10 LIKE alz_file.alz09 
DEFINE l_tot11 LIKE alz_file.alz09 
DEFINE l_tot12 LIKE alz_file.alz09 
DEFINE l_tot13 LIKE alz_file.alz09 
DEFINE l_tot14 LIKE alz_file.alz09 
DEFINE l_tot15 LIKE alz_file.alz09 
DEFINE l_tot16 LIKE alz_file.alz09 
DEFINE l_tot17 LIKE alz_file.alz09 
DEFINE l_tot18 LIKE alz_file.alz09 
DEFINE l_tot19 LIKE alz_file.alz09 
DEFINE l_tot20 LIKE alz_file.alz09 
DEFINE l_tot21 LIKE alz_file.alz09 
DEFINE l_tot22 LIKE alz_file.alz09 
DEFINE l_tot23 LIKE alz_file.alz09 
DEFINE l_tot24 LIKE alz_file.alz09 
DEFINE l_tot25 LIKE alz_file.alz09 
DEFINE l_tot26 LIKE alz_file.alz09 
DEFINE l_tot27 LIKE alz_file.alz09 
DEFINE l_tot28 LIKE alz_file.alz09 
DEFINE l_tot12_1 LIKE alz_file.alz09 
DEFINE l_tot13_1 LIKE alz_file.alz09 
DEFINE l_tot14_1 LIKE alz_file.alz09 
DEFINE l_tot15_1 LIKE alz_file.alz09 
DEFINE l_tot16_1 LIKE alz_file.alz09 
DEFINE l_tot17_1 LIKE alz_file.alz09 
DEFINE l_tot18_1 LIKE alz_file.alz09 
DEFINE l_tot19_1 LIKE alz_file.alz09 
DEFINE l_tot20_1 LIKE alz_file.alz09 
DEFINE l_tot21_1 LIKE alz_file.alz09 
DEFINE l_tot22_1 LIKE alz_file.alz09 
DEFINE l_tot23_1 LIKE alz_file.alz09 
DEFINE l_tot24_1 LIKE alz_file.alz09 
DEFINE l_tot25_1 LIKE alz_file.alz09 
DEFINE l_tot26_1 LIKE alz_file.alz09 
DEFINE l_tot27_1 LIKE alz_file.alz09 
DEFINE l_tot28_1 LIKE alz_file.alz09 
DEFINE l_occ45   LIKE occ_file.occ45 
DEFINE l_str     STRING

LET l_tot1 = 0   LET l_tot2 = 0
LET l_tot3 = 0   LET l_tot4 = 0
LET l_tot5 = 0   LET l_tot6 = 0
LET l_tot7 = 0   LET l_tot8 = 0
LET l_tot9 = 0   LET l_tot10 = 0 LET l_tot11 = 0
LET l_tot12 = 0  LET l_tot12_1 = 0 
LET l_tot13 = 0  LET l_tot13_1 = 0 
LET l_tot14 = 0  LET l_tot14_1 = 0 
LET l_tot15 = 0  LET l_tot15_1 = 0 
LET l_tot16 = 0  LET l_tot16_1 = 0 
LET l_tot17 = 0  LET l_tot17_1 = 0 
LET l_tot18 = 0  LET l_tot18_1 = 0 
LET l_tot19 = 0  LET l_tot19_1 = 0 
LET l_tot20 = 0  LET l_tot20_1 = 0 
LET l_tot21 = 0  LET l_tot21_1 = 0 
LET l_tot22 = 0  LET l_tot22_1 = 0 
LET l_tot23 = 0  LET l_tot23_1 = 0 
LET l_tot24 = 0  LET l_tot24_1 = 0 
LET l_tot25 = 0  LET l_tot25_1 = 0 
LET l_tot26 = 0  LET l_tot26_1 = 0 
LET l_tot27 = 0  LET l_tot27_1 = 0 
LET l_tot28 = 0  LET l_tot28_1 = 0 
   CASE tm.u
     WHEN '1'
     IF tm.org = 'Y' THEN
        LET g_sql = "SELECT apa05,'','','','','','','',apa13,SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
     ELSE
        LET g_sql = "SELECT apa05,'','','','','','','','',SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
     END IF
     LET g_sql = g_sql CLIPPED,"  SUM(apa34),SUM(apa35),SUM(amt_2),SUM(sum2),SUM(sum4),SUM(num01),SUM(num1),SUM(num02),",
                    "       SUM(num2),SUM(num03),SUM(num3),SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),",
                    "       SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),SUM(num09),SUM(num9),SUM(num010),",
                    "       SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
                    "       SUM(num014),SUM(num14),SUM(num015),SUM(num15), ",
                    "       SUM(num016),SUM(num16),SUM(num017),SUM(num17),0,apa06,apa07,pmy01,'' ",
                   # "  FROM aapq191_tmp ", #FUN-CB0146 mark
                    "  FROM q191_tmp ", #FUN-CB0146
                    "  WHERE ",g_filter_wc CLIPPED 
         IF tm.d = 'Y' THEN LET g_sql = g_sql CLIPPED," AND  apa13 = '",p_apa13,"' " END IF
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa05,apa13,apa06,apa07,pmy01 ",   
                        " ORDER BY apa05,apa13,apa06,apa07,pmy01 "   
         ELSE
            LET g_sql = g_sql CLIPPED,
                        " GROUP BY apa05,apa06,apa07,pmy01 ",
                        " ORDER BY apa05,apa06,apa07,pmy01 "
         END IF

         PREPARE q191_pb1 FROM g_sql
         DECLARE q191_curs1 CURSOR FOR q191_pb1
         FOREACH q191_curs1 INTO g_alz_1[g_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF

            SELECT pmc03 INTO g_alz_1[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_alz_1[g_cnt].apa05
            SELECT pmy02 INTO g_alz_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_alz_1[g_cnt].pmy01
    
            IF tm.d = 'N' THEN
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4
            END IF

            IF tm.d = 'Y' THEN 
               LET l_tot1 = l_tot1 + g_alz_1[g_cnt].apa34f
               LET l_tot2 = l_tot2 + g_alz_1[g_cnt].apa35f
               LET l_tot3 = l_tot3 + g_alz_1[g_cnt].amt_1 
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35f
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot7 = l_tot7 + g_alz_1[g_cnt].sum1 
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2 
               LET l_tot9 = l_tot9 + g_alz_1[g_cnt].sum3 
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4 
               LET l_tot12 = l_tot12 + g_alz_1[g_cnt].amt1 
               LET l_tot13 = l_tot13 + g_alz_1[g_cnt].amt2 
               LET l_tot14 = l_tot14 + g_alz_1[g_cnt].amt3       
               LET l_tot15 = l_tot15 + g_alz_1[g_cnt].amt4 
               LET l_tot16 = l_tot16 + g_alz_1[g_cnt].amt5 
               LET l_tot17 = l_tot17 + g_alz_1[g_cnt].amt6 
               LET l_tot18 = l_tot18 + g_alz_1[g_cnt].amt7 
               LET l_tot19 = l_tot19 + g_alz_1[g_cnt].amt8 
               LET l_tot20 = l_tot20 + g_alz_1[g_cnt].amt9 
               LET l_tot21 = l_tot21 + g_alz_1[g_cnt].amt10 
               LET l_tot22 = l_tot22 + g_alz_1[g_cnt].amt11 
               LET l_tot23 = l_tot23 + g_alz_1[g_cnt].amt12 
               LET l_tot24 = l_tot24 + g_alz_1[g_cnt].amt13 
               LET l_tot25 = l_tot25 + g_alz_1[g_cnt].amt14 
               LET l_tot26 = l_tot26 + g_alz_1[g_cnt].amt15 
               LET l_tot27 = l_tot27 + g_alz_1[g_cnt].amt16 
               LET l_tot28 = l_tot28 + g_alz_1[g_cnt].amt17 
               LET l_tot12_1 = l_tot12_1 + g_alz_1[g_cnt].bamt1 
               LET l_tot13_1 = l_tot13_1 + g_alz_1[g_cnt].bamt2 
               LET l_tot14_1 = l_tot14_1 + g_alz_1[g_cnt].bamt3 
               LET l_tot15_1 = l_tot15_1 + g_alz_1[g_cnt].bamt4 
               LET l_tot16_1 = l_tot16_1 + g_alz_1[g_cnt].bamt5 
               LET l_tot17_1 = l_tot17_1 + g_alz_1[g_cnt].bamt6 
               LET l_tot18_1 = l_tot18_1 + g_alz_1[g_cnt].bamt7 
               LET l_tot19_1 = l_tot19_1 + g_alz_1[g_cnt].bamt8 
               LET l_tot20_1 = l_tot20_1 + g_alz_1[g_cnt].bamt9 
               LET l_tot21_1 = l_tot21_1 + g_alz_1[g_cnt].bamt10 
               LET l_tot22_1 = l_tot22_1 + g_alz_1[g_cnt].bamt11 
               LET l_tot23_1 = l_tot23_1 + g_alz_1[g_cnt].bamt12 
               LET l_tot24_1 = l_tot24_1 + g_alz_1[g_cnt].bamt13 
               LET l_tot25_1 = l_tot25_1 + g_alz_1[g_cnt].bamt14 
               LET l_tot26_1 = l_tot26_1 + g_alz_1[g_cnt].bamt15 
               LET l_tot27_1 = l_tot27_1 + g_alz_1[g_cnt].bamt16 
               LET l_tot28_1 = l_tot28_1 + g_alz_1[g_cnt].bamt17 
            END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
       WHEN '2'
        IF tm.org = 'Y' THEN
        LET g_sql = "SELECT '','',apa22,'','','','','',apa13,SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        ELSE
        LET g_sql = "SELECT '','',apa22,'','','','','','',SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        END IF
        LET g_sql = g_sql CLIPPED,"  SUM(apa34),SUM(apa35),SUM(amt_2),SUM(sum2),SUM(sum4),SUM(num01),SUM(num1),SUM(num02),",
                    "       SUM(num2),SUM(num03),SUM(num3),SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),",
                    "       SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),SUM(num09),SUM(num9),SUM(num010),",
                    "       SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
                    "       SUM(num014),SUM(num14),SUM(num015),SUM(num15), ",
                    "       SUM(num016),SUM(num16),SUM(num017),SUM(num17),0,apa06,apa07,pmy01,'' ",
                   # "  FROM aapq191_tmp ", #FUN-CB0146 mark
                    "  FROM q191_tmp ", #FUN-CB0146
                    "  WHERE ",g_filter_wc CLIPPED 
         IF tm.d = 'Y' THEN LET g_sql = g_sql CLIPPED," AND  apa13 = '",p_apa13,"' " END IF
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa22,apa13,apa06,apa07,pmy01 ",   
                        " ORDER BY apa22,apa13,apa06,apa07,pmy01 "   
         ELSE
            LET g_sql = g_sql CLIPPED,
                        " GROUP BY apa22,apa06,apa07,pmy01 ",
                        " ORDER BY apa22,apa06,apa07,pmy01 "
         END IF

         PREPARE q191_pb2 FROM g_sql
         DECLARE q191_curs2 CURSOR FOR q191_pb2
         FOREACH q191_curs2 INTO g_alz_1[g_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF

            SELECT gem02 INTO g_alz_1[g_cnt].gem02 FROM gem_file WHERE gem01 = g_alz_1[g_cnt].apa22
            SELECT pmy02 INTO g_alz_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_alz_1[g_cnt].pmy01
    
            IF tm.d = 'N' THEN
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4
            END IF

            IF tm.d = 'Y' THEN 
               LET l_tot1 = l_tot1 + g_alz_1[g_cnt].apa34f
               LET l_tot2 = l_tot2 + g_alz_1[g_cnt].apa35f
               LET l_tot3 = l_tot3 + g_alz_1[g_cnt].amt_1 
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35f
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot7 = l_tot7 + g_alz_1[g_cnt].sum1 
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2 
               LET l_tot9 = l_tot9 + g_alz_1[g_cnt].sum3 
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4 
               LET l_tot12 = l_tot12 + g_alz_1[g_cnt].amt1 
               LET l_tot13 = l_tot13 + g_alz_1[g_cnt].amt2 
               LET l_tot14 = l_tot14 + g_alz_1[g_cnt].amt3       
               LET l_tot15 = l_tot15 + g_alz_1[g_cnt].amt4 
               LET l_tot16 = l_tot16 + g_alz_1[g_cnt].amt5 
               LET l_tot17 = l_tot17 + g_alz_1[g_cnt].amt6 
               LET l_tot18 = l_tot18 + g_alz_1[g_cnt].amt7 
               LET l_tot19 = l_tot19 + g_alz_1[g_cnt].amt8 
               LET l_tot20 = l_tot20 + g_alz_1[g_cnt].amt9 
               LET l_tot21 = l_tot21 + g_alz_1[g_cnt].amt10 
               LET l_tot22 = l_tot22 + g_alz_1[g_cnt].amt11 
               LET l_tot23 = l_tot23 + g_alz_1[g_cnt].amt12 
               LET l_tot24 = l_tot24 + g_alz_1[g_cnt].amt13 
               LET l_tot25 = l_tot25 + g_alz_1[g_cnt].amt14 
               LET l_tot26 = l_tot26 + g_alz_1[g_cnt].amt15 
               LET l_tot27 = l_tot27 + g_alz_1[g_cnt].amt16 
               LET l_tot28 = l_tot28 + g_alz_1[g_cnt].amt17 
               LET l_tot12_1 = l_tot12_1 + g_alz_1[g_cnt].bamt1 
               LET l_tot13_1 = l_tot13_1 + g_alz_1[g_cnt].bamt2 
               LET l_tot14_1 = l_tot14_1 + g_alz_1[g_cnt].bamt3 
               LET l_tot15_1 = l_tot15_1 + g_alz_1[g_cnt].bamt4 
               LET l_tot16_1 = l_tot16_1 + g_alz_1[g_cnt].bamt5 
               LET l_tot17_1 = l_tot17_1 + g_alz_1[g_cnt].bamt6 
               LET l_tot18_1 = l_tot18_1 + g_alz_1[g_cnt].bamt7 
               LET l_tot19_1 = l_tot19_1 + g_alz_1[g_cnt].bamt8 
               LET l_tot20_1 = l_tot20_1 + g_alz_1[g_cnt].bamt9 
               LET l_tot21_1 = l_tot21_1 + g_alz_1[g_cnt].bamt10 
               LET l_tot22_1 = l_tot22_1 + g_alz_1[g_cnt].bamt11 
               LET l_tot23_1 = l_tot23_1 + g_alz_1[g_cnt].bamt12 
               LET l_tot24_1 = l_tot24_1 + g_alz_1[g_cnt].bamt13 
               LET l_tot25_1 = l_tot25_1 + g_alz_1[g_cnt].bamt14 
               LET l_tot26_1 = l_tot26_1 + g_alz_1[g_cnt].bamt15 
               LET l_tot27_1 = l_tot27_1 + g_alz_1[g_cnt].bamt16 
               LET l_tot28_1 = l_tot28_1 + g_alz_1[g_cnt].bamt17 
            END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
       WHEN '3'
        IF tm.org = 'Y' THEN
        LET g_sql = "SELECT '','','','',apa21,'','','',apa13,SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        ELSE
        LET g_sql = "SELECT '','','','',apa21,'','','','',SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        END IF
        LET g_sql = g_sql CLIPPED,"   SUM(apa34),SUM(apa35),SUM(amt_2),SUM(sum2),SUM(sum4),SUM(num01),SUM(num1),SUM(num02),",
                    "       SUM(num2),SUM(num03),SUM(num3),SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),",
                    "       SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),SUM(num09),SUM(num9),SUM(num010),",
                    "       SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
                    "       SUM(num014),SUM(num14),SUM(num015),SUM(num15), ",
                    "       SUM(num016),SUM(num16),SUM(num017),SUM(num17),0,apa06,apa07,pmy01,'' ",
                   # "  FROM aapq191_tmp ", #FUN-CB0146 mark
                   "  FROM q191_tmp ", #FUN-CB0146
                    "  WHERE ",g_filter_wc CLIPPED 
         IF tm.d = 'Y' THEN LET g_sql = g_sql CLIPPED," AND  apa13 = '",p_apa13,"' " END IF
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa21,apa13,apa06,apa07,pmy01 ",   
                        " ORDER BY apa21,apa13,apa06,apa07,pmy01 "   
         ELSE
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa21,apa06,apa07,pmy01 ",   
                        " ORDER BY apa21,apa06,apa07,pmy01 "   
         END IF

         PREPARE q191_pb3 FROM g_sql
         DECLARE q191_curs3 CURSOR FOR q191_pb3
         FOREACH q191_curs3 INTO g_alz_1[g_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF

            SELECT gen02 INTO g_alz_1[g_cnt].gen02 FROM gen_file WHERE gen01 = g_alz_1[g_cnt].apa21
            SELECT pmy02 INTO g_alz_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_alz_1[g_cnt].pmy01
    
            IF tm.d = 'N' THEN
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4
            END IF

            IF tm.d = 'Y' THEN 
               LET l_tot1 = l_tot1 + g_alz_1[g_cnt].apa34f
               LET l_tot2 = l_tot2 + g_alz_1[g_cnt].apa35f
               LET l_tot3 = l_tot3 + g_alz_1[g_cnt].amt_1 
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35f
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot7 = l_tot7 + g_alz_1[g_cnt].sum1 
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2 
               LET l_tot9 = l_tot9 + g_alz_1[g_cnt].sum3 
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4 
               LET l_tot12 = l_tot12 + g_alz_1[g_cnt].amt1 
               LET l_tot13 = l_tot13 + g_alz_1[g_cnt].amt2 
               LET l_tot14 = l_tot14 + g_alz_1[g_cnt].amt3       
               LET l_tot15 = l_tot15 + g_alz_1[g_cnt].amt4 
               LET l_tot16 = l_tot16 + g_alz_1[g_cnt].amt5 
               LET l_tot17 = l_tot17 + g_alz_1[g_cnt].amt6 
               LET l_tot18 = l_tot18 + g_alz_1[g_cnt].amt7 
               LET l_tot19 = l_tot19 + g_alz_1[g_cnt].amt8 
               LET l_tot20 = l_tot20 + g_alz_1[g_cnt].amt9 
               LET l_tot21 = l_tot21 + g_alz_1[g_cnt].amt10 
               LET l_tot22 = l_tot22 + g_alz_1[g_cnt].amt11 
               LET l_tot23 = l_tot23 + g_alz_1[g_cnt].amt12 
               LET l_tot24 = l_tot24 + g_alz_1[g_cnt].amt13 
               LET l_tot25 = l_tot25 + g_alz_1[g_cnt].amt14 
               LET l_tot26 = l_tot26 + g_alz_1[g_cnt].amt15 
               LET l_tot27 = l_tot27 + g_alz_1[g_cnt].amt16 
               LET l_tot28 = l_tot28 + g_alz_1[g_cnt].amt17 
               LET l_tot12_1 = l_tot12_1 + g_alz_1[g_cnt].bamt1 
               LET l_tot13_1 = l_tot13_1 + g_alz_1[g_cnt].bamt2 
               LET l_tot14_1 = l_tot14_1 + g_alz_1[g_cnt].bamt3 
               LET l_tot15_1 = l_tot15_1 + g_alz_1[g_cnt].bamt4 
               LET l_tot16_1 = l_tot16_1 + g_alz_1[g_cnt].bamt5 
               LET l_tot17_1 = l_tot17_1 + g_alz_1[g_cnt].bamt6 
               LET l_tot18_1 = l_tot18_1 + g_alz_1[g_cnt].bamt7 
               LET l_tot19_1 = l_tot19_1 + g_alz_1[g_cnt].bamt8 
               LET l_tot20_1 = l_tot20_1 + g_alz_1[g_cnt].bamt9 
               LET l_tot21_1 = l_tot21_1 + g_alz_1[g_cnt].bamt10 
               LET l_tot22_1 = l_tot22_1 + g_alz_1[g_cnt].bamt11 
               LET l_tot23_1 = l_tot23_1 + g_alz_1[g_cnt].bamt12 
               LET l_tot24_1 = l_tot24_1 + g_alz_1[g_cnt].bamt13 
               LET l_tot25_1 = l_tot25_1 + g_alz_1[g_cnt].bamt14 
               LET l_tot26_1 = l_tot26_1 + g_alz_1[g_cnt].bamt15 
               LET l_tot27_1 = l_tot27_1 + g_alz_1[g_cnt].bamt16 
               LET l_tot28_1 = l_tot28_1 + g_alz_1[g_cnt].bamt17 
            END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
       WHEN '4'
        IF tm.org = 'Y' THEN
        LET g_sql = "SELECT apa05,'','','','','',apa54,'',apa13,SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        ELSE
        LET g_sql = "SELECT apa05,'','','','','',apa54,'','',SUM(apa34f),SUM(apa35f),SUM(amt_1),SUM(sum1),SUM(sum3),"
        END IF
        LET g_sql = g_sql CLIPPED,"  SUM(apa34),SUM(apa35),SUM(amt_2),SUM(sum2),SUM(sum4),SUM(num01),SUM(num1),SUM(num02),",
                    "       SUM(num2),SUM(num03),SUM(num3),SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),",
                    "       SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),SUM(num09),SUM(num9),SUM(num010),",
                    "       SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
                    "       SUM(num014),SUM(num14),SUM(num015),SUM(num15), ",
                    "       SUM(num016),SUM(num16),SUM(num017),SUM(num17),0,apa06,apa07,pmy01,'' ",
                    #"  FROM aapq191_tmp ", #FUN-CB0146 mark
                    "  FROM q191_tmp ", #FUN-CB0146
                    "  WHERE ",g_filter_wc CLIPPED 
         IF tm.d = 'Y' THEN LET g_sql = g_sql CLIPPED," AND  apa13 = '",p_apa13,"' " END IF
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa05,apa54,apa13,apa06,apa07,pmy01 ",   
                        " ORDER BY apa05,apa54,apa13,apa06,apa07,pmy01 "   
         ELSE
            LET g_sql = g_sql CLIPPED,         
                        " GROUP BY apa05,apa54,apa06,apa07,pmy01 ",   
                        " ORDER BY apa05,apa54,apa06,apa07,pmy01 "   
         END IF

         PREPARE q191_pb4 FROM g_sql
         DECLARE q191_curs4 CURSOR FOR q191_pb4
         FOREACH q191_curs4 INTO g_alz_1[g_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF

            SELECT pmc03 INTO g_alz_1[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_alz_1[g_cnt].apa05
            SELECT aag02 INTO g_alz_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_alz_1[g_cnt].apa54
            SELECT pmy02 INTO g_alz_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_alz_1[g_cnt].pmy01
    
            IF tm.d = 'N' THEN
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4
            END IF

            IF tm.d = 'Y' THEN 
               LET l_tot1 = l_tot1 + g_alz_1[g_cnt].apa34f
               LET l_tot2 = l_tot2 + g_alz_1[g_cnt].apa35f
               LET l_tot3 = l_tot3 + g_alz_1[g_cnt].amt_1 
               LET l_tot4 = l_tot4 + g_alz_1[g_cnt].apa34
               LET l_tot5 = l_tot5 + g_alz_1[g_cnt].apa35
               LET l_tot6 = l_tot6 + g_alz_1[g_cnt].amt_2
               LET l_tot7 = l_tot7 + g_alz_1[g_cnt].sum1 
               LET l_tot8 = l_tot8 + g_alz_1[g_cnt].sum2 
               LET l_tot9 = l_tot9 + g_alz_1[g_cnt].sum3 
               LET l_tot10 = l_tot10 + g_alz_1[g_cnt].sum4 
               LET l_tot12 = l_tot12 + g_alz_1[g_cnt].amt1 
               LET l_tot13 = l_tot13 + g_alz_1[g_cnt].amt2 
               LET l_tot14 = l_tot14 + g_alz_1[g_cnt].amt3       
               LET l_tot15 = l_tot15 + g_alz_1[g_cnt].amt4 
               LET l_tot16 = l_tot16 + g_alz_1[g_cnt].amt5 
               LET l_tot17 = l_tot17 + g_alz_1[g_cnt].amt6 
               LET l_tot18 = l_tot18 + g_alz_1[g_cnt].amt7 
               LET l_tot19 = l_tot19 + g_alz_1[g_cnt].amt8 
               LET l_tot20 = l_tot20 + g_alz_1[g_cnt].amt9 
               LET l_tot21 = l_tot21 + g_alz_1[g_cnt].amt10 
               LET l_tot22 = l_tot22 + g_alz_1[g_cnt].amt11 
               LET l_tot23 = l_tot23 + g_alz_1[g_cnt].amt12 
               LET l_tot24 = l_tot24 + g_alz_1[g_cnt].amt13 
               LET l_tot25 = l_tot25 + g_alz_1[g_cnt].amt14 
               LET l_tot26 = l_tot26 + g_alz_1[g_cnt].amt15 
               LET l_tot27 = l_tot27 + g_alz_1[g_cnt].amt16 
               LET l_tot28 = l_tot28 + g_alz_1[g_cnt].amt17 
               LET l_tot12_1 = l_tot12_1 + g_alz_1[g_cnt].bamt1 
               LET l_tot13_1 = l_tot13_1 + g_alz_1[g_cnt].bamt2 
               LET l_tot14_1 = l_tot14_1 + g_alz_1[g_cnt].bamt3 
               LET l_tot15_1 = l_tot15_1 + g_alz_1[g_cnt].bamt4 
               LET l_tot16_1 = l_tot16_1 + g_alz_1[g_cnt].bamt5 
               LET l_tot17_1 = l_tot17_1 + g_alz_1[g_cnt].bamt6 
               LET l_tot18_1 = l_tot18_1 + g_alz_1[g_cnt].bamt7 
               LET l_tot19_1 = l_tot19_1 + g_alz_1[g_cnt].bamt8 
               LET l_tot20_1 = l_tot20_1 + g_alz_1[g_cnt].bamt9 
               LET l_tot21_1 = l_tot21_1 + g_alz_1[g_cnt].bamt10 
               LET l_tot22_1 = l_tot22_1 + g_alz_1[g_cnt].bamt11 
               LET l_tot23_1 = l_tot23_1 + g_alz_1[g_cnt].bamt12 
               LET l_tot24_1 = l_tot24_1 + g_alz_1[g_cnt].bamt13 
               LET l_tot25_1 = l_tot25_1 + g_alz_1[g_cnt].bamt14 
               LET l_tot26_1 = l_tot26_1 + g_alz_1[g_cnt].bamt15 
               LET l_tot27_1 = l_tot27_1 + g_alz_1[g_cnt].bamt16 
               LET l_tot28_1 = l_tot28_1 + g_alz_1[g_cnt].bamt17 
            END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
    END CASE
    IF tm.d = 'N' THEN
       DISPLAY l_tot4  TO FORMONLY.apa34_tot
       DISPLAY l_tot5  TO FORMONLY.apa35_tot
       DISPLAY l_tot6  TO FORMONLY.apa34_apa35_tot
       DISPLAY l_tot8  TO FORMONLY.sum_2_tot
       DISPLAY l_tot10  TO FORMONLY.sum_4_tot
    END IF
    IF tm.d = 'Y' THEN 
       LET g_alz_1[g_cnt].apa13 = cl_getmsg('amr-003',g_lang)
        IF tm.d = 'Y' THEN 
           LET g_alz_1[g_cnt].apa34f = l_tot1
           LET g_alz_1[g_cnt].apa35f = l_tot2
           LET g_alz_1[g_cnt].amt_1 = l_tot3
           LET g_alz_1[g_cnt].apa34 = l_tot4
           LET g_alz_1[g_cnt].apa35 = l_tot5
           LET g_alz_1[g_cnt].amt_2 = l_tot6
           LET g_alz_1[g_cnt].sum1 = l_tot7
           LET g_alz_1[g_cnt].sum2 = l_tot8
           LET g_alz_1[g_cnt].sum3 = l_tot9
           LET g_alz_1[g_cnt].sum4 = l_tot10 
           LET g_alz_1[g_cnt].sum5 = l_tot11 
           LET g_alz_1[g_cnt].amt1 = l_tot12 
           LET g_alz_1[g_cnt].amt2 = l_tot13 
           LET g_alz_1[g_cnt].amt3 = l_tot14
           LET g_alz_1[g_cnt].amt4 = l_tot15
           LET g_alz_1[g_cnt].amt5 = l_tot16
           LET g_alz_1[g_cnt].amt6 = l_tot17  
           LET g_alz_1[g_cnt].amt7 = l_tot18
           LET g_alz_1[g_cnt].amt8 = l_tot19
           LET g_alz_1[g_cnt].amt9 = l_tot20
           LET g_alz_1[g_cnt].amt10 = l_tot21
           LET g_alz_1[g_cnt].amt11 = l_tot22
           LET g_alz_1[g_cnt].amt12 = l_tot23
           LET g_alz_1[g_cnt].amt13 = l_tot24
           LET g_alz_1[g_cnt].amt14 = l_tot25
           LET g_alz_1[g_cnt].amt15 = l_tot26
           LET g_alz_1[g_cnt].amt16 = l_tot27
           LET g_alz_1[g_cnt].amt17 = l_tot28
           LET g_alz_1[g_cnt].bamt1 = l_tot12
           LET g_alz_1[g_cnt].bamt2 = l_tot13
           LET g_alz_1[g_cnt].bamt3 = l_tot14
           LET g_alz_1[g_cnt].bamt4 = l_tot15
           LET g_alz_1[g_cnt].bamt5 = l_tot16
           LET g_alz_1[g_cnt].bamt6 = l_tot17
           LET g_alz_1[g_cnt].bamt7 = l_tot18
           LET g_alz_1[g_cnt].bamt8 = l_tot19
           LET g_alz_1[g_cnt].bamt9 = l_tot20
           LET g_alz_1[g_cnt].bamt10 = l_tot21
           LET g_alz_1[g_cnt].bamt11 = l_tot22
           LET g_alz_1[g_cnt].bamt12 = l_tot23
           LET g_alz_1[g_cnt].bamt13 = l_tot24
           LET g_alz_1[g_cnt].bamt14 = l_tot25
           LET g_alz_1[g_cnt].bamt15 = l_tot26
           LET g_alz_1[g_cnt].bamt16 = l_tot27
           LET g_alz_1[g_cnt].bamt17 = l_tot28
        END IF
    END IF      
    DISPLAY ARRAY g_alz_1 TO s_alz_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY
    IF tm.d != 'Y' THEN   
       CALL g_alz_1.deleteElement(g_cnt)
       LET g_rec_b2 = g_cnt - 1
    ELSE
       LET g_rec_b2 = g_cnt 
    END IF
    DISPLAY g_rec_b2 TO FORMONLY.cnt1
END FUNCTION 

#FUN-C80102--add--end---

#FUN-C80102-----mark---srt----
#FUNCTION q191_b_fill()                     #BODY FILL UP\
#DEFINE l_apa06 LIKE apa_file.apa06
#DEFINE l_total LIKE type_file.num20_6

#  #--TQC-C30349--mod--str--  #增加按原幣列印的判斷
#  IF tm.detail = 'Y' THEN
#     IF tm.org = 'Y' THEN 
#        LET g_sql = "SELECT apa06,apa07,apa01,apa02,apa13,num01,num1,num02,num2,num03,num3,",
#                    " num04,num4,num05,num5,num06,num6,num07,num7,num08,num8,",
#                    " num09,num9,num010,num10,num011,num11,num012,num12,num013,num13,",
#                    " num014,num14,num015,num15,num016,num16,num017,num17,0",
#                    " FROM aapq191_tmp ",
#                    " ORDER BY apa06,apa07"
#     ELSE
#        LET g_sql = "SELECT apa06,apa07,apa01,apa02,'',num01,num1,num02,num2,num03,num3,",
#                    " num04,num4,num05,num5,num06,num6,num07,num7,num08,num8,",
#                    " num09,num9,num010,num10,num011,num11,num012,num12,num013,num13,",
#                    " num014,num14,num015,num15,num016,num16,num017,num17,0",
#                    " FROM aapq191_tmp ",
#                    " ORDER BY apa06,apa07"
#     END IF  
#  ELSE
#     IF tm.org = 'Y' THEN 
#        LET g_sql = "SELECT apa06,apa07,'','',apa13,SUM(num01),SUM(num1),SUM(num02),SUM(num2),SUM(num03),SUM(num3),",
#                    " SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),",
#                    " SUM(num09),SUM(num9),SUM(num010),SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
#                    " SUM(num014),SUM(num14),SUM(num015),SUM(num15),SUM(num016),SUM(num16),SUM(num017),SUM(num17),0",
#                    " FROM aapq191_tmp ",
#                    " GROUP BY apa06,apa07,apa13",
#                    " ORDER BY apa06,apa07,apa13"
#     ELSE
#        LET g_sql = "SELECT apa06,apa07,'','','',SUM(num01),SUM(num1),SUM(num02),SUM(num2),SUM(num03),SUM(num3),",
#                    " SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),",
#                    " SUM(num09),SUM(num9),SUM(num010),SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),",
#                    " SUM(num014),SUM(num14),SUM(num015),SUM(num15),SUM(num016),SUM(num16),SUM(num017),SUM(num17),0",
#                    " FROM aapq191_tmp ",
#                    " GROUP BY apa06,apa07",
#                    " ORDER BY apa06,apa07"
#     END IF 
#  END IF                                                          
#  #--TQC-C30349--mod--end--                                                        
#
#  PREPARE aapq191_pb FROM g_sql
#  DECLARE alz_curs  CURSOR FOR aapq191_pb        #CURSOR
#
#  CALL g_alz.clear()
#  LET g_cnt = 1
#  LET g_rec_b = 0
#  LET l_total = 0
#  FOREACH alz_curs INTO g_alz[g_cnt].*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     IF g_cnt > 1 AND tm.detail = 'Y'  THEN 
#        IF g_alz[g_cnt].apa06 = l_apa06 THEN
#           LET g_alz[g_cnt].apa06=''
#           LET g_alz[g_cnt].pmc03=''
#        ELSE
#        	  LET l_apa06 = g_alz[g_cnt].apa06
#        END IF
#     ELSE
#     	 LET l_apa06 = g_alz[g_cnt].apa06 
#     END IF 
#     LET g_alz[g_cnt].sum = 0
#     LET g_alz[g_cnt].sum = g_alz[g_cnt].amt1+g_alz[g_cnt].amt2+g_alz[g_cnt].amt3+g_alz[g_cnt].amt4+
#                            g_alz[g_cnt].amt5+g_alz[g_cnt].amt6+g_alz[g_cnt].amt7+g_alz[g_cnt].amt8+
#                            g_alz[g_cnt].amt9+g_alz[g_cnt].amt10+g_alz[g_cnt].amt11+g_alz[g_cnt].amt12+
#                            g_alz[g_cnt].amt13+g_alz[g_cnt].amt14+g_alz[g_cnt].amt15+g_alz[g_cnt].amt16+
#                            g_alz[g_cnt].amt17
#     LET l_total = l_total + g_alz[g_cnt].sum
#     LET g_cnt = g_cnt + 1
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#     EXIT FOREACH
#     END IF
#  END FOREACH
#  IF g_cnt - 1 > 0 THEN
#     SELECT '','','','',SUM(num01),SUM(num1),SUM(num02),SUM(num2),SUM(num03),SUM(num3),
#            SUM(num04),SUM(num4),SUM(num05),SUM(num5),SUM(num06),SUM(num6),SUM(num07),SUM(num7),SUM(num08),SUM(num8),
#            SUM(num09),SUM(num9),SUM(num010),SUM(num10),SUM(num011),SUM(num11),SUM(num012),SUM(num12),SUM(num013),SUM(num13),
#            SUM(num014),SUM(num14),SUM(num015),SUM(num15),SUM(num016),SUM(num16),SUM(num017),SUM(num17),SUM(num)
#       INTO g_alz[g_cnt].*
#       FROM aapq191_tmp
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#     END IF
#     LET g_alz[g_cnt].sum = l_total
#     #--TQC-C30349--mod--str--  #增加按原幣列印的判斷
#     IF tm.detail = 'Y' THEN
#        IF tm.org = 'Y' THEN
#           LET g_alz[g_cnt].apa13 = cl_getmsg('axr107',g_lang)
#        ELSE
#           LET g_alz[g_cnt].apa01 = cl_getmsg('axr107',g_lang)
#        END IF 
#     ELSE
#        IF tm.org = 'Y' THEN
#           LET g_alz[g_cnt].apa13 = cl_getmsg('axr107',g_lang)
#        ELSE
#           LET g_alz[g_cnt].pmc03 = cl_getmsg('axr107',g_lang)
#        END IF   
#     END IF
#     #--TQC-C30349--mod--end-- 
#  END IF
#  LET g_rec_b = g_cnt
#  DISPLAY g_rec_b TO FORMONLY.cnt
#END FUNCTION

FUNCTION q191_out()
   DEFINE l_cmd        LIKE type_file.chr1000, 
         #l_wc         LIKE type_file.chr1000   #MOD-G10097 mark
          l_wc         STRING                   #MOD-G10097 add 

   CALL cl_wait()
   IF tm.wc IS NULL THEN CALL cl_err('','9057',0) END IF       
   LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
   LET l_cmd = "aapr191",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' ",
               " '",tm.wc CLIPPED,"'",
               " '",tm.aly01 CLIPPED,"'",
               " '",tm.a CLIPPED,"'",
               " '",tm.edate CLIPPED,"'",
               " '",tm.detail CLIPPED,"'",
               " '",tm.zr CLIPPED,"'",
               " '",tm.org CLIPPED,"'"    #TQC-C30349  add
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION

#FUN-C80102--add--str--
FUNCTION q191_set_title_1()
   DEFINE   l_i2,i         LIKE type_file.num5
   DEFINE   l_aly          RECORD LIKE aly_file.*
   DEFINE   l_sql          STRING
   DEFINE   l_msg,l_msg1   STRING
   DEFINE   l_zl,l_zl1     STRING
   DEFINE   l_til,l_til1   STRING

   LET l_i2 = 1
   LET l_msg  = cl_getmsg('axr108',g_lang)
   LET l_msg1 = cl_getmsg('axr109',g_lang)
   LET l_sql = "SELECT * FROM aly_file WHERE aly01 = '",tm.aly01,"'",
               " ORDER BY aly02"
   PREPARE q191_prepare FROM l_sql
   DECLARE q191_curs CURSOR FOR q191_prepare
   FOREACH q191_curs INTO l_aly.*
     #LET l_zl  = l_aly.aly03 USING '<<&','-',l_aly.aly04 USING '<<<',l_msg         #MOD-G10179 mark
     #LET l_zl1 = l_aly.aly03 USING '<<&','-',l_aly.aly04 USING '<<<',l_msg1        #MOD-G10179 mark
      LET l_zl  = l_aly.aly03 USING '<<<<<&','-',l_aly.aly04 USING '<<<<<',l_msg    #MOD-G10179 add 
      LET l_zl1 = l_aly.aly03 USING '<<<<<&','-',l_aly.aly04 USING '<<<<<',l_msg1   #MOD-G10179 add
      LET l_til= "amt",l_i2 USING "<<<<<<","_1"
      LET l_til1= "bamt",l_i2 USING "<<<<<<","_1"
      CALL cl_set_comp_visible(l_til,TRUE)
      CALL cl_set_comp_visible(l_til1,TRUE)
      CALL cl_set_comp_att_text(l_til,l_zl CLIPPED)
      CALL cl_set_comp_att_text(l_til1,l_zl1 CLIPPED)
      LET l_i2 = l_i2 + 1
   END FOREACH
   IF l_i2 > 1 THEN
     #LET l_zl  = '>',l_aly.aly04 USING '<<<',l_msg      #MOD-G10179 mark
     #LET l_zl1 = '>',l_aly.aly04 USING '<<<',l_msg1     #MOD-G10179 mark
      LET l_zl  = '>',l_aly.aly04 USING '<<<<<',l_msg    #MOD-G10179 add 
      LET l_zl1 = '>',l_aly.aly04 USING '<<<<<',l_msg1   #MOD-G10179 add
      LET l_til= "amt17_1"
      LET l_til1= "bamt17_1"
      CALL cl_set_comp_visible(l_til,TRUE)
      CALL cl_set_comp_visible(l_til1,TRUE)
      CALL cl_set_comp_att_text(l_til,l_zl CLIPPED)
      CALL cl_set_comp_att_text(l_til1,l_zl1 CLIPPED)
      IF l_i2 < 17 THEN
         FOR i = l_i2 TO 16
            LET l_til= "amt",i USING "<<<<<<","_1"
            LET l_til1= "bamt",i USING "<<<<<<","_1"
            CALL cl_set_comp_visible(l_til,FALSE)
            CALL cl_set_comp_visible(l_til1,FALSE)
         END FOR
      END IF 
   END IF
END FUNCTION

FUNCTION q191_set_title()
   DEFINE   l_i2,i         LIKE type_file.num5 
   DEFINE   l_aly          RECORD LIKE aly_file.*
   DEFINE   l_sql          STRING
   DEFINE   l_msg,l_msg1   STRING
   DEFINE   l_zl,l_zl1     STRING
   DEFINE   l_til,l_til1   STRING

   LET l_i2 = 1 
   LET l_msg  = cl_getmsg('axr108',g_lang) 
   LET l_msg1 = cl_getmsg('axr109',g_lang) 
   LET l_sql = "SELECT * FROM aly_file WHERE aly01 = '",tm.aly01,"'",
               " ORDER BY aly02"      
   PREPARE q191_prepare_1 FROM l_sql
   DECLARE q191_curs_1 CURSOR FOR q191_prepare_1
   FOREACH q191_curs_1 INTO l_aly.*
     #LET l_zl  = l_aly.aly03 USING '<<&','-',l_aly.aly04 USING '<<<',l_msg         #MOD-G10179 mark
     #LET l_zl1 = l_aly.aly03 USING '<<&','-',l_aly.aly04 USING '<<<',l_msg1        #MOD-G10179 mark
      LET l_zl  = l_aly.aly03 USING '<<<<<&','-',l_aly.aly04 USING '<<<<<',l_msg    #MOD-G10179 add 
      LET l_zl1 = l_aly.aly03 USING '<<<<<&','-',l_aly.aly04 USING '<<<<<',l_msg1   #MOD-G10179 add
      LET l_til= "amt",l_i2 USING "<<<<<<"
      LET l_til1= "bamt",l_i2 USING "<<<<<<"
      CALL cl_set_comp_visible(l_til,TRUE)
      CALL cl_set_comp_visible(l_til1,TRUE)
      CALL cl_set_comp_att_text(l_til,l_zl CLIPPED)
      CALL cl_set_comp_att_text(l_til1,l_zl1 CLIPPED)
      LET l_i2 = l_i2 + 1
   END FOREACH
   IF l_i2 > 1 THEN
     #LET l_zl  = '>',l_aly.aly04 USING '<<<',l_msg      #MOD-G10179 mark
     #LET l_zl1 = '>',l_aly.aly04 USING '<<<',l_msg1     #MOD-G10179 mark
      LET l_zl  = '>',l_aly.aly04 USING '<<<<<',l_msg    #MOD-G10179 add 
      LET l_zl1 = '>',l_aly.aly04 USING '<<<<<',l_msg1   #MOD-G10179 add
      LET l_til= "amt17"  
      LET l_til1= "bamt17"
      CALL cl_set_comp_visible(l_til,TRUE)
      CALL cl_set_comp_visible(l_til1,TRUE)
      CALL cl_set_comp_att_text(l_til,l_zl CLIPPED)
      CALL cl_set_comp_att_text(l_til1,l_zl1 CLIPPED)
      IF l_i2 < 17 THEN
         FOR i = l_i2 TO 16
            LET l_til= "amt",i USING "<<<<<<"
            LET l_til1= "bamt",i USING "<<<<<<"
            CALL cl_set_comp_visible(l_til,FALSE)
            CALL cl_set_comp_visible(l_til1,FALSE)
         END FOR
      END IF   
   END IF
END FUNCTION
#FUN-C80102--add--end--

FUNCTION q191_table()
   DROP TABLE aapq191_tmp;
   CREATE TEMP TABLE aapq191_tmp(
    apa06 LIKE apa_file.apa06,
    apa07 LIKE apa_file.apa07,
    apa34f  LIKE apa_file.apa34f,
    apa35f  LIKE apa_file.apa35f,
    apa13 LIKE apa_file.apa13,
    apa14 LIKE apa_file.apa14,
    amt_1 LIKE type_file.num5,
    sum1  LIKE alz_file.alz09,
    sum3  LIKE alz_file.alz09,
    apa34 LIKE apa_file.apa34,
    apa35 LIKE apa_file.apa35,
    amt_2 LIKE type_file.num5,              
    sum2  LIKE alz_file.alz09,               
    sum4  LIKE alz_file.alz09, 
    num01 LIKE alz_file.alz09,
    num02 LIKE alz_file.alz09,
    num03 LIKE alz_file.alz09,
    num04 LIKE alz_file.alz09,
    num05 LIKE alz_file.alz09,
    num06 LIKE alz_file.alz09,
    num07 LIKE alz_file.alz09,
    num08 LIKE alz_file.alz09,
    num09 LIKE alz_file.alz09,
    num010 LIKE alz_file.alz09,
    num011 LIKE alz_file.alz09,
    num012 LIKE alz_file.alz09,
    num013 LIKE alz_file.alz09,
    num014 LIKE alz_file.alz09,
    num015 LIKE alz_file.alz09,
    num016 LIKE alz_file.alz09,
    num017 LIKE alz_file.alz09,
    num1 LIKE alz_file.alz09,
    num2 LIKE alz_file.alz09,
    num3 LIKE alz_file.alz09,
    num4 LIKE alz_file.alz09,
    num5 LIKE alz_file.alz09,
    num6 LIKE alz_file.alz09,
    num7 LIKE alz_file.alz09,
    num8 LIKE alz_file.alz09,
    num9 LIKE alz_file.alz09,
    num10 LIKE alz_file.alz09,
    num11 LIKE alz_file.alz09,
    num12 LIKE alz_file.alz09,
    num13 LIKE alz_file.alz09,
    num14 LIKE alz_file.alz09,
    num15 LIKE alz_file.alz09,
    num16 LIKE alz_file.alz09,
    num17 LIKE alz_file.alz09,
    sum5  LIKE alz_file.alz09,
    apa15 LIKE apa_file.apa15,
    apa16 LIKE apa_file.apa16,
    net1  LIKE type_file.num5,
    net2  LIKE type_file.num5,
    apa21 LIKE apa_file.apa21,
    gen02 LIKE gen_file.gen02,
    apa22 LIKE apa_file.apa22,
    gem02 LIKE gem_file.gem02,
    apa08 LIKE apa_file.apa08,
    apa00 LIKE apa_file.apa00,
    apa01 LIKE apa_file.apa01,
    apa02 LIKE apa_file.apa02,
    alz12 LIKE alz_file.alz12,
    alz07 LIKE alz_file.alz07,
    apa11 LIKE apa_file.apa11,
    pma02 LIKE pma_file.pma02,
    apa36 LIKE apa_file.apa36,
    apr02 LIKE apr_file.apr02,
    apa44 LIKE apa_file.apa44,         
    apa54 LIKE apa_file.apa54,
    aag02 LIKE aag_file.aag02,      
    apa05 LIKE apa_file.apa05,  
    pmc03 LIKE pmc_file.pmc03, 
    pmy01 LIKE pmy_file.pmy01,
    pmy02 LIKE pmy_file.pmy02,
    apa41 LIKE apa_file.apa41   
   );
END FUNCTION 

#栏位输入管控
FUNCTION q191_chk_datas()
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      LET g_field = "apa22"
      RETURN FALSE  
   END IF
   IF tm.aly01 IS NULL THEN
      CALL cl_err('','aap1001',0)
      LET g_field = "aly01"
      RETURN FALSE
   END IF
   IF tm.edate IS NULL THEN
      CALL cl_err('','aap1000',0)
      LET g_field = "edate" 
      RETURN FALSE 
   END IF
   #IF MONTH(tm.edate) = MONTH(tm.edate+1) THEN   #FUN-D70118 mark
   IF s_get_aznn(g_plant,g_bookno1,tm.edate,3) = s_get_aznn(g_plant,g_bookno1,tm.edate+1,3) THEN   #FUN-D70118 add
      CALL cl_err('','aap-993',1)
      LET g_field = "edate" 
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION

FUNCTION q191_get_datas()
   DEFINE l_i      LIKE type_file.num5
   DEFINE l_gae04_1,l_gae04_2  LIKE gae_file.gae04
   DEFINE l_field1,l_field2    STRING
   DEFINE l_str1,l_str2        STRING
   DEFINE l_aly04  LIKE aly_file.aly04
   CALL cl_set_comp_visible("amt1,amt2,amt3,amt4,amt5,amt6,amt7,amt8,
                             amt9,amt10,amt11,amt12,amt13,amt14,amt15,
                             amt16,amt17",FALSE) 
   CALL cl_set_comp_visible("bamt1,bamt2,bamt3,bamt4,bamt5,bamt6,bamt7,bamt8,
                             bamt9,bamt10,bamt11,bamt12,bamt13,bamt14,bamt15,
                             bamt16,bamt17",FALSE) 
   #抓取字段名稱
   SELECT gae04 INTO l_gae04_1 FROM gae_file
    WHERE gae01 = 'aapq191' AND gae12 = 'std'
      AND gae02 = 'amt1' AND gae03 = g_lang
   SELECT gae04 INTO l_gae04_2 FROM gae_file
    WHERE gae01 = 'aapq191' AND gae12 = 'std'
      AND gae02 = 'bamt1' AND gae03 = g_lang
   #根據賬齡類型抓取賬齡資料
   LET l_i = 1 
   LET g_sql = "SELECT * FROM aly_file WHERE aly01='",tm.aly01,"' ORDER BY aly02"
   PREPARE aly_prepare FROM g_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('aly_prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL g_aly.clear()
   INITIALIZE g_aly[16].* TO NULL
   DECLARE aly_curs1 CURSOR FOR aly_prepare
   FOREACH aly_curs1 INTO g_aly[l_i].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_aly[l_i].aly05 IS NULL THEN
         LET g_aly[l_i].aly05=100
      END IF 
      LET l_field1 = "amt",l_i USING "<<"
      LET l_field2 = "bamt",l_i USING "<<"
      CALL cl_set_comp_visible(l_field1,TRUE)
      CALL cl_set_comp_visible(l_field2,TRUE)
     #LET l_str1 = g_aly[l_i].aly03 USING "<<&",'-',g_aly[l_i].aly04 USING "<<&",l_gae04_1         #MOD-G10179 mark
      LET l_str1 = g_aly[l_i].aly03 USING "<<<<<&",'-',g_aly[l_i].aly04 USING "<<<<<&",l_gae04_1   #MOD-G10179 add
      CALL cl_set_comp_att_text(l_field1,l_str1)
     #LET l_str2 = g_aly[l_i].aly03 USING "<<&",'-',g_aly[l_i].aly04 USING "<<&",l_gae04_2         #MOD-G10179 mark
      LET l_str2 = g_aly[l_i].aly03 USING "<<<<<&",'-',g_aly[l_i].aly04 USING "<<<<<&",l_gae04_2   #MOD-G10179 add
      CALL cl_set_comp_att_text(l_field2,l_str2)
      LET l_i = l_i+1
   END FOREACH  
   LET l_field1 = "amt17"
   LET l_field2 = "bamt17"
   LET l_aly04  = g_aly[l_i-1].aly04+1
   CALL cl_set_comp_visible(l_field1,TRUE)
   CALL cl_set_comp_visible(l_field2,TRUE)
  #LET l_str1 = ">=",l_aly04 USING "<<&",l_gae04_1      #MOD-G10179 mark
   LET l_str1 = ">=",l_aly04 USING "<<<<<&",l_gae04_1   #MOD-G10179 add
   CALL cl_set_comp_att_text(l_field1,l_str1)
  #LET l_str2 = ">=",l_aly04 USING "<<&",l_gae04_2      #MOD-G10179 mark
   LET l_str2 = ">=",l_aly04 USING "<<<<<&",l_gae04_2   #MOD-G10179 add
   CALL cl_set_comp_att_text(l_field2,l_str2)
  #FUN-C80102----mark---str---
  #IF tm.detail = 'Y' THEN
  #   CALL cl_set_comp_visible("apa01,apa02",TRUE)     
  #ELSE
  #   CALL cl_set_comp_visible("apa01,apa02",FALSE)
  #END IF 
  #FUN-C80102----mark---str---
   #--TQC-C30349--add--str--  
   IF tm.org = 'Y' THEN 
      CALL cl_set_comp_visible("apa13",TRUE)
   ELSE
      CALL cl_set_comp_visible("apa13",FALSE)
   END  IF 
   #--TQC-C30349--add--end--   
END FUNCTION 

#FUN-C80102----mark----str---
#FUN-B60129--add--str--
#FUNCTION q191_detail()
#  DEFINE   l_ac1      LIKE type_file.num5 
#  DEFINE   l_cmd      LIKE type_file.chr1000, 
#           l_wc       STRING
#
#  CALL cl_wait()
#  IF tm.wc IS NULL THEN CALL cl_err('','9057',0) END IF
#  LET l_ac1 = 0
#  LET l_ac1 = ARR_CURR()
#  IF l_ac1 < 1 THEN
#     RETURN 
#  ELSE
#     IF cl_null(g_alz[l_ac1].apa06) THEN
#        RETURN
#     END IF   
#     LET l_wc = tm.wc, " AND apa06 = '",g_alz[l_ac1].apa06,"'"
#     LET l_wc = cl_replace_str(l_wc, "'", "\"")
#     LET l_cmd = "aapq191",               
#                 " '",l_wc CLIPPED,"'",
#                 " '",tm.aly01 CLIPPED,"'",
#                 " '",tm.a CLIPPED,"'",
#                 " '",tm.edate CLIPPED,"'",
#                 " 'Y'",
#                 " '",tm.zr CLIPPED,"'"
#     CALL cl_cmdrun(l_cmd)
#  END IF    
#END FUNCTION
##FUN-B60129--add--end--
#FUN-C80102----mark----end---
#FUN-B60071

#FUN-CB0146--add--str--
FUNCTION q191_get_tmp()
  DEFINE l_sql    STRING,
         i        LIKE type_file.num5
   DISPLAY g_time
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   CALL q191_get_datas()
   DELETE FROM q191_tmp;
   

   LET l_sql = "SELECT apa06,apa07,apa34f,apa35f,apa13,apa14, 0,0,0,apa34,apa35, 0,0,0,",
               "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, ",
               "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,",
               "       0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0, ",
               "       0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,",
               "       0,apa15,apa16,1,1,apa21,gen02,apa22,gem02,",
               "       apa08,apa00,apa01,apa02,alz12,alz07,apa11,pma02,",
               "       apa36,apr02,apa44,apa54,'',apa05,'',",
               "       pmy01,pmy02,apa41,alz09,alz09f,alz06,'0' ",                  
               "  FROM apc_file,alz_file,aznn_file,",   #FUN-D70118 add aznn_file
               "       apa_file LEFT OUTER JOIN gem_file ON (gem01=apa22) ",
               "                LEFT OUTER JOIN gen_file ON (gen01=apa21) ",
               "                LEFT OUTER JOIN pma_file ON (apa11=pma01) ",
               "                LEFT OUTER JOIN apr_file ON (apr01=apa36), ",
               "       pmc_file LEFT OUTER JOIN pmy_file ON(pmc_file.pmc02=pmy_file.pmy01)",			
               " WHERE ",tm.wc CLIPPED," AND apa06 = pmc01 AND apa01 = apc01 ",
               #"   AND apa06 = alz01 AND alz00 = '1' AND alz02 = ",YEAR(tm.edate),   #FUN-D70118 mark
               "   AND apa06 = alz01 AND alz00 = '1' AND alz02 = aznn02 ",            #FUN-D70118 add
               #"   AND alz03 = ",MONTH(tm.edate)," AND alz04 = apa01 ",              #FUN-D70118 mark
               "   AND alz03 = aznn04  AND alz04 = apa01 ",                           #FUN-D70118 add
               "   AND alz05 = apc02 ",
               "   AND aznn00 = '",g_bookno1,"'",   #FUN-D70118 add
               "   AND aznn01 = '",tm.edate,"'"     #FUN-D70118 add
   
   #選擇扣除折讓資料            
  #IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<'",tm.edate,"'" END IF    #MOD-G10097 mark
   IF tm.a = '2' THEN  LET l_sql=l_sql CLIPPED," AND alz07<='",tm.edate,"'" END IF   #MOD-G10097 add	
   CASE tm.pay1
      WHEN '1' LET l_sql = l_sql CLIPPED
      WHEN '2' 
         IF tm.b = 'Y' THEN
            LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24','16','26') "
         ELSE
            LET l_sql = l_sql CLIPPED," AND apa00 IN('11','12','15','21','22','23','24') "
         END IF  
      WHEN '3' LET l_sql = l_sql CLIPPED," AND apa00 IN('17','13','25','24')"
   END CASE
 
   LET l_sql = " INSERT INTO q191_tmp ",l_sql CLIPPED 
   PREPARE q191_ins FROM l_sql
   EXECUTE q191_ins 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF

   #供應商簡稱
   LET l_sql = " UPDATE q191_tmp o ",
               "    SET o.pmc03= (SELECT pmc03 FROM pmc_file n",
               "                  WHERE n.pmc01=o.apa05 ) "
   PREPARE q191_pr1 FROM l_sql
   EXECUTE q191_pr1
   #科目名稱
   LET l_sql = " UPDATE q191_tmp o ",
               "    SET aag02= (SELECT UNIQUE aag02 FROM aag_file n ",
               "                WHERE n.aag01=o.apa54) "
   PREPARE q191_pr3 FROM l_sql
   EXECUTE q191_pr3
 
   UPDATE q191_tmp
      SET apa34f=-1*apa34f,apa34=-1*apa34,
          apa35f=-1*apa35f,apa35=-1*apa35
    WHERE apa00[1,1]='2'

   UPDATE q191_tmp
      SET amt_1=apa34f-apa35f,
          amt_2=apa34-apa35
         
   #應付款日匯率      
   SELECT * INTO g_aza.* FROM aza_file WHERE aza01 = '0'
   CASE
      WHEN g_aza.aza19 = '1'            #取每月匯率 
         #net1
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net1=(",
                   "              SELECT azj041 FROM azj_file n,aznn_file ",   #FUN-D70118 add aznn_file
                   "               WHERE n.azj01 = o.apa13 "
         IF tm.a='1' THEN            
            #LET l_sql=l_sql," AND n.azj02= YEAR(o.apa02)||MONTH(o.apa02) )"   #FUN-D70118 mark
            LET l_sql=l_sql," AND n.azj02= aznn02||aznn04 AND aznn01 = o.apa02 AND aznn00 = '",g_bookno1,"')"  #FUN-D70118 add
         ELSE
            #LET l_sql=l_sql," AND n.azj02= YEAR(o.alz12)||MONTH(o.alz12) )"   #FUN-D70118 mark
            LET l_sql=l_sql," AND n.azj02= aznn02||aznn04 AND aznn01 = o.alz12 AND aznn00 = '",g_bookno1,"')"  #FUN-D70118 add
         END IF
         LET l_sql=l_sql," WHERE o.apa13 <> '",g_aza.aza17,"'"
         PREPARE q191_pr4 FROM l_sql
         EXECUTE q191_pr4
         #取不到時, 取最近匯率
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net1=(",
                   "              SELECT azj041 FROM azj_file ",
                   "              WHERE azj01 = o.apa13",
                   "                AND azj02 = (SELECT MAX(azj02) FROM azj_file,aznn_file ",  #FUN-D70118 add aznn_file
                   "                              WHERE azj01 =o.apa13 "
         IF tm.a='1' THEN            
            #LET l_sql=l_sql," AND azj02<= YEAR(o.apa02)||MONTH(o.apa02) )"   #FUN-D70118 mark
            LET l_sql=l_sql," AND azj02<= aznn02||aznn04 AND aznn01 =o.apa02 AND aznn00 = '",g_bookno1,"')"   #FUN-D70118 add
         ELSE
            #LET l_sql=l_sql," `AND azj02<= YEAR(o.alz12)||MONTH(o.alz12) )"  #FUN-D70118 mark
            LET l_sql=l_sql," AND azj02<= aznn02||aznn04 AND aznn01 =o.alz12 AND aznn00 = '",g_bookno1,"')"   #FUN-D70118 add
         END IF           
         LET l_sql=l_sql,"  )",
                         " WHERE o.apa13<>'",g_aza.aza17,"'"
         PREPARE q191_pr5 FROM l_sql
         EXECUTE q191_pr5 
         
         #net2
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net2=(",
                   "              SELECT azj041 FROM azj_file n,apa_file a,aznn_file",   #FUN-D70118 add aznn_file
                   "               WHERE n.azj01 = o.apa13 AND o.apa01=a.apa01 ",
                   #"                 AND n.azj02= YEAR(a.apa64)||MONTH(a.apa64) )",   #FUN-D70118 mark
                   "                 AND n.azj02=  aznn02||aznn04 AND aznn01 = a.apa64 AND aznn00 = '",g_bookno1,"')",  #FUN-D70118 add
                   " WHERE o.apa13 <> '",g_aza.aza17,"'"
         PREPARE q191_pr6 FROM l_sql
         EXECUTE q191_pr6 
         #取不到時, 取最近匯率
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net2=(",
                   "              SELECT azj041 FROM azj_file",
                   "              WHERE azj01 = o.apa13",
                   "                AND azj02 = (SELECT MAX(azj02) FROM azj_file,apa_file a,aznn_file ",  #FUN-D70118 add aznn_file
                   "                              WHERE azj01 =o.apa13 AND o.apa01=a.apa01 ",
                   #"                                AND azj02<= YEAR(a.apa64)||MONTH(a.apa64) )",  #FUN-D70118 mark
                   "                                AND azj02<= aznn02||aznn04 AND aznn01 = a.apa64 AND aznn00 = '",g_bookno1,"')", #FUN-D70118 add
                   "              )",
                   " WHERE o.apa13<>'",g_aza.aza17,"'"
         PREPARE q191_pr7 FROM l_sql
         EXECUTE q191_pr7    
         
      WHEN g_aza.aza19 = '2'            #取每日匯率
         #net1
         LET l_sql="UPDATE q191_tmp o ",
                   "   SET o.net1=( ",
                   "              SELECT azk041 FROM azk_file n ",
                   "               WHERE n.azk01 = o.apa13 "
         IF tm.a='1' THEN            
            LET l_sql=l_sql," AND n.azk02= o.apa02 )"
         ELSE
            LET l_sql=l_sql," AND n.azk02= o.alz12 )"
         END IF
         LET l_sql=l_sql," WHERE o.apa13 <> '",g_aza.aza17,"'"
         PREPARE q191_pr8 FROM l_sql
         EXECUTE q191_pr8 
         #每日取不到時, 取最近匯率
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net1=(",
                   "              SELECT azk041 FROM azk_file",
                   "              WHERE azk01 = o.apa13",
                   "                AND azk02 = (SELECT MAX(azk02) FROM azj_file ",
                   "                              WHERE azk01 =o.apa13 "
         IF tm.a='1' THEN            
            LET l_sql=l_sql," AND azk02<= o.apa02 )"
         ELSE
            LET l_sql=l_sql," AND azk02<= o.alz12 )"
         END IF           
         LET l_sql=l_sql,"  )",
                         " WHERE o.apa13<>'",g_aza.aza17,"'",
                         "   AND o.net1=0 "
         PREPARE q191_pr9 FROM l_sql
         EXECUTE q191_pr9 
         
         #net2
         LET l_sql="UPDATE q191_tmp o ",
                   "   SET o.net2=( ",
                   "              SELECT azk041 FROM azk_file n ,apa_file a",
                   "               WHERE n.azk01 = o.apa13 AND o.apa01=a.apa01",
                   "                 AND n.azk02= a.apa64 )",
                   " WHERE o.apa13 <> '",g_aza.aza17,"'"
         PREPARE q191_pr10 FROM l_sql
         EXECUTE q191_pr10 
         #每日取不到時, 取最近匯率
         LET l_sql="UPDATE q191_tmp o",
                   "   SET o.net2=(",
                   "              SELECT azk041 FROM azk_file",
                   "              WHERE azk01 = o.apa13",
                   "                AND azk02 = (SELECT MAX(azk02) FROM azj_file,apa_file a ",
                   "                              WHERE azk01 =o.apa13 AND o.apa01=a.apa01",
                   "                                AND azk02<= a.apa64 )",         
                   "              )",
                   " WHERE o.apa13<>'",g_aza.aza17,"'"
         PREPARE q191_pr11 FROM l_sql
         EXECUTE q191_pr11 
   END CASE

   LET l_sql = " MERGE INTO q191_tmp o ",
               "      USING (SELECT azi01,azi07 FROM azi_file ",
               "              ) n ",
               "         ON (o.apa13 = n.azi01) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.net1 =ROUND(o.net1,n.azi07),",
               "           o.net2 =ROUND(o.net2,n.azi07) "
   PREPARE q191_pr12 FROM l_sql
   EXECUTE q191_pr12
  
   #期間帳款金額計算
   LET i=1
   IF tm.org = 'Y' THEN
      WHILE NOT cl_null(g_aly[i].aly04)
         LET l_sql="UPDATE q191_tmp SET num0",i USING "<<","=alz09f ,",
                   "                    num", i USING "<<","=alz09f*",g_aly[i].aly05/100,",",
                   "                    l_num0",i USING "<<","=alz09 ,",
                   "                    l_num", i USING "<<","=alz09*",g_aly[i].aly05/100,",",
                   "                    flag='1' "
          IF tm.a='2' THEN
             LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz07 AS DATE)<=",g_aly[i].aly04
          ELSE
             LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz06 AS DATE)<=",g_aly[i].aly04
          END IF
          LET l_sql=l_sql,"   AND flag='0' "
         PREPARE q191_amt_pr1 FROM l_sql
         EXECUTE q191_amt_pr1  
         LET i=i+1    
      END WHILE
      LET l_sql="UPDATE q191_tmp SET num0",i USING "<<","=alz09f ,",
                "                    num", i USING "<<","=alz09f ,",
                "                    l_num0",i USING "<<","=alz09,",
                "                    l_num", i USING "<<","=alz09, ",
                "                    flag='1' "
     #MOD-G10167---mark---str--
     #IF tm.a='2' THEN
     #    LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz07 AS DATE)<=",g_aly[i].aly04
     #ELSE
     #    LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz06 AS DATE)<=",g_aly[i].aly04
     #END IF
     #LET l_sql=l_sql,"   AND flag='0' "
     #MOD-G10167---mark---end--
      LET l_sql=l_sql," WHERE flag='0' "   #MOD-G10167 add 
      PREPARE q191_amt_pr2 FROM l_sql
      EXECUTE q191_amt_pr2 
      UPDATE q191_tmp SET sum3=num01 + num02 + num03 + num04 + num05 + num06
                              +num07 + num08 + num09 + num010+ num011+ num012
                              +num013+ num014+ num015+ num016+ num017 
      UPDATE q191_tmp SET sum4=l_num01 + l_num02 + l_num03 + l_num04 + l_num05
                              +l_num06 + l_num07 + l_num08 + l_num09 + l_num010
                              +l_num011+ l_num012+ l_num013+ l_num014+ l_num015
                              +l_num016+ l_num017
      UPDATE q191_tmp SET sum2 = apa34 - sum4               #本幣未逾期金額
      UPDATE q191_tmp SET sum1 = apa34f - sum3              #原幣未逾期金額
      UPDATE q191_tmp SET sum5=(net2 - net1) * sum3
   ELSE
      WHILE NOT cl_null(g_aly[i].aly04)
         LET l_sql="UPDATE q191_tmp SET num0",i USING "<<","=alz09,",
                   "                    num", i USING "<<","=alz09*",g_aly[i].aly05/100,",",
                   "                    l_num0",i USING "<<","=alz09f,",
                   "                    l_num", i USING "<<","=alz09f*",g_aly[i].aly05/100,",",
                  #"                    flag='1' ",                                              #MOD-G10167 mark
                   "                    flag='1' "                                               #MOD-G10167 add
                  #" WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz07 AS DATE)<=",g_aly[i].aly04,   #MOD-G10167 mark
                  #"   AND flag='0' "                                                            #MOD-G10167 mark
        #MOD-G10167---add---str--
         IF tm.a='2' THEN
            LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz07 AS DATE)<=",g_aly[i].aly04
         ELSE
            LET l_sql=l_sql," WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz06 AS DATE)<=",g_aly[i].aly04
         END IF
         LET l_sql=l_sql,"   AND flag='0' "
        #MOD-G10167---add---end--         
         PREPARE q191_amt_pr3 FROM l_sql
         EXECUTE q191_amt_pr3  
         LET i=i+1    
      END WHILE
      LET i =17  #add by lixwz201110
      LET l_sql="UPDATE q191_tmp SET num0",i USING "<<","=alz09 ,",
                "                    num", i USING "<<","=alz09 ,",
                "                    l_num0",i USING "<<","=alz09f ,",
                "                    l_num", i USING "<<","=alz09f ,",
               #"                    flag='1' ",                                               #MOD-G10167 mark
                "                    flag='1' "                                                #MOD-G10167 add 
               #" WHERE CAST('",tm.edate,"' AS DATE)-CAST(alz07 AS DATE)>",g_aly[i-1].aly04,   #MOD-G10167 mark
               #"   AND flag='0' "                                                             #MOD-G10167 mark
      LET l_sql=l_sql," WHERE flag='0' "                                                       #MOD-G10167 add

      PREPARE q191_amt_pr4 FROM l_sql
      EXECUTE q191_amt_pr4 
      UPDATE q191_tmp SET sum4=num01 + num02 + num03 + num04 + num05 + num06
                              +num07 + num08 + num09 + num010+ num011+ num012
                              +num013+ num014+ num015+ num016+ num017 
      UPDATE q191_tmp SET sum3=l_num01 + l_num02 + l_num03 + l_num04 + l_num05
                              +l_num06 + l_num07 + l_num08 + l_num09 + l_num010
                              +l_num011+ l_num012+ l_num013+ l_num014+ l_num015
                              +l_num016+ l_num017
      UPDATE q191_tmp SET sum2 = apa34 - sum4               #本幣未逾期金額       
      UPDATE q191_tmp SET sum1 = apa34f - sum3              #原幣未逾期金額
      UPDATE q191_tmp SET sum5=0
   END IF
   LET l_sql = " MERGE INTO q191_tmp o ",
               "      USING (SELECT azi01,azi04 FROM azi_file ",
               "              ) n ",
               "         ON (o.apa13 = n.azi01) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sum1 = ROUND(o.sum1,n.azi04),",
               "           o.sum2 = ROUND(o.sum2,n.azi04),",
               "           o.sum3 = ROUND(o.sum3,n.azi04),",
               "           o.sum4 = ROUND(o.sum4,n.azi04),",
               "           o.sum5 = ROUND(o.sum5,n.azi04),",
               "           o.num01 = ROUND(o.num01,n.azi04),",
               "           o.num02 = ROUND(o.num02,n.azi04),",
               "           o.num03 = ROUND(o.num03,n.azi04),",
               "           o.num04 = ROUND(o.num04,n.azi04),",
               "           o.num05 = ROUND(o.num05,n.azi04),",
               "           o.num06 = ROUND(o.num06,n.azi04),",
               "           o.num07 = ROUND(o.num07,n.azi04),",
               "           o.num08 = ROUND(o.num08,n.azi04),",
               "           o.num09 = ROUND(o.num09,n.azi04),",
               "           o.num010 = ROUND(o.num010,n.azi04),",
               "           o.num011 = ROUND(o.num011,n.azi04),",
               "           o.num012 = ROUND(o.num012,n.azi04),",
               "           o.num013 = ROUND(o.num013,n.azi04),",
               "           o.num014 = ROUND(o.num014,n.azi04),",
               "           o.num015 = ROUND(o.num015,n.azi04),",
               "           o.num016 = ROUND(o.num016,n.azi04),",
               "           o.num017 = ROUND(o.num017,n.azi04),",
               "           o.num1 = ROUND(o.num1,n.azi04),",
               "           o.num2 = ROUND(o.num2,n.azi04),",
               "           o.num3 = ROUND(o.num3,n.azi04),",
               "           o.num4 = ROUND(o.num4,n.azi04),",
               "           o.num5 = ROUND(o.num5,n.azi04),",
               "           o.num6 = ROUND(o.num6,n.azi04),",
               "           o.num7 = ROUND(o.num7,n.azi04),",
               "           o.num8 = ROUND(o.num8,n.azi04),",
               "           o.num9 = ROUND(o.num9,n.azi04),",
               "           o.num10 = ROUND(o.num10,n.azi04),",
               "           o.num11 = ROUND(o.num11,n.azi04),",
               "           o.num12 = ROUND(o.num12,n.azi04),",
               "           o.num13 = ROUND(o.num13,n.azi04),",
               "           o.num14 = ROUND(o.num14,n.azi04),",
               "           o.num15 = ROUND(o.num15,n.azi04),",
               "           o.num16 = ROUND(o.num16,n.azi04),",
               "           o.num17 = ROUND(o.num17,n.azi04) "

   PREPARE q191_amt_pr5 FROM l_sql
   EXECUTE q191_amt_pr5 
END FUNCTION

FUNCTION q191_table2()
   DROP TABLE q191_tmp;
   CREATE TEMP TABLE q191_tmp(
    apa06   LIKE apa_file.apa06,
    apa07   LIKE apa_file.apa07,
    apa34f  LIKE apa_file.apa34f,
    apa35f  LIKE apa_file.apa35f,
    apa13 LIKE apa_file.apa13,
    apa14 LIKE apa_file.apa14,
    amt_1 LIKE apa_file.apa34,
    sum1  LIKE alz_file.alz09,
    sum3  LIKE alz_file.alz09,
    apa34 LIKE apa_file.apa34,
    apa35 LIKE apa_file.apa35,
    amt_2 LIKE apa_file.apa34,              
    sum2  LIKE alz_file.alz09,               
    sum4  LIKE alz_file.alz09, 
    num01 LIKE alz_file.alz09,
    num02 LIKE alz_file.alz09,
    num03 LIKE alz_file.alz09,
    num04 LIKE alz_file.alz09,
    num05 LIKE alz_file.alz09,
    num06 LIKE alz_file.alz09,
    num07 LIKE alz_file.alz09,
    num08 LIKE alz_file.alz09,
    num09 LIKE alz_file.alz09,
    num010 LIKE alz_file.alz09,
    num011 LIKE alz_file.alz09,
    num012 LIKE alz_file.alz09,
    num013 LIKE alz_file.alz09,
    num014 LIKE alz_file.alz09,
    num015 LIKE alz_file.alz09,
    num016 LIKE alz_file.alz09,
    num017 LIKE alz_file.alz09,
    num1 LIKE alz_file.alz09,
    num2 LIKE alz_file.alz09,
    num3 LIKE alz_file.alz09,
    num4 LIKE alz_file.alz09,
    num5 LIKE alz_file.alz09,
    num6 LIKE alz_file.alz09,
    num7 LIKE alz_file.alz09,
    num8 LIKE alz_file.alz09,
    num9 LIKE alz_file.alz09,
    num10 LIKE alz_file.alz09,
    num11 LIKE alz_file.alz09,
    num12 LIKE alz_file.alz09,
    num13 LIKE alz_file.alz09,
    num14 LIKE alz_file.alz09,
    num15 LIKE alz_file.alz09,
    num16 LIKE alz_file.alz09,
    num17 LIKE alz_file.alz09,
    l_num01 LIKE alz_file.alz09,
    l_num02 LIKE alz_file.alz09,
    l_num03 LIKE alz_file.alz09,
    l_num04 LIKE alz_file.alz09,
    l_num05 LIKE alz_file.alz09,
    l_num06 LIKE alz_file.alz09,
    l_num07 LIKE alz_file.alz09,
    l_num08 LIKE alz_file.alz09,
    l_num09 LIKE alz_file.alz09,
    l_num010 LIKE alz_file.alz09,
    l_num011 LIKE alz_file.alz09,
    l_num012 LIKE alz_file.alz09,
    l_num013 LIKE alz_file.alz09,
    l_num014 LIKE alz_file.alz09,
    l_num015 LIKE alz_file.alz09,
    l_num016 LIKE alz_file.alz09,
    l_num017 LIKE alz_file.alz09,
    l_num1 LIKE alz_file.alz09,
    l_num2 LIKE alz_file.alz09,
    l_num3 LIKE alz_file.alz09,
    l_num4 LIKE alz_file.alz09,
    l_num5 LIKE alz_file.alz09,
    l_num6 LIKE alz_file.alz09,
    l_num7 LIKE alz_file.alz09,
    l_num8 LIKE alz_file.alz09,
    l_num9 LIKE alz_file.alz09,
    l_num10 LIKE alz_file.alz09,
    l_num11 LIKE alz_file.alz09,
    l_num12 LIKE alz_file.alz09,
    l_num13 LIKE alz_file.alz09,
    l_num14 LIKE alz_file.alz09,
    l_num15 LIKE alz_file.alz09,
    l_num16 LIKE alz_file.alz09,
    l_num17 LIKE alz_file.alz09,
    sum5  LIKE alz_file.alz09,
    apa15 LIKE apa_file.apa15,
    apa16 LIKE apa_file.apa16,
    net1  LIKE type_file.num5,
    net2  LIKE type_file.num5,
    apa21 LIKE apa_file.apa21,
    gen02 LIKE gen_file.gen02,
    apa22 LIKE apa_file.apa22,
    gem02 LIKE gem_file.gem02,
    apa08 LIKE apa_file.apa08,
    apa00 LIKE apa_file.apa00,
    apa01 LIKE apa_file.apa01,
    apa02 LIKE apa_file.apa02,
    alz12 LIKE alz_file.alz12,
    alz07 LIKE alz_file.alz07,
    apa11 LIKE apa_file.apa11,
    pma02 LIKE pma_file.pma02,
    apa36 LIKE apa_file.apa36,
    apr02 LIKE apr_file.apr02,
    apa44 LIKE apa_file.apa44,         
    apa54 LIKE apa_file.apa54,
    aag02 LIKE aag_file.aag02,      
    apa05 LIKE apa_file.apa05,  
    pmc03 LIKE pmc_file.pmc03, 
    pmy01 LIKE pmy_file.pmy01,
    pmy02 LIKE pmy_file.pmy02,
    apa41 LIKE apa_file.apa41,
    alz09  LIKE alz_file.alz09,
    alz09f LIKE alz_file.alz09f,
    alz06  LIKE alz_file.alz06,
    flag   LIKE type_file.chr1);
END FUNCTION 
#FUN-CB0146--add--end


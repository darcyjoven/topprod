# Prog. Version..: '5.30.07-13.06.06(00003)'     #
# PROG. VERSION..: '5.25.02-11.03.23(00010)'     #
#
# PATTERN NAME...: axcq402.4gl
# DESCRIPTIONS...: 狀態查詢作業
# DATE & AUTHOR..: No.FUN-D20073 13/02/17 BY fengrui
# Modify.........: No.TQC-D20055 13/02/28 By fengrui 問題修正 
# Modify.........: No.FUN-D50084 13/05/23 By xianghui 增加元件科目,並可以按其匯總

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING, 
                 yy     LIKE type_file.num5,
                 mm     LIKE type_file.num5,
                 type   LIKE type_file.chr1,                
                 a      LIKE type_file.chr1       #小計選項
              END RECORD     
   DEFINE g_filter_wc     STRING                                                                                                       
   DEFINE g_sql     STRING             
   DEFINE g_rec_b   LIKE type_file.num10
   DEFINE g_cnt     LIKE type_file.num10      
   
   DEFINE g_cch,g_cch_excel    DYNAMIC ARRAY OF RECORD 
                cch01     LIKE cch_file.cch01,
                sfb02     LIKE sfb_file.sfb02,
                sfb99     LIKE sfb_file.sfb99,
                sfb05     LIKE sfb_file.sfb05,
                ima02     LIKE ima_file.ima02,
                ima021    LIKE ima_file.ima021,
                ima57     LIKE ima_file.ima57,
                cch04     LIKE cch_file.cch04,
                ima02a    LIKE ima_file.ima02,
                ima021a   LIKE ima_file.ima021,
                aag01     LIKE aag_file.aag01,   #FUN-D50084
                aag02     LIKE aag_file.aag02,   #FUN-D50084
                cch07     LIKE cch_file.cch07,
                ima57a    LIKE ima_file.ima57,
                sfb98     LIKE sfb_file.sfb98,
                cch11     LIKE cch_file.cch11,
                cch12a    LIKE cch_file.cch12a,
                cch12b    LIKE cch_file.cch12b,
                cch12c    LIKE cch_file.cch12c,
                cch12d    LIKE cch_file.cch12d,
                cch12e    LIKE cch_file.cch12e,
                cch12f    LIKE cch_file.cch12f,
                cch12g    LIKE cch_file.cch12g,
                cch12h    LIKE cch_file.cch12h,
                cch12     LIKE cch_file.cch12,
                amt12     LIKE cch_file.cch12,
                cch21     LIKE cch_file.cch11,
                cch22a    LIKE cch_file.cch12a,
                cch22b    LIKE cch_file.cch12b,
                cch22c    LIKE cch_file.cch12c,
                cch22d    LIKE cch_file.cch12d,
                cch22e    LIKE cch_file.cch12e,
                cch22f    LIKE cch_file.cch12f,
                cch22g    LIKE cch_file.cch12g,
                cch22h    LIKE cch_file.cch12h,
                cch22     LIKE cch_file.cch12,
                amt22     LIKE cch_file.cch12,
                cch31     LIKE cch_file.cch11,
                cch32a    LIKE cch_file.cch12a,
                cch32b    LIKE cch_file.cch12b,
                cch32c    LIKE cch_file.cch12c,
                cch32d    LIKE cch_file.cch12d,
                cch32e    LIKE cch_file.cch12e,
                cch32f    LIKE cch_file.cch12f,
                cch32g    LIKE cch_file.cch12g,
                cch32h    LIKE cch_file.cch12h,
                cch32     LIKE cch_file.cch12,
                amt32     LIKE cch_file.cch12,
                cch41     LIKE cch_file.cch11,
                cch42a    LIKE cch_file.cch12a,
                cch42b    LIKE cch_file.cch12b,
                cch42c    LIKE cch_file.cch12c,
                cch42d    LIKE cch_file.cch12d,
                cch42e    LIKE cch_file.cch12e,
                cch42f    LIKE cch_file.cch12f,
                cch42g    LIKE cch_file.cch12g,
                cch42h    LIKE cch_file.cch12h,
                cch42     LIKE cch_file.cch12,
                amt42     LIKE cch_file.cch12,
                cch91     LIKE cch_file.cch11,
                cch92a    LIKE cch_file.cch12a,
                cch92b    LIKE cch_file.cch12b,
                cch92c    LIKE cch_file.cch12c,
                cch92d    LIKE cch_file.cch12d,
                cch92e    LIKE cch_file.cch12e,
                cch92f    LIKE cch_file.cch12f,
                cch92g    LIKE cch_file.cch12g,
                cch92h    LIKE cch_file.cch12h,
                cch92     LIKE cch_file.cch12,
                amt92     LIKE cch_file.cch12
                         END RECORD 
   DEFINE g_cch_1,g_cch_1_excel    DYNAMIC ARRAY OF RECORD 
                cch01     LIKE cch_file.cch01,
                sfb02a    LIKE sfb_file.sfb02,
                sfb05     LIKE sfb_file.sfb05,
                ima02     LIKE ima_file.ima02,
                ima021    LIKE ima_file.ima021,
                cch04     LIKE cch_file.cch04,
                ima02a    LIKE ima_file.ima02,
                ima021a   LIKE ima_file.ima021,
                aag01     LIKE aag_file.aag01,   #FUN-D50084
                aag02     LIKE aag_file.aag02,   #FUN-D50084
                sfb98     LIKE sfb_file.sfb98,
                cch11     LIKE cch_file.cch11,
                cch12a    LIKE cch_file.cch12a,
                cch12b    LIKE cch_file.cch12b,
                cch12c    LIKE cch_file.cch12c,
                cch12d    LIKE cch_file.cch12d,
                cch12e    LIKE cch_file.cch12e,
                cch12f    LIKE cch_file.cch12f,
                cch12g    LIKE cch_file.cch12g,
                cch12h    LIKE cch_file.cch12h,
                cch12     LIKE cch_file.cch12,
                cch21     LIKE cch_file.cch11,
                cch22a    LIKE cch_file.cch12a,
                cch22b    LIKE cch_file.cch12b,
                cch22c    LIKE cch_file.cch12c,
                cch22d    LIKE cch_file.cch12d,
                cch22e    LIKE cch_file.cch12e,
                cch22f    LIKE cch_file.cch12f,
                cch22g    LIKE cch_file.cch12g,
                cch22h    LIKE cch_file.cch12h,
                cch22     LIKE cch_file.cch12,
                cch31     LIKE cch_file.cch11,
                cch32a    LIKE cch_file.cch12a,
                cch32b    LIKE cch_file.cch12b,
                cch32c    LIKE cch_file.cch12c,
                cch32d    LIKE cch_file.cch12d,
                cch32e    LIKE cch_file.cch12e,
                cch32f    LIKE cch_file.cch12f,
                cch32g    LIKE cch_file.cch12g,
                cch32h    LIKE cch_file.cch12h,
                cch32     LIKE cch_file.cch12,
                cch41     LIKE cch_file.cch11,
                cch42a    LIKE cch_file.cch12a,
                cch42b    LIKE cch_file.cch12b,
                cch42c    LIKE cch_file.cch12c,
                cch42d    LIKE cch_file.cch12d,
                cch42e    LIKE cch_file.cch12e,
                cch42f    LIKE cch_file.cch12f,
                cch42g    LIKE cch_file.cch12g,
                cch42h    LIKE cch_file.cch12h,
                cch42     LIKE cch_file.cch12,
                cch91     LIKE cch_file.cch11,
                cch92a    LIKE cch_file.cch12a,
                cch92b    LIKE cch_file.cch12b,
                cch92c    LIKE cch_file.cch12c,
                cch92d    LIKE cch_file.cch12d,
                cch92e    LIKE cch_file.cch12e,
                cch92f    LIKE cch_file.cch12f,
                cch92g    LIKE cch_file.cch12g,
                cch92h    LIKE cch_file.cch12h,
                cch92     LIKE cch_file.cch12
                         END RECORD 
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10    
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_pmk_qty      LIKE type_file.num20_6      #訂單數量總計
   DEFINE g_pmk_sum      LIKE type_file.num20_6      #訂單本幣金額總計
   DEFINE g_pmk_sum1     LIKE type_file.num20_6      #訂單原幣金額總計  
   DEFINE g_tot_cch11    LIKE cch_file.cch11
   DEFINE g_tot_cch12    LIKE cch_file.cch12
   DEFINE g_tot_cch21    LIKE cch_file.cch21
   DEFINE g_tot_cch22    LIKE cch_file.cch22
   DEFINE g_tot_cch31    LIKE cch_file.cch31
   DEFINE g_tot_cch32    LIKE cch_file.cch32
   DEFINE g_tot_cch41    LIKE cch_file.cch41
   DEFINE g_tot_cch42    LIKE cch_file.cch42
   DEFINE g_tot_cch91    LIKE cch_file.cch91
   DEFINE g_tot_cch92    LIKE cch_file.cch92
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100   
   DEFINE w              ui.Window
   DEFINE f              ui.Form
   DEFINE page om.DomNode  
   DEFINE
    g_head          RECORD  
        cch01_2     LIKE cch_file.cch01,
        sfb02a_2     LIKE sfb_file.sfb02,
        sfb99_2     LIKE sfb_file.sfb99,
        sfb05_2     LIKE sfb_file.sfb05,
        ima02_2     LIKE ima_file.ima02,
        ima021_2    LIKE ima_file.ima021,
        ima57_2     LIKE ima_file.ima57,
        sfb98_2     LIKE sfb_file.sfb98
                    END RECORD,
    g_head_sfa      RECORD
        sfb01_sfa   LIKE sfb_file.sfb01,
        sfb08_sfa   LIKE sfb_file.sfb08,
        sfb81_sfa  LIKE sfb_file.sfb81,
        sfb82_sfa  LIKE sfb_file.sfb82,
        pmc03_sfa   LIKE pmc_file.pmc03
                    END RECORD,
    g_head_sfs      RECORD
        sfp01_sfs   LIKE sfp_file.sfp01,
        sfp06_sfs   LIKE sfp_file.sfp06,
        sfp07_sfs   LIKE sfp_file.sfp07,
        gem02_sfs   LIKE gem_file.gem02,
        sfp16_sfs   LIKE sfp_file.sfp16,
        gen02_sfs   LIKE gen_file.gen02,
        sfpconf_sfs LIKE sfp_file.sfpconf,
        sfp04_sfs   LIKE sfp_file.sfp04
                    END RECORD,
    g_head_sfv      RECORD
        sfu01_sfv   LIKE sfu_file.sfu01,
        sfu02_sfv   LIKE sfu_file.sfu02,
        sfu04_sfv   LIKE sfu_file.sfu04,
        gem02_sfv   LIKE gem_file.gem02,
        sfu16_sfv   LIKE sfu_file.sfu16,
        gen02_sfv   LIKE gen_file.gen02,
        sfuconf_sfv LIKE sfu_file.sfuconf,
        sfupost_sfv LIKE sfu_file.sfupost
                    END RECORD,
    g_sfb         DYNAMIC ARRAY OF RECORD   
        sfb01       LIKE sfb_file.sfb01,
        sfb44       LIKE sfb_file.sfb44,    
        gen02_sfb   LIKE gen_file.gen02,    
        sfb81       LIKE sfb_file.sfb81,    
        sfb82       LIKE sfb_file.sfb82,    
        pmc03_sfb   LIKE pmc_file.pmc03,   
        sfb39       LIKE sfb_file.sfb39,    
        sfb08       LIKE sfb_file.sfb08,   
        sfb93       LIKE sfb_file.sfb93,    
        sfb06       LIKE sfb_file.sfb06,   
        sfb87       LIKE sfb_file.sfb87,   
        sfb04       LIKE sfb_file.sfb04,    
        sfb43       LIKE sfb_file.sfb43     
                    END RECORD,
    g_sfa           DYNAMIC ARRAY OF RECORD 
        sfa27       LIKE sfa_file.sfa27,   
        sfa08       LIKE sfa_file.sfa08,   
        sfa26       LIKE sfa_file.sfa26,   
        sfa28       LIKE sfa_file.sfa28,   
        sfa03       LIKE sfa_file.sfa03,   
        ima02_sfa   LIKE ima_file.ima02,   
        ima021_sfa  LIKE ima_file.ima021,   
        sfa12       LIKE sfa_file.sfa12,   
        sfa13       LIKE sfa_file.sfa13, 
        sfa05       LIKE sfa_file.sfa05,   
        sfa065      LIKE sfa_file.sfa065,   
        sfa06       LIKE sfa_file.sfa06,   
        sfa062      LIKE sfa_file.sfa062,   
        sfa063      LIKE sfa_file.sfa063,   
        sfa064      LIKE sfa_file.sfa064,   
        sfa30       LIKE sfa_file.sfa30,   
        sfa31       LIKE sfa_file.sfa31
                    END RECORD,
    g_sfp           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfp01       LIKE sfp_file.sfp01,
        sfp06       LIKE sfp_file.sfp06,
        sfp07       LIKE sfp_file.sfp07,
        gem02_sfp   LIKE gem_file.gem02,
        sfp16       LIKE sfp_file.sfp16,
        gen02_sfp   LIKE gen_file.gen02,
        sfp02       LIKE sfp_file.sfp02,
        sfp03       LIKE sfp_file.sfp03,
        sfpconf     LIKE sfp_file.sfpconf,
        sfp04       LIKE sfp_file.sfp04
                    END RECORD,
    g_sfs           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfs02       LIKE sfs_file.sfs02,
        sfs26       LIKE sfs_file.sfs26,
        sfs28       LIKE sfs_file.sfs28,
        sfs27       LIKE sfs_file.sfs27,
        sfs04       LIKE sfs_file.sfs04,
        ima02_sfs   LIKE ima_file.ima02,
        ima021_sfs  LIKE ima_file.ima021,
        sfs06       LIKE sfs_file.sfs06,
        sfa05       LIKE sfa_file.sfa05,  #TQC-D20055 add
        sfa06       LIKE sfa_file.sfa06,
        sfs07       LIKE sfs_file.sfs07,
        sfs08       LIKE sfs_file.sfs08,
        sfs09       LIKE sfs_file.sfs09,
        sfs930      LIKE sfs_file.sfs930,
        gem02_sfs   LIKE gem_file.gem02
                    END RECORD,
    g_sfu           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfu01       LIKE sfu_file.sfu01,
        sfu14       LIKE sfu_file.sfu14,
        sfu02       LIKE sfu_file.sfu02,
        sfu04       LIKE sfu_file.sfu04,
        gem02_sfu   LIKE gem_file.gem02,
        sfu09       LIKE sfu_file.sfu09,
        sfu16       LIKE sfu_file.sfu16,
        gen02_sfu   LIKE gen_file.gen02,
        sfuconf     LIKE sfu_file.sfuconf,
        sfupost     LIKE sfu_file.sfupost
                    END RECORD,
    g_sfv           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfv03       LIKE sfv_file.sfv03,
        sfv04       LIKE sfv_file.sfv04,
        ima02_sfv   LIKE ima_file.ima02,
        ima021_sfv  LIKE ima_file.ima021,
        sfv05       LIKE sfv_file.sfv05,
        sfv06       LIKE sfv_file.sfv06,
        sfv07       LIKE sfv_file.sfv07,
        sfv08       LIKE sfv_file.sfv08,
        sfv09       LIKE sfv_file.sfv09
                    END RECORD, 
    g_rec_b_sfb     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfa     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfp     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfs     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfu     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfv     LIKE type_file.num5,    #單身筆數
    l_ac_sfb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfa        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfp        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfs        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfu        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfv        LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_b_flag     LIKE type_file.num5
DEFINE g_b_flag2    LIKE type_file.num5
DEFINE g_b_flag3    LIKE type_file.num5
DEFINE g_b_flag4    LIKE type_file.num5
DEFINE g_int_flag   LIKE type_file.chr1
DEFINE g_cch01_o    LIKE pmk_file.pmk01
#DEFINE g_pml02_o    LIKE pml_file.pml02
DEFINE g_pmk01_change_sfa LIKE type_file.chr1
DEFINE g_pmk01_change_sfs LIKE type_file.chr1
DEFINE g_pmk01_change_sfv LIKE type_file.chr1
DEFINE g_pmk01_change_qct LIKE type_file.chr1
DEFINE g_pmk01_change_rvv LIKE type_file.chr1
DEFINE g_pmk01_change_rvv_y LIKE type_file.chr1
DEFINE g_pmk01_change_rvv_c LIKE type_file.chr1
DEFINE g_pmk01_change_apb LIKE type_file.chr1
DEFINE g_pml02_change_pml LIKE type_file.chr1
DEFINE g_pml02_change_pmn LIKE type_file.chr1


MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
   OPEN WINDOW q402_w AT 5,10
        WITH FORM "axc/42f/axcq402" ATTRIBUTE(STYLE = g_win_style)  
   CALL cl_ui_init() 
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q402_table()   #free
   DELETE FROM axcq402_tmp
   CALL q402_q()   
   CALL q402_menu()

   DROP TABLE axcq402_tmp;
   CLOSE WINDOW q402_w  
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION q402_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   
   DEFINE   l_wc    STRING
   DEFINE   l_action_page3    LIKE type_file.chr1

   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      LET l_action_page3 = 'Y'
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q402_bp("G")
            LET l_action_page3 = 'N'
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q402_bp2()
            LET l_action_page3 = 'N'
         END IF
         IF g_action_flag = "page3" AND l_action_page3 = 'Y' THEN
            CALL q402_bp3()
         END IF
      END IF 
      CASE g_action_choice
         WHEN "page1"
            CALL q402_bp("G")
         WHEN "page2"
            CALL q402_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q402_q()    
            END IF   
            LET g_action_choice = " " 
         WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q402_filter_askkey()
               CALL q402()
               CALL q402_show()
            END IF 
            LET g_action_choice = " "           
         WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q402()
               CALL q402_show() 
            END IF             
            LET g_action_choice = " "
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_action_flag = "page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_cch_excel),'','')
               END IF
               IF g_action_flag = "page2" THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_cch_1),'','')
               END IF
               IF g_action_flag = "page3" THEN
                  CALL q402_excel()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "cch01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
         WHEN "sfb"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_head.cch01_2) THEN
                  CALL q402_b_fill_sfb()
               ELSE
                  CALL g_sfb.clear()
                  CALL g_sfa.clear()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "sfa"
            IF cl_chk_act_auth() THEN
               CALL q402_b_fill_sfa()
            END IF
            LET g_action_choice = " "
         WHEN "sfp"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_head.cch01_2) THEN
                 CALL q402_b_fill_sfp()
               ELSE
                  CALL g_sfp.clear()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "sfs"
            IF cl_chk_act_auth() THEN
               CALL q402_b_fill_sfs() 
            END IF
            LET g_action_choice = " "
         WHEN "sfu"
            IF cl_chk_act_auth() THEN
               CALL q402_b_fill_sfu()
            END IF
            LET g_action_choice = " "   
         WHEN "sfv"
            IF cl_chk_act_auth() THEN
               CALL q402_b_fill_sfv()
            END IF
            LET g_action_choice = " "  
      END CASE
   END WHILE
END FUNCTION

FUNCTION q402_b_fill()
DEFINE l_wc    STRING

   CALL g_cch.clear()
   CALL g_cch_excel.clear()   
   LET g_cnt = 1
   LET g_rec_b = 0

   LET g_sql = "SELECT * FROM axcq402_tmp "
  
   
   PREPARE axcq402_pb_cs FROM g_sql
   DECLARE cch_curs  CURSOR FOR axcq402_pb_cs        #CURSOR
   
   SELECT SUM(cch11),SUM(cch12),SUM(cch21),SUM(cch22),SUM(cch31),SUM(cch32),
          SUM(cch41),SUM(cch42),SUM(cch91),SUM(cch92) 
     INTO g_tot_cch11,g_tot_cch12,g_tot_cch21,g_tot_cch22,g_tot_cch31,
          g_tot_cch32,g_tot_cch41,g_tot_cch42,g_tot_cch91,g_tot_cch92
     FROM axcq402_tmp 
  
   FOREACH cch_curs INTO g_cch_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN
         LET g_cch[g_cnt].* = g_cch_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_cch.deleteElement(g_cnt)
   END IF
   CALL g_cch_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b    TO FORMONLY.cnt
   DISPLAY g_tot_cch11  TO FORMONLY.tot_cch11
   DISPLAY g_tot_cch12  TO FORMONLY.tot_cch12
   DISPLAY g_tot_cch21  TO FORMONLY.tot_cch21
   DISPLAY g_tot_cch22  TO FORMONLY.tot_cch22
   DISPLAY g_tot_cch31  TO FORMONLY.tot_cch31
   DISPLAY g_tot_cch32  TO FORMONLY.tot_cch32
   DISPLAY g_tot_cch41  TO FORMONLY.tot_cch41
   DISPLAY g_tot_cch42  TO FORMONLY.tot_cch42
   DISPLAY g_tot_cch91  TO FORMONLY.tot_cch91
   DISPLAY g_tot_cch92  TO FORMONLY.tot_cch92
END FUNCTION

FUNCTION q402_b_fill_2()
DEFINE l_wc,l_sql    STRING

   CALL g_cch_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   CALL q402_get_sum()
     
END FUNCTION

FUNCTION q402_b_fill_sfb()              #BODY FILL UP

    IF cl_null(g_head.cch01_2) THEN LET g_head.cch01_2='' END IF  

    LET g_sql = 
        "SELECT sfb01,sfb44,gen02,sfb81,sfb82,pmc03, ",
        "       sfb39,sfb08,sfb93,sfb06,sfb87,sfb04,sfb43",
        " FROM sfb_file LEFT OUTER JOIN pmc_file ON pmc01=sfb82 ",
        "               LEFT OUTER JOIN gen_file ON gen01=sfb44 ",
        "WHERE sfb01='", g_head.cch01_2 CLIPPED ,"'",
        " ORDER BY 1"
    
    PREPARE q402_sfb1 FROM g_sql
    DECLARE sfb_curs1 CURSOR FOR q402_sfb1

    CALL g_sfb.clear()
    LET g_cnt = 1
    LET g_rec_b_sfb = 0
    MESSAGE "Searching!"
    FOREACH sfb_curs1 INTO g_sfb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF (g_head.sfb02a_2<>7 AND g_head.sfb02a_2<>8 ) THEN 
          SELECT gem02 INTO g_sfb[g_cnt].pmc03_sfb FROM gem_file
           WHERE gem01=g_sfb[g_cnt].sfb82
       END IF 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfb = g_cnt-1
    DISPLAY g_rec_b_sfb TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_b_fill_sfa()              #BODY FILL UP

    IF cl_null(g_head_sfa.sfb01_sfa) THEN LET g_head_sfa.sfb01_sfa='' END IF 

    LET g_sql =
        "SELECT DISTINCT sfa27,sfa08,sfa26,sfa28,sfa03,ima02,ima021,sfa12,sfa13, ",
        "       sfa05,sfa065,sfa06,sfa062,sfa063,sfa064,sfa30,sfa31 ",
        "  FROM sfa_file LEFT OUTER JOIN ima_file on sfa03=ima01 ",
        " WHERE sfa01 ='", g_head_sfa.sfb01_sfa CLIPPED ,"' ",
        " ORDER BY 1"
    PREPARE q402_sfa FROM g_sql
    DECLARE sfa_curs CURSOR FOR q402_sfa

    CALL g_sfa.clear()
    LET g_cnt = 1
    LET g_rec_b_sfa = 0
    MESSAGE "Searching!"
    FOREACH sfa_curs INTO g_sfa[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfa = g_cnt-1
    DISPLAY g_rec_b_sfa TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_b_fill_sfp()              #BODY FILL UP

    IF cl_null(g_head.cch01_2) THEN LET g_head.cch01_2='' END IF 
    LET g_sql =
        "SELECT UNIQUE sfp01,sfp06,sfp07,gem02,sfp16,gen02,",
        "       sfp02,sfp03,sfpconf,sfp04 ",
        " FROM sfp_file LEFT OUTER JOIN gem_file ON gem01=sfp07 ",
        "               LEFT OUTER JOIN gen_file ON gen01=sfp16 ",
        "     ,sfs_file ",
        " WHERE sfp01 = sfs01 AND sfs03 ='", g_head.cch01_2 CLIPPED,"' ",
        " UNION ",
        "SELECT UNIQUE sfp01,sfp06,sfp07,gem02,sfp16,gen02,",
        "       sfp02,sfp03,sfpconf,sfp04 ",
        " FROM sfp_file LEFT OUTER JOIN gem_file ON gem01=sfp07 ",
        "               LEFT OUTER JOIN gen_file ON gen01=sfp16 ",
        "     ,sfe_file ",
        " WHERE sfp01 = sfe02  AND sfp04 ='Y' ",
        "   AND sfe01 ='", g_head.cch01_2 CLIPPED,"' ",
        " ORDER BY 1"
        
    PREPARE q402_sfp FROM g_sql
    DECLARE sfp_curs CURSOR FOR q402_sfp

    CALL g_sfp.clear()
    LET g_cnt = 1
    LET g_rec_b_sfp = 0
    MESSAGE "Searching!"
    FOREACH sfp_curs INTO g_sfp[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfp = g_cnt-1
    DISPLAY g_rec_b_sfp TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_b_fill_sfs()              #BODY FILL UP

    IF cl_null(g_head_sfs.sfp01_sfs) THEN LET g_head_sfs.sfp01_sfs='' END IF
    IF g_head_sfs.sfp04_sfs = 'N' THEN 
       LET g_sql =
           "SELECT DISTINCT sfs02,sfs26,sfs28,sfs27,sfs04,ima02,ima021,sfs06,(sfa05-sfa065),",
           "       sfa06,sfs07,sfs08,sfs09,sfs930,'' ",
           " FROM sfs_file LEFT OUTER JOIN ima_file ON ima01=sfs04 ",
           "               LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs06=sfa12 AND sfs10=sfa08 ",
           "               AND sfs012=sfa012 AND sfs013=sfa013 AND sfs27=sfa27 AND sfs04=sfa03 ",
           " WHERE sfs01 ='", g_head_sfs.sfp01_sfs CLIPPED,"' ",
           "   AND sfs03 ='", g_head.cch01_2 CLIPPED,"' ",
           " ORDER BY 1 "
    ELSE 
       LET g_sql =
           "SELECT DISTINCT sfe28,sfe26,sfa28,sfe27,sfe07,ima02,ima021,sfe17,(sfa05-sfa065),",
           "                sfa06,sfe08,sfe09,sfe10,sfe930,'' ",
           "  FROM sfe_file LEFT OUTER JOIN sfa_file ON sfe01=sfa01 AND sfe17=sfa12 AND sfe14=sfa08 ",
           "   AND sfe012=sfa012 AND sfe013=sfa013 AND sfe07=sfa03 AND sfe27=sfa27 ",
           "                LEFT OUTER JOIN ima_file ON ima01=sfe07 ",
           " WHERE sfe01='", g_head.cch01_2 CLIPPED,"' ",
           "   AND sfe02='", g_head_sfs.sfp01_sfs CLIPPED,"' ",
           " ORDER BY 1 "
    END IF 
    PREPARE q402_sfs FROM g_sql
    DECLARE sfs_curs CURSOR FOR q402_sfs

    CALL g_sfs.clear()
    LET g_cnt = 1
    LET g_rec_b_sfs = 0
    MESSAGE "Searching!"
    FOREACH sfs_curs INTO g_sfs[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_sfs[g_cnt].gem02_sfs=s_costcenter_desc(g_sfs[l_ac].sfs930)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfs.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfs = g_cnt-1
    DISPLAY g_rec_b_sfs TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_b_fill_sfu()              #BODY FILL UP

    IF cl_null(g_head.cch01_2) THEN LET g_head.cch01_2='' END IF 
    IF g_head.sfb02a_2 <> 11 AND g_head.sfb02a_2 <> 7 THEN 
       LET g_sql = 
        "SELECT DISTINCT sfu01,sfu14,sfu02,sfu04,gem02,sfu09, ",
        "                sfu16,gen02,sfuconf,sfupost ",
        "  FROM sfu_file LEFT OUTER JOIN gem_file ON sfu04=gem01 ",
        "                LEFT OUTER JOIN gen_file ON sfu16=gen01 ",
        "                LEFT OUTER JOIN sfv_file ON sfu01 = sfv01 ",
        " WHERE sfv11 ='", g_head.cch01_2 CLIPPED,"'",
        " ORDER BY 1 "
    ELSE 
       IF g_head.sfb02a_2 =7 THEN
          LET g_sql = 
           "SELECT DISTINCT rvu01,'',rvu03,rvu06,gem02,'', ",
           "                rvu07,gen02,rvuconf,'' ",
           "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
           "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
           "       ,rvv_file,pmn_file ",
           " WHERE rvv01=rvu01 AND rvu00 = '1' ",
           "   AND rvv36=pmn01 AND rvv37=pmn02",
           "   AND pmn41 = '", g_head.cch01_2 CLIPPED,"'",
           " ORDER BY 1 "
       ELSE
          LET g_sql =
           "SELECT DISTINCT ksc01,ksc14,ksc02,ksc04,gem02,ksc09, ",
           "                '','',kscconf,kscpost ",
           "  FROM ksc_file LEFT OUTER JOIN gem_file ON ksc04=gem01 ",
           "      ,ksd_file ",
           " WHERE ksc01 = ksd01 ",
           "   AND ksd11 = '", g_head.cch01_2 CLIPPED,"'",
           " ORDER BY 1 "
       END IF
    END IF 
        

    PREPARE q402_sfu FROM g_sql
    DECLARE sfu_curs CURSOR FOR q402_sfu

    CALL g_sfu.clear()
    LET g_cnt = 1
    LET g_rec_b_sfu = 0
    MESSAGE "Searching!"
    FOREACH sfu_curs INTO g_sfu[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfu = g_cnt-1
    DISPLAY g_rec_b_sfu TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_b_fill_sfv()              #BODY FILL UP

    IF cl_null(g_head_sfv.sfu01_sfv) THEN LET g_head_sfv.sfu01_sfv='' END IF
    IF g_head.sfb02a_2 <> 11 AND g_head.sfb02a_2 <> 7 THEN 
       LET g_sql = 
        "SELECT DISTINCT sfv03,sfv04,ima02,ima021,sfv05, ",
        "                sfv06,sfv07,sfv08,sfv09 ",
        "  FROM sfv_file LEFT OUTER JOIN ima_file ON sfv04=ima01 ",
        " WHERE sfv01 ='", g_head_sfv.sfu01_sfv CLIPPED,"' ",
        "   AND sfv11 ='", g_head.cch01_2 CLIPPED,"' ",
        " ORDER BY 1 "
    ELSE
       IF g_head.sfb02a_2 = 7 THEN
           LET g_sql =
           "SELECT DISTINCT rvv02,rvv31,rvv031,ima021,rvv32, ",
           "                rvv33,rvv34,rvv35,rvv17 ",
           "  FROM rvv_file LEFT OUTER JOIN ima_file ON rvv31=ima01 ",
           "       ,pmn_file ",
           " WHERE rvv01 ='", g_head_sfv.sfu01_sfv CLIPPED,"' ",
           "   AND rvv36=pmn01 AND rvv37=pmn02",
           "   AND pmn41 = '", g_head.cch01_2 CLIPPED,"'",
           " ORDER BY 1 "

       ELSE
          LET g_sql = 
           "SELECT DISTINCT ksd03,ksd04,ima02,ima021,ksd05, ",
           "                ksd06,ksd07,ksd08,ksd09 ",
           "  FROM ksd_file LEFT OUTER JOIN ima_file ON ksd04=ima01 ",
           " WHERE ksd01 ='", g_head_sfv.sfu01_sfv CLIPPED,"' ",
           "   AND ksd11 ='", g_head.cch01_2 CLIPPED,"' ",
           " ORDER BY 1 "
       END IF 
    END IF 
    PREPARE q402_sfv FROM g_sql
    DECLARE sfv_curs CURSOR FOR q402_sfv

    CALL g_sfv.clear()
    LET g_cnt = 1
    LET g_rec_b_sfv = 0
    MESSAGE "Searching!"
    FOREACH sfv_curs INTO g_sfv[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_sfv = g_cnt-1
    DISPLAY g_rec_b_sfv TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q402_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,
            l_cutwip        LIKE ecm_file.ecm315,
            l_packwip       LIKE ecm_file.ecm315,
            l_completed     LIKE ecm_file.ecm315,
            l_sfb08         LIKE sfb_file.sfb08   

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1' 

   IF g_action_choice = "page1"  AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q402_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.a
   DISPLAY g_tot_cch11  TO FORMONLY.tot_cch11
   DISPLAY g_tot_cch12  TO FORMONLY.tot_cch12
   DISPLAY g_tot_cch21  TO FORMONLY.tot_cch21
   DISPLAY g_tot_cch22  TO FORMONLY.tot_cch22
   DISPLAY g_tot_cch31  TO FORMONLY.tot_cch31
   DISPLAY g_tot_cch32  TO FORMONLY.tot_cch32
   DISPLAY g_tot_cch41  TO FORMONLY.tot_cch41
   DISPLAY g_tot_cch42  TO FORMONLY.tot_cch42
   DISPLAY g_tot_cch91  TO FORMONLY.tot_cch91
   DISPLAY g_tot_cch92  TO FORMONLY.tot_cch92
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

   END DISPLAY

   ON ACTION page2
      LET g_action_choice = 'page2'
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
   ON ACTION ACCEPT
      LET l_ac = ARR_CURR() 
          LET g_b_flag2 = 1  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("po,chu", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("po,chu", TRUE)
      CALL act_page3()
      EXIT DIALOG

   ON ACTION data_filter
      LET g_action_choice="data_filter"
      EXIT DIALOG     

   ON ACTION revert_filter         
      LET g_action_choice="revert_filter"
      EXIT DIALOG 

   ON ACTION refresh_detail
      CALL q402()
      CALL q402_b_fill()
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG

   ON ACTION page3
      LET l_ac = ARR_CURR()
      LET g_b_flag2 = 1  LET g_b_flag3 = 1
      CALL cl_set_comp_visible("po,chu", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("po,chu", TRUE)
      CALL act_page3()
      EXIT DIALOG
    
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
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

   ON ACTION related_document 
      LET g_action_choice="related_document"          
      EXIT DIALOG

   AFTER DIALOG
      CONTINUE DIALOG

   ON ACTION controls                    
      CALL cl_set_head_visible("","AUTO")
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp2()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q402_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY ARRAY g_cch_1 TO s_cch_1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE DISPLAY
          EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a 
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         LET g_action_choice = "page2"
         DISPLAY  tm.a TO a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_cch_1 TO s_cch_1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

   END DISPLAY

   ON ACTION page1
      LET g_action_choice="page1"
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
   ON ACTION ACCEPT
      LET l_ac1 = ARR_CURR()
      IF l_ac1 > 0  THEN
         CALL q402_detail_fill(l_ac1)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_choice= "page1"  
         LET g_flag = '1'              
         EXIT DIALOG 
      END IF
   

   ON ACTION refresh_detail
      CALL q402()
      CALL q402_b_fill()
      CALL cl_set_comp_visible("page2,page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2,page3", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG
   ON ACTION page3
      LET l_ac = g_cch.getLength()
      IF l_ac > 0 THEN
         LET l_ac = 1
      END IF
      LET g_b_flag2 = 1  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("po,chu", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("po,chu", TRUE)
      CALL act_page3()
      EXIT DIALOG
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
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

   ON ACTION related_document 
      LET g_action_choice="related_document"          
      EXIT DIALOG

   AFTER DIALOG
      CONTINUE DIALOG

   ON ACTION controls                    
      CALL cl_set_head_visible("","AUTO")
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_cs()
   DEFINE  l_cnt LIKE type_file.num5   
 
   CLEAR FORM #清除畫面
   CALL g_cch.clear()
   CALL g_cch_1.clear() 
   CALL g_sfb.clear()
   CALL g_sfa.clear() 
   CALL g_sfp.clear()
   CALL g_sfs.clear() 
   CALL g_sfu.clear()
   CALL g_sfv.clear()   
   LET g_rec_b_sfb = 0 
   LET g_rec_b_sfa = 0 
   LET g_rec_b_sfp = 0 
   LET g_rec_b_sfs = 0 
   LET g_rec_b_sfu = 0 
   LET g_rec_b_sfv = 0 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_filter_wc = ''
   LET g_b_flag2 = ''
   LET tm.a = '1'   
   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   LET tm.type = g_ccz.ccz28
   LET g_int_flag = '0'
   LET g_pmk01_change_sfa = '0'
   LET g_pmk01_change_sfs = '0'
   LET g_pmk01_change_sfv = '0'
   LET g_pml02_change_pml = '0'
   LET g_pml02_change_pmn = '0'
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL cl_set_comp_visible("page2", FALSE)
   CALL cl_set_comp_visible("page3", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   CALL cl_set_comp_visible("page3", TRUE)

   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT tm.yy,tm.mm,tm.type,tm.a FROM yy,mm,type,a ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT 
            CALL q402_set_visible()
         AFTER FIELD yy
            IF NOT cl_null(tm.yy) AND (tm.yy<1000 OR tm.yy>9999) THEN
               CALL cl_err(tm.yy,'afa-370',0)
               NEXT FIELD yy
            END IF
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) AND tm.mm<1 OR tm.mm>12 THEN
               CALL cl_err(tm.mm,'agl-020',0)
               NEXT FIELD mm
            END IF
         ON CHANGE a
            CALL q402_set_visible()
      END INPUT
 
      CONSTRUCT tm.wc2
         ON cch01,sfb02,sfb99,sfb05,cch04,aag01,cch07,sfb98,          #FUN-D50084 add aag01
            cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,
            cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,
            cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,
            cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,
            cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92
       FROM s_cch[1].cch01 ,s_cch[1].sfb02 ,s_cch[1].sfb99 ,s_cch[1].sfb05 ,
            s_cch[1].cch04 ,s_cch[1].aag01,s_cch[1].cch07 ,s_cch[1].sfb98 ,   #FUN-D50084 add s_cch[1].aag01
            s_cch[1].cch11 ,s_cch[1].cch12a,s_cch[1].cch12b,s_cch[1].cch12c,s_cch[1].cch12d,
            s_cch[1].cch12e,s_cch[1].cch12f,s_cch[1].cch12g,s_cch[1].cch12h,s_cch[1].cch12 ,
            s_cch[1].cch21 ,s_cch[1].cch22a,s_cch[1].cch22b,s_cch[1].cch22c,s_cch[1].cch22d,
            s_cch[1].cch22e,s_cch[1].cch22f,s_cch[1].cch22g,s_cch[1].cch22h,s_cch[1].cch22 ,
            s_cch[1].cch31 ,s_cch[1].cch32a,s_cch[1].cch32b,s_cch[1].cch32c,s_cch[1].cch32d,
            s_cch[1].cch32e,s_cch[1].cch32f,s_cch[1].cch32g,s_cch[1].cch32h,s_cch[1].cch32 ,
            s_cch[1].cch41 ,s_cch[1].cch42a,s_cch[1].cch42b,s_cch[1].cch42c,s_cch[1].cch42d,
            s_cch[1].cch42e,s_cch[1].cch42f,s_cch[1].cch42g,s_cch[1].cch42h,s_cch[1].cch42 ,
            s_cch[1].cch91 ,s_cch[1].cch92a,s_cch[1].cch92b,s_cch[1].cch92c,s_cch[1].cch92d,
            s_cch[1].cch92e,s_cch[1].cch92f,s_cch[1].cch92g,s_cch[1].cch92h,s_cch[1].cch92 
            
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(cch01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_sfb"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cch01
                  NEXT FIELD cch01
 
             WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05      
         
            WHEN INFIELD(cch04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cch04
                 NEXT FIELD cch04 

             #FUN-D50084 add-----------str
             WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
             #FUN-D50084 add-----------end

            WHEN INFIELD(sfb98)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb98
                 NEXT FIELD sfb98
          END CASE
          
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
   END DIALOG          


   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      LET g_int_flag = '1'
      DELETE FROM axcq402_tmp
      RETURN 
   END IF
   CALL q402()
         
END FUNCTION 

FUNCTION q402_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q402_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"

    MESSAGE ""
    CALL q402_show()
END FUNCTION


FUNCTION q402_show()
   DISPLAY tm.a TO a
   DISPLAY tm.yy,tm.mm,tm.type,tm.a TO yy,mm,type,a
   IF cl_null(g_action_flag) OR g_action_flag="page2" THEN
      LET g_action_choice = "page2" 
      CALL cl_set_comp_visible("page1", FALSE)
      CALL cl_set_comp_visible("page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
      CALL cl_set_comp_visible("page3", TRUE)
      LET g_action_flag = "page2"
      CALL q402_b_fill_2()
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL cl_set_comp_visible("page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL cl_set_comp_visible("page3", TRUE)
      LET g_action_flag = "page1"
      CALL q402_b_fill() 
   END IF

   CALL q402_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q402_filter_askkey()
DEFINE l_wc   STRING
      CLEAR FORM
      CONSTRUCT l_wc 
         ON cch01,sfb02,sfb99,sfb05,cch04,aag01,cch07,sfb98,                            #FUN-D50084 add aag01
            cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,
            cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,
            cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,
            cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,
            cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92
       FROM s_cch[1].cch01 ,s_cch[1].sfb02 ,s_cch[1].sfb99 ,s_cch[1].sfb05 ,
            s_cch[1].cch04 ,s_cch[1].aag01 ,s_cch[1].cch07 ,s_cch[1].sfb98 ,             #FUN-D50084 add s_cch[1].aag01
            s_cch[1].cch11 ,s_cch[1].cch12a,s_cch[1].cch12b,s_cch[1].cch12c,s_cch[1].cch12d,
            s_cch[1].cch12e,s_cch[1].cch12f,s_cch[1].cch12g,s_cch[1].cch12h,s_cch[1].cch12 ,
            s_cch[1].cch21 ,s_cch[1].cch22a,s_cch[1].cch22b,s_cch[1].cch22c,s_cch[1].cch22d,
            s_cch[1].cch22e,s_cch[1].cch22f,s_cch[1].cch22g,s_cch[1].cch22h,s_cch[1].cch22 ,
            s_cch[1].cch31 ,s_cch[1].cch32a,s_cch[1].cch32b,s_cch[1].cch32c,s_cch[1].cch32d,
            s_cch[1].cch32e,s_cch[1].cch32f,s_cch[1].cch32g,s_cch[1].cch32h,s_cch[1].cch32 ,
            s_cch[1].cch41 ,s_cch[1].cch42a,s_cch[1].cch42b,s_cch[1].cch42c,s_cch[1].cch42d,
            s_cch[1].cch42e,s_cch[1].cch42f,s_cch[1].cch42g,s_cch[1].cch42h,s_cch[1].cch42 ,
            s_cch[1].cch91 ,s_cch[1].cch92a,s_cch[1].cch92b,s_cch[1].cch92c,s_cch[1].cch92d,
            s_cch[1].cch92e,s_cch[1].cch92f,s_cch[1].cch92g,s_cch[1].cch92h,s_cch[1].cch92 
            
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(cch01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_sfb"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cch01
                  NEXT FIELD cch01
 
             WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05      
         
            WHEN INFIELD(cch04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cch04
                 NEXT FIELD cch04 

             #FUN-D50084 add-----------str
             WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
             #FUN-D50084 add-----------end

            WHEN INFIELD(sfb98)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb98
                 NEXT FIELD sfb98
          END CASE
          
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

FUNCTION q402_table()
   CREATE TEMP TABLE axcq402_tmp(
                cch01     LIKE cch_file.cch01,
                sfb02     LIKE sfb_file.sfb02,
                sfb99     LIKE sfb_file.sfb99,
                sfb05     LIKE sfb_file.sfb05,
                ima02     LIKE ima_file.ima02,
                ima021    LIKE ima_file.ima021,
                ima57     LIKE ima_file.ima57,
                cch04     LIKE cch_file.cch04,
                ima02a    LIKE ima_file.ima02,
                ima021a   LIKE ima_file.ima021,
                aag01     LIKE aag_file.aag01,      #FUN-D50084 add
                aag02     LIKE aag_file.aag02,      #FUN-D50084 add
                cch07     LIKE cch_file.cch07,
                ima57a    LIKE ima_file.ima57,
                sfb98     LIKE sfb_file.sfb98,
                cch11     LIKE cch_file.cch11,
                cch12a    LIKE cch_file.cch12a,
                cch12b    LIKE cch_file.cch12b,
                cch12c    LIKE cch_file.cch12c,
                cch12d    LIKE cch_file.cch12d,
                cch12e    LIKE cch_file.cch12e,
                cch12f    LIKE cch_file.cch12f,
                cch12g    LIKE cch_file.cch12g,
                cch12h    LIKE cch_file.cch12h,
                cch12     LIKE cch_file.cch12,
                amt12     LIKE cch_file.cch12,
                cch21     LIKE cch_file.cch11,
                cch22a    LIKE cch_file.cch12a,
                cch22b    LIKE cch_file.cch12b,
                cch22c    LIKE cch_file.cch12c,
                cch22d    LIKE cch_file.cch12d,
                cch22e    LIKE cch_file.cch12e,
                cch22f    LIKE cch_file.cch12f,
                cch22g    LIKE cch_file.cch12g,
                cch22h    LIKE cch_file.cch12h,
                cch22     LIKE cch_file.cch12,
                amt22     LIKE cch_file.cch12,
                cch31     LIKE cch_file.cch11,
                cch32a    LIKE cch_file.cch12a,
                cch32b    LIKE cch_file.cch12b,
                cch32c    LIKE cch_file.cch12c,
                cch32d    LIKE cch_file.cch12d,
                cch32e    LIKE cch_file.cch12e,
                cch32f    LIKE cch_file.cch12f,
                cch32g    LIKE cch_file.cch12g,
                cch32h    LIKE cch_file.cch12h,
                cch32     LIKE cch_file.cch12,
                amt32     LIKE cch_file.cch12,
                cch41     LIKE cch_file.cch11,
                cch42a    LIKE cch_file.cch12a,
                cch42b    LIKE cch_file.cch12b,
                cch42c    LIKE cch_file.cch12c,
                cch42d    LIKE cch_file.cch12d,
                cch42e    LIKE cch_file.cch12e,
                cch42f    LIKE cch_file.cch12f,
                cch42g    LIKE cch_file.cch12g,
                cch42h    LIKE cch_file.cch12h,
                cch42     LIKE cch_file.cch12,
                amt42     LIKE cch_file.cch12,
                cch91     LIKE cch_file.cch11,
                cch92a    LIKE cch_file.cch12a,
                cch92b    LIKE cch_file.cch12b,
                cch92c    LIKE cch_file.cch12c,
                cch92d    LIKE cch_file.cch12d,
                cch92e    LIKE cch_file.cch12e,
                cch92f    LIKE cch_file.cch12f,
                cch92g    LIKE cch_file.cch12g,
                cch92h    LIKE cch_file.cch12h,
                cch92     LIKE cch_file.cch12,
                amt92     LIKE cch_file.cch12); 

END FUNCTION 

FUNCTION q402()
   DEFINE l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,          
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5              
   DEFINE l_wc,l_msg,l_wc1 STRING 
   DEFINE l_num    LIKE type_file.num5
   DEFINE l_apb09  LIKE apb_file.apb09
   DEFINE l_apb24  LIKE apb_file.apb24
   DEFINE l_day    LIKE type_file.dat
   DEFINE l_wc_ccu         STRING 
   DEFINE l_wc_cce         STRING 
   DEFINE g_filter_wc_ccu  STRING 
   DEFINE g_filter_wc_cce  STRING
   DEFINE l_n      LIKE type_file.num5
   #FUN-D50084 add----------str
   DEFINE l_flag   LIKE type_file.chr1,
          l_bookno1  LIKE aza_file.aza81,
          l_bookno2  LIKE aza_file.aza82
   #FUN-D50084 add----------end
                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
   DELETE FROM axcq402_tmp

   LET l_wc = ''
   IF cl_null(tm.wc2) THEN LET tm.wc2=" 1=1" END IF 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   IF cl_null(l_wc) THEN LET l_wc =' 1=1' END IF 
   LET l_wc_ccu=cl_replace_str(tm.wc2,'cch','ccu')
   LET l_wc_cce=cl_replace_str(tm.wc2,'cch','cce')
   LET g_filter_wc_ccu=cl_replace_str(g_filter_wc,'cch','ccu')
   LET g_filter_wc_cce=cl_replace_str(g_filter_wc,'cch','cce')

   #cch01,sfb02,sfb99,ccg04,ima02,ima021,ima57,
   #cch04,ima02a,ima021a,cch07,ima57a,sfb98,
   #cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,amt12,
   #cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,amt22,
   #cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,amt32,
   #cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,amt42,
   #cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,amt92
   #FUN-D50084 add--------------------str
   SELECT ccz07 INTO g_ccz.ccz07 FROM ccz_file  WHERE ccz00 = '0' 
   LET l_bookno1 = ' '
   CALL s_get_bookno(tm.yy) RETURNING l_flag,l_bookno1,l_bookno2
   CASE g_ccz.ccz07
      WHEN '1' 
         LET tm.wc2 = cl_replace_str(tm.wc2,'aag01','b.ima39')
         LET g_filter_wc = cl_replace_str(g_filter_wc,'aag01','b.ima39')
         LET l_sql = "SELECT nvl(trim(cch01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99,",
                     "       nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
                     "       nvl(trim(cch04),'') cch04,b.ima02 ima02a,b.ima021 ima021a,",
                     "       b.ima39 aag01,' ' aag02, ",
                     "       nvl(trim(cch07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
                     "       cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,0 amt12, ",
                     "       cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,0 amt22, ",
                     "       cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,0 amt32, ",
                     "       cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,0 amt42, ",
                     "       cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,0 amt92  ",
                     "  FROM cch_file LEFT OUTER JOIN sfb_file ON sfb01=cch01 ",
                     "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
                     "                LEFT OUTER JOIN ima_file b ON cch04=b.ima01 ",
                     " WHERE cch02= '",tm.yy,"' AND cch03= '",tm.mm,"' AND cch06 = '",tm.type,"' ",  #free tm.type
                     "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
      WHEN '2' 
         LET tm.wc2 = cl_replace_str(tm.wc2,'aag01','imz39')
         LET g_filter_wc = cl_replace_str(g_filter_wc,'aag01','imz39')
         LET l_sql = "SELECT nvl(trim(cch01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99,",
                     "       nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
                     "       nvl(trim(cch04),'') cch04,b.ima02 ima02a,b.ima021 ima021a, ",
                     "       imz39 aag01,' ' aag02, ",
                     "       nvl(trim(cch07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98, ",
                     "       cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,0 amt12, ",
                     "       cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,0 amt22, ",
                     "       cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,0 amt32, ",
                     "       cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,0 amt42, ",
                     "       cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,0 amt92  ",
                     "  FROM cch_file LEFT OUTER JOIN sfb_file ON sfb01=cch01 ",
                     "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
                     "                LEFT OUTER JOIN ima_file b ON cch04=b.ima01 ",
                     "                LEFT OUTER JOIN imz_file   ON imz01=b.ima06 ",
                     " WHERE cch02= '",tm.yy,"' AND cch03= '",tm.mm,"' AND cch06 = '",tm.type,"' ",  #free tm.type
                     "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
      WHEN '3' 
         LET tm.wc2 = cl_replace_str(tm.wc2,'aag01','imd08')
         LET g_filter_wc = cl_replace_str(g_filter_wc,'aag01','imd08')
         LET l_sql = "SELECT nvl(trim(cch01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99, ",
                     "       nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
                     "       nvl(trim(cch04),'') cch04,b.ima02 ima02a,b.ima021 ima021a, ",
                     "       imd08 aag01,' ' aag02, ",
                     "       nvl(trim(cch07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
                     "       cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,0 amt12, ",
                     "       cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,0 amt22, ",
                     "       cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,0 amt32, ",
                     "       cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,0 amt42, ",
                     "       cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,0 amt92  ",
                     "  FROM cch_file LEFT OUTER JOIN sfb_file ON sfb01=cch01 ",
                     "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
                     "                LEFT OUTER JOIN ima_file b ON cch04=b.ima01 ",
                     "                LEFT OUTER JOIN imd_file   ON imd01=b.ima35 ",
                     " WHERE cch02= '",tm.yy,"' AND cch03= '",tm.mm,"' AND cch06 = '",tm.type,"' ",  #free tm.type
                     "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
      WHEN '4' 
         LET tm.wc2 = cl_replace_str(tm.wc2,'aag01','ime09')
         LET g_filter_wc = cl_replace_str(g_filter_wc,'aag01','ime09')
         LET l_sql = "SELECT nvl(trim(cch01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99, ",
                     "       nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
                     "       nvl(trim(cch04),'') cch04,b.ima02 ima02a,b.ima021 ima021a, ",
                     "       ime09 aag01,' ' aag02, ",
                     "       nvl(trim(cch07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
                     "       cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,0 amt12, ",
                     "       cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,0 amt22, ",
                     "       cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,0 amt32, ",
                     "       cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,0 amt42, ",
                     "       cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,0 amt92  ",
                     "  FROM cch_file LEFT OUTER JOIN sfb_file ON sfb01=cch01 ",
                     "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
                     "                LEFT OUTER JOIN ima_file b ON cch04=b.ima01 ",
                     "                LEFT OUTER JOIN ime_file   ON ime01=b.ima35 AND ime02 = b.ima36 ",
                     " WHERE cch02= '",tm.yy,"' AND cch03= '",tm.mm,"' AND cch06 = '",tm.type,"' ",  #free tm.type
                     "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
   END CASE
   #FUN-D50084 add--------------------end
  ##FUN-D50084 mark-------------------str
  #LET l_sql = "SELECT nvl(trim(cch01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99,nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
  #            "       nvl(trim(cch04),''):cch04,b.ima02 ima02a,b.ima021 ima021a,nvl(trim(cch07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
  #            "       cch11,cch12a,cch12b,cch12c,cch12d,cch12e,cch12f,cch12g,cch12h,cch12,0 amt12, ",
  #            "       cch21,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h,cch22,0 amt22, ",
  #            "       cch31,cch32a,cch32b,cch32c,cch32d,cch32e,cch32f,cch32g,cch32h,cch32,0 amt32, ",
  #            "       cch41,cch42a,cch42b,cch42c,cch42d,cch42e,cch42f,cch42g,cch42h,cch42,0 amt42, ",
  #            "       cch91,cch92a,cch92b,cch92c,cch92d,cch92e,cch92f,cch92g,cch92h,cch92,0 amt92  ",
  #            "  FROM cch_file LEFT OUTER JOIN sfb_file ON sfb01=cch01 ",
  #            "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
  #            "                LEFT OUTER JOIN ima_file b ON cch04=b.ima01 ",
  #            " WHERE cch02= '",tm.yy,"' AND cch03= '",tm.mm,"' AND cch06 = '",tm.type,"' ",  #free tm.type
  #            "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
  ##FUN-D50084 mark-------------------str

  # LET l_sql = l_sql ,"  UNION ",
  #             "SELECT nvl(trim(ccu01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99,nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
  #             "       nvl(trim(ccu04),'') cch04,b.ima02 ima02a,b.ima021 ima021a,nvl(trim(ccu07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
  #             "       ccu11 cch11,ccu12a cch12a,ccu12b cch12b,ccu12c cch12c,ccu12d cch12d,ccu12e cch12e,ccu12f cch12f,ccu12g cch12g,ccu12h cch12h,ccu12 cch12,0 amt12, ",
  #             "       ccu21 cch21,ccu22a cch22a,ccu22b cch22b,ccu22c cch22c,ccu22d cch22d,ccu22e cch22e,ccu22f cch22f,ccu22g cch22g,ccu22h cch22h,ccu22 cch22,0 amt22, ",
  #             "       ccu31 cch31,ccu32a cch32a,ccu32b cch32b,ccu32c cch32c,ccu32d cch32d,ccu32e cch32e,ccu32f cch32f,ccu32g cch32g,ccu32h cch32h,ccu32 cch32,0 amt32, ",
  #             "       ccu41 cch41,ccu42a cch42a,ccu42b cch42b,ccu42c cch42c,ccu42d cch42d,ccu42e cch42e,ccu42f cch42f,ccu42g cch42g,ccu42h cch42h,ccu42 cch42,0 amt42, ",
  #             "       ccu91 cch91,ccu92a cch92a,ccu92b cch92b,ccu92c cch92c,ccu92d cch92d,ccu92e cch92e,ccu92f cch92f,ccu92g cch92g,ccu92h cch92h,ccu92 cch92,0 amt92  ",
  #             "  FROM ccu_file LEFT OUTER JOIN sfb_file ON sfb01=ccu01 ",
  #             "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
  #             "                LEFT OUTER JOIN ima_file b ON ccu04=b.ima01 ",
  #             " WHERE ccu02= '",tm.yy,"' AND ccu03= '",tm.mm,"' AND ccu06 = '",tm.type,"'  ", 
  #             "   AND ",l_wc_ccu CLIPPED," AND ",g_filter_wc_ccu CLIPPED

  # LET l_sql = l_sql ,"  UNION ",
  #             "SELECT nvl(trim(cce01),'') cch01,nvl(trim(sfb02),'') sfb02,sfb99,nvl(trim(sfb05),'') sfb05,a.ima02 ima02,a.ima021 ima021,a.ima57 ima57, ",
  #             "       nvl(trim(cce04),'') cch04,b.ima02 ima02a,b.ima021 ima021a,nvl(trim(cce07),'') cch07,b.ima57 ima57a,nvl(trim(sfb98),'') sfb98,",
  #             "       cce11 cch11,cce12a cch12a,cce12b cch12b,cce12c cch12c,cce12d cch12d,cce12e cch12e,cce12f cch12f,cce12g cch12g,cce12h cch12h,cce12 cch12,0 amt12, ",
  #             "       cce21 cch21,cce22a cch22a,cce22b cch22b,cce22c cch22c,cce22d cch22d,cce22e cch22e,cce22f cch22f,cce22g cch22g,cce22h cch22h,cce22 cch22,0 amt22, ",
  #             "       0 cch31,0 cch32a,0 cch32b,0 cch32c,0 cch32d,0 cch32e,0 cch32f,0 cch32g,0 cch32h,0 cch32,0 amt32, ",
  #             "       0 cch41,0 cch42a,0 cch42b,0 cch42c,0 cch42d,0 cch42e,0 cch42f,0 cch42g,0 cch42h,0 cch42,0 amt42, ",
  #             "       cce91 cch91,cce92a cch92a,cce92b cch92b,cce92c cch92c,cce92d cch92d,cce92e cch92e,cce92f cch92f,cce92g cch92g,cce92h cch92h,cce92 cch92,0 amt92  ",
  #             "  FROM cce_file LEFT OUTER JOIN sfb_file ON sfb01=cce01 ",
  #             "                LEFT OUTER JOIN ima_file a ON sfb05=a.ima01 ",
  #             "                LEFT OUTER JOIN ima_file b ON cce04=b.ima01 ",
  #             " WHERE cce02= '",tm.yy,"' AND cce03= '",tm.mm,"' AND cce06 = '",tm.type,"'  ", 
  #             "   AND ",l_wc_cce CLIPPED," AND ",g_filter_wc_cce CLIPPED


   LET l_sql = " INSERT INTO axcq402_tmp SELECT x.* FROM (",l_sql CLIPPED ," ) x "
   PREPARE q402_ins FROM l_sql
   EXECUTE q402_ins

   #FUN-D50084 add--------------------str
   LET l_sql = " UPDATE axcq402_tmp o ",
               "    SET o.aag02 = (SELECT DISTINCT aag02 FROM aag_file x ",
               "                    WHERE x.aag01 = o.aag01 AND x.aag00 ='",l_bookno1,"') "
   PREPARE q402_upd_0 FROM l_sql
   EXECUTE q402_upd_0
   #FUN-D50084 add--------------------end

   LET l_sql = " UPDATE axcq402_tmp ",
               "    SET amt12 = nvl(cch12/cch11,0) ",
               "  WHERE cch11 <> 0  "
   PREPARE q402_upd_1 FROM l_sql
   EXECUTE q402_upd_1

   LET l_sql = " UPDATE axcq402_tmp ",
               "    SET amt22 = nvl(cch22/cch21,0)  ",
               "  WHERE cch21 <> 0  "
   PREPARE q402_upd_2 FROM l_sql
   EXECUTE q402_upd_2

   LET l_sql = " UPDATE axcq402_tmp ",
               "    SET amt32 = nvl(cch32/cch31,0)  ",
               "  WHERE cch31 <> 0  "
   PREPARE q402_upd_3 FROM l_sql
   EXECUTE q402_upd_3

   LET l_sql = " UPDATE axcq402_tmp ",
               "    SET amt42 = nvl(cch42/cch41,0)  ",
               "  WHERE cch41 <> 0  "
   PREPARE q402_upd_4 FROM l_sql
   EXECUTE q402_upd_4

   LET l_sql = " UPDATE axcq402_tmp ",
               "    SET amt92 = nvl(cch92/cch91,0)  ",
               "  WHERE cch91 <> 0  "
   PREPARE q402_upd_5 FROM l_sql
   EXECUTE q402_upd_5

END FUNCTION 

FUNCTION q402_get_sum()
DEFINE     l_wc     STRING
DEFINE     l_sql    STRING

   CASE tm.a
      WHEN '1'   #单号
         LET l_sql = 
               "SELECT cch01,'','','','', ",
               "       '','','','','','',",                #FUN-D50084 add '',''
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY cch01 ",
               " ORDER BY cch01 "
      WHEN '2'   #主件料號
         LET l_sql = 
               "SELECT '','',sfb05,ima02,ima021, ",
               "       '','','','','','',",                  #FUN-D50084 add '',''
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY sfb05,ima02,ima021 ",
               " ORDER BY sfb05,ima02,ima021 "
      WHEN '3'   #元件料號
         LET l_sql = 
               "SELECT '','','','','', ",
               "       cch04,ima02a,ima021a,'','','',",           #FUN-D50084 add '',''
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY cch04,ima02a,ima021a ",
               " ORDER BY cch04,ima02a,ima021a "
      WHEN '4'   #成本中心
         LET l_sql = 
               "SELECT '','','','','', ",
               "       '','','','','',sfb98,",              #FUN-D50084 add '',''
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY sfb98 ",
               " ORDER BY sfb98 "
      WHEN '5'   #部门
         LET l_sql = 
               "SELECT '',sfb02,'','','', ",
               "       '','','','','','',",         #FUN-D50084 add '',''
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY sfb02 ",
               " ORDER BY sfb02 "
      #FUN-D50084 add----------------------str
      WHEN '6'   #元件科目
         LET l_sql =
               "SELECT '','','','','', ",
               "       '','','',aag01,aag02,'',",
               "       sum(cch11) ,sum(cch12a),sum(cch12b),sum(cch12c),sum(cch12d),",
               "       sum(cch12e),sum(cch12f),sum(cch12g),sum(cch12h),sum(cch12), ",
               "       sum(cch21) ,sum(cch22a),sum(cch22b),sum(cch22c),sum(cch22d),",
               "       sum(cch22e),sum(cch22f),sum(cch22g),sum(cch22h),sum(cch22), ",
               "       sum(cch31) ,sum(cch32a),sum(cch32b),sum(cch32c),sum(cch32d),",
               "       sum(cch32e),sum(cch32f),sum(cch32g),sum(cch32h),sum(cch32), ",
               "       sum(cch41) ,sum(cch42a),sum(cch42b),sum(cch42c),sum(cch42d),",
               "       sum(cch42e),sum(cch42f),sum(cch42g),sum(cch42h),sum(cch42), ",
               "       sum(cch91) ,sum(cch92a),sum(cch92b),sum(cch92c),sum(cch92d),",
               "       sum(cch92e),sum(cch92f),sum(cch92g),sum(cch92h),sum(cch92)  ",
               " FROM axcq402_tmp ",
               " GROUP BY aag01,aag02 ",
               " ORDER BY aag01 "
      #FUN-D50084 add----------------------end
   END CASE 

   PREPARE q402_pb FROM l_sql
   DECLARE q402_curs1 CURSOR FOR q402_pb
   FOREACH q402_curs1 INTO g_cch_1[g_cnt].*
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
   SELECT SUM(cch11),SUM(cch12),SUM(cch21),SUM(cch22),SUM(cch31),SUM(cch32), 
               SUM(cch41),SUM(cch42),SUM(cch91),SUM(cch92) 
     INTO g_tot_cch11,g_tot_cch12,g_tot_cch21,g_tot_cch22,g_tot_cch31,
          g_tot_cch32,g_tot_cch41,g_tot_cch42,g_tot_cch91,g_tot_cch92
     FROM axcq402_tmp 
   CALL g_cch_1.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   DISPLAY ARRAY g_cch_1 TO s_cch_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   LET g_rec_b2 = g_cnt 
   DISPLAY g_rec_b2   TO FORMONLY.cnt1 
   DISPLAY g_tot_cch11  TO FORMONLY.tot1_cch11
   DISPLAY g_tot_cch12  TO FORMONLY.tot1_cch12
   DISPLAY g_tot_cch21  TO FORMONLY.tot1_cch21
   DISPLAY g_tot_cch22  TO FORMONLY.tot1_cch22
   DISPLAY g_tot_cch31  TO FORMONLY.tot1_cch31
   DISPLAY g_tot_cch32  TO FORMONLY.tot1_cch32
   DISPLAY g_tot_cch41  TO FORMONLY.tot1_cch41
   DISPLAY g_tot_cch42  TO FORMONLY.tot1_cch42
   DISPLAY g_tot_cch91  TO FORMONLY.tot1_cch91
   DISPLAY g_tot_cch92  TO FORMONLY.tot1_cch92
END FUNCTION  

FUNCTION q402_detail_fill(p_ac)
DEFINE p_ac         LIKE type_file.num5,
       l_sql        STRING, 
       l_tmp        STRING,
       l_sql_tot    STRING,
       l_sql_tmp    STRING 

   LET l_sql_tmp = "SELECT SUM(cch11),SUM(cch12),SUM(cch21),SUM(cch22),SUM(cch31),SUM(cch32), ",
                   "       SUM(cch41),SUM(cch42),SUM(cch91),SUM(cch92)   ",
                   "  FROM axcq402_tmp  " 
   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_cch_1[p_ac].cch01) THEN 
            LET g_cch_1[p_ac].cch01 = ''
            LET l_tmp = " OR cch01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (cch01='",g_cch_1[p_ac].cch01,"' ",l_tmp," )",
                     " ORDER BY cch01 "
         LET l_sql_tot = l_sql_tmp, " WHERE (cch01='",g_cch_1[p_ac].cch01,"' ",l_tmp," )"
                     
      WHEN "2"
         IF cl_null(g_cch_1[p_ac].sfb05) THEN 
            LET g_cch_1[p_ac].sfb05 = ''
            LET l_tmp = " OR sfb05 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (sfb05='",g_cch_1[p_ac].sfb05,"' ",l_tmp," )",
                     " ORDER BY sfb05 "
         LET l_sql_tot = l_sql_tmp,"  WHERE (sfb05='",g_cch_1[p_ac].sfb05,"' ",l_tmp," )"
         
      WHEN "3"
         IF cl_null(g_cch_1[p_ac].cch04) THEN 
            LET g_cch_1[p_ac].cch04 = ''
            LET l_tmp = " OR cch04 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (cch04='",g_cch_1[p_ac].cch04,"' ",l_tmp," )",
                     " ORDER BY cch04 "
         LET l_sql_tot = l_sql_tmp," WHERE (cch04='",g_cch_1[p_ac].cch04,"' ",l_tmp," )"
         
      WHEN "4"
         IF cl_null(g_cch_1[p_ac].sfb98) THEN 
            LET g_cch_1[p_ac].sfb98 = ''
            LET l_tmp = " OR sfb98 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (sfb98='",g_cch_1[p_ac].sfb98,"' ",l_tmp," )",
                     " ORDER BY sfb98 "
         LET l_sql_tot = l_sql_tmp," WHERE (sfb98='",g_cch_1[p_ac].sfb98,"' ",l_tmp," )"
         
      WHEN "5"
         IF cl_null(g_cch_1[p_ac].sfb02a) THEN 
            LET g_cch_1[p_ac].sfb02a = ''
            LET l_tmp = " OR sfb02 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (sfb02='",g_cch_1[p_ac].sfb02a,"' ",l_tmp," )",
                     " ORDER BY sfb02 "
         LET l_sql_tot = l_sql_tmp," WHERE (sfb02='",g_cch_1[p_ac].sfb02a,"' ",l_tmp," )"
      #FUN-D50084 add----------------------str
      WHEN "5"
         IF cl_null(g_cch_1[p_ac].aag01) THEN
            LET g_cch_1[p_ac].aag01 = ''
            LET l_tmp = " OR aag01 IS NULL "
         ELSE
            LET l_tmp = ''
         END IF
         LET l_sql = "SELECT * FROM axcq402_tmp WHERE (aag01='",g_cch_1[p_ac].aag01,"' ",l_tmp," )",
                     " ORDER BY aag01 "
         LET l_sql_tot = l_sql_tmp," WHERE (aag01='",g_cch_1[p_ac].aag01,"' ",l_tmp," )"
      #FUN-D50084 add----------------------end
   END CASE

      PREPARE axcq402_pb_detail FROM l_sql
      DECLARE cch_curs_detail  CURSOR FOR axcq402_pb_detail        #CURSOR
      CALL g_cch.clear()
      CALL g_cch_excel.clear()
      LET g_cnt = 1
      LET g_rec_b = 0
      FOREACH cch_curs_detail INTO g_cch_excel[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF g_cnt <= g_max_rec THEN
            LET g_cch[g_cnt].* = g_cch_excel[g_cnt].*
         END IF
         LET g_cnt = g_cnt + 1  
      END FOREACH
      IF g_cnt <= g_max_rec THEN
         CALL g_cch.deleteElement(g_cnt)
      END IF
      CALL g_cch_excel.deleteElement(g_cnt)
      LET g_rec_b = g_cnt -1
      IF g_rec_b > g_max_rec THEN
         CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
         LET g_rec_b = g_max_rec
      END IF

      PREPARE axcq402_pb_tot FROM l_sql_tot
      DECLARE cch_curs_tot  CURSOR FOR axcq402_pb_tot        #CURSOR
      OPEN cch_curs_tot
      FETCH cch_curs_tot INTO g_tot_cch11,g_tot_cch12,g_tot_cch21,g_tot_cch22,g_tot_cch31,
                              g_tot_cch32,g_tot_cch41,g_tot_cch42,g_tot_cch91,g_tot_cch92
      DISPLAY g_rec_b TO FORMONLY.cnt  
      DISPLAY g_tot_cch11  TO FORMONLY.tot_cch11
      DISPLAY g_tot_cch12  TO FORMONLY.tot_cch12
      DISPLAY g_tot_cch21  TO FORMONLY.tot_cch21
      DISPLAY g_tot_cch22  TO FORMONLY.tot_cch22
      DISPLAY g_tot_cch31  TO FORMONLY.tot_cch31
      DISPLAY g_tot_cch32  TO FORMONLY.tot_cch32
      DISPLAY g_tot_cch41  TO FORMONLY.tot_cch41
      DISPLAY g_tot_cch42  TO FORMONLY.tot_cch42
      DISPLAY g_tot_cch91  TO FORMONLY.tot_cch91
      DISPLAY g_tot_cch92  TO FORMONLY.tot_cch92
END FUNCTION 

FUNCTION q402_set_visible()
CALL cl_set_comp_visible("cch01_1,sfb02a_1,sfb05_1,ima02_1,ima021_1",TRUE)
CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,aag01_1,aag02_1,sfb98_1",TRUE)   #FUN-D50084 add aag01_1,aag02_1

IF cl_null(tm.a) THEN LET tm.a = 1 END IF 
CASE tm.a 
   WHEN "1"
      CALL cl_set_comp_visible("sfb02a_1,sfb05_1,ima02_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,aag01_1,aag02_1,sfb98_1",FALSE)   #FUN-D50084 add aag01_1,aag02_1
   WHEN "2"
        CALL cl_set_comp_visible("cch01_1,sfb02a_1",FALSE)
      CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,aag01_1,aag02_1,sfb98_1",FALSE)   #FUN-D50084 add aag01_1,aag02_1
   WHEN "3"
      CALL cl_set_comp_visible("cch01_1,sfb02a_1,sfb05_1,ima02_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("aag01_1,aag02_1,sfb98_1",FALSE)                              #FUN-D50084 add aag01_1,aag02_1
   WHEN "4"
      CALL cl_set_comp_visible("cch01_1,sfb02a_1,sfb05_1,ima02_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,aag01_1,aag02_1",FALSE)           #FUN-D50084 add aag01_1,aag02_1
   WHEN "5"
      CALL cl_set_comp_visible("cch01_1,sfb05_1,ima02_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,aag01_1,aag02_1,sfb98_1",FALSE)   #FUN-D50084 add aag01_1,aag02_1
   #FUN-D50084 add--------------str
   WHEN "6"
      CALL cl_set_comp_visible("cch01_1,sfb02a_1,sfb05_1,ima02_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("cch04_1,ima02a_1,ima021a_1,sfb98_1",FALSE)
   #FUN-D50084 add--------------end
END CASE

END FUNCTION 

FUNCTION q402_bp3()
   DEFINE   p_ud   LIKE type_file.chr1        

   LET g_action_choice = " "
   LET g_action_flag = "page3"
   DISPLAY BY NAME g_head.cch01_2,g_head.sfb02a_2,g_head.sfb99_2,g_head.sfb05_2,
                   g_head.ima02_2,g_head.ima021_2,g_head.ima57_2,g_head.sfb98_2

   CASE g_b_flag2
      WHEN 1
        CALL q402_bp_pr()
      WHEN 2
        CALL q402_bp_po()
      WHEN 3
        CALL q402_bp_chu()
      OTHERWISE
          CALL q402_bp_pr()
   END CASE

END FUNCTION

FUNCTION q402_bp_pr()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q402_bp_sfb()
      WHEN 2
        CALL q402_bp_sfa()
      OTHERWISE
        CALL q402_bp_sfb()
   END CASE

END FUNCTION

FUNCTION q402_bp_po()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q402_bp_sfp()
      WHEN 2
        CALL q402_bp_sfs()
      OTHERWISE
        CALL q402_bp_sfp()
   END CASE

END FUNCTION

FUNCTION q402_bp_chu()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q402_bp_sfu()
      WHEN 2
        CALL q402_bp_sfv()
      OTHERWISE
        CALL q402_bp_sfu()
   END CASE

END FUNCTION

FUNCTION q402_bp_sfb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfb TO FORMONLY.cn2
   CALL cl_set_comp_visible("sfa", FALSE)
   CALL g_sfa.clear()
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("sfa", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_sfa = '1' OR g_pml02_change_pml = '1' THEN
      LET g_pmk01_change_sfa = '0' 
      LET g_pml02_change_pml = '0'
      CALL  g_sfa.clear()
      INITIALIZE g_head_sfa.* TO NULL 
      LET g_rec_b_sfa = ''

      DISPLAY g_head_sfa.sfb01_sfa   TO FORMONLY.sfb01_sfa
      DISPLAY g_head_sfa.sfb08_sfa   TO FORMONLY.sfb08_sfa
      DISPLAY g_head_sfa.sfb81_sfa   TO FORMONLY.sfb81_sfa
      DISPLAY g_head_sfa.sfb82_sfa   TO FORMONLY.sfb82_sfa
      DISPLAY g_head_sfa.pmc03_sfa   TO FORMONLY.pmc03_sfa
      DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)  #free ??
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
   END IF
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b_sfb)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b_sfb)

      BEFORE DISPLAY
         IF l_ac_sfb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfb)
         END IF
         
      BEFORE ROW
        LET l_ac_sfb = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfa
         LET l_ac_sfb = ARR_CURR()
         IF l_ac_sfb > 0 THEN
            LET g_head_sfa.sfb01_sfa   = g_head.cch01_2
            LET g_head_sfa.sfb08_sfa   = g_sfb[l_ac_sfb].sfb08
            LET g_head_sfa.sfb81_sfa   = g_sfb[l_ac_sfb].sfb81
            LET g_head_sfa.sfb82_sfa   = g_sfb[l_ac_sfb].sfb82
            LET g_head_sfa.pmc03_sfa   = g_sfb[l_ac_sfb].pmc03_sfb
            LET g_b_flag3 = 2
            LET g_action_choice = "sfa"
         END IF
         EXIT DIALOG       

      ON ACTION ACCEPT
         LET l_ac_sfb = ARR_CURR()
         IF l_ac_sfb > 0 THEN
            LET g_head_sfa.sfb01_sfa   = g_head.cch01_2
            LET g_head_sfa.sfb08_sfa   = g_sfb[l_ac_sfb].sfb08
            LET g_head_sfa.sfb81_sfa   = g_sfb[l_ac_sfb].sfb81
            LET g_head_sfa.sfb82_sfa   = g_sfb[l_ac_sfb].sfb82
            LET g_head_sfa.pmc03_sfa   = g_sfb[l_ac_sfb].pmc03_sfb
            LET g_b_flag3 = 2
            LET g_action_choice = "sfa"
            CALL cl_set_comp_visible("sfb", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("sfb", TRUE)
         END IF
         EXIT DIALOG  
         
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "sfp"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "sfu"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp_sfa()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfa TO FORMONLY.cn2
      DISPLAY g_head_sfa.sfb01_sfa   TO FORMONLY.sfb01_sfa
      DISPLAY g_head_sfa.sfb08_sfa   TO FORMONLY.sfb08_sfa
      DISPLAY g_head_sfa.sfb81_sfa   TO FORMONLY.sfb81_sfa
      DISPLAY g_head_sfa.sfb82_sfa   TO FORMONLY.sfb82_sfa
      DISPLAY g_head_sfa.pmc03_sfa   TO FORMONLY.pmc03_sfa
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a 
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)

      BEFORE DISPLAY
         IF l_ac_sfa != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfa)
         END IF

      BEFORE ROW
        LET l_ac_sfa = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()  
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfb
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG

      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "sfp"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "sfu"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp_sfp()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfp TO FORMONLY.cn2
   CALL cl_set_comp_visible("sfs", FALSE)
   CALL g_sfs.clear()
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("sfs", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_sfs = '1' OR g_pml02_change_pmn = '1' THEN
      LET g_pmk01_change_sfs = '0' 
      LET g_pml02_change_pmn = '0'
      CALL  g_sfs.clear()
      INITIALIZE g_head_sfs.* TO NULL 
      LET g_rec_b_sfs = ''
      DISPLAY g_head_sfs.sfp01_sfs TO FORMONLY.sfp01_sfs
      DISPLAY g_head_sfs.sfp06_sfs TO FORMONLY.sfp06_sfs
      DISPLAY g_head_sfs.sfp07_sfs TO FORMONLY.sfp07_sfs
      DISPLAY g_head_sfs.gem02_sfs TO FORMONLY.gem02a_sfs
      DISPLAY g_head_sfs.sfp16_sfs TO FORMONLY.sfp16_sfs
      DISPLAY g_head_sfs.gen02_sfs TO FORMONLY.gen02_sfs
      DISPLAY g_head_sfs.sfpconf_sfs TO FORMONLY.sfpconf_sfs
      DISPLAY g_head_sfs.sfp04_sfs TO FORMONLY.sfp04_sfs
      DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b_sfs)
      BEFORE DISPLAY
         EXIT DISPLAY 
      END DISPLAY
   END IF
   DISPLAY ARRAY g_sfp TO s_sfp.* ATTRIBUTE(COUNT=g_rec_b_sfp)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfp TO s_sfp.* ATTRIBUTE(COUNT=g_rec_b_sfp)

      BEFORE DISPLAY
         IF l_ac_sfp != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfp)
         END IF

      BEFORE ROW
        LET l_ac_sfp = ARR_CURR()
        CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about       
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfs
         LET l_ac_sfp = ARR_CURR()
         IF l_ac_sfp > 0 THEN
            LET g_head_sfs.sfp01_sfs = g_sfp[l_ac_sfp].sfp01
            LET g_head_sfs.sfp06_sfs = g_sfp[l_ac_sfp].sfp06
            LET g_head_sfs.sfp07_sfs = g_sfp[l_ac_sfp].sfp07
            LET g_head_sfs.gem02_sfs = g_sfp[l_ac_sfp].gem02_sfp
            LET g_head_sfs.sfp16_sfs = g_sfp[l_ac_sfp].sfp16
            LET g_head_sfs.gen02_sfs = g_sfp[l_ac_sfp].gen02_sfp
            LET g_head_sfs.sfpconf_sfs=g_sfp[l_ac_sfp].sfpconf
            LET g_head_sfs.sfp04_sfs = g_sfp[l_ac_sfp].sfp04
            LET g_b_flag3 = 2
            LET g_action_choice = "sfs"
         END IF
         EXIT DIALOG

      ON ACTION ACCEPT
         LET l_ac_sfp = ARR_CURR()
         IF l_ac_sfp > 0 THEN
            LET g_head_sfs.sfp01_sfs = g_sfp[l_ac_sfp].sfp01
            LET g_head_sfs.sfp06_sfs = g_sfp[l_ac_sfp].sfp06
            LET g_head_sfs.sfp07_sfs = g_sfp[l_ac_sfp].sfp07
            LET g_head_sfs.gem02_sfs = g_sfp[l_ac_sfp].gem02_sfp
            LET g_head_sfs.sfp16_sfs = g_sfp[l_ac_sfp].sfp16
            LET g_head_sfs.gen02_sfs = g_sfp[l_ac_sfp].gen02_sfp
            LET g_head_sfs.sfpconf_sfs=g_sfp[l_ac_sfp].sfpconf
            LET g_head_sfs.sfp04_sfs = g_sfp[l_ac_sfp].sfp04
            LET g_b_flag3 = 2
            LET g_action_choice = "sfs"
            CALL cl_set_comp_visible("sfp", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("sfp", TRUE)
         END IF
         EXIT DIALOG
         
      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "sfu"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp_sfs()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfs TO FORMONLY.cn2
   DISPLAY g_head_sfs.sfp01_sfs TO FORMONLY.sfp01_sfs
   DISPLAY g_head_sfs.sfp06_sfs TO FORMONLY.sfp06_sfs
   DISPLAY g_head_sfs.sfp07_sfs TO FORMONLY.sfp07_sfs
   DISPLAY g_head_sfs.gem02_sfs TO FORMONLY.gem02a_sfs
   DISPLAY g_head_sfs.sfp16_sfs TO FORMONLY.sfp16_sfs
   DISPLAY g_head_sfs.gen02_sfs TO FORMONLY.gen02_sfs
   DISPLAY g_head_sfs.sfpconf_sfs TO FORMONLY.sfpconf_sfs
   DISPLAY g_head_sfs.sfp04_sfs TO FORMONLY.sfp04_sfs
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b_sfs)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a 
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b_sfs)

      BEFORE DISPLAY
         IF l_ac_sfs != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfs)
         END IF

      BEFORE ROW
         LET l_ac_sfs = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()              
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfp
         LET g_b_flag3 = 1
         LET g_action_choice = "sfp"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "sfa"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "sfu"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp_sfu()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfu TO FORMONLY.cn2
   CALL cl_set_comp_visible("sfv", FALSE)
   CALL  g_sfv.clear()   
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("sfv", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_sfv = '1' THEN
      LET g_pmk01_change_sfv = '0' 
      CALL  g_sfv.clear()   
      INITIALIZE g_head_sfv.* TO NULL
      LET g_rec_b_sfv = ''
      DISPLAY g_head_sfv.sfu01_sfv TO FORMONLY.sfu01_sfv
      DISPLAY g_head_sfv.sfu02_sfv TO FORMONLY.sfu02_sfv
      DISPLAY g_head_sfv.sfu04_sfv TO FORMONLY.sfu04_sfv
      DISPLAY g_head_sfv.gem02_sfv TO FORMONLY.gem02_sfv
      DISPLAY g_head_sfv.sfu16_sfv TO FORMONLY.sfu16_sfv
      DISPLAY g_head_sfv.gen02_sfv TO FORMONLY.gen02_sfv
      DISPLAY g_head_sfv.sfuconf_sfv TO FORMONLY.sfuconf_sfv 
      DISPLAY g_head_sfv.sfupost_sfv TO FORMONLY.sfupost_sfv 
      DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b_sfv)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
   END IF
   DISPLAY ARRAY g_sfu TO s_sfu.* ATTRIBUTE(COUNT=g_rec_b_sfu)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfu TO s_sfu.* ATTRIBUTE(COUNT=g_rec_b_sfu)

      BEFORE DISPLAY
         IF l_ac_sfu != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfu)
         END IF

      BEFORE ROW
        LET l_ac_sfu = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfv
         LET l_ac_sfu = ARR_CURR()
         IF l_ac_sfu > 0 THEN
            LET g_head_sfv.sfu01_sfv = g_sfu[l_ac_sfu].sfu01
            LET g_head_sfv.sfu02_sfv = g_sfu[l_ac_sfu].sfu02
            LET g_head_sfv.sfu04_sfv = g_sfu[l_ac_sfu].sfu04
            LET g_head_sfv.gem02_sfv = g_sfu[l_ac_sfu].gem02_sfu
            LET g_head_sfv.sfu16_sfv = g_sfu[l_ac_sfu].sfu16
            LET g_head_sfv.gen02_sfv = g_sfu[l_ac_sfu].gen02_sfu
            LET g_head_sfv.sfuconf_sfv = g_sfu[l_ac_sfu].sfuconf
            LET g_head_sfv.sfupost_sfv = g_sfu[l_ac_sfu].sfupost
            LET g_b_flag3 = 2
            LET g_action_choice = "sfv"
         END IF
         EXIT DIALOG

      ON ACTION ACCEPT
         LET l_ac_sfu = ARR_CURR()
         IF l_ac_sfu > 0 THEN
            LET g_head_sfv.sfu01_sfv = g_sfu[l_ac_sfu].sfu01
            LET g_head_sfv.sfu02_sfv = g_sfu[l_ac_sfu].sfu02
            LET g_head_sfv.sfu04_sfv = g_sfu[l_ac_sfu].sfu04
            LET g_head_sfv.gem02_sfv = g_sfu[l_ac_sfu].gem02_sfu
            LET g_head_sfv.sfu16_sfv = g_sfu[l_ac_sfu].sfu16
            LET g_head_sfv.gen02_sfv = g_sfu[l_ac_sfu].gen02_sfu
            LET g_head_sfv.sfuconf_sfv = g_sfu[l_ac_sfu].sfuconf
            LET g_head_sfv.sfupost_sfv = g_sfu[l_ac_sfu].sfupost
            LET g_b_flag3 = 2
            LET g_action_choice = "sfv"
            CALL cl_set_comp_visible("sfu", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("sfu", TRUE)
         END IF
         EXIT DIALOG
         
      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "sfp"
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q402_bp_sfv()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfv TO FORMONLY.cn2
      DISPLAY g_head_sfv.sfu01_sfv TO FORMONLY.sfu01_sfv
      DISPLAY g_head_sfv.sfu02_sfv TO FORMONLY.sfu02_sfv
      DISPLAY g_head_sfv.sfu04_sfv TO FORMONLY.sfu04_sfv
      DISPLAY g_head_sfv.gem02_sfv TO FORMONLY.gem02_sfv
      DISPLAY g_head_sfv.sfu16_sfv TO FORMONLY.sfu16_sfv
      DISPLAY g_head_sfv.gen02_sfv TO FORMONLY.gen02_sfv
      DISPLAY g_head_sfv.sfuconf_sfv TO FORMONLY.sfuconf_sfv 
      DISPLAY g_head_sfv.sfupost_sfv TO FORMONLY.sfupost_sfv 
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b_sfv)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         CALL q402_b_fill_2()
         CALL q402_set_visible()
         CALL cl_set_comp_visible("page1,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1,page3", TRUE)
         LET g_action_choice = "page2"
         DISPLAY BY NAME tm.a
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b_sfv)

      BEFORE DISPLAY
         IF l_ac_sfv != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfv)
         END IF

      BEFORE ROW
        LET l_ac_sfv = ARR_CURR()
        CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION sfu
         LET g_b_flag3 = 1
         LET g_action_choice = "sfu"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "sfp"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION act_page3()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
      IF l_ac > 0 THEN
         IF NOT cl_null(g_cch01_o) AND g_cch01_o != g_cch[l_ac].cch01 THEN
            LET g_pmk01_change_sfa = '1'
            LET g_pmk01_change_sfs = '1'
            LET g_pmk01_change_sfv = '1'
         END IF
            LET g_pml02_change_pmn = '1'     
 
            LET g_head.cch01_2 = g_cch[l_ac].cch01
            LET g_head.sfb02a_2= g_cch[l_ac].sfb02  
            LET g_head.sfb99_2 = g_cch[l_ac].sfb99
            LET g_head.sfb05_2 = g_cch[l_ac].sfb05 
            LET g_head.ima02_2 = g_cch[l_ac].ima02 
            LET g_head.ima021_2= g_cch[l_ac].ima021
            LET g_head.ima57_2 = g_cch[l_ac].ima57 
            LET g_head.sfb98_2 = g_cch[l_ac].sfb98 

         ELSE
             INITIALIZE g_head.* TO NULL 
             LET g_head.cch01_2 = ' '
             LET g_pmk01_change_sfa = '1'
             LET g_pmk01_change_sfs = '1'
             LET g_pmk01_change_sfv = '1'
             LET g_pml02_change_pmn = '1'
         END IF
         LET g_action_flag = "page3"
         LET g_b_flag3 = 1
         CALL cl_set_comp_visible("page1", FALSE)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
         CASE g_b_flag2
            WHEN 1
               LET g_action_choice="sfb"
            WHEN 2
               LET g_action_choice="sfp"
            WHEN 3 
               LET g_action_choice="sfu"
            OTHERWISE
               LET g_action_choice="sfb" LET g_b_flag2=1
         END CASE
END FUNCTION
      
FUNCTION q402_excel()
CASE 
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 1
       LET page = f.FindNode("Page","sfb")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfb),'','')
       
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 2
       LET page = f.FindNode("Page","sfa")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfa),'','')
 
   WHEN g_b_flag2 = 2 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","sfp")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfp),'','')  

   WHEN g_b_flag2 = 2 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","sfs")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfs),'','') 

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","sfu")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfu),'','')

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","sfv")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfv),'','')

END CASE

END FUNCTION 
#FUN-D20073
#TQC-D20055

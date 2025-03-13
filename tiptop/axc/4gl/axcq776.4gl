# Prog. Version..: '5.30.06-13.03.19(00004)'     #
#
# Pattern name...: axcq776.4gl
# Descriptions...: 
# Date & Author..: 12/08/28 By lixh1 
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理 
# Modify.........: No:MOD-D20105 13/02/20 By wujie tm.stock默认为‘2’
# Modify.........: No.FUN-D10022 13/01/05 By xujing 優化成本勾稽
# Modify.........: No.MOD-D20105 13/02/19 By zm 当站下线数量/金额应为正数
# Modify.........: No.TQC-D30024 13/03/07 By xujing 當使用單帳套時，隱藏欄位【會計科目二】
# Modify.........: No.TQC-D50098 13/05/21 By fengrui 調整s_ckk_fill至主函數中

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
   g_tlf62        LIKE tlf_file.tlf62,  
   g_tlf DYNAMIC ARRAY OF RECORD 
         #FUN-D10022---add---str---   
         ima12    LIKE ima_file.ima12,
         imz02    LIKE imz_file.imz02,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08, 
         #FUN-D10022---add---end---   
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ima39    LIKE ima_file.ima39,
         ima391   LIKE ima_file.ima391,
         tlf930   LIKE tlf_file.tlf930,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222                       
             END RECORD,
   #FUN-C80092--add--str--
   g_tlf_excel DYNAMIC ARRAY OF RECORD   
        #FUN-D10022---add---str--- 
         ima12    LIKE ima_file.ima12,
         imz02    LIKE imz_file.imz02,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08, 
        #FUN-D10022---add---end---     
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ima39    LIKE ima_file.ima39,
         ima391   LIKE ima_file.ima391,
         tlf930   LIKE tlf_file.tlf930,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222                       
             END RECORD,
   #FUN-D10022---add---str--- 
   g_tlf_1,g_tlf_1_excel DYNAMIC ARRAY OF RECORD     
         ima12    LIKE ima_file.ima12,
         imz02    LIKE imz_file.imz02,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08,     
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222                       
             END RECORD,
   #FUN-D10022---add---end---
   #FUN-C80092--add--end--
   g_argv1       LIKE type_file.num5,
   g_argv2       LIKE type_file.num5,   #No.FUN-C80092 add
   g_argv3       LIKE type_file.chr1,   #No.FUN-C80092 add
   g_argv4       LIKE type_file.chr1,   #No.FUN-C80092 add
   g_argv5       LIKE type_file.chr1,   #No.FUN-C80092 add
   g_wc,g_sql    STRING,     
   g_rec_b       LIKE type_file.num10,  #No.FUN-C80092 num5->10       
   g_rec_b1      LIKE type_file.num10,  #No.FUN-C80092 add   
   g_rec_b2      LIKE type_file.num10,  #FUN-D10022 add  
   l_ac          LIKE type_file.num5,      
   l_ac1         LIKE type_file.num5    #FUN-D10022 add   
DEFINE   g_forupd_sql    STRING                       
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE ze_file.ze03           
DEFINE   g_cka00         LIKE cka_file.cka00
DEFINE   l_bdate         LIKE type_file.dat
DEFINE   l_edate         LIKE type_file.dat
DEFINE   tm,tm_t  RECORD                  
              wc      LIKE type_file.chr1000,      
              bdate   LIKE type_file.dat,   
              edate   LIKE type_file.dat,  
              type    LIKE type_file.chr1,     
              stock   LIKE type_file.chr1,     
              z       LIKE type_file.chr1,        
              a       LIKE type_file.chr1        #FUN-D10022 add 
              END RECORD

DEFINE   sr1 RECORD
           qty   LIKE tlf_file.tlf10,     #數量
           tot   LIKE ccc_file.ccc23,     #總金額
           cl    LIKE tlfc_file.tlfc221,  #材料費用
           rg    LIKE tlfc_file.tlfc222,  #人工費用
           jg    LIKE tlfc_file.tlfc2232, #加工費用
           zf01  LIKE tlfc_file.tlfc2231, #製費一
           zf02  LIKE tlfc_file.tlfc224,  #製費二
           zf03  LIKE tlfc_file.tlfc2241, #製費三
           zf04  LIKE tlfc_file.tlfc2242, #製費四
           zf05  LIKE tlfc_file.tlfc2243  #製費五
           END RECORD
#FUN-D10022---add---str---
DEFINE g_filter_wc  STRING 
DEFINE g_flag       LIKE type_file.chr1 
DEFINE g_action_flag LIKE type_file.chr100
DEFINE g_row_count  LIKE type_file.num10  
DEFINE g_curs_index LIKE type_file.num10  
DEFINE w            ui.Window      
DEFINE f            ui.Form       
DEFINE page         om.DomNode 
#FUN-D10022---add---end---

MAIN
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #LET g_argv1   = ARG_VAL(1)   
   #No.FUN-C80092 add str   
   LET g_argv1   = ARG_VAL(1)  #年度    
   LET g_argv2   = ARG_VAL(2)  #期別    
   LET g_argv3   = ARG_VAL(3)  #成本計算類型    
   LET g_argv4   = ARG_VAL(4)  #勾稽否       
   LET g_argv5   = ARG_VAL(5)  #背景執行否   
   LET g_bgjob = g_argv5
   #No.FUN-C80092 add end
   LET g_tlf62   = NULL  
   CALL q776_table()      #FUN-D10022 add   
  # LET g_tlf62   = g_argv1
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    
      OPEN WINDOW q776_w WITH FORM "axc/42f/axcq776"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL cl_set_comp_visible("ima391", g_aza.aza63='Y')  #TQC-D30024 add
#      CALL q776_tm(0,0)     #FUN-D10022 mark
      CALL q776_q()       #FUN-D10022 add
      CALL cl_set_act_visible("revert_filter",FALSE) #FUN-D10022 add
      CALL q776_menu()
      CLOSE WINDOW q776_w
   ELSE 
      CALL axcq776()  
   END IF 
   DROP TABLE axcq776_tmp   #FUN-D10022 add   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#FUN-D10022---mark---str---- 
#FUNCTION q776_tm(p_row,p_col)
#DEFINE lc_qbe_sn            LIKE gbm_file.gbm01   
#   DEFINE p_row,p_col       LIKE type_file.num5,  
#          l_cmd             LIKE type_file.chr1000 
# 
#   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
#   LET p_row = 5 LET p_col = 20
#   OPEN WINDOW axcq776_w AT p_row,p_col
#        WITH FORM "axc/42f/axcq776_1" 
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
#    
#   CALL cl_ui_init()
# 
#   CALL cl_opmsg('p')
#   LET tm_t.* = tm.*
#   INITIALIZE tm.* TO NULL
#   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
#   CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_bdate,l_edate
#   LET tm.bdate = l_bdate
#   LET tm.edate = l_edate
#   LET tm.type = g_ccz.ccz28
#   LET tm.stock = '2'    #No.MOD-D20105 1 --->2  
#   LET tm.z = 'Y'
#   LET g_pdate= g_today
#   LET g_rlang= g_lang
#   LET g_copies= '1'
#   LET g_bgjob = 'N'
# 
#   WHILE TRUE
#      CONSTRUCT BY NAME tm.wc ON ima12,ima08,tlf62,ima57,ima01
#         BEFORE CONSTRUCT
#            CALL cl_qbe_init()
#            #FUN-C80092--add--by--free--
#            IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
#               LET tm.wc = ' 1=1'
#               EXIT CONSTRUCT 
#            END IF 
#            #FUN-C80092--add--by--free--
# 
#      ON ACTION locale
#         CALL cl_show_fld_cont()                  
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION controlp                                                      
#         IF INFIELD(ima01) THEN                                              
#            CALL cl_init_qry_var()                                           
#            LET g_qryparam.form = "q_ima"                                    
#            LET g_qryparam.state = "c"                                       
#            CALL cl_create_qry() RETURNING g_qryparam.multiret               
#            DISPLAY g_qryparam.multiret TO ima01                             
#            NEXT FIELD ima01                                                 
#         END IF                                                              
# 
#       ON ACTION about        
#          CALL cl_about()      
# 
#       ON ACTION help          
#          CALL cl_show_help() 
# 
#       ON ACTION controlg      
#          CALL cl_cmdask()     
# 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT CONSTRUCT
#          ON ACTION qbe_select
#          CALL cl_qbe_select()
# 
#      END CONSTRUCT
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      LET tm.* = tm_t.* 
#      CLOSE WINDOW axcq776_w  
#      RETURN
#   END IF
#   IF tm.wc = ' 1=1' AND cl_null(g_argv1) THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF  #FUN-C80092 g_arvg8
#   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.stock,tm.z 
#      WITHOUT DEFAULTS 
#      BEFORE INPUT
#         CALL cl_qbe_display_condition(lc_qbe_sn)
#         CALL cl_set_comp_entry("z",TRUE)
#         #FUN-C80092--add--by--free--
#         IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
#            CALL s_azn01(g_argv1,g_argv2) RETURNING tm.bdate,tm.edate
#            LET tm.type = g_argv3
#            IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN 
#               LET tm.z = 'N'
#            ELSE 
#               LET tm.z = 'Y'
#            END IF
#            DISPLAY BY NAME tm.*
#            CALL cl_set_comp_entry('bdate,edate,type',FALSE)
#         ELSE 
#            CALL cl_set_comp_entry('bdate,edate,type',TRUE)
#         END IF 
#         #FUN-C80092--add--by--free--
#            
#      BEFORE FIELD bdate
#         CALL cl_set_comp_entry("z",TRUE)
#      AFTER FIELD bdate
#         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
#         CALL q776_set_no_entry()
#         DISPLAY tm.z TO z 
#      BEFORE FIELD edate
#         CALL cl_set_comp_entry("z",TRUE)
#      AFTER FIELD edate
#         IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
#         CALL q776_set_no_entry()
#         DISPLAY tm.z TO z
#      AFTER FIELD type 
#         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF 
#      ON CHANGE bdate
#         IF tm.bdate <> l_bdate THEN
#            LET tm.z = 'N'
#            DISPLAY tm.z TO z
#            CALL q776_set_no_entry() 
#         END IF 
#      ON CHANGE edate 
#         IF tm.edate <> l_edate THEN
#            LET tm.z = 'N'
#            DISPLAY tm.z TO z
#            CALL q776_set_no_entry()
#         END IF
#
#      AFTER INPUT 
#         IF INT_FLAG THEN
#            EXIT INPUT
#         END IF
#         IF tm.edate < tm.bdate THEN
#            CALL cl_err('','agl-031',0)
#            NEXT FIELD edate
#         END IF
#         IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
#            LET tm.z = 'N'
#            DISPLAY tm.z TO z
#         END IF
#
#      ON ACTION CONTROLZ
#         CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()    
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
#   
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT

#      ON ACTION qbe_save
#         CALL cl_qbe_save()
# 
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      LET tm.* = tm_t.*
#   #  INITIALIZE tm.* TO NULL
#      CLOSE WINDOW axcq776_w 
#      RETURN
#   END IF
#   CLOSE WINDOW axcq776_w
#   CALL axcq776()
#   EXIT WHILE
#   END WHILE
#END FUNCTION
#FUN-D10022---mark---end
 
FUNCTION q776_menu()
   WHILE TRUE
      #FUN-D10022---add---str---
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page01" THEN
            CALL q776_bp("G")
         END IF
         IF g_action_flag = "page02" THEN
            CALL q776_bp2()
         END IF
      END IF
      #FUN-D10022---add---end---
      #CALL q776_bp("G")   #FUN-D10022 mark
      CASE g_action_choice
       #FUN-D10022---add---str---
         WHEN "page01"
            CALL q776_bp("G")
         WHEN "page02"
            CALL q776_bp2()
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q776_filter_askkey()
               CALL axcq776()        #重填充新臨時表
               CALL q776_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL axcq776()        #重填充新臨時表
               CALL q776_show() 
            END IF             
            LET g_action_choice = " "
         #FUN-D10022---add---end---
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL q776_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-D10022 add
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
            LET g_action_choice = " "  #FUN-D10022 add
         WHEN "exporttoexcel" 
           #FUN-D10022---mark---str
           #IF cl_chk_act_auth() THEN
           #  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlf_excel),'','')  #FUN-C80092
           #END IF
           #FUN-D10022---mark---end
           #FUN-D10022---add---str
           LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page01" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page01")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
                END IF
             END IF  
             IF g_action_flag = "page02" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page02")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_1_excel),'','')
                END IF
             END IF
            LET g_action_choice = " "
           #FUN-D10022---add---end
      END CASE
   END WHILE
END FUNCTION

#FUN-D10022---mark---str 
#FUNCTION q776_q()
#   MESSAGE ""
#   CALL cl_opmsg('q')
#   CALL q776_tm(0,0)                              
#END FUNCTION
#FUN-D10022---mark---end

#FUN-D10022---add---str
FUNCTION q776_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q776_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q776_show()                             
END FUNCTION
#FUN-D10022---add---end 
FUNCTION axcq776()
DEFINE    l_sql    STRING
DEFINE    l_where  STRING
DEFINE    l_tlf032 LIKE tlf_file.tlf032
DEFINE    l_tlf930 LIKE tlf_file.tlf930
DEFINE    l_ccz07  LIKE ccz_file.ccz07
DEFINE    l_slip     LIKE smy_file.smyslip   
DEFINE    l_smydmy1  LIKE smy_file.smydmy1
DEFINE    l_ima39    LIKE ima_file.ima39 
DEFINE    l_ima391   LIKE ima_file.ima391
DEFINE    l_azf03    LIKE azf_file.azf03
DEFINE    i          LIKE type_file.num10 #FUN-C80092 5->10
DEFINE    g_ckk      RECORD LIKE ckk_file.*
DEFINE    l_msg      STRING
DEFINE    l_msg1     STRING
#FUN-D10022---mark---str---
#DEFINE    sr               RECORD code   LIKE type_file.chr1,  
#                                  ima12  LIKE ima_file.ima12,
#                                  ima01  LIKE ima_file.ima01,
#                                  ima02  LIKE ima_file.ima02,
#                                  ima021 LIKE ima_file.ima021, 
#                                  tlfccost LIKE tlfc_file.tlfccost, 
#                                  tlf02  LIKE tlf_file.tlf02,
#                                  tlf021 LIKE tlf_file.tlf021,
#                                  tlf03  LIKE tlf_file.tlf03,
#                                  tlf031 LIKE tlf_file.tlf031,
#                                  tlf06  LIKE tlf_file.tlf06,
#                                  tlf026 LIKE tlf_file.tlf026,
#                                  tlf027 LIKE tlf_file.tlf027,
#                                  tlf036 LIKE tlf_file.tlf036,
#                                  tlf037 LIKE tlf_file.tlf037,
#                                  tlf01  LIKE tlf_file.tlf01,
#                                  tlf10  LIKE tlf_file.tlf10,
#                                  tlfc21  LIKE tlfc_file.tlfc21,  
#                                  tlf13  LIKE tlf_file.tlf13,
#                                  tlf62  LIKE tlf_file.tlf62,
#                                  tlf907 LIKE tlf_file.tlf907,
#                                  amt01  LIKE tlfc_file.tlfc221,   #材料金額
#                                  amt02  LIKE tlfc_file.tlfc222,   #人工金額
#                                  amt03  LIKE tlfc_file.tlfc2231,  #製造費用
#                                  amt04  LIKE tlfc_file.tlfc2232,  #加工費用
#                                  amt05  LIKE tlfc_file.tlfc224,   #其他金額
#                                  amt07  LIKE tlfc_file.tlfc2241, #制費三  
#                                  amt08  LIKE tlfc_file.tlfc2241, #制費四  
#                                  amt09  LIKE tlfc_file.tlfc2241, #制費五 
#                                  amt06  LIKE ccc_file.ccc23      #總金額
#                                  END RECORD
#FUN-D10022---mark---end---
     DELETE FROM axcq776_tmp    #FUN-D10022 add
     IF g_bgjob = 'Y' THEN
        INITIALIZE tm.* TO NULL
        LET tm.type = g_argv3
        LET tm.z = g_argv4
        LET tm.wc = '1=1'
        LET tm.stock = '2'
        CALL s_azn01(g_argv1,g_argv2) RETURNING tm.bdate,tm.edate
        IF cl_null(tm.bdate) OR cl_null(tm.edate) THEN
           CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_bdate,l_edate
        END IF
     END IF
     LET l_msg1 = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.type = '",tm.type,"'",";",
                  "tm.stock = '",tm.stock,"'",";","tm.z = '",tm.z,"'"
     CALL s_log_ins(g_prog,'','',tm.wc,l_msg1)
          RETURNING g_cka00

#FUN-D10022---mark---str---
#     LET l_sql = "SELECT '',   ima12,ima01,ima02,ima021,tlfccost, ",
#                 "       tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,",
#                 "       tlf036,tlf037,tlf01,tlf10*tlf60,tlf21,tlf13,tlf62,tlf907,",
#                 "       tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,tlf032,tlf930",
#                 "  FROM ima_file,sfb_file,tlf_file LEFT OUTER JOIN tlfc_file ",         
#                 "                        ON  tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc06 = tlf06",      
#                 "                        AND tlfc_file.tlfc02 = tlf02  AND tlfc_file.tlfc03 = tlf03 ",      
#                 "                        AND tlfc_file.tlfc13 = tlf13 ",                                   
#                 "                        AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903 ",   
#                 "                        AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc907= tlf907 ",                   
#                 "                        AND tlfc_file.tlfc905= tlf905 AND tlfc_file.tlfc906= tlf906",    
#                 " WHERE ima_file.ima01 = tlf01 AND tlf62 = sfb_file.sfb01 ",
#                 "   AND ",tm.wc CLIPPED,
#                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
#                 "   AND tlf902 NOT IN(SELECT jce02 FROM jce_file) "  ,
#                 " AND tlfc_file.tlfctype = '",tm.type,"'"                 
#FUN-D10022---mark---end---
#FUN-D10022---add---str---
     IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF
     LET l_sql = "SELECT NVL(TRIM(ima12),'') ima12,azf03,NVL(TRIM(ima57),'') ima57,NVL(TRIM(ima08),'') ima08,",
                 "       tlf021,tlf06,tlf026,NVL(TRIM(tlf62),'') tlf62,",
                 "       NVL(TRIM(tlf01),'') tlf01,ima02,ima021,ima39,ima391,tlf930,tlfccost,",
                 "       NVL(tlf10*tlf60,0) tlf10,NVL(tlfc221,0),NVL(tlfc222,0),NVL(tlfc2231,0),",
                 "       NVL(tlfc2232,0),NVL(tlfc224,0),NVL(tlfc2241,0),NVL(tlfc2242,0),",
                 "       NVL(tlfc2243,0),0 amt06,tlf031,tlf032,tlf907,tlf13,tlf036",
                 "  FROM ima_file LEFT OUTER JOIN azf_file ON azf_file.azf01 = ima_file.ima12",
                 "                                        AND azf_file.azf02 = 'G',",
                 "       sfb_file,tlf_file LEFT OUTER JOIN tlfc_file ",         
                 "                        ON  tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc06 = tlf06",      
                 "                        AND tlfc_file.tlfc02 = tlf02  AND tlfc_file.tlfc03 = tlf03 ",      
                 "                        AND tlfc_file.tlfc13 = tlf13 ",                                   
                 "                        AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903 ",   
                 "                        AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc907= tlf907 ",                   
                 "                        AND tlfc_file.tlfc905= tlf905 AND tlfc_file.tlfc906= tlf906",    
                 " WHERE ima_file.ima01 = tlf01 AND tlf62 = sfb_file.sfb01 ",
                 "   AND (trim(tlfctype) is null OR tlfctype = '",tm.type CLIPPED,"') ", 
                 "   AND (tlf907>0 AND 'Y'=(SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf036,0,instr(tlf036,'-')-1) ) ",
                 "     OR tlf907<=0 AND 'Y'=(SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf026,0,instr(tlf026,'-')-1) ) )",             
                 "   AND ",tm.wc CLIPPED,
                 "   AND ",g_filter_wc CLIPPED,
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                 "   AND tlf902 NOT IN(SELECT jce02 FROM jce_file) "  ,
                 " AND tlfc_file.tlfctype = '",tm.type,"'" 
#FUN-D10022---add---end---
     CASE tm.stock
        WHEN "2"
           LET l_where = "   AND ((tlf13 matches 'asfi5*') OR (tlf13 matches 'asft6*' AND sfb02='11') OR (tlf13='asft700'))"
        WHEN "3"
           LET l_where = "   AND (tlf13='asft700')"
        OTHERWISE
           LET l_where = "   AND ((tlf13 matches 'asfi5*') OR (tlf13 matches 'asft6*' AND sfb02='11'))"
     END CASE

     LET l_sql = l_sql CLIPPED, l_where CLIPPED
     #FUN-D10022---add---str---
     LET l_sql = " INSERT INTO axcq776_tmp  ",l_sql CLIPPED 
     PREPARE q776_ins FROM l_sql
     EXECUTE q776_ins

     LET l_sql = " UPDATE axcq776_tmp ",
               "    SET tlf021 = tlf031 ,",
               "        tlf026 = tlf036  ",
               "  WHERE tlf907 = 1 ",
               "    AND tlf13 <> 'asft700'"
     PREPARE q776_pre1 FROM l_sql
     EXECUTE q776_pre1


     LET l_sql = " UPDATE axcq776_tmp ",
               "    SET tlf10 = tlf10 * -1,",
               "        amt01 = amt01 * -1,",
               "        amt02 = amt02 * -1,",
               "        amt03 = amt03 * -1,",
               "        amt04 = amt04 * -1,",
               "        amt05 = amt05 * -1,",
               "        amt07 = amt07 * -1,",
               "        amt08 = amt08 * -1,", 
               "        amt09 = amt09 * -1 ",
               "  WHERE tlf907 <> 1 "
#               "     OR tlf13 = 'asft700'"   #MOD-D20105 当站下线为正值     #mark by liuyya 170916
     PREPARE q776_pre2 FROM l_sql
     EXECUTE q776_pre2

     LET l_sql = " UPDATE axcq776_tmp",
                 "    SET amt06 = amt01+amt02+amt03+amt04+amt05+amt07+amt08+amt09"
     PREPARE q776_pre3 FROM l_sql
     EXECUTE q776_pre3

     SELECT ccz07 INTO l_ccz07 FROM ccz_file WHERE ccz00='0'
     CASE WHEN l_ccz07='1'                                                                                                    
             LET l_sql=
               " MERGE INTO axcq776_tmp o ",
               "      USING (SELECT ima01,ima39,ima391 FROM ima_file ) x ",
               "         ON (o.tlf01 = x.ima01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.ima39 ,",
               "           o.ima391= x.ima391 "                                                               
          WHEN l_ccz07='2'   
             LET l_sql=
               " MERGE INTO axcq776_tmp o ",
               "      USING (SELECT ima01,imz39,imz391 FROM ima_file,imz_file ",
               "              WHERE ima06=imz01 ) x ",
               "         ON (o.tlf01 = x.ima01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.imz39 ,",
               "           o.ima391= x.imz391 "                                                             
          WHEN l_ccz07='3'    
             LET l_sql=
               " MERGE INTO axcq776_tmp o ",
               "      USING (SELECT imd01,imd08,imd081 FROM imd_file) x ",
               "         ON (o.tlf031 = x.imd01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.imd08 ,",
               "           o.ima391= x.imd081 "                                                                                  
          WHEN l_ccz07='4'          
             LET l_sql=
               " MERGE INTO axcq776_tmp o ",
               "      USING (SELECT imd01,ime09,ime091 FROM ime_file) x ",
               "         ON (o.tlf031 = x.ime01 AND o.tlf032 = x.ime02 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.ime09 ,",
               "           o.ima391= x.ime091 "                                                                          
     END CASE
     IF l_ccz07 MATCHES '[1234]' THEN 
        PREPARE q776_pre4 FROM l_sql
        EXECUTE q776_pre4 
     END IF 
     CALL q776_get_tot()
     #TQC-D50098--add--str--
     #插入ckk_file
     IF tm.z = 'Y' AND NOT cl_null(tm.bdate)
        AND NOT cl_null(tm.edate)  THEN   #wujie 130628 remove g_rec_b
        LET l_msg = tm.bdate,"|",tm.edate,"|",tm.type,"|",tm.stock,"|",tm.z
        CALL s_ckk_fill('','306','axc-453',g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type,sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,
                        sr1.zf01,sr1.zf02,sr1.zf03,sr1.zf04,sr1.zf05,l_msg,g_user,g_today,g_time,'Y')
             RETURNING g_ckk.*
        IF NOT s_ckk(g_ckk.*,'') THEN END IF
     END IF
     CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
     #TQC-D50098--add--end--
     #FUN-D10022---add---end---
#FUN-D10022---mark---str
#     PREPARE axcq776_prepare1 FROM l_sql
#     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM 
#     END IF
#     DECLARE axcq776_curs1 CURSOR FOR axcq776_prepare1
#     CALL g_tlf.clear()
#     CALL g_tlf_excel.clear()  #FUN-C80092
#     LET g_cnt = 1
#     FOREACH axcq776_curs1 INTO sr.*,l_tlf032,l_tlf930  #FUN-9A0050 Add l_tlf032,l_tlf930
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       IF sr.tlf907>0 THEN
#          LET l_slip = s_get_doc_no(sr.tlf036)
#       ELSE
#          LET l_slip = s_get_doc_no(sr.tlf026)
#       END IF
#       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
#        WHERE smyslip = l_slip
#       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
#          CONTINUE FOREACH
#       END IF
#                                     
#       LET sr.code=' '                                                          
#       SELECT cch05 INTO sr.code FROM cch_file WHERE cch04 = sr.tlf01           
#                     AND cch01 = sr.tlf62                                       
#                     AND cch02 = YEAR(sr.tlf06)                                 
#                     AND cch03 = MONTH(sr.tlf06)                                
#                     AND cch06 = tm.type                                        
#                     AND cch07 = sr.tlfccost                                    
#
#       IF  cl_null(sr.code)   THEN LET sr.code = ' ' END IF
#       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
#       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
#       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
#       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
#       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF  
#       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF 
#       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF
#       IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF
#       #-->退料時為正值
#
#       IF sr.tlf907 = 1 AND (sr.tlf13<>'asft700') THEN 
#          LET sr.tlf02  = sr.tlf03
#          LET sr.tlf021 = sr.tlf031  
#          LET sr.tlf026 = sr.tlf036
#       ELSE 
#          LET sr.tlf10= sr.tlf10 * -1
#          LET sr.amt01= sr.amt01 * -1
#          LET sr.amt02= sr.amt02 * -1
#          LET sr.amt03= sr.amt03 * -1
#          LET sr.amt04= sr.amt04 * -1
#          LET sr.amt05= sr.amt05 * -1
#          LET sr.amt07= sr.amt07 * -1
#          LET sr.amt08= sr.amt08 * -1 
#          LET sr.amt09= sr.amt09 * -1
#       END IF
#       LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05 + sr.amt07 + sr.amt08 + sr.amt09
#       IF cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF
#      
#      IF NOT cl_null(sr.ima12) THEN                                                                                                
#         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G'
#         IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF                                                                            
#      END IF
#      LET l_sql = "SELECT ccz07 ",                                                                                             
#                  " FROM ccz_file ",                                                                          
#                  " WHERE ccz00 = '0' "                                                                                        
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                                     
#      PREPARE ccz_p1 FROM l_sql                                                                                                
#      IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
#           DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
#           OPEN ccz_c1                                                                                                              
#           FETCH ccz_c1 INTO l_ccz07                                                                                                
#           CLOSE ccz_c1
#           CASE WHEN l_ccz07='1'                                                                                                    
#                     LET l_sql="SELECT ima39,ima391 FROM ima_file ",                  
#                               " WHERE ima01='",sr.tlf01,"'"                                                                     
#                WHEN l_ccz07='2'                                                                                                    
#                    LET l_sql="SELECT imz39,imz391 ",                                                  
#                         " FROM ima_file,imz_file",                                                                      
#                         " WHERE ima01='",sr.tlf01,"' AND ima06=imz01 "                                                          
#                WHEN l_ccz07='3'                                                                                                    
#                     LET l_sql="SELECT imd08,imd081 FROM imd_file",                          
#                         " WHERE imd01='",sr.tlf031,"'"                                                                           
#                WHEN l_ccz07='4'                                                                                                    
#                     LET l_sql="SELECT ime09,ime091 FROM ime_file",           
#                         " WHERE ime01='",sr.tlf031,"' ",                                                                         
#                           " AND ime02='",l_tlf032,"'"                                                                           
#          END CASE
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                               
#          PREPARE stock_p1 FROM l_sql                                                                                               
#          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
#          DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
#          OPEN stock_c1                                                                                                             
#          FETCH stock_c1 INTO l_ima39,l_ima391    
#          CLOSE stock_c1
#          #FUN-C80092--modify--str--  #g_tlf->g_tlf_excel
#          LET g_tlf_excel[g_cnt].tlf021 = sr.tlf021
#          LET g_tlf_excel[g_cnt].tlf06 = sr.tlf06
#          LET g_tlf_excel[g_cnt].tlf026 = sr.tlf026
#          LET g_tlf_excel[g_cnt].tlf62 = sr.tlf62       
#          LET g_tlf_excel[g_cnt].tlf01 = sr.tlf01
#          LET g_tlf_excel[g_cnt].ima02 = sr.ima02
#          LET g_tlf_excel[g_cnt].ima021 = sr.ima021
#          LET g_tlf_excel[g_cnt].ima39 = l_ima39
#          LET g_tlf_excel[g_cnt].ima391 = l_ima391
#          LET g_tlf_excel[g_cnt].tlf930 = l_tlf930
#          LET g_tlf_excel[g_cnt].tlfccost = sr.tlfccost
#          LET g_tlf_excel[g_cnt].tlf10 = sr.tlf10
#          LET g_tlf_excel[g_cnt].amt01 = sr.amt01
#          LET g_tlf_excel[g_cnt].amt02 = sr.amt02
#          LET g_tlf_excel[g_cnt].amt03 = sr.amt03
#          LET g_tlf_excel[g_cnt].amt04 = sr.amt04
#          LET g_tlf_excel[g_cnt].amt05 = sr.amt05
#          LET g_tlf_excel[g_cnt].amt06 = sr.amt06
#          LET g_tlf_excel[g_cnt].amt07 = sr.amt07
#          LET g_tlf_excel[g_cnt].amt08 = sr.amt08
#          LET g_tlf_excel[g_cnt].amt09 = sr.amt09           
#          #FUN-C80092--modify--end--
#          #FUN-C80092--add--str--
#          IF g_cnt <= g_max_rec THEN
#             LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
#          END IF  
#          #FUN-C80092--add--end--    
#          LET g_cnt = g_cnt + 1
#          #FUN-C80092--mark--str--
#          #IF g_cnt > g_max_rec THEN
#          #   CALL cl_err( '', 9035, 0 )
#          #   EXIT FOREACH
#          #END IF       
#          #FUN-C80092--mark--end--
#   END FOREACH
#     
#   CALL g_tlf.deleteElement(g_cnt)
# 
#   LET g_rec_b1 = g_cnt-1
#   LET g_rec_b  = g_rec_b1
#   #FUN-C80092--add--str--
#   #IF g_rec_b > g_max_rec THEN  #FUN-C80092 
#   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
#      CALL cl_err_msg(NULL,"axc-131",
#           g_rec_b||"|"||g_max_rec,10)
#      LET g_rec_b  = g_max_rec
#   END IF       
#   #FUN-C80092--add--end--    
#   LET sr1.qty = 0
#   LET sr1.tot = 0
#   LET sr1.cl = 0
#   LET sr1.rg = 0
#   LET sr1.jg = 0
#   LET sr1.zf01 = 0
#   LET sr1.zf02 = 0
#   LET sr1.zf03 = 0
#   LET sr1.zf04 = 0
#   LET sr1.zf05 = 0
##總計
#   IF g_rec_b1 > 0 THEN     #FUN-C80092 
#      FOR i=1 TO g_rec_b1   #FUN-C80092 
#         #FUN-C80092--modify--str--  #g_tlf->g_tlf_excel
#         LET sr1.qty  = sr1.qty  + g_tlf_excel[i].tlf10
#         LET sr1.tot  = sr1.tot  + g_tlf_excel[i].amt06
#         LET sr1.cl   = sr1.cl   + g_tlf_excel[i].amt01
#         LET sr1.rg   = sr1.rg   + g_tlf_excel[i].amt02
#         LET sr1.jg   = sr1.jg   + g_tlf_excel[i].amt04
#         LET sr1.zf01 = sr1.zf01 + g_tlf_excel[i].amt03
#         LET sr1.zf02 = sr1.zf02 + g_tlf_excel[i].amt05
#         LET sr1.zf03 = sr1.zf03 + g_tlf_excel[i].amt07
#         LET sr1.zf04 = sr1.zf04 + g_tlf_excel[i].amt08
#         LET sr1.zf05 = sr1.zf05 + g_tlf_excel[i].amt09
#         #FUN-C80092--modify--end--  
#      END FOR
##     IF sr1.qty < 0 THEN
##        LET sr1.qty = sr1.qty * -1
##     END IF  
##     IF sr1.tot < 0 THEN
##        LET sr1.tot = sr1.tot * -1
##     END IF
##     IF sr1.cl < 0 THEN
##        LET sr1.cl  = sr1.cl * -1
##     END IF
##     IF sr1.rg < 0 THEN
##        LET sr1.rg = sr1.rg * -1
##     END IF
##     IF sr1.jg < 0 THEN
##        LET sr1.jg = sr1.jg * -1
##     END IF
##     IF sr1.zf01 < 0 THEN
##        LET sr1.zf01 = sr1.zf01 * -1
##     END IF        
##     IF sr1.zf02 < 0 THEN
##        LET sr1.zf02 = sr1.zf02 * -1
##     END IF
##     IF sr1.zf03 < 0 THEN
##        LET sr1.zf03 = sr1.zf03 * -1
##     END IF
##     IF sr1.zf04 < 0 THEN
##        LET sr1.zf04 = sr1.zf04 * -1
##     END IF
##     IF sr1.zf05 < 0 THEN
##        LET sr1.zf05 = sr1.zf05 * -1
##     END IF
#   END IF
##插入ckk_file
#   IF tm.z = 'Y' AND NOT cl_null(tm.bdate)
#      AND NOT cl_null(tm.edate) AND g_rec_b1 > 0 THEN
#      LET l_msg = tm.bdate,"|",tm.edate,"|",tm.type,"|",tm.stock,"|",tm.z 
#      CALL s_ckk_fill('','306','axc-453',g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type,sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,
#                      sr1.zf01,sr1.zf02,sr1.zf03,sr1.zf04,sr1.zf05,l_msg,g_user,g_today,g_time,'Y')
#           RETURNING g_ckk.*
#      IF NOT s_ckk(g_ckk.*,'') THEN END IF
#   END IF
#   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
#FUN-D10022---mark---end
END FUNCTION 

FUNCTION q776_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   #FUN-D10022---add---str---
   LET g_action_flag = 'page01'
   IF g_action_choice = "page01" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q776_b_fill()
   END IF
   LET g_flag = ' '
   #FUN-D10022---add---end---
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
   DISPLAY tm.type TO type
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   #FUN-D10022---add---str
   DISPLAY tm.z TO z
   DISPLAY tm.a TO a 
   DISPLAY tm.stock TO stock

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q776_b_fill_2()
               CALL q776_set_visible()
               CALL cl_set_comp_visible("page01", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page01", TRUE)
               LET g_action_choice = "page02"
            ELSE
               CALL q776_b_fill()
               CALL g_tlf_1.clear()
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG
      END INPUT
   #FUN-D10022---add---end---
 #  DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #FUN-D10022--mark
    DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b)     #FUN-D10022 add
      BEFORE ROW
         LET l_ac = ARR_CURR()
    END DISPLAY                      #FUN-D10022 add
    
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG               #FUN-D10022 to DIALOG

#FUN-D10022---add---str---
      ON ACTION page02
         LET g_action_choice = 'page02'
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
         CALL cl_set_comp_visible("page02", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page02", TRUE)
         LET g_action_choice = 'page01' 
         EXIT DIALOG
#FUN-D10022---add---end--- 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG               #FUN-D10022 to DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG               #FUN-D10022 to DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG               #FUN-D10022 to DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG               #FUN-D10022 to DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG               #FUN-D10022 to DIALOG
 
      ON ACTION about      
         CALL cl_about()  
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG               #FUN-D10022 to DIALOG
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")   
      &include "qry_string.4gl"    
   END DIALOG               #FUN-D10022 to DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q776_set_no_entry()
   IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
      IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
         LET tm.z = 'N'
         CALL cl_set_comp_entry("z",FALSE)
      END IF
   END IF 
END FUNCTION

#FUN-D10022---add---str---
FUNCTION q776_cs()
DEFINE lc_qbe_sn            LIKE gbm_file.gbm01   
   DEFINE p_row,p_col       LIKE type_file.num5,  
          l_cmd             LIKE type_file.chr1000 
   CLEAR FORM 
   CALL cl_opmsg('p')
   LET tm_t.* = tm.*
   INITIALIZE tm.* TO NULL
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
   CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_bdate,l_edate
   LET tm.bdate = l_bdate
   LET tm.edate = l_edate
   LET tm.type = g_ccz.ccz28
   LET tm.stock = '2'    #No.MOD-D20105 1 --->2   
   LET tm.a = '4'   #FUN-D10022 
   LET tm.z = 'Y'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_copies= '1'
   LET g_bgjob = 'N'
   LET g_filter_wc = ''
   LET g_action_flag = ''
   CALL cl_set_comp_visible("page02", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page02", TRUE)
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a,tm.stock,tm.z ATTRIBUTE(WITHOUT DEFAULTS) 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            CALL cl_set_comp_entry("z",TRUE)
            IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
               CALL s_azn01(g_argv1,g_argv2) RETURNING tm.bdate,tm.edate
               LET tm.type = g_argv3
               IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN 
                  LET tm.z = 'N'
               ELSE 
                  LET tm.z = 'Y'
               END IF
               DISPLAY BY NAME tm.bdate,tm.edate,tm.z,tm.type
               CALL cl_set_comp_entry('bdate,edate,type',FALSE)
            ELSE 
               CALL cl_set_comp_entry('bdate,edate,type',TRUE)
            END IF 
            #FUN-C80092--add--by--free--
               
         BEFORE FIELD bdate
            CALL cl_set_comp_entry("z",TRUE)
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
               CALL q776_set_no_entry()
            DISPLAY tm.z TO z 
         BEFORE FIELD edate
            CALL cl_set_comp_entry("z",TRUE)
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
               CALL q776_set_no_entry()
            DISPLAY tm.z TO z
         AFTER FIELD TYPE 
            IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF 
         ON CHANGE bdate
            IF tm.bdate <> l_bdate THEN
               LET tm.z = 'N'
               DISPLAY tm.z TO z
               CALL q776_set_no_entry() 
            END IF 
         ON CHANGE edate 
            IF tm.edate <> l_edate THEN
               LET tm.z = 'N'
               DISPLAY tm.z TO z
               CALL q776_set_no_entry()
            END IF

         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT DIALOG
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
               NEXT FIELD edate
            END IF
            IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
               LET tm.z = 'N'
               DISPLAY tm.z TO z
            END IF
      END INPUT
      
      CONSTRUCT tm.wc ON ima12,ima57,ima08,tlf021,tlf06,tlf026,tlf62,tlf01,
                         ima39,ima391,tlf930,tlf10
                    FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08,
                         s_tlf[1].tlf021,s_tlf[1].tlf06,s_tlf[1].tlf026,s_tlf[1].tlf62,
                         s_tlf[1].tlf01,s_tlf[1].ima39,s_tlf[1].ima391,
                         s_tlf[1].tlf930,s_tlf[1].tlf10
         
      END CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION controlp                                                      
         CASE
           WHEN INFIELD(tlf01) 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO tlf01                             
               NEXT FIELD tlf01                                                 
            #FUN-D10022-add--str
            WHEN INFIELD(tlf021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf021
               NEXT FIELD tlf021
            WHEN INFIELD(tlf026)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfp"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf026
               NEXT FIELD tlf026
            WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39 
               NEXT FIELD ima39 
            WHEN INFIELD(ima391)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima391"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima391 
               NEXT FIELD ima391 
            WHEN INFIELD(tlf930)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_smh"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf930
               NEXT FIELD tlf930
            #FUN-D10022-add--end                                                
         END CASE   

         IF INFIELD(ima12) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "G"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima12 
            NEXT FIELD ima12    
         END IF     

        IF INFIELD(tlf62) THEN                                              
            CALL cl_init_qry_var()                                           
            LET g_qryparam.form = "q_sfb"                                    
            LET g_qryparam.state = "c"                                       
            CALL cl_create_qry() RETURNING g_qryparam.multiret               
            DISPLAY g_qryparam.multiret TO tlf62                             
            NEXT FIELD tlf62
        END IF 
       ON ACTION about        
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help() 
 
       ON ACTION controlg      
          CALL cl_cmdask()     
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG
          
       ON ACTION qbe_select
          CALL cl_qbe_select()
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()   

      ON ACTION qbe_save
         CALL cl_qbe_save()
         
      ON ACTION ACCEPT
         ACCEPT DIALOG 

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG   
      BEFORE DIALOG
         CALL cl_qbe_init()
         #FUN-D10022--add---str---
         IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
            LET tm.wc = ' 1=1'
            EXIT DIALOG
         END IF 
         #FUN-D10022--add---end---
   END DIALOG
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
   LET tm.wc = cl_replace_str(tm.wc,'tlf021',"(CASE WHEN tlf907=1 AND tlf13<>'asft700' THEN tlf031 ELSE tlf021 END)") #FUN-D10022
   LET tm.wc = cl_replace_str(tm.wc,'tlf026',"(CASE WHEN tlf907=1 AND tlf13<>'asft700' THEN tlf036 ELSE tlf026 END)") #FUN-D10022
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      INITIALIZE sr1.* TO NULL
      DELETE FROM axcq776_tmp
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
      RETURN
   END IF
   CALL axcq776()

END FUNCTION

FUNCTION q776_show()
   DISPLAY tm.a TO a
   IF cl_null(g_action_flag) OR g_action_flag = "page02" THEN
      LET g_action_choice = "page02"
      CALL q776_b_fill()  
      CALL q776_b_fill_2()
      CALL cl_set_comp_visible("page01", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page01", TRUE)
   ELSE
      CALL q776_b_fill_2()
      CALL q776_b_fill()  
      LET g_action_choice = "page01"
      CALL cl_set_comp_visible("page02", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page02", TRUE)
   END IF 
   CALL q776_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q776_set_visible()
   CALL cl_set_comp_visible("ima12_1,imz02_1,ima57_1,ima08_1,tlf62_1,tlf01_1,ima02_1,ima021_1",TRUE)

   CASE tm.a
       WHEN '1'
          CALL cl_set_comp_visible("ima57_1,ima08_1,tlf62_1,tlf01_1,ima02_1,ima021_1",FALSE)
       WHEN '2'
          CALL cl_set_comp_visible("ima12_1,imz02_1,ima08_1,tlf62_1,tlf01_1,ima02_1,ima021_1",FALSE) 
       WHEN '3'
          CALL cl_set_comp_visible("ima12_1,imz02_1,ima57_1,tlf62_1,tlf01_1,ima02_1,ima021_1",FALSE)
       WHEN '4'
          CALL cl_set_comp_visible("ima12_1,imz02_1,ima57_1,ima08_1,tlf62_1",FALSE)
       WHEN '5'
          CALL cl_set_comp_visible("ima12_1,imz02_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1",FALSE)
   END CASE
END FUNCTION 

FUNCTION q776_table()
DEFINE l_sql    STRING

LET l_sql = "CREATE TEMP TABLE axcq776_tmp( ",
            "          ima12    LIKE ima_file.ima12,",
            "          imz02    LIKE imz_file.imz02,",
            "          ima57    LIKE ima_file.ima57,",
            "          ima08    LIKE ima_file.ima08,",  
            "          tlf021   LIKE tlf_file.tlf031,",
            "          tlf06    LIKE tlf_file.tlf06,",
            "          tlf026   LIKE tlf_file.tlf036,",    
            "          tlf62    LIKE tlf_file.tlf62,",
            "          tlf01    LIKE tlf_file.tlf01,",
            "          ima02    LIKE ima_file.ima02,",
            "          ima021   LIKE ima_file.ima021,",
            "          ima39    LIKE ima_file.ima39,",
            "          ima391   LIKE ima_file.ima391,",
            "          tlf930   LIKE tlf_file.tlf930,",
            "        tlfccost   LIKE tlfc_file.tlfccost,",
            "          tlf10    LIKE tlf_file.tlf10,",
            "          amt01    LIKE tlf_file.tlf222,",
            "          amt02    LIKE tlf_file.tlf222,",
            "          amt03    LIKE tlf_file.tlf222,",
            "          amt04    LIKE tlf_file.tlf222,",
            "          amt05    LIKE tlf_file.tlf222,",
            "          amt07    LIKE tlf_file.tlf222,",
            "          amt08    LIKE tlf_file.tlf222,",
            "          amt09    LIKE tlf_file.tlf222,",
            "          amt06    LIKE tlf_file.tlf222,",
            "          tlf031   LIKE tlf_file.tlf031,",
            "          tlf032   LIKE tlf_file.tlf032,",
            "          tlf907   LIKE tlf_file.tlf907,",
            "          tlf13    LIKE tlf_file.tlf13,",
            "          tlf036   LIKE tlf_file.tlf036)"
    PREPARE q776_table_pre FROM l_sql
    EXECUTE q776_table_pre
END FUNCTION 

FUNCTION q776_b_fill()
DEFINE    g_ckk      RECORD LIKE ckk_file.*
DEFINE    l_msg      STRING  
   LET g_sql = "SELECT ima12,imz02,ima57,ima08,tlf021,tlf06,tlf026,tlf62,tlf01,ima02,ima021,",
               "       ima39,ima391,tlf930,tlfccost,tlf10,amt01,amt02,amt03,amt04,amt05,amt07,",
               "       amt08,amt09,amt06",
               "  FROM axcq776_tmp",
               " ORDER BY ima12,imz02,ima57,ima08,tlf62,tlf01"
               
   PREPARE axcq776_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR axcq776_pb        #CURSOR

   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1 
   END FOREACH

   CALL q776_get_tot()
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1      
   LET g_rec_b = g_cnt
   #TQC-D50098--mark--str--
   #插入ckk_file
   #IF tm.z = 'Y' AND NOT cl_null(tm.bdate)
   #   AND NOT cl_null(tm.edate) AND g_rec_b > 0 THEN
   #   LET l_msg = tm.bdate,"|",tm.edate,"|",tm.type,"|",tm.stock,"|",tm.z 
   #   CALL s_ckk_fill('','306','axc-453',g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type,sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,
   #                   sr1.zf01,sr1.zf02,sr1.zf03,sr1.zf04,sr1.zf05,l_msg,g_user,g_today,g_time,'Y')
   #        RETURNING g_ckk.*
   #   IF NOT s_ckk(g_ckk.*,'') THEN END IF
   #END IF
   #CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
   #TQC-D50098--mark--str--
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec 
   END IF 
   DISPLAY g_rec_b TO FORMONLY.cn2 
END FUNCTION

FUNCTION q776_b_fill_2()

   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   CALL q776_get_tot()
   CALL q776_get_sum()
     
END FUNCTION

FUNCTION q776_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT ima12,imz02,'','','','','','',",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04), ",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06)",
                     "  FROM axcq776_tmp",
                     " GROUP BY ima12,imz02 ",
                     " ORDER BY ima12,imz02 "
      WHEN '2'
         LET l_sql = "SELECT '','',ima57,'','','','','',",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04), ",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06)",
                     "  FROM axcq776_tmp",
                     " GROUP BY ima57 ",
                     " ORDER BY ima57 "
      WHEN '3'
         LET l_sql = "SELECT '','','',ima08,'','','','',",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04), ",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06)",
                     "  FROM axcq776_tmp",
                     " GROUP BY ima08 ",
                     " ORDER BY ima08 "
      WHEN '4'
         LET l_sql = "SELECT '','','','','',tlf01,ima02,ima021,",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04), ",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06)",
                     "  FROM axcq776_tmp",
                     " GROUP BY tlf01,ima02,ima021 ",
                     " ORDER BY tlf01,ima02,ima021 "
                     
      WHEN '5'
         LET l_sql = "SELECT '','','','',tlf62,'','','',",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04), ",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06)",
                     "  FROM axcq776_tmp",
                     " GROUP BY tlf62 ",
                     " ORDER BY tlf62 "
   END CASE 
        
   PREPARE q776_pb FROM l_sql
   DECLARE q776_curs1 CURSOR FOR q776_pb
   FOREACH q776_curs1 INTO g_tlf_1_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf_1[g_cnt].* = g_tlf_1_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1
   END FOREACH
   DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf_1.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_1_excel.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1      
   LET g_rec_b2 = g_cnt
   IF g_rec_b2 > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b2||"|"||g_max_rec,10)
      LET g_rec_b2  = g_max_rec 
   END IF
   DISPLAY g_rec_b2 TO FORMONLY.cn2 
END FUNCTION  

FUNCTION q776_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page02'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q776_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q776_b_fill_2()
               CALL q776_set_visible()
               LET g_action_choice = "page02"
            END IF
            DISPLAY  tm.a TO a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY

      ON ACTION page01
         LET g_action_choice="page01"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q776_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page02", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page02", TRUE)
            LET g_action_choice= "page01"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   

      ON ACTION refresh_detail
         CALL cl_set_comp_visible("page02", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page02", TRUE)
         LET g_action_choice = 'page01' 
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

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q776_get_tot()
    LET sr1.qty = 0
    LET sr1.tot = 0
    LET sr1.cl = 0
    LET sr1.rg = 0
    LET sr1.jg = 0
    LET sr1.zf01 = 0
    LET sr1.zf02 = 0
    LET sr1.zf03 = 0
    LET sr1.zf04 = 0
    LET sr1.zf05 = 0
    SELECT SUM(tlf10),SUM(amt06),SUM(amt01),SUM(amt02),SUM(amt04),
           SUM(amt03),SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09)
      INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,sr1.zf01,sr1.zf02,
           sr1.zf03,sr1.zf04,sr1.zf05
      FROM axcq776_tmp
END FUNCTION 

FUNCTION q776_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,  
          l_sql        STRING, 
          l_sql1       STRING,
          l_sql2       STRING,
          l_tmp        STRING 
   LET l_sql = "SELECT ima12,imz02,ima57,ima08,tlf021,tlf06,tlf026,tlf62,tlf01,ima02,ima021,",
               "       ima39,ima391,tlf930,tlfccost,tlf10,amt01,amt02,amt03,amt04,amt05,amt07,",
               "       amt08,amt09,amt06",
               "  FROM axcq776_tmp"
               
   LET l_sql1= "SELECT SUM(tlf10),SUM(amt06),SUM(amt01),SUM(amt02),SUM(amt04),",
               "       SUM(amt03),SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09)",
               "  FROM axcq776_tmp WHERE 1=1 "


   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_tlf_1[p_ac].ima12) THEN 
            LET g_tlf_1[p_ac].ima12 = ''
            LET l_tmp = " OR ima12 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima12,imz02,ima57,ima08,tlf62,tlf01"
         LET l_sql1= l_sql1," AND  (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " GROUP BY ima12,imz02",
                           " ORDER BY ima12,imz02"

      WHEN "2"
         IF cl_null(g_tlf_1[p_ac].ima57) THEN 
            LET g_tlf_1[p_ac].ima57 = ''
            LET l_tmp = " OR ima57 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima57,ima12,imz02,ima08,tlf62,tlf01"
         LET l_sql1= l_sql1," AND  (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )",
                            " GROUP BY ima57",
                            " ORDER BY ima57"
         
      WHEN "3"
         IF cl_null(g_tlf_1[p_ac].ima08) THEN 
            LET g_tlf_1[p_ac].ima08 = ''
            LET l_tmp = " OR ima08 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,imz02,ima57,tlf62,tlf01"
         LET l_sql1= l_sql1," AND  (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )",
                            " GROUP BY ima08",
                            " ORDER BY ima08"

      WHEN "5"
         IF cl_null(g_tlf_1[p_ac].tlf62) THEN 
            LET g_tlf_1[p_ac].tlf62 = ''
            LET l_tmp = " OR tlf62 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (tlf62 = '",g_tlf_1[p_ac].tlf62 CLIPPED,"'",l_tmp," )",
                           " ORDER BY tlf62,ima08,ima57,ima12,imz02,tlf01"
         LET l_sql1= l_sql1," AND  (tlf62 = '",g_tlf_1[p_ac].tlf62 CLIPPED,"'",l_tmp," )",
                            " GROUP BY tlf62",
                            " ORDER BY tlf62"
         
      WHEN "4"
         IF cl_null(g_tlf_1[p_ac].tlf01) THEN 
            LET g_tlf_1[p_ac].tlf01 = ''
            LET l_tmp = " OR tlf01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )",
                           " ORDER BY tlf01,ima02,ima021,ima12,imz02,ima57,ima08,tlf62"
         LET l_sql1= l_sql1," AND  (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )",
                            " GROUP BY tlf01,ima02,ima021",
                            " ORDER BY tlf01,ima02,ima021"

   END CASE

   PREPARE axcq_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR axcq_pb_detail        #CURSOR
   
   PREPARE axcq_pb_det_sr1 FROM l_sql1                                                                                               
   DECLARE axcq_cs_sr1 CURSOR FOR axcq_pb_det_sr1                                                                                      
   OPEN axcq_cs_sr1                                                                                                             
   FETCH axcq_cs_sr1 INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,
                          sr1.jg,sr1.zf01,sr1.zf02,
                          sr1.zf03,sr1.zf04,sr1.zf05


   CALL g_tlf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs_detail INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1  
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_tlf.deleteElement(g_cnt)
   END IF
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION 

FUNCTION q776_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON ima12,ima57,ima08,tlf021,tlf06,tlf026,tlf62,tlf01,
                         ima39,ima391,tlf930,tlf10
                    FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08,
                         s_tlf[1].tlf021,s_tlf[1].tlf06,s_tlf[1].tlf026,s_tlf[1].tlf62,
                         s_tlf[1].tlf01,s_tlf[1].ima39,s_tlf[1].ima391,
                         s_tlf[1].tlf930,s_tlf[1].tlf10
      BEFORE CONSTRUCT
         DISPLAY tm.bdate TO bdate
         DISPLAY tm.edate TO edate
         DISPLAY tm.type TO TYPE
         DISPLAY tm.z TO z
         DISPLAY tm.stock TO stock
         DISPLAY tm.a TO a 
         CALL cl_qbe_init()

     ON ACTION controlp                                                      
        CASE
           WHEN INFIELD(ima12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "G"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima12 
              NEXT FIELD ima12
           #FUN-D10022-add--str
            WHEN INFIELD(tlf021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf021
               NEXT FIELD tlf021
            WHEN INFIELD(tlf026)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfp"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf026
               NEXT FIELD tlf026
            WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39 
               NEXT FIELD ima39 
            WHEN INFIELD(ima391)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima391"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima391 
               NEXT FIELD ima391 
            WHEN INFIELD(tlf930)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_smh"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf930
               NEXT FIELD tlf930
            #FUN-D10022-add--end   
           WHEN INFIELD(tlf01)                                             
              CALL cl_init_qry_var()                                           
              LET g_qryparam.form = "q_ima"                                    
              LET g_qryparam.state = "c"                                       
              CALL cl_create_qry() RETURNING g_qryparam.multiret               
              DISPLAY g_qryparam.multiret TO tlf01                             
              NEXT FIELD tlf01    

           WHEN INFIELD(tlf62)                                               
              CALL cl_init_qry_var()                                           
              LET g_qryparam.form = "q_sfb"                                    
              LET g_qryparam.state = "c"                                       
              CALL cl_create_qry() RETURNING g_qryparam.multiret               
              DISPLAY g_qryparam.multiret TO tlf62                             
              NEXT FIELD tlf62              
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
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 
   LET l_wc = cl_replace_str(l_wc,'tlf021',"(CASE WHEN tlf907=1 AND tlf13<>'asft700' THEN tlf031 ELSE tlf021 END)") #FUN-D10022
   LET l_wc = cl_replace_str(l_wc,'tlf026',"(CASE WHEN tlf907=1 AND tlf13<>'asft700' THEN tlf036 ELSE tlf026 END)") #FUN-D10022
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION
#FUN-D10022---add---end

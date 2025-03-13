# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: axrq310.4gl
# Descriptions...: 應收帳款查詢
# Date & Author..: 94/02/10 by Nick 未收金額=0 不印 類別為2* 之未收金額應為負
# Modify.........: No.8522 03/10/20 By Kitty F3按到最後一頁時資料不正確,加show本幣
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-5C0086 06/05/08 By ice AR月底重評修改
# Modify.........: No.FUN-5C0014 06/05/29 By rainy 顯示發票號碼及INVOICE NO.
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.TQC-690117 06/10/17 By Smapmin 補上oma66
# Modify.........: No.FUN-6A0095 06/11/06 By xumin l_time轉g_time
# Modify.........: No.TQC-770016 07/07/02 By judy 匯出EXCEL的值多一空白行
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/30 By wujie  增来源单据联查
#                                                   增加原/本币应收/已付金额 
# Modify.........: No.TQC-B10157 11/01/14 By yinhy 為與axrq320顯示數據統一，類別為2* 之oma54t,oma55,oma56t,oma57改為負
# Modify.........: No.MOD-B40268 11/04/29 By wujie TQC-B10157有改错
# Modify.........: No.TQC-BB0244 11/11/29 By yinhy tot01顯示為空
# Modify.........: No.MOD-C50070 12/05/11 By Elise 本幣未沖金額只有在ooz07="N"時才會以負數呈現
# Modify.........: No.MOD-C60011 12/06/01 By yinhy 增加客戶編號欄位
# Modify.........: No.FUN-C80102 12/09/26 By chenying 報表改善
# Modify.........: No.FUN-CB0146 13/01/08 By zhangweib 報表查詢時間優化
# Modify.........: No.TQC-D30014 13/03/05 By xuxz 當賬款類型為11/12/13/14時，沖帳金額、已收金額應該顯示為負數
# Modify.........: No.FUN-D40121 13/05/31 By lujh 增加傳參
# Modify.........: No.TQC-D60013 13/06/05 By wangrr 點擊“串查待抵單”按鈕時,根據賬款類別oma19分別開啟aapq230 \aapq231\aapq240
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_oma           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oma00       LIKE oma_file.oma00,
        oma01       LIKE oma_file.oma01,
        oma02       LIKE oma_file.oma02,
        oma03       LIKE oma_file.oma03,   #MOD-C60011
        oma032      LIKE oma_file.oma032,  #FUN-C80102 add
        oma23       LIKE oma_file.oma23,
        oma54       LIKE oma_file.oma54,   #FUN-C80102 add
        oma54x      LIKE oma_file.oma54x,  #FUN-C80102 add
        oma51f      LIKE oma_file.oma51f,  #FUN-C80102 add
        oma54t      LIKE oma_file.oma54t,      #No.FUN-A30028
        oma55       LIKE oma_file.oma55,       #No.FUN-A30028
        amt1        LIKE oma_file.oma54t, #FUN-C80102 add
        oma56       LIKE oma_file.oma56,  #FUN-C80102 add
        oma56x      LIKE oma_file.oma56x, #FUN-C80102 add
        oma51       LIKE oma_file.oma51,  #FUN-C80102 add
        oma56t      LIKE oma_file.oma56t,      #No.FUN-A30028
        oma57       LIKE oma_file.oma57,       #No.FUN-A30028
        amt2        LIKE oma_file.oma56t, #FUN-C80102 add
        oma10       LIKE oma_file.oma10,   #FUN-C80102 add
        oma09       LIKE oma_file.oma09,   #FUN-C80102 add
        oma67       LIKE oma_file.oma67,   #FUN-C80102 add
        oma33       LIKE oma_file.oma33,   #FUN-C80102 add
        oma211      LIKE oma_file.oma211,  #FUN-C80102 add
        oma24       LIKE oma_file.oma24,   #FUN-C80102 add
        oma15       LIKE oma_file.oma15,
        gem02       LIKE gem_file.gem02,   #FUN-C80102 add
        oma14       LIKE oma_file.oma14,   #FUN-C80102 add
        gen02       LIKE gen_file.gen02,   #FUN-C80102 add
        oma11       LIKE oma_file.oma11,
        oma16       LIKE oma_file.oma16,   #FUN-C80102 add
        oma52       LIKE oma_file.oma52,   #FUN-C80102 add
        oma53       LIKE oma_file.oma53,  #FUN-C80102 add
        oma18       LIKE oma_file.oma18,   #FUN-C80102 add
        aag02       LIKE aag_file.aag02,   #FUN-C80102 add  
        oma08       LIKE oma_file.oma08,   #FUN-C80102 add
        oma19       LIKE oma_file.oma19,   #FUN-C80102 add
        oma99       LIKE oma_file.oma99,   #FUN-C80102 add
        oma68       LIKE oma_file.oma68,   #FUN-C80102 add
        oma69       LIKE oma_file.oma69,   #FUN-C80102 add
        oma04       LIKE oma_file.oma04,   #FUN-C80102 add
        occ18       LIKE occ_file.occ18,   #FUN-C80102 add
       #oma032      LIKE oma_file.oma032,  #FUN-C80102 mark
        oma21       LIKE oma_file.oma21,   #FUN-C80102 add
       #balance     integer,                   #No.+138 010522 by plum
       #balance     LIKE oma_file.oma54t, #FUN-C80102 mark
       #balance1    LIKE oma_file.oma56t,      #No:8522      #FUN-C80102 mark
        omaconf     LIKE oma_file.omaconf,
        oma66       LIKE oma_file.oma66,       #FUN-630043   
        azp01       LIKE azp_file.azp01        #FUN-C80102 
       #oma10       LIKE oma_file.oma10,       #FUN-5C0015   #FUN-C80102 mark
       #oma67       LIKE oma_file.oma67        #FUN-5C0015   #FUN-C80102 mark
                    END RECORD 
#FUN-C80102--add---str---
DEFINE  g_oma_1        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        mm          LIKE type_file.chr1000,
        oma03       LIKE oma_file.oma03,  
        oma032      LIKE oma_file.oma032, 
        oma68       LIKE oma_file.oma68, 
        oma69       LIKE oma_file.oma69, 
        oma15       LIKE oma_file.oma15,
        gem02       LIKE gem_file.gem02,   
        oma14       LIKE oma_file.oma14, 
        gen02       LIKE gen_file.gen02,  
        oma18       LIKE oma_file.oma18, 
        aag02       LIKE aag_file.aag02, 
        oma23       LIKE oma_file.oma25,
        oma52       LIKE oma_file.oma52,  
        oma54       LIKE oma_file.oma54,  
        oma54x      LIKE oma_file.oma54x, 
        oma51f      LIKE oma_file.oma51f, 
        oma54t      LIKE oma_file.oma54t, 
        oma55       LIKE oma_file.oma55,  
        amt1        LIKE oma_file.oma54t, 
        oma53       LIKE oma_file.oma53,  
        oma56       LIKE oma_file.oma56,  
        oma56x      LIKE oma_file.oma56x, 
        oma51       LIKE oma_file.oma51,  
        oma56t      LIKE oma_file.oma56t, 
        oma57       LIKE oma_file.oma57 
                    END RECORD      
DEFINE tm      RECORD                   
               u      LIKE type_file.chr1,  
               a      LIKE type_file.chr1,
               d1     LIKE type_file.chr1,
               d2     LIKE type_file.chr1,
               org    LIKE type_file.chr1,
               c      LIKE type_file.chr1
               END RECORD, 
#FUN-C80102--add---end--- 
   #l_tot01	    INTEGER,                   #No.+138
    l_tot01	    LIKE oma_file.oma56t,
    g_wc2,g_sql     string,                    #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5,       #單身筆數  #No.FUN-680123 SMALLINT
    g_rec_b2        LIKE type_file.num5,       #FUN-C80102
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT  #No.FUN-680123 SMALLINT
    l_ac1           LIKE type_file.num5,       #FUN-C80102
    l_sl            LIKE type_file.num5        #目前處理的SCREEN LINE #No.FUN-680123 SMALLINT
 
DEFINE   g_cnt      LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE   g_msg      LIKE type_file.chr1000     #No.FUN-A30028
DEFINE   g_flag         LIKE type_file.chr1    #FUN-C80102 
DEFINE   g_action_flag  LIKE type_file.chr100  #FUN-C80102 
DEFINE   g_filter_wc    STRING                 #FUN-C80102
DEFINE   g_comb         ui.ComboBox            #FUN-C80102 
DEFINE   g_cmd          LIKE type_file.chr1000 #FUN-C80102
#FUN-C80102---add--str--
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
#FUN-C80102---add--end--
#FUN-D40121--add--str--
DEFINE l_u    LIKE type_file.chr1
DEFINE l_org  LIKE type_file.chr1
DEFINE l_c    LIKE type_file.chr1
DEFINE l_wc   STRING  
#FUN-D40121--add--end--

MAIN
# DEFINE l_time       LIKE type_file.chr8        #計算被使用時間 #No.FUN-680123 VARCHAR(8)     #No.FUN-6A0095
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680123 SMALLINT
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818   #No.FUN-6A0095
        RETURNING g_time   #No.FUN-6A0095

   #FUN-D40121--add--str--
   LET l_u = ARG_VAL(1)
   LET l_org = ARG_VAL(2)
   LET l_c = ARG_VAL(3)
   LET l_wc = ARG_VAL(4)
   LET l_wc = cl_replace_str(l_wc, "\\\"", "'") 
   #FUN-D40121--add--end--

    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q310_w AT p_row,p_col WITH FORM "axr/42f/axrq310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_entry("c",FALSE)               #FUN-C80102 add
    CALL cl_set_comp_visible("azp01",FALSE)               #FUN-C80102 add
    CALL cl_set_act_visible("revert_filter",FALSE)  #FUN-C80102

#FUN-C80102--add--str--  
    INITIALIZE tm.* TO NULL
    IF cl_null(l_u) THEN       #FUN-D40121 add
    LET tm.u = ' '  
    #FUN-D40121--add--str--
    ELSE
      IF l_u = '1' THEN
         LET tm.u = '4'
      END IF
      IF l_u = '2' THEN
         LET tm.u = '1'
      END IF
      IF l_u = '3' THEN
         LET tm.u = ' '
      END IF
    END IF
    #FUN-D40121--add--end--
    LET tm.d1 = '3'  
    LET tm.d2 = '3'
    IF cl_null(l_org) THEN     #FUN-D40121 add
       LET tm.org = 'N'
    #FUN-D40121--add--str--
    ELSE
       LET tm.org = l_org 
    END IF 
    #FUN-D40121--add--end--     
    IF cl_null(l_c) THEN       #FUN-D40121 add
       LET tm.c = 'N'
    #FUN-D40121--add--str--
    ELSE
       LET tm.c = l_c
    END IF  
    #FUN-D40121--add--end--  
  
   IF g_azw.azw04 <> '2' THEN  
      LET g_comb = ui.ComboBox.forName("oma00")
      CALL g_comb.removeItem('15')
      CALL g_comb.removeItem('16') 
      CALL g_comb.removeItem('17')
      CALL g_comb.removeItem('18')
      CALL g_comb.removeItem('19')
      CALL g_comb.removeItem('26')
      CALL g_comb.removeItem('27')
      CALL g_comb.removeItem('28')
   END IF
#FUN-C80102--add--end--  
    IF cl_null(l_wc) THEN 
       CALL q310_q()    #FUN-C80102 remark
    ELSE
       CALL q310_get_temp('1=1')
       CALL q310_t() 
    END IF 
    CALL q310_menu()
    DROP TABLE axrq310_tmp;
    CLOSE WINDOW q310_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818   #No.FUN-6A0095
        RETURNING g_time     #No.FUN-6A0095
END MAIN
 
FUNCTION q310_menu()
 
   WHILE TRUE
#FUN-C80102--add--str-- 
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q310_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q310_bp2()
         END IF
      END IF 
#FUN-C80102--add--end--
#     CALL q310_bp("G")   #FUN-C80102 mark
      CASE g_action_choice
#FUN-C80102--add--str--
      WHEN "page1"
            CALL q310_bp("G")
         
      WHEN "page2"
            CALL q310_bp2()

      WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q310_filter_askkey()
               CALL q310_show()
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102 
            END IF            

      WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q310_show() 
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102 
            END IF
#FUN-C80102--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q310_q()
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102 
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-C80102 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "  #FUN-C80102 
#No.FUN-A30028 --begin
#FUN-C80102--mark---str---
#        WHEN "qry_oma"
#           IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
#              LET g_msg = "axrt300 '",g_oma[l_ac].oma01,"'"
#              CALL cl_cmdrun(g_msg)
#           END IF
#No.FUN-A30028 --end 
#FUN-C80102--mark---end---
         #FUN-4B0017
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  #FUN-C80102 add
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_oma),'','') 
                END IF
             END IF  #FUN-C80102
#FUN-C80120--add--str--
             IF g_action_flag = "page2" THEN 
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_oma_1),'','') 
                END IF
             END IF 
#FUN-C80120--add--end--
             LET g_action_choice = " "  #FUN-C80102 
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q310_q()
   CALL q310_b_askkey()
END FUNCTION
 
 
FUNCTION q310_b_askkey()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01 
    CLEAR FORM
    CALL g_oma.clear()
    CALL cl_opmsg('q')
    CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)  #FUN-C80102 add
#FUN-C80102--mod--str---   
#   CONSTRUCT g_wc2 ON oma00,oma01,oma02,oma11,oma15,oma03,oma032,oma23,omaconf,oma66,oma10,oma67 #FUN-630043 #FUN-5C0015 add oma10,oma67  #MOD-C60011 add oma03
#           FROM s_oma[1].oma00,s_oma[1].oma01,s_oma[1].oma02,
#                s_oma[1].oma11,s_oma[1].oma15,s_oma[1].oma03,    #MOD-C60011 add oma03
#                s_oma[1].oma032,s_oma[1].oma23,s_oma[1].omaconf,s_oma[1].oma66,s_oma[1].oma10,s_oma[1].oma67 #FUN-630043 #FUN-5C0014 add oma10,oma67
    DISPLAY BY NAME tm.u,tm.d1,tm.d2,tm.org,tm.c
    DIALOG ATTRIBUTE(UNBUFFERED)           
    INPUT BY NAME tm.u,tm.d1,tm.d2,tm.org,tm.c ATTRIBUTES (WITHOUT DEFAULTS=TRUE)
       BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)    

       AFTER FIELD org
       #     IF tm.org = 'Y' THEN 
       #        CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)
       #     ELSE
       #        CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",FALSE)
       #     END IF
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("c",TRUE)
             ELSE
                CALL cl_set_comp_entry("c",FALSE)
             END IF
         
       AFTER FIELD u
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("c",TRUE)
             ELSE
                CALL cl_set_comp_entry("c",FALSE)
             END IF

        AFTER INPUT 
       #     IF tm.org = 'N' THEN  
       #        CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",FALSE)
       #     ELSE
       #        CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)
       #     END IF
    END INPUT   

    CONSTRUCT g_wc2 ON oma00,oma01,oma02,oma03,oma032,oma23,oma54,oma54x,oma51f,oma54t,oma55,amt1,oma56,oma56x,
                       oma51,oma56t,oma57,amt2,oma10,oma09,oma67,oma33,oma211,oma24,oma15,oma14,oma11,
                       oma16,oma52,oma53,oma18,oma08,oma19,oma99,oma68,oma69,oma04,oma21,omaconf,oma66   
                  FROM s_oma[1].oma00,s_oma[1].oma01,s_oma[1].oma02,s_oma[1].oma03,s_oma[1].oma032,
                       s_oma[1].oma23,s_oma[1].oma54,s_oma[1].oma54x,s_oma[1].oma51f,s_oma[1].oma54t,
                       s_oma[1].oma55,amt1,s_oma[1].oma56,s_oma[1].oma56x,s_oma[1].oma51,s_oma[1].oma56t,
                       s_oma[1].oma57,amt2,s_oma[1].oma10,s_oma[1].oma09,s_oma[1].oma67,
                       s_oma[1].oma33,s_oma[1].oma211,s_oma[1].oma24,s_oma[1].oma15,s_oma[1].oma14,
                       s_oma[1].oma11,s_oma[1].oma16,s_oma[1].oma52,s_oma[1].oma53,s_oma[1].oma18,
                       s_oma[1].oma08,s_oma[1].oma19,s_oma[1].oma99,s_oma[1].oma68,s_oma[1].oma69,
                       s_oma[1].oma04,s_oma[1].oma21,s_oma[1].omaconf,s_oma[1].oma66
#FUN-C80102--mod--end---   
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    END CONSTRUCT  #FUN-C80102 
#FUN-C80102--add--str--
      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(oma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma01
               NEXT FIELD oma01

          WHEN INFIELD(oma03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma03
               NEXT FIELD oma03
          
          WHEN INFIELD(oma032)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma032
               NEXT FIELD oma032
   
          WHEN INFIELD(oma68)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma68
               NEXT FIELD oma68

          WHEN INFIELD(oma69)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma69
               NEXT FIELD oma69

          WHEN INFIELD(oma04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma04
               NEXT FIELD oma04

          WHEN INFIELD(oma15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem3"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma15
               NEXT FIELD oma15 

          WHEN INFIELD(oma14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen5"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma14
               NEXT FIELD oma14

          WHEN INFIELD(oma18)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma18
               NEXT FIELD oma18  
          
          WHEN INFIELD(oma21)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gec8_1"
               LET g_qryparam.arg1 = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma21
 
          WHEN INFIELD(oma23)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma23
               NEXT FIELD oma23

         END CASE  

      AFTER DIALOG 
         IF tm.org = 'Y' THEN
            CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)
         ELSE
            CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",FALSE)
         END IF      

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

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
            
      ON ACTION close
         LET INT_FLAG = 1
         EXIT DIALOG 
#FUN-C80102--add--end--
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
         #CONTINUE CONSTRUCT #FUN-C80102
          CONTINUE DIALOG    #FUN-C80102 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
#   END CONSTRUCT #FUN-C80102 mark
    END DIALOG    #FUN-C80102 add
#FUN-C80102--add--str-- 
    IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
    END IF 
#FUN-C80102--add--end-- 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN#只能使用自己的資料
    #        LET g_wc2 = g_wc2 clipped," AND omauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc2 = g_wc2 clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc2 = g_wc2 clipped," AND omagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
    #End:FUN-980030
     
    LET g_wc2 =cl_replace_str(g_wc2, "amt1", "oma54t-oma55")   #FUN-C80102
    LET g_wc2 =cl_replace_str(g_wc2, "amt2", "oma56t-oma57")   #FUN-C80102
   #CALL q310_b_fill(g_wc2)  #FUN-C80102 mark
   #CALL q310()              #FUN-C80102 add   #No.FUN-CB0146  Mark
    CALL q310_get_temp(g_wc2)                  #No.FUN-CB0145 Add
    CALL q310_t()            #FUN-C80102 add  
END FUNCTION

#FUN-C80102--add--str---
FUNCTION q310()
   CALL q310_table()
   LET g_sql = "INSERT INTO axrq310_tmp",                                                                
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ", 
               "        ?,? ,? ,?,?  )"  
               
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        
      EXIT PROGRAM                                                                                                                 
   END IF

   CALL q310_get_tmp(g_wc2)

END FUNCTION

FUNCTION q310_table()
   DROP TABLE axrq310_tmp;
      CREATE TEMP TABLE axrq310_tmp(
        oma00       LIKE oma_file.oma00,
        oma01       LIKE oma_file.oma01,
        oma02       LIKE oma_file.oma02,
        oma03       LIKE oma_file.oma03,
        oma032      LIKE oma_file.oma032,
        oma23       LIKE oma_file.oma23,
        oma54       LIKE oma_file.oma54,
        oma54x      LIKE oma_file.oma54x,
        oma51f      LIKE oma_file.oma51f,
        oma54t      LIKE oma_file.oma54t,
        oma55       LIKE oma_file.oma55,
        amt1        LIKE oma_file.oma54t,
        oma56       LIKE oma_file.oma56,
        oma56x      LIKE oma_file.oma56x,
        oma51       LIKE oma_file.oma51,
        oma56t      LIKE oma_file.oma56t,
        oma57       LIKE oma_file.oma57,
        amt2        LIKE oma_file.oma56t,
        oma10       LIKE oma_file.oma10,
        oma09       LIKE oma_file.oma09,
        oma67       LIKE oma_file.oma67,
        oma33       LIKE oma_file.oma33,
        oma211      LIKE oma_file.oma211,
        oma24       LIKE oma_file.oma24,
        oma15       LIKE oma_file.oma15,
        gem02       LIKE gem_file.gem02,
        oma14       LIKE oma_file.oma14,
        gen02       LIKE gen_file.gen02,
        oma11       LIKE oma_file.oma11,
        oma16       LIKE oma_file.oma16,
        oma52       LIKE oma_file.oma52,
        oma53       LIKE oma_file.oma53,
        oma18       LIKE oma_file.oma18,
        aag02       LIKE aag_file.aag02,
        oma08       LIKE oma_file.oma08,
        oma19       LIKE oma_file.oma19,
        oma99       LIKE oma_file.oma99,
        oma68       LIKE oma_file.oma68,
        oma69       LIKE oma_file.oma69,
        oma04       LIKE oma_file.oma04,
        occ18       LIKE occ_file.occ18,
        oma21       LIKE oma_file.oma21,
        omaconf     LIKE oma_file.omaconf,
        oma66       LIKE oma_file.oma66,
        azp01       LIKE azp_file.azp01)
     
END FUNCTION

FUNCTION q310_t()
   IF tm.org = 'Y' THEN 
      CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE) 
      CALL cl_set_comp_visible("oma23_1,oma52_1,oma54_1,oma54x_1,oma51f_1,oma54t_1,oma55_1,amt1_1",TRUE) 
   ELSE
      CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",FALSE) 
      CALL cl_set_comp_visible("oma23_1,oma52_1,oma54_1,oma54x_1,oma51f_1,oma54t_1,oma55_1,amt1_1",FALSE) 
   END  IF 
   CLEAR FORM
   CALL g_oma.clear()
   CALL q310_show()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q310_show()
   DISPLAY tm.u TO u
   DISPLAY tm.c TO c
   DISPLAY tm.org TO org 
   DISPLAY tm.d1 TO d1 
   DISPLAY tm.d2 TO d2 

   
   CALL q310_b_fill_1()
   CALL q310_b_fill_2()
   IF cl_null(tm.u)  THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   ELSE
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
   END IF

   CALL q310_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q310_set_visible()

   CALL cl_set_comp_visible("mm,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,gen02_1,oma14_1,gem02_1,oma18_1,aag02_1",TRUE) 
   CALL cl_set_comp_visible("oma53_1,oma56_1,oma56x_1,oma51_1,oma56t_1,oma57_1",TRUE)
   CASE tm.u
        WHEN "1"  CALL cl_set_comp_visible("mm,oma15_1,oma14_1,oma18_1,gen02_1,gem02_1,aag02_1",FALSE)  
        WHEN "2"  CALL cl_set_comp_visible("mm,oma03_1,oma032_1,oma68_1,oma69_1,oma14_1,oma18_1,gen02_1,aag02_1",FALSE)
        WHEN "3"  CALL cl_set_comp_visible("mm,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,oma18_1,gem02_1,aag02_1",FALSE)
        WHEN "4"  CALL cl_set_comp_visible("mm,oma03_1,oma032_1,oma68_1,oma69_1,oma14_1,oma15_1,gen02_1,gem02_1",FALSE)
        WHEN "5"  CALL cl_set_comp_visible("oma03_1,oma032_1,oma68_1,oma69_1,oma14_1,oma18_1,oma15_1,gen02_1,gem02_1,aag02_1",FALSE)
   END CASE
END FUNCTION

FUNCTION q310_b_fill_2()
DEFINE l_oma23  LIKE oma_file.oma23
DEFINE g_tot1   LIKE oma_file.oma56t
DEFINE g_tot2   LIKE oma_file.oma56t
DEFINE g_tot3   LIKE oma_file.oma56t
DEFINE g_tot4   LIKE oma_file.oma56t
DEFINE g_tot5   LIKE oma_file.oma56t
DEFINE g_tot6   LIKE oma_file.oma56t

   CALL g_oma_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   LET g_tot1 = 0
   LET g_tot2 = 0
   LET g_tot3 = 0
   LET g_tot4 = 0
   LET g_tot5 = 0
   LET g_tot6 = 0

   IF tm.c = "Y" THEN
      LET g_sql = " SELECT distinct oma23 FROM axrq310_tmp ORDER BY oma23"

      PREPARE q310_bp_d FROM g_sql
      DECLARE q310_curs_d CURSOR FOR q310_bp_d
      FOREACH q310_curs_d INTO l_oma23
         CALL q310_get_sum(l_oma23)
         LET g_tot1 = g_tot1 + g_oma_1[g_cnt].oma53
         LET g_tot2 = g_tot2 + g_oma_1[g_cnt].oma56
         LET g_tot3 = g_tot3 + g_oma_1[g_cnt].oma56x
         LET g_tot4 = g_tot4 + g_oma_1[g_cnt].oma51
         LET g_tot5 = g_tot5 + g_oma_1[g_cnt].oma56t
         LET g_tot6 = g_tot6 + g_oma_1[g_cnt].oma57
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF 
      END FOREACH
      DISPLAY g_tot1 TO FORMONLY.oma53_tot
      DISPLAY g_tot2 TO FORMONLY.oma56_tot
      DISPLAY g_tot3 TO FORMONLY.oma56x_tot
      DISPLAY g_tot4 TO FORMONLY.oma51_tot
      DISPLAY g_tot5 TO FORMONLY.oma56t_tot
      DISPLAY g_tot6 TO FORMONLY.oma57_tot
   ELSE
      CALL q310_get_sum('')
   END IF      
 
END FUNCTION

FUNCTION q310_get_sum(p_oma23)
DEFINE p_oma23 LIKE oma_file.oma23
DEFINE l_tot1   LIKE oma_file.oma56t
DEFINE l_tot2   LIKE oma_file.oma56t
DEFINE l_tot3   LIKE oma_file.oma56t
DEFINE l_tot4   LIKE oma_file.oma56t
DEFINE l_tot5   LIKE oma_file.oma56t
DEFINE l_tot6   LIKE oma_file.oma56t
DEFINE l_tot7   LIKE oma_file.oma56t
DEFINE l_tot8   LIKE oma_file.oma56t
DEFINE l_tot9   LIKE oma_file.oma56t
DEFINE l_tot10  LIKE oma_file.oma56t
DEFINE l_tot11  LIKE oma_file.oma56t
DEFINE l_tot12  LIKE oma_file.oma56t
DEFINE l_tot13  LIKE oma_file.oma56t
DEFINE l_year   LIKE type_file.num5  
DEFINE l_month  LIKE type_file.num5  
DEFINE l_yy     STRING  
DEFINE l_mm     STRING  

LET l_tot1 = 0 
LET l_tot2 = 0 
LET l_tot3 = 0 
LET l_tot4 = 0 
LET l_tot5 = 0 
LET l_tot6 = 0 
LET l_tot7 = 0 
LET l_tot8 = 0 
LET l_tot9 = 0 
LET l_tot10 = 0 
LET l_tot11 = 0
LET l_tot12 = 0 
LET l_tot13 = 0 

  #FUN-D40121--add--str--
   IF cl_null(l_wc) THEN 
      LET l_wc = '1=1'
   END IF 
   #FUN-D40121--add--end--

  CASE tm.u 
     WHEN "1"
     IF tm.org = "Y" THEN 
        LET g_sql = "SELECT '',oma03,'',oma68,'','','','','','','',oma23,SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"
     ELSE
        LET g_sql = "SELECT '',oma03,'',oma68,'','','','','','','','',SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"
     END IF
        LET g_sql = g_sql ClIPPED, "       SUM(oma54t-oma55),SUM(oma53),SUM(oma56),SUM(oma56x),SUM(oma51),SUM(oma56t),SUM(oma57) ",
                    "  FROM axrq310_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.org = "Y" THEN 
           LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma03,oma68,oma23 ",
                    " ORDER BY oma03,oma68,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma03,oma68 ",
                    " ORDER BY oma03,oma68 "
        END IF 
        PREPARE q310_pb1 FROM g_sql
        DECLARE q310_curs1 CURSOR FOR q310_pb1
        FOREACH q310_curs1 INTO g_oma_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct oma032 INTO g_oma_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_oma_1[g_cnt].oma03

        IF tm.c = "N" THEN
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
        END IF
        IF tm.c ="Y" THEN
           LET l_tot1 = l_tot1 + g_oma_1[g_cnt].oma52
           LET l_tot2 = l_tot2 + g_oma_1[g_cnt].oma54
           LET l_tot3 = l_tot3 + g_oma_1[g_cnt].oma54x
           LET l_tot4 = l_tot4 + g_oma_1[g_cnt].oma55
           LET l_tot5 = l_tot5 + g_oma_1[g_cnt].amt1
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
           LET l_tot12 = l_tot12 + g_oma_1[g_cnt].oma51f
           LET l_tot13 = l_tot13 + g_oma_1[g_cnt].oma54t
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        END FOREACH

     WHEN "2"
     IF tm.org = "Y" THEN  
        LET g_sql = "SELECT '','','','','',oma15,'','','','','',oma23,SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"   
     ELSE
        LET g_sql = "SELECT '','','','','',oma15,'','','','','','',SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"   
     END IF
        LET g_sql = g_sql CLIPPED,"       SUM(oma54t-oma55),SUM(oma53),SUM(oma56),SUM(oma56x),SUM(oma51),SUM(oma56t),SUM(oma57) ",
                    "  FROM axrq310_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
     IF tm.org = "Y"  THEN 
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma15,oma23 ",
                    " ORDER BY oma15,oma23 "
     ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma15 ",
                    " ORDER BY oma15 "
     END IF 
        PREPARE q310_pb2 FROM g_sql
        DECLARE q310_curs2 CURSOR FOR q310_pb2
        FOREACH q310_curs2 INTO g_oma_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct oma032 INTO g_oma_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_oma_1[g_cnt].oma03
        SELECT distinct gem02 INTO g_oma_1[g_cnt].gem02 FROM gem_file WHERE gem01 = g_oma_1[g_cnt].oma15

        IF tm.c = "N" THEN
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
        END IF
        IF tm.c ="Y" THEN
           LET l_tot1 = l_tot1 + g_oma_1[g_cnt].oma52
           LET l_tot2 = l_tot2 + g_oma_1[g_cnt].oma54
           LET l_tot3 = l_tot3 + g_oma_1[g_cnt].oma54x
           LET l_tot4 = l_tot4 + g_oma_1[g_cnt].oma55
           LET l_tot5 = l_tot5 + g_oma_1[g_cnt].amt1
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
           LET l_tot12 = l_tot12 + g_oma_1[g_cnt].oma51f
           LET l_tot13 = l_tot13 + g_oma_1[g_cnt].oma54t
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        END FOREACH

     WHEN "3"
     IF tm.org = "Y" THEN  
        LET g_sql = "SELECT '','','','','','','',oma14,'','','',oma23,SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"  
     ELSE 
        LET g_sql = "SELECT '','','','','','','',oma14,'','','','',SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"   
     END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(oma54t-oma55),SUM(oma53),SUM(oma56),SUM(oma56x),SUM(oma51),SUM(oma56t),SUM(oma57) ",
                    "  FROM axrq310_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
     IF tm.org = "Y" THEN  
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma14,oma23 ",
                    " ORDER BY oma14,oma23 "
     ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma14 ",
                    " ORDER BY oma14 "
     END IF
        PREPARE q310_pb3 FROM g_sql
        DECLARE q310_curs3 CURSOR FOR q310_pb3
        FOREACH q310_curs3 INTO g_oma_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct oma032 INTO g_oma_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_oma_1[g_cnt].oma03
        SELECT distinct gen02 INTO g_oma_1[g_cnt].gen02 FROM gen_file WHERE gen01 = g_oma_1[g_cnt].oma14

        IF tm.c = "N" THEN
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
        END IF
        IF tm.c ="Y" THEN
           LET l_tot1 = l_tot1 + g_oma_1[g_cnt].oma52
           LET l_tot2 = l_tot2 + g_oma_1[g_cnt].oma54
           LET l_tot3 = l_tot3 + g_oma_1[g_cnt].oma54x
           LET l_tot4 = l_tot4 + g_oma_1[g_cnt].oma55
           LET l_tot5 = l_tot5 + g_oma_1[g_cnt].amt1
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
           LET l_tot12 = l_tot12 + g_oma_1[g_cnt].oma51f
           LET l_tot13 = l_tot13 + g_oma_1[g_cnt].oma54t
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        END FOREACH

     WHEN "4"
     IF tm.org = "Y"  THEN
        LET g_sql = "SELECT '','','','','','','','','',oma18,'',oma23,SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"   
     ELSE
        LET g_sql = "SELECT '','','','','','','','','',oma18,'','',SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"   
     END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(oma54t-oma55),SUM(oma53),SUM(oma56),SUM(oma56x),SUM(oma51),SUM(oma56t),SUM(oma57) ",
                    "  FROM axrq310_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
     IF tm.org = "Y"  THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma18,oma23 ",
                    " ORDER BY oma18,oma23 "
     ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY oma18 ",
                    " ORDER BY oma18 "
     END IF
        PREPARE q310_pb4 FROM g_sql
        DECLARE q310_curs4 CURSOR FOR q310_pb4
        FOREACH q310_curs4 INTO g_oma_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct oma032 INTO g_oma_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_oma_1[g_cnt].oma03
        SELECT distinct aag02 INTO g_oma_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_oma_1[g_cnt].oma18

        IF tm.c = "N" THEN
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
        END IF
        IF tm.c ="Y" THEN
           LET l_tot1 = l_tot1 + g_oma_1[g_cnt].oma52
           LET l_tot2 = l_tot2 + g_oma_1[g_cnt].oma54
           LET l_tot3 = l_tot3 + g_oma_1[g_cnt].oma54x
           LET l_tot4 = l_tot4 + g_oma_1[g_cnt].oma55
           LET l_tot5 = l_tot5 + g_oma_1[g_cnt].amt1
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
           LET l_tot12 = l_tot12 + g_oma_1[g_cnt].oma51f
           LET l_tot13 = l_tot13 + g_oma_1[g_cnt].oma54t
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        END FOREACH

     WHEN "5"
     IF tm.org = "Y"  THEN
        LET g_sql = "SELECT YEAR(oma11),MONTH(oma11),'','','','','','','','','','',oma23,SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55)," 
     ELSE
        LET g_sql = "SELECT YEAR(oma11),MONTH(oma11),'','','','','','','','','','','',SUM(oma52),SUM(oma54),SUM(oma54x),SUM(oma51f),SUM(oma54t),SUM(oma55),"
     END IF 
        LET g_sql = g_sql CLIPPED,"       SUM(oma54t-oma55),SUM(oma53),SUM(oma56),SUM(oma56x),SUM(oma51),SUM(oma56t),SUM(oma57) ",
                    "  FROM axrq310_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add 
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
      IF tm.org = "Y"  THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY YEAR(oma11),MONTH(oma11),oma23 ",
                    " ORDER BY MONTH(oma11),oma23 "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY YEAR(oma11),MONTH(oma11) ",
                    " ORDER BY MONTH(oma11) "
      END IF 
        PREPARE q310_pb5 FROM g_sql
        DECLARE q310_curs5 CURSOR FOR q310_pb5
        FOREACH q310_curs5 INTO l_year,l_month,g_oma_1[g_cnt].oma03,g_oma_1[g_cnt].oma032,g_oma_1[g_cnt].oma68,
                                g_oma_1[g_cnt].oma69,g_oma_1[g_cnt].oma15,g_oma_1[g_cnt].gem02,
                                g_oma_1[g_cnt].oma14,g_oma_1[g_cnt].gen02,g_oma_1[g_cnt].oma18,g_oma_1[g_cnt].aag02,
                                g_oma_1[g_cnt].oma23,g_oma_1[g_cnt].oma52,g_oma_1[g_cnt].oma54,g_oma_1[g_cnt].oma54x,
                                g_oma_1[g_cnt].oma51f,g_oma_1[g_cnt].oma54t,g_oma_1[g_cnt].oma55,g_oma_1[g_cnt].amt1,
                                g_oma_1[g_cnt].oma53,g_oma_1[g_cnt].oma56,g_oma_1[g_cnt].oma56x,g_oma_1[g_cnt].oma51,
                                g_oma_1[g_cnt].oma56t,g_oma_1[g_cnt].oma57 
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct oma032 INTO g_oma_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_oma_1[g_cnt].oma03
        LET l_mm = l_month
        LET l_mm = l_mm.trim()
        LET l_yy = l_year
        LET l_yy = l_yy.trim()
        LET g_oma_1[g_cnt].mm = l_yy,'/',l_mm 
        IF tm.c = "N" THEN
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
        END IF
        IF tm.c ="Y" THEN
           LET l_tot1 = l_tot1 + g_oma_1[g_cnt].oma52
           LET l_tot2 = l_tot2 + g_oma_1[g_cnt].oma54
           LET l_tot3 = l_tot3 + g_oma_1[g_cnt].oma54x
           LET l_tot4 = l_tot4 + g_oma_1[g_cnt].oma55
           LET l_tot5 = l_tot5 + g_oma_1[g_cnt].amt1
           LET l_tot6 = l_tot6 + g_oma_1[g_cnt].oma53
           LET l_tot7 = l_tot7 + g_oma_1[g_cnt].oma56
           LET l_tot8 = l_tot8 + g_oma_1[g_cnt].oma56x
           LET l_tot9 = l_tot9 + g_oma_1[g_cnt].oma51
           LET l_tot10 = l_tot10 + g_oma_1[g_cnt].oma56t
           LET l_tot11 = l_tot11 + g_oma_1[g_cnt].oma57
           LET l_tot12 = l_tot12 + g_oma_1[g_cnt].oma51f
           LET l_tot13 = l_tot13 + g_oma_1[g_cnt].oma54t
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        END FOREACH
    END CASE
     IF tm.c = 'N' THEN 
      DISPLAY l_tot6 TO FORMONLY.oma53_tot
      DISPLAY l_tot7 TO FORMONLY.oma56_tot
      DISPLAY l_tot8 TO FORMONLY.oma56x_tot
      DISPLAY l_tot9 TO FORMONLY.oma51_tot
      DISPLAY l_tot10 TO FORMONLY.oma56t_tot
      DISPLAY l_tot11 TO FORMONLY.oma57_tot
    END IF
    IF tm.c = 'Y' THEN 
       LET g_oma_1[g_cnt].oma23 = cl_getmsg('amr-003',g_lang)
       LET g_oma_1[g_cnt].oma52 = l_tot1
       LET g_oma_1[g_cnt].oma54 = l_tot2
       LET g_oma_1[g_cnt].oma54x = l_tot3
       LET g_oma_1[g_cnt].oma55 = l_tot4
       LET g_oma_1[g_cnt].amt1 = l_tot5
       LET g_oma_1[g_cnt].oma53 = l_tot6
       LET g_oma_1[g_cnt].oma56 = l_tot7
       LET g_oma_1[g_cnt].oma56x = l_tot8
       LET g_oma_1[g_cnt].oma51 = l_tot9
       LET g_oma_1[g_cnt].oma56t = l_tot10
       LET g_oma_1[g_cnt].oma57 = l_tot11
       LET g_oma_1[g_cnt].oma51f = l_tot12
       LET g_oma_1[g_cnt].oma54t = l_tot13
    END IF      
    DISPLAY ARRAY g_oma_1 TO s_oma_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY
    IF tm.c != 'Y' THEN   
       CALL g_oma_1.deleteElement(g_cnt)
       LET g_rec_b2 = g_cnt - 1
    ELSE
       LET g_rec_b2 = g_cnt 
    END IF
    DISPLAY g_rec_b2 TO FORMONLY.cnt1 
        
END FUNCTION
#FUN-C80102--add--end---
 
#FUNCTION q310_b_fill(p_wc2)                 #BODY FILL UP  #FUN-C80102 mark
FUNCTION q310_get_tmp(p_wc2)                         #BODY FILL UP  #FUN-C80102 add
DEFINE l_sql        LIKE type_file.chr1000 #FUN-C80102
DEFINE
      sr            RECORD   
        oma00       LIKE oma_file.oma00,
        oma01       LIKE oma_file.oma01,
        oma02       LIKE oma_file.oma02,
        oma03       LIKE oma_file.oma03, 
        oma032      LIKE oma_file.oma032,
        oma23       LIKE oma_file.oma23,
        oma54       LIKE oma_file.oma54, 
        oma54x      LIKE oma_file.oma54x,
        oma51f      LIKE oma_file.oma51f, 
        oma54t      LIKE oma_file.oma54t, 
        oma55       LIKE oma_file.oma55,  
        amt1        LIKE oma_file.oma54t,
        oma56       LIKE oma_file.oma56, 
        oma56x      LIKE oma_file.oma56x,
        oma51       LIKE oma_file.oma51, 
        oma56t      LIKE oma_file.oma56t, 
        oma57       LIKE oma_file.oma57,  
        amt2        LIKE oma_file.oma56t, 
        oma10       LIKE oma_file.oma10, 
        oma09       LIKE oma_file.oma09, 
        oma67       LIKE oma_file.oma67, 
        oma33       LIKE oma_file.oma33, 
        oma211      LIKE oma_file.oma211, 
        oma24       LIKE oma_file.oma24, 
        oma15       LIKE oma_file.oma15,
        gem02       LIKE gem_file.gem02,  
        oma14       LIKE oma_file.oma14, 
        gen02       LIKE gen_file.gen02, 
        oma11       LIKE oma_file.oma11,
        oma16       LIKE oma_file.oma16, 
        oma52       LIKE oma_file.oma52,
        oma53       LIKE oma_file.oma53, 
        oma18       LIKE oma_file.oma18, 
        aag02       LIKE aag_file.aag02, 
        oma08       LIKE oma_file.oma08, 
        oma19       LIKE oma_file.oma19, 
        oma99       LIKE oma_file.oma99, 
        oma68       LIKE oma_file.oma68, 
        oma69       LIKE oma_file.oma69, 
        oma04       LIKE oma_file.oma04, 
        occ18       LIKE occ_file.occ18, 
        oma21       LIKE oma_file.oma21, 
        omaconf     LIKE oma_file.omaconf,
        oma66       LIKE oma_file.oma66,  
        azp01       LIKE azp_file.azp01
                    END RECORD 

DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
 
    #No.TQC-5C0086  --Begin                                                                                                         
    IF g_ooz.ooz07 = 'N' THEN
#FUN-C80102--mod---str---
#      LET g_sql = "SELECT oma00,oma01,oma02,oma11,oma15,oma03,oma032,oma23, ",    #MOD-C60011 add oma03
#                  #"       oma54t-oma55,oma56t-oma57,omaconf,oma66, azi04,oma10,oma67 ",    #No:8522  #FUN-630043 #FUN-5C0014   #TQC-690117
##                  "       oma54t-oma55,oma56t-oma57,omaconf,oma66, oma10,oma67,azi04 ",    #No:8522  #FUN-630043 #FUN-5C0014   #TQC-690117
#                  #"       oma54t,oma55,oma54t-oma55,oma56t,oma57,oma56t-oma57,omaconf,oma66, oma10,oma67,azi04 ",    #No:8522  #FUN-630043 #FUN-5C0014   #TQC-690117  #No.FUN-A30028 add oma54t,oma55,oma56t,oma57 #TQC-B10157 mark
#                  "       oma54t,oma55,'',oma56t,oma57,'',omaconf,oma66, oma10,oma67,azi04 ", #TQC-B10157 add
       LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,oma54,oma54x,oma51f,oma54t,oma55,0,oma56,oma56x,oma51,oma56t,oma57,0,",
                   "       oma10,oma09,oma67,oma33,oma211,oma24,oma15,'',oma14,'',oma11,oma16,oma52,oma53,oma18,'',oma08,oma19,", 
                   "       oma99,oma68,oma69,oma04,'',oma21,omaconf,oma66,'',azi04  ",  
#FUN-C80102--mod---str---
           	   " FROM oma_file,azi_file ",
       		   " WHERE ", p_wc2 CLIPPED,                     #單身
                   "   AND azi01=oma23 ",
         	   #"   AND (oma54t-oma55) > 0",   #yinhy1307011	
                   "   AND omavoid = 'N'" 
#FUN-C80102--add--str--
       CASE tm.d1 WHEN "1" LET l_sql = l_sql CLIPPED," AND (oma54t-oma55)<>0 AND (oma56t-oma57)<>0 "
                  WHEN "2" LET l_sql = l_sql CLIPPED," AND (oma56t-oma57)=0 "
       END CASE
       CASE tm.d2 WHEN "1" LET l_sql = l_sql CLIPPED," AND omaconf = 'Y' "
                  WHEN "2" LET l_sql = l_sql CLIPPED," AND omaconf = 'N' "
       END CASE
       LET l_sql = l_sql CLIPPED," ORDER BY 1" 
#FUN-C80102--add--end--
       	   	  #" ORDER BY 1"  #FUN-C80102 mark
    ELSE 
#FUN-C80102--mod---str--                                                                                                                    
#      LET g_sql = "SELECT oma00,oma01,oma02,oma11,oma15,oma03,oma032,oma23, ",          #MOD-C60011 add oma03                                                   
#                  #"       oma54t-oma55,oma61,omaconf,azi04,oma10,oma67 ",    #No:8522  #FUN-5C0015    #TQC-690117                                                       
##                  "       oma54t-oma55,oma61,omaconf,oma66,oma10,oma67,azi04 ",    #No:8522  #FUN-5C0015    #TQC-690117                                                       
#                  #"       oma54t,oma55,oma54t-oma55,oma56t,oma56t-oma61,oma61,omaconf,oma66,oma10,oma67,azi04 ",    #No:8522  #FUN-5C0015    #TQC-690117    #No.FUN-A30028 #TQC-B10157 mark
##                  "       oma54t,oma55,'',oma56t,'',oma61,omaconf,oma66,oma10,oma67,azi04 ",  #No.TQC-B10157 mod
#                  "       oma54t,oma55,'',oma56t,oma57,oma61,omaconf,oma66,oma10,oma67,azi04 ",  #No.TQC-B10157 mod  #No.MOD-B40268

       LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,oma54,oma54x,oma51f,oma54t,oma55,oma54t-oma55,oma56,oma56x,oma51,oma56t,oma57,oma61,",
                   "       oma10,oma09,oma67,oma33,oma211,oma24,oma15,'',oma14,'',oma11,oma16,oma52,oma53,oma18,'',oma08,oma19,", 
                   "       oma99,oma68,oma69,oma04,'',oma21,omaconf,oma66,'',azi04  ",  
#FUN-C80102--mod---str--                                                                                                                    
                   " FROM oma_file,azi_file ",                                                                                      
                   " WHERE ", p_wc2 CLIPPED,                     #單身                                                              
                   "   AND azi01=oma23 ",                                                                                           
                   #"   AND (oma54t-oma55) > 0",      #yinhy130711
                   "   AND omavoid = 'N'"                                                                                           
#FUN-C80102--add--str--
       CASE tm.d1 WHEN "1" LET l_sql = l_sql CLIPPED," AND (oma54t-oma55)<>0 AND (oma56t-oma57)<>0 "
                  WHEN "2" LET l_sql = l_sql CLIPPED," AND (oma56t-oma57)=0 "
       END CASE
       CASE tm.d2 WHEN "1" LET l_sql = l_sql CLIPPED," AND omaconf = 'Y' "
                  WHEN "2" LET l_sql = l_sql CLIPPED," AND omaconf = 'N' "
       END CASE
       LET l_sql = l_sql CLIPPED," ORDER BY oma00" 
#FUN-C80102--add--end--
#                  " ORDER BY oma00"  #FUN-C80102 mark                                                                                               
    END IF                                                                                                                          
    #No.TQC-5C0086  --End
    PREPARE q310_pb FROM l_sql
    DECLARE oma_curs CURSOR FOR q310_pb
 
    LET g_rec_b=0
    LET g_cnt = 1
   #LET l_tot01 =0  #FUN-C80102 mark
   #MESSAGE "Searching!"
   #FOREACH oma_curs INTO g_oma[g_cnt].*   #No.+138 010522 by plum
   #FOREACH oma_curs INTO g_oma[g_cnt].*,g_azi04
    FOREACH oma_curs INTO sr.*,g_azi04
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#FUN-C80102--mod--str---
#       #No.TQC-B10157  --Begin
#       IF g_oma[g_cnt].oma54t IS NULL THEN
#              LET g_oma[g_cnt].oma54t = 0
#       END IF
#       IF g_oma[g_cnt].oma55 IS NULL THEN
#              LET g_oma[g_cnt].oma55 = 0
#       END IF
#       #No:8522
#       IF g_oma[g_cnt].oma56t IS NULL THEN
#              LET g_oma[g_cnt].oma56t = 0
#       END IF
#       IF g_oma[g_cnt].oma57 IS NULL THEN
#              LET g_oma[g_cnt].oma57 = 0
#       END IF
  
        SELECT DISTINCT gen02 INTO sr.gen02 FROM gen_file 
           WHERE gen01 = sr.oma14 
        SELECT DISTINCT gem02 INTO sr.gem02 FROM gem_file 
           WHERE gem01 = sr.oma15 
        SELECT DISTINCT aag02 INTO sr.aag02 FROM aag_file 
           WHERE aag01 = sr.oma18 
        SELECT occ18 INTO sr.occ18 FROM occ_file
           WHERE occ01 = occ1022 AND occ1022 = sr.oma04 
        IF sr.oma54t IS NULL THEN
           LET sr.oma54t = 0
        END IF
        IF sr.oma55 IS NULL THEN
           LET sr.oma55 = 0
        END IF
        IF sr.oma56t IS NULL THEN
           LET sr.oma56t = 0
        END IF
        IF sr.oma57 IS NULL THEN
           LET sr.oma57 = 0
        END IF
#FUN-C80102--mod--str---
#FUN-C80102--add---str-- 
        IF sr.oma54x IS NULL THEN
           LET sr.oma54x = 0
        END IF
        IF sr.oma56x IS NULL THEN
           LET sr.oma56x = 0
        END IF
        IF sr.oma52 IS NULL THEN
           LET sr.oma52 = 0
        END IF
        IF sr.oma53 IS NULL THEN
           LET sr.oma53 = 0
        END IF
        IF sr.oma54 IS NULL THEN
           LET sr.oma54 = 0
        END IF
        IF sr.oma56 IS NULL THEN
           LET sr.oma56 = 0
        END IF
        IF sr.oma51f IS NULL THEN
           LET sr.oma51f = 0
        END IF
        IF sr.oma51 IS NULL THEN
           LET sr.oma51 = 0
        END IF
#FUN-C80102--add---end-- 
        #No.TQC-B10157  --End
       #No.+138 010522 by plum
        #CALL cl_digcut(g_oma[g_cnt].balance,g_azi04)
        #     RETURNING g_oma[g_cnt].balance
       #No.+138..end
        #CALL cl_digcut(g_oma[g_cnt].balance1,t_azi04)    #No:8522
        #     RETURNING g_oma[g_cnt].balance1
       #IF g_oma[g_cnt].oma00 matches '2*' THEN  #FUN-C80102
        IF sr.oma00 matches '2*' THEN  #FUN-C80102
           #No.TQC-B10157  --Begin
           #LET g_oma[g_cnt].balance=g_oma[g_cnt].balance * (-1)
           #LET g_oma[g_cnt].balance1=g_oma[g_cnt].balance1 * (-1)   #No:8522
#FUN-C80102--mark--str-- 
#         #MOD-C50070----S---
#          IF g_ooz.ooz07 = 'Y' THEN 
#             LET g_oma[g_cnt].balance1=g_oma[g_cnt].balance1 * (-1)
#          END IF 
#         #MOD-C50070----E---
#          LET g_oma[g_cnt].oma54t=g_oma[g_cnt].oma54t*(-1)
#          LET g_oma[g_cnt].oma55=g_oma[g_cnt].oma55*(-1)
#          LET g_oma[g_cnt].oma56t=g_oma[g_cnt].oma56t*(-1)
#          LET g_oma[g_cnt].oma57=g_oma[g_cnt].oma57*(-1)
#FUN-C80102--mark--end-- 
#FUN-C80102---add---str---
           LET sr.oma54t=sr.oma54t*(-1)
           LET sr.oma55=sr.oma55*(-1)
           LET sr.oma56t=sr.oma56t*(-1)
           LET sr.oma57=sr.oma57*(-1)
           LET sr.oma52=sr.oma52*(-1)
           LET sr.oma53=sr.oma53*(-1)
           LET sr.oma56=sr.oma56*(-1)
           LET sr.oma54=sr.oma54*(-1)
           LET sr.oma54x=sr.oma54x*(-1)
           LET sr.oma56x=sr.oma56x*(-1)
           LET sr.oma51f=sr.oma51f*(-1)
           LET sr.oma51 =sr.oma51 *(-1)
#FUN-C80102---add---end---
           #No.TQC-B10157  --End
        END IF
#FUN-C80102--mod--str--
#       LET g_oma[g_cnt].balance  = g_oma[g_cnt].oma54t - g_oma[g_cnt].oma55     #No.TQC-B10157 add
#       IF g_ooz.ooz07 = 'N' THEN   #No.MOD-B40268
#          LET g_oma[g_cnt].balance1 = g_oma[g_cnt].oma56t - g_oma[g_cnt].oma57     #No.TQC-B10157 add
#       END IF                      #No.MOD-B40268
#       #No.TQC-BB0244  --Begin
#       IF cl_null(g_oma[g_cnt].balance1) THEN
#          LET g_oma[g_cnt].balance1 = 0
#       END IF
        LET sr.amt1  = sr.oma54t - sr.oma55  
        IF g_ooz.ooz07 = 'N' THEN  
           LET sr.amt2 = sr.oma56t - sr.oma57  
        END IF   #yinhy130705  
        #ELSE    #yinhy130705 mark
           IF sr.oma00 matches '2*' THEN
              LET sr.amt2 = sr.amt2 * (-1)
           END IF
        #END IF  #yinhy130705 mark                
        IF cl_null(sr.amt2) THEN
           LET sr.amt2 = 0
        END IF
#FUN-C80102--mod--end
        #No.TQC-BB0244  --End
       #LET l_tot01 = l_tot01+g_oma[g_cnt].balance1  #FUN-C80102 mark
#FUN-C80102--mark--str--
#       LET g_cnt = g_cnt + 1
#       IF g_cnt > g_max_rec THEN
#          CALL cl_err( '', 9035, 0 )
#	   EXIT FOREACH
#       END IF
#FUN-C80102--mark--str--
    EXECUTE insert_prep USING sr.*   #FUN-C80102 add
    END FOREACH
#FUN-C80102--mark--str--
#   CALL g_oma.deleteElement(g_cnt)  #TQC-770016  
#   MESSAGE ""
#   LET g_rec_b = g_cnt-1
#   DISPLAY l_tot01 TO FORMONLY.tot01    #TQC-BB0244 
#   DISPLAY g_rec_b TO FORMONLY.cnt
#FUN-C80102--mark--str--
END FUNCTION
 
FUNCTION q310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
   DEFINE  l_apa00 LIKE apa_file.apa00 #TQC-D60013 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_flag = 'page1'  #FUN-C80102 
  
 
   #FUN-C80102--add--str---  
   IF g_action_choice = "page1"  AND NOT cl_null(tm.u) AND g_flag != '1' THEN
      CALL q310_b_fill_1()
   END IF
   #FUN-C80102--add--end---
 
   LET g_action_choice = " "
   LET g_flag = ' '   #FUN-C80102
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY l_tot01 TO FORMONLY.tot01    #TQC-BB0244 mark
#FUN-C80102--add---str--
   DISPLAY BY NAME tm.u,tm.org,tm.c
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.org,tm.c FROM u,org,c ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("c",TRUE)
            ELSE
               CALL cl_set_comp_entry("c",FALSE)
            END IF
            
            IF NOT cl_null(tm.u)  THEN 
               CALL q310_b_fill_2()
               CALL q310_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q310_b_fill_1()
               CALL g_oma_1.clear()
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.oma53_tot
               DISPLAY 0  TO FORMONLY.oma56_tot
               DISPLAY 0  TO FORMONLY.oma56x_tot
               DISPLAY 0  TO FORMONLY.oma51_tot
               DISPLAY 0  TO FORMONLY.oma56t_tot
               DISPLAY 0  TO FORMONLY.oma57_tot
            END IF
            DISPLAY BY NAME tm.u
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("c",TRUE)
             ELSE
                CALL cl_set_comp_entry("c",FALSE)
             END IF
            #CALL q310()   #No.FUN-CB0146 Mark
             CALL q310_get_temp(g_wc2) #No.FUN-CB0146 Add
             CALL q310_t()
             EXIT DIALOG

          ON CHANGE c
             CALL q310_b_fill_2()
             CALL q310_set_visible()
             CALL cl_set_comp_visible("page1", FALSE)
             CALL ui.interface.refresh()
             CALL cl_set_comp_visible("page1", TRUE)
             LET g_action_choice = "page2"

      END INPUT  
   #FUN-C80102--add--end-- 
#FUN-C80102--add---end--
 
  #DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #FUN-C80102 mark
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b)             #FUN-C80102 add
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()   #FUN-C80102 mark
   END DISPLAY  #FUN-C80102 add   
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
#FUN-C80102--add--str--
      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q310_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG

      ON ACTION ar_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 THEN
            LET g_cmd = "axrt300 "," '",g_oma[l_ac].oma01,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF

      ON ACTION chuhuo_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 THEN
            LET g_cmd = "axmt620 "," "," '",g_oma[l_ac].oma16,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF

      ON ACTION daidi_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 THEN
            #TQC-D60013--add--str--
            LET l_apa00=''
            SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_oma[l_ac].oma19
            CASE
               WHEN l_apa00='23'
                  LET g_cmd = "aapq230 "," '",g_oma[l_ac].oma19,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN l_apa00='25'
                  LET g_cmd = "aapq231 "," '",g_oma[l_ac].oma19,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN l_apa00='24'
                  LET g_cmd = "aapq240 "," '",g_oma[l_ac].oma19,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
              OTHERWISE
                  CALL cl_err(g_oma[l_ac].oma19,'axr-280',0)
            END CASE   
            #TQC-D60013--add--end
            #LET g_cmd = "aapq250 "," '",g_oma[l_ac].oma19,"'" #TQC-D60013 mark
            #CALL cl_cmdrun(g_cmd CLIPPED) #TQC-D60013 mark
         END IF

      ON ACTION qry_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 THEN
            LET g_cmd = "aglt110 "," '",g_oma[l_ac].oma33,"' "," ","  " 
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF    

      ON ACTION accept
         LET l_ac = ARR_CURR()
         IF l_ac > 0 THEN
            IF NOT cl_null(g_oma[l_ac].oma01) OR NOT cl_null(g_oma[l_ac].oma19) OR NOT cl_null(g_oma[l_ac].oma16)
               OR NOT cl_null(g_oma[l_ac].oma01) THEN 
               IF cl_null(g_oma[l_ac].oma01) AND cl_null(g_oma[l_ac].oma16) AND cl_null(g_oma[l_ac].oma19)
                  AND NOT cl_null(g_oma[l_ac].oma33) THEN
                  LET g_cmd = "aglt110 "," '",g_oma[l_ac].oma33,"' "," ","  "
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  EXIT DIALOG
               END IF
               IF cl_null(g_oma[l_ac].oma01) AND cl_null(g_oma[l_ac].oma16) AND cl_null(g_oma[l_ac].oma33)
                  AND NOT cl_null(g_oma[l_ac].oma19) THEN
                  LET g_cmd = "aapq250 "," '",g_oma[l_ac].oma19,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  EXIT DIALOG
               END IF
               IF cl_null(g_oma[l_ac].oma01) AND cl_null(g_oma[l_ac].oma33) AND cl_null(g_oma[l_ac].oma19)
                  AND NOT cl_null(g_oma[l_ac].oma16) THEN
                  LET g_cmd = "axmt620 "," "," '",g_oma[l_ac].oma16,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  EXIT DIALOG
               END IF
               IF cl_null(g_oma[l_ac].oma33) AND cl_null(g_oma[l_ac].oma16) AND cl_null(g_oma[l_ac].oma19)
                  AND NOT cl_null(g_oma[l_ac].oma01) THEN
                  LET g_cmd = "axrt300 "," '",g_oma[l_ac].oma01,"'"
                  CALL cl_cmdrun(g_cmd CLIPPED)
                  EXIT DIALOG
               END IF
               CALL q310_1(l_ac)   
            END IF
         END IF
  

#FUN-C80102--add--end--
      ON ACTION help
         LET g_action_choice="help"
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
#FUN-C80102--mark--str--
#No.FUN-A30028 --begin
#     ON ACTION qry_oma
#        LET g_action_choice = 'qry_oma'
#        EXIT DISPLAY
#No.FUN-A30028 --end 
#FUN-C80102--mark--end--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        #CONTINUE DISPLAY #FUN-C80102
         CONTINUE DIALOG  #FUN-C80102
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
      #--
       #No.MOD-530853  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
        #EXIT DISPLAY #FUN-C80102
         EXIT DIALOG  #FUN-C80102 
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
     #AFTER DISPLAY       #FUN-C80102
        #CONTINUE DISPLAY #FUN-C80102
      # No.FUN-530067 ---end---
 
 
  #END DISPLAY  #FUN-C80102
   END DIALOG   #FUN-C80102
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C80102--add---str--
FUNCTION q310_bp2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.u TO u
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   LET g_action_choice = " " 
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.org,tm.c FROM u,org,c ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("c",TRUE)
            ELSE
               CALL cl_set_comp_entry("c",FALSE)
            END IF
            IF NOT cl_null(tm.u)  THEN
               CALL q310_b_fill_2()
               CALL q310_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q310_b_fill_1()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_oma_1.clear()  
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.oma53_tot
               DISPLAY 0  TO FORMONLY.oma56_tot
               DISPLAY 0  TO FORMONLY.oma56x_tot
               DISPLAY 0  TO FORMONLY.oma51_tot
               DISPLAY 0  TO FORMONLY.oma56t_tot
               DISPLAY 0  TO FORMONLY.oma57_tot
            END IF
            DISPLAY tm.u TO u 
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("c",TRUE)
             ELSE
               CALL cl_set_comp_entry("c",FALSE)
             END IF
            #CALL q310()            #No.FUN-CB0146 Mark
             CALL q310_get_temp(g_wc2)   #No.FUN-CB0146 Add
             CALL q310_t()
             EXIT DIALOG

          ON CHANGE c
             CALL q310_b_fill_2()
             CALL q310_set_visible()
             LET g_action_choice = "page2"

      END INPUT

      DISPLAY ARRAY g_oma_1 TO s_oma_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q310_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = "page1"
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
            CALL q310_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  #FUN-C80102
            LET g_flag = '1'              #FUN-C80102
            EXIT DIALOG 
         END IF
        
      

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 


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

FUNCTION q310_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_tot11   LIKE oma_file.oma56t
DEFINE l_tot21   LIKE oma_file.oma56t
DEFINE l_tot31   LIKE oma_file.oma56t
DEFINE l_tot41   LIKE oma_file.oma56t
DEFINE l_tot51   LIKE oma_file.oma56t
DEFINE l_tot61   LIKE oma_file.oma56t
DEFINE l_tot71   LIKE oma_file.oma56t
DEFINE l_mm1     STRING
DEFINE l_mm2     STRING
DEFINE l_yy      STRING

   LET l_tot11 = 0
   LET l_tot21 = 0
   LET l_tot31 = 0
   LET l_tot41 = 0
   LET l_tot51 = 0
   LET l_tot61 = 0
   LET l_tot71 = 0
   CASE tm.u
      WHEN '1'
         LET g_sql = "SELECT * FROM axrq310_tmp ",
                     " WHERE oma03 = '",g_oma_1[p_ac].oma03,"'"
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED," AND oma23 = '",g_oma_1[p_ac].oma23,"'"
         END IF
         LET g_sql = g_sql CLIPPED, 
                     "   AND oma68 = '",g_oma_1[p_ac].oma68,"'",
                     " ORDER BY oma03,oma68,oma23 "

        PREPARE axrq310_pb_detail1 FROM g_sql
        DECLARE oma_curs_detail1  CURSOR FOR axrq310_pb_detail1        #CURSOR
        CALL g_oma.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH oma_curs_detail1 INTO g_oma[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_oma[g_cnt].oma53
           LET l_tot21 = l_tot21 + g_oma[g_cnt].oma56
           LET l_tot31 = l_tot31 + g_oma[g_cnt].oma56x
           LET l_tot41 = l_tot41 + g_oma[g_cnt].oma51
           LET l_tot51 = l_tot51 + g_oma[g_cnt].oma56t
           LET l_tot61 = l_tot61 + g_oma[g_cnt].oma57
           LET l_tot71 = l_tot71 + g_oma[g_cnt].amt2
           LET g_cnt = g_cnt + 1  
        END FOREACH


      WHEN '2'
         LET g_sql = "SELECT * FROM axrq310_tmp ",
                     " WHERE oma15 = '",g_oma_1[p_ac].oma15,"'"
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED," AND oma23 = '",g_oma_1[p_ac].oma23,"'"
         END IF
         LET g_sql = g_sql CLIPPED, 
                     " ORDER BY oma15,oma23 "

        PREPARE axrq310_pb_detail2 FROM g_sql
        DECLARE oma_curs_detail2  CURSOR FOR axrq310_pb_detail2        #CURSOR
        CALL g_oma.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH oma_curs_detail2 INTO g_oma[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_oma[g_cnt].oma53
           LET l_tot21 = l_tot21 + g_oma[g_cnt].oma56
           LET l_tot31 = l_tot31 + g_oma[g_cnt].oma56x
           LET l_tot41 = l_tot41 + g_oma[g_cnt].oma51
           LET l_tot51 = l_tot51 + g_oma[g_cnt].oma56t
           LET l_tot61 = l_tot61 + g_oma[g_cnt].oma57
           LET l_tot71 = l_tot71 + g_oma[g_cnt].amt2
           LET g_cnt = g_cnt + 1  
        END FOREACH 

      WHEN '3'
         LET g_sql = "SELECT * FROM axrq310_tmp ",
                     " WHERE oma14 = '",g_oma_1[p_ac].oma14,"'"
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED," AND oma23 = '",g_oma_1[p_ac].oma23,"'"
         END IF
         LET g_sql = g_sql CLIPPED, 
                     " ORDER BY oma14,oma23 "

        PREPARE axrq310_pb_detail3 FROM g_sql
        DECLARE oma_curs_detail3  CURSOR FOR axrq310_pb_detail3        #CURSOR
        CALL g_oma.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH oma_curs_detail3 INTO g_oma[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_oma[g_cnt].oma53
           LET l_tot21 = l_tot21 + g_oma[g_cnt].oma56
           LET l_tot31 = l_tot31 + g_oma[g_cnt].oma56x
           LET l_tot41 = l_tot41 + g_oma[g_cnt].oma51
           LET l_tot51 = l_tot51 + g_oma[g_cnt].oma56t
           LET l_tot61 = l_tot61 + g_oma[g_cnt].oma57
           LET l_tot71 = l_tot71 + g_oma[g_cnt].amt2
           LET g_cnt = g_cnt + 1  
        END FOREACH 

    
      WHEN '4'
         LET g_sql = "SELECT * FROM axrq310_tmp ",
                     " WHERE oma18 = '",g_oma_1[p_ac].oma18,"'"
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED," AND oma23 = '",g_oma_1[p_ac].oma23,"'"
         END IF
         LET g_sql = g_sql CLIPPED, 
                     " ORDER BY oma18,oma032 "

        PREPARE axrq310_pb_detail4 FROM g_sql
        DECLARE oma_curs_detail4  CURSOR FOR axrq310_pb_detail4        #CURSOR
        CALL g_oma.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH oma_curs_detail4 INTO g_oma[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_oma[g_cnt].oma53
           LET l_tot21 = l_tot21 + g_oma[g_cnt].oma56
           LET l_tot31 = l_tot31 + g_oma[g_cnt].oma56x
           LET l_tot41 = l_tot41 + g_oma[g_cnt].oma51
           LET l_tot51 = l_tot51 + g_oma[g_cnt].oma56t
           LET l_tot61 = l_tot61 + g_oma[g_cnt].oma57
           LET l_tot71 = l_tot71 + g_oma[g_cnt].amt2
           LET g_cnt = g_cnt + 1  
        END FOREACH

     WHEN '5'
         LET l_mm1= g_oma_1[p_ac].mm
         LET l_mm1= l_mm1.subString(6,6)
         LET l_mm2= g_oma_1[p_ac].mm
         LET l_mm2= l_mm2.subString(6,7)
         LET l_yy = g_oma_1[p_ac].mm LET l_yy = l_yy.subString(1,4) 
         LET g_sql = "SELECT * FROM axrq310_tmp ",
                     " WHERE (MONTH(oma11) = '",l_mm1,"' OR MONTH(oma11) = '",l_mm2,"') AND YEAR(oma11) = '",l_yy,"' " 
         IF tm.org = 'Y' THEN
            LET g_sql = g_sql CLIPPED," AND oma23 = '",g_oma_1[p_ac].oma23,"'"
         END IF
         LET g_sql = g_sql CLIPPED, 
                     " ORDER BY MONTH(oma11),oma23 "

        PREPARE axrq310_pb_detail5 FROM g_sql
        DECLARE oma_curs_detail5  CURSOR FOR axrq310_pb_detail5        #CURSOR
        CALL g_oma.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH oma_curs_detail5 INTO g_oma[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_oma[g_cnt].oma53
           LET l_tot21 = l_tot21 + g_oma[g_cnt].oma56
           LET l_tot31 = l_tot31 + g_oma[g_cnt].oma56x
           LET l_tot41 = l_tot41 + g_oma[g_cnt].oma51
           LET l_tot51 = l_tot51 + g_oma[g_cnt].oma56t
           LET l_tot61 = l_tot61 + g_oma[g_cnt].oma57
           LET l_tot71 = l_tot71 + g_oma[g_cnt].amt2
           LET g_cnt = g_cnt + 1  
        END FOREACH
   END CASE
   DISPLAY l_tot11 TO FORMONLY.oma53_tot1
   DISPLAY l_tot21 TO FORMONLY.oma56_tot1
   DISPLAY l_tot31 TO FORMONLY.oma56x_tot1
   DISPLAY l_tot41 TO FORMONLY.oma51_tot1
   DISPLAY l_tot51 TO FORMONLY.oma56t_tot1
   DISPLAY l_tot61 TO FORMONLY.oma57_tot1
   DISPLAY l_tot71 TO FORMONLY.amt2_tot1
   CALL g_oma.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cnt    
END FUNCTION

FUNCTION q310_b_fill_1()
DEFINE l_oma03   LIKE oma_file.oma03
DEFINE g_tot11   LIKE oma_file.oma56t
DEFINE g_tot21   LIKE oma_file.oma56t
DEFINE g_tot31   LIKE oma_file.oma56t
DEFINE g_tot41   LIKE oma_file.oma56t
DEFINE g_tot51   LIKE oma_file.oma56t
DEFINE g_tot61   LIKE oma_file.oma56t
DEFINE g_tot71   LIKE oma_file.oma56t


   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF    #FUN-D40121 add
   LET g_sql = "SELECT * FROM axrq310_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               "   AND ",l_wc CLIPPED,    #FUN-D40121 add
               " ORDER BY oma00,oma01,oma02,oma03 "
   

   PREPARE axrq310_pb1 FROM g_sql
   DECLARE oma_curs1  CURSOR FOR axrq310_pb1        #CURSOR

   CALL g_oma.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0
   LET g_tot61 = 0
   LET g_tot71 = 0
   FOREACH oma_curs1 INTO g_oma[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_tot11 = g_tot11 + g_oma[g_cnt].oma53
      LET g_tot21 = g_tot21 + g_oma[g_cnt].oma56
      LET g_tot31 = g_tot31 + g_oma[g_cnt].oma56x
      LET g_tot41 = g_tot41 + g_oma[g_cnt].oma51
      LET g_tot51 = g_tot51 + g_oma[g_cnt].oma56t
      LET g_tot61 = g_tot61 + g_oma[g_cnt].oma57
      LET g_tot71 = g_tot71 + g_oma[g_cnt].amt2
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY g_tot11 TO FORMONLY.oma53_tot1
   DISPLAY g_tot21 TO FORMONLY.oma56_tot1
   DISPLAY g_tot31 TO FORMONLY.oma56x_tot1
   DISPLAY g_tot41 TO FORMONLY.oma51_tot1
   DISPLAY g_tot51 TO FORMONLY.oma56t_tot1
   DISPLAY g_tot61 TO FORMONLY.oma57_tot1
   DISPLAY g_tot71 TO FORMONLY.amt2_tot1
   CALL g_oma.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q310_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_oma.clear()
   CALL g_oma_1.clear()
   CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)  
   DISPLAY BY NAME tm.u,tm.org,tm.d1,tm.d2,tm.c
   CONSTRUCT l_wc ON oma00,oma01,oma02,oma03,oma032,oma23,oma54,oma54x,oma51f,oma54t,oma55,amt1,oma56,oma56x,
                       oma51,oma56t,oma57,amt2,oma10,oma09,oma67,oma33,oma211,oma24,oma15,oma14,oma11,
                       oma16,oma52,oma53,oma18,oma08,oma19,oma99,oma68,oma69,oma04,oma21,omaconf,oma66   
                  FROM s_oma[1].oma00,s_oma[1].oma01,s_oma[1].oma02,s_oma[1].oma03,s_oma[1].oma032,
                       s_oma[1].oma23,s_oma[1].oma54,s_oma[1].oma54x,s_oma[1].oma51f,s_oma[1].oma54t,
                       s_oma[1].oma55,amt1,s_oma[1].oma56,s_oma[1].oma56x,s_oma[1].oma51,s_oma[1].oma56t,
                       s_oma[1].oma57,amt2,s_oma[1].oma10,s_oma[1].oma09,s_oma[1].oma67,
                       s_oma[1].oma33,s_oma[1].oma211,s_oma[1].oma24,s_oma[1].oma15,s_oma[1].oma14,
                       s_oma[1].oma11,s_oma[1].oma16,s_oma[1].oma52,s_oma[1].oma53,s_oma[1].oma18,
                       s_oma[1].oma08,s_oma[1].oma19,s_oma[1].oma99,s_oma[1].oma68,s_oma[1].oma69,
                       s_oma[1].oma04,s_oma[1].oma21,s_oma[1].omaconf,s_oma[1].oma66
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
   AFTER CONSTRUCT 
         IF tm.org = 'Y' THEN
            CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",TRUE)
         ELSE
            CALL cl_set_comp_visible("oma23,oma52,oma54,oma54x,oma51f,oma54t,oma55,amt1",FALSE)
         END IF      

      ON ACTION CONTROLP
       CASE
         WHEN INFIELD(oma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma01
               NEXT FIELD oma01

          WHEN INFIELD(oma03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma03
               NEXT FIELD oma03

          WHEN INFIELD(oma032)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma032
               NEXT FIELD oma032

          WHEN INFIELD(oma68)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma68
               NEXT FIELD oma68

          WHEN INFIELD(oma69)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma69
               NEXT FIELD oma69
          WHEN INFIELD(oma04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma04
               NEXT FIELD oma04
          WHEN INFIELD(oma15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem3"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma15
               NEXT FIELD oma15

          WHEN INFIELD(oma14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen5"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma18
               NEXT FIELD oma18

          WHEN INFIELD(oma18)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma18
               NEXT FIELD oma18

          WHEN INFIELD(oma21) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gec8_1"
               LET g_qryparam.arg1 = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma21

          WHEN INFIELD(oma23)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma23
               NEXT FIELD oma23

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

FUNCTION q310_1(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE p_row,p_col     LIKE type_file.num5 
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01 


   OPEN WINDOW axrq310_1_w AT p_row,p_col WITH FORM "axr/42f/axrq310_1"   
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
    CALL cl_ui_init()

    LET tm.a = '1'
    DISPLAY BY NAME tm.a 
    INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)

       BEFORE INPUT
        CALL cl_qbe_display_condition(lc_qbe_sn)


       AFTER FIELD a
         IF tm.a = '1' THEN
            LET g_cmd = "axrt300 "," '",g_oma[p_ac].oma01,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF
         IF tm.a = '2' THEN
            LET g_cmd = "axmt620 "," "," '",g_oma[p_ac].oma16,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF
         IF tm.a = '3' THEN
            LET g_cmd = "aapq250 "," '",g_oma[p_ac].oma19,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF
         IF tm.a = '4' THEN
            LET g_cmd = "aglt110 "," '",g_oma[p_ac].oma33,"' "," ","  "
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF
      ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT INPUT 
            
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT INPUT 
            
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 

      ON ACTION about          
         CALL cl_about()
         CONTINUE INPUT       
 
      ON ACTION help           
         CALL cl_show_help()
         CONTINUE INPUT   
 
      ON ACTION controlg       
         CALL cl_cmdask()
         CONTINUE INPUT    

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT 
            
      ON ACTION close
         LET INT_FLAG = 1
         EXIT INPUT
            
      ON ACTION qbe_select
         CALL cl_qbe_select()
    END INPUT
    CLOSE WINDOW axrq310_1_w
END FUNCTION
#FUN-C80102--add---end--

#No.FUN-CB0146 ---start--- Add
FUNCTION q310_get_temp(p_wc2)
DEFINE l_sql      STRING
DEFINE p_wc2      LIKE type_file.chr1000

   DISPLAY "START TIME: ",TIME

   IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF

   CALL q310_table()
   LET l_sql = "INSERT INTO axrq310_tmp "
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql = l_sql,"SELECT DISTINCT oma00,oma01,oma02,oma03,oma032,oma23,",
                        "       CASE WHEN oma54  IS NULL THEN 0 ELSE oma54  END,",
                        "       CASE WHEN oma54x IS NULL THEN 0 ELSE oma54x END,",
                        "       CASE WHEN oma51f IS NULL THEN 0 ELSE oma51f END,",
                        "       CASE WHEN oma54t IS NULL THEN 0 ELSE oma54t END,",
                        "       CASE WHEN oma55  IS NULL THEN 0 ELSE oma55  END,",
                        "       CASE WHEN (oma54t-oma55) IS NULL THEN 0 ELSE (oma54t-oma55) END,",
                        "       CASE WHEN oma56  IS NULL THEN 0 ELSE oma56  END,",
                        "       CASE WHEN oma56x IS NULL THEN 0 ELSE oma56x END,",
                        "       CASE WHEN oma51  IS NULL THEN 0 ELSE oma51  END,",
                        "       CASE WHEN oma56t IS NULL THEN 0 ELSE oma56t END,",
                        "       CASE WHEN oma57  IS NULL THEN 0 ELSE oma57  END,",
                        "       CASE WHEN (oma56t-oma57) IS NULL THEN 0 ELSE (oma56t-oma57) END,",
                        "       oma10,oma09,oma67,oma33,oma211,oma24,",
                        "       oma15,gem02,oma14,gen02,oma11 ,oma16,",
                        "       CASE WHEN oma52  IS NULL THEN 0 ELSE oma52  END,",
                        "       CASE WHEN oma53  IS NULL THEN 0 ELSE oma53  END,",
                        "       oma18,aag02,oma08,oma19  ,oma99,oma68,oma69,",
                        "       oma04,occ18,oma21,omaconf,oma66,azi04 ",
           	        "  FROM oma_file LEFT JOIN gem_file ON gem01 = oma15 ",
                        "                LEFT JOIN gen_file ON gen01 = oma14 ",
                        "                LEFT JOIN occ_file ON occ1022 = oma04  AND occ01 = occ1022 ",
                        "                LEFT JOIN aag_file ON aag01 = oma18 AND aag00 = '",g_aza.aza81,"',",
                        "       azi_file ",
       		        " WHERE ", p_wc2 CLIPPED,                     #單身
                        "   AND azi01=oma23 ",
         	        #"   AND (oma54t-oma55) > 0",   #yinhy130711
                        "   AND omavoid = 'N'"
      CASE tm.d1 WHEN "1" LET l_sql = l_sql CLIPPED," AND (oma54t-oma55)<>0 AND (oma56t-oma57)<>0 "
                 WHEN "2" LET l_sql = l_sql CLIPPED," AND (oma56t-oma57)=0 "
      END CASE
      CASE tm.d2 WHEN "1" LET l_sql = l_sql CLIPPED," AND omaconf = 'Y' "
                 WHEN "2" LET l_sql = l_sql CLIPPED," AND omaconf = 'N' "
      END CASE
      LET l_sql = l_sql CLIPPED," ORDER BY 1" 
   ELSE
      LET l_sql = l_sql,"SELECT DISTINCT oma00,oma01,oma02,oma03,oma032,oma23,",
                        "       CASE WHEN oma54  IS NULL THEN 0 ELSE oma54  END,",
                        "       CASE WHEN oma54x IS NULL THEN 0 ELSE oma54x END,",
                        "       CASE WHEN oma51f IS NULL THEN 0 ELSE oma51f END,",
                        "       CASE WHEN oma54t IS NULL THEN 0 ELSE oma54t END,",
                        "       CASE WHEN oma55  IS NULL THEN 0 ELSE oma55  END,",
                        "       CASE WHEN (oma54t-oma55) IS NULL THEN 0 ELSE (oma54t-oma55) END,",
                        "       CASE WHEN oma56  IS NULL THEN 0 ELSE oma56  END,",
                        "       CASE WHEN oma56x IS NULL THEN 0 ELSE oma56x END,",
                        "       CASE WHEN oma51  IS NULL THEN 0 ELSE oma51  END,",
                        "       CASE WHEN oma56t IS NULL THEN 0 ELSE oma56t END,",
                        "       CASE WHEN oma57  IS NULL THEN 0 ELSE oma57  END,",
                        "       CASE WHEN oma61  IS NULL THEN 0 ELSE oma61  END,",
                        "       oma10,oma09,oma67,oma33,oma211,oma24,",
                        "       oma15,gem02,oma14,gen02,oma11 ,oma16,",
                        "       CASE WHEN oma52  IS NULL THEN 0 ELSE oma52  END,",
                        "       CASE WHEN oma53  IS NULL THEN 0 ELSE oma53  END,",
                        "       oma18,aag02,oma08  ,oma19,oma99,oma68,", 
                        "       oma69,oma04,occ18,oma21,omaconf,oma66,azi04 ",
                        "  FROM oma_file LEFT JOIN gem_file ON gem01 = oma15 ",
                        "                LEFT JOIN gen_file ON gen01 = oma14 ",
                        "                LEFT JOIN occ_file ON occ1022 = oma04  AND occ01 = occ1022 ",
                        "                LEFT JOIN aag_file ON aag01 = oma18,",
                        "       azi_file ",
                        " WHERE ", p_wc2 CLIPPED,                     #單身  
                        "   AND azi01=oma23 ",                                                                                           
                        #"   AND (oma54t-oma55) > 0",       #yinhy130711
                        "   AND omavoid = 'N'"      
      CASE tm.d1 WHEN "1" LET l_sql = l_sql CLIPPED," AND (oma54t-oma55)<>0 AND (oma56t-oma57)<>0 "
                 WHEN "2" LET l_sql = l_sql CLIPPED," AND (oma56t-oma57)=0 "
      END CASE
      CASE tm.d2 WHEN "1" LET l_sql = l_sql CLIPPED," AND omaconf = 'Y' "
                 WHEN "2" LET l_sql = l_sql CLIPPED," AND omaconf = 'N' "
      END CASE
      LET l_sql = l_sql CLIPPED," ORDER BY oma00"
   END IF
   PREPARE q310_ins_tmp FROM l_sql
   EXECUTE q310_ins_tmp

   LET l_sql = "UPDATE axrq310_tmp SET oma54t = oma54t * (-1),",
               "                       oma55  = oma55  * (-1),",
               "                       oma56t = oma56t * (-1),",
               "                       oma57  = oma57  * (-1),",
               "                       oma52  = oma52  * (-1),",
               "                       oma53  = oma53  * (-1),",
               "                       oma56  = oma56  * (-1),",
               "                       oma54  = oma54  * (-1),",
               "                       oma54x = oma54x * (-1),",
               "                       oma56x = oma56x * (-1),",
               "                       oma51f = oma51f * (-1),",
               "                       oma51  = oma51  * (-1),",
               "                       amt1   = amt1   * (-1), ",
                "                      amt2   = amt2   * (-1) "        #yinhy130705
   
   #IF g_ooz.ooz07 = 'N' THEN
   #   LET l_sql = l_sql,",amt2   = amt2   * (-1) "
   #END IF
   LET l_sql =l_sql," WHERE oma00 LIKE '2%' "
   PREPARE q310_upd_tmp FROM l_sql
   EXECUTE q310_upd_tmp
   
  #TQC-D30014--add--str
  #當賬款類型為11/12/13/14時，沖帳金額、已收金額應該顯示為負數
   LET l_sql = "UPDATE axrq310_tmp SET oma51f = oma51f * (-1),",
               "                       oma51  = oma51  * (-1),",
               "                       oma55  = oma55  * (-1),",
               "                       oma57  = oma57  * (-1) "
   LET l_sql =l_sql," WHERE oma00 LIKE '1%' "
   PREPARE q310_upd_tmp1 FROM l_sql
   EXECUTE q310_upd_tmp1
  #TQC-D30014--add--end
   DISPLAY "END   TIME: ",TIME
END FUNCTION
#No.FUN-CB0146 ---start--- Add

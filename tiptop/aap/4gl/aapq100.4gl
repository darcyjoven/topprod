# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: aapq100.4gl
# Descriptions...: 應付帳款資料查詢
# Date & Author..: 93/07/09 By Roger
# Modify.........: No.8523 03/10/28 By kitty 212行到236行不知被誰mark掉
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-4B0225 04/11/25 By ching 選未沖,已沖不抓
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多一空白行
# Modify.........: No.MOD-890175 08/09/19 By Sarah apa35_u計算方式改為apa34-apa35
# Modify.........: No.MOD-920361 09/02/26 By Smapmin 發票號碼若為MISC時,未秀出多發票號碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/30 By wujie 增加来源单据串查
#                                                  增加应付金额栏位
# Modify.........: No:CHI-A50026 10/05/26 By Summer 增加欄位:原幣應付金額(apa34f),原幣已沖金額(apa65f),原幣未付金額(apa35_uf)
# Modify.........: No:MOD-B10024 11/01/05 By Dido 帳款發票若為 MISC 則無法查詢之問題改善 
# Modify.........: No:TQC-B10068 11/01/10 By yinhy 原幣未付金額(apa35_uf)計算錯誤
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:CHI-B50056 11/06/24 By Dido 增加欄位:原幣已付金額(apa35f) 
# Modify.........: No:FUN-C30105 12/06/07 By Lori 新增拋轉傳票欄位(apa44)
# Modify.........: No.FUN-C80102 12/10/08 By chenying 報表改善
# Modify.........: No.FUN-CB0146 13/01/07 By zhangweib 報表查詢時間優化
# Modify.........: No.FUN-D10072 13/01/29 By chenying 增加部門匯總
# Modify.........: No.FUN-D40121 13/05/31 By lujh 增加傳參
# Modify.........: No.TQC-D60041 13/06/07 By yangtt 1."匯總類型"為應付款月時，單身匯總頁的營運中心欄位取值有誤
#                                                   2."匯總類型"為apa22時，單身匯總頁的營運中心欄位沒有取到值
#                                                   3. 勾選"顯示原幣"，"幣別小計"的選項是灰色,不可以編輯
#                                                   4. 勾選"幣別小計"，合計欄位顯示添加幣別(apa13)的顯示
# Modify.........: No.MOD-D40029 13/06/07 By yinhy INSERT INTO臨時表時13,17,25類型應查apa07 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm         RECORD
                   wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(600) #FUN-C80102 add ,
#FUN-C80102--add--str--
                   a    LIKE type_file.chr1,   
                   u    LIKE type_file.chr1,   
                   org  LIKE type_file.chr1,   
                   c    LIKE type_file.chr1    
#FUN-C80102--add--end--
                  END RECORD,
       g_apa      DYNAMIC ARRAY OF RECORD
                  #apa08   LIKE apa_file.apa08,   #MOD-920361
                  #apa08   LIKE type_file.chr1000,   #MOD-920361  #FUN-C80102 mark
                   apa00   LIKE apa_file.apa00,  #FUN-C80102 add
                   apa01   LIKE apa_file.apa01,
                   apa02   LIKE apa_file.apa02,  #FUN-C80102 add
                   apa05   LIKE apa_file.apa05,  #FUN-C80102 add
                   pmc03   LIKE pmc_file.pmc03,  #FUN-C80102 add
                   apa13   LIKE apa_file.apa13,
                   apa14   LIKE apa_file.apa14,  #FUN-C80102 add
                   apa31f  LIKE apa_file.apa31f, #FUN-C80102 add
                   apa32f  LIKE apa_file.apa32f, #FUN-C80102 add
                   apa65f  LIKE apa_file.apa65f, #FUN-C80102 add
                   apa34f  LIKE apa_file.apa34f, #FUN-C80102 add
                   apa35f  LIKE apa_file.apa35f, #FUN-C80102 add
                   amt1    LIKE apa_file.apa34,  #FUN-C80102 add
                   apa31   LIKE apa_file.apa31,  #FUN-C80102 add
                   apa32   LIKE apa_file.apa32,  #FUN-C80102 add
                   apa65   LIKE apa_file.apa65,  #FUN-C80102 add
                   apa34   LIKE apa_file.apa34,  #FUN-C80102 add
                   apa35   LIKE apa_file.apa35,  #FUN-C80102 add
                   amt2    LIKE apa_file.apa34f, #FUN-C80102 add
                   apa21   LIKE apa_file.apa21,  #FUN-C80102 add
                   gen02   LIKE gen_file.gen02,  #FUN-C80102 add
                   apa22   LIKE apa_file.apa22,  #FUN-C80102 add
                   gem02   LIKE gem_file.gem02,  #FUN-C80102 add
                   apa08   LIKE apa_file.apa08,  #FUN-C80102 add
                   apa44   LIKE apa_file.apa44,  #FUN-C30105 add
                   apa12   LIKE apa_file.apa12,
                   apa11   LIKE apa_file.apa11,  #FUN-C80102 add
                   pma02   LIKE pma_file.pma02,  #FUN-C80102 add
                   apa06   LIKE apa_file.apa06,  #FUN-C80102 add
                   apa07   LIKE apa_file.apa07,  #FUN-C80102 add
                   pmy01   LIKE pmy_file.pmy01,  #FUN-C80102 add
                   pmy02   LIKE pmy_file.pmy02,  #FUN-C80102 add
                   apa36   LIKE apa_file.apa36,  #FUN-C80102 add
                   apr02   LIKE apr_file.apr02,  #FUN-C80102 add
                   apa54   LIKE apa_file.apa54,  #FUN-C80102 add
                   aag02   LIKE aag_file.aag02,  #FUN-C80102 add
                   apa99   LIKE apa_file.apa99,  #FUN-C80102 add
                   apa15   LIKE apa_file.apa15,  #FUN-C80102 add
                   apa16   LIKE apa_file.apa16,  #FUN-C80102 add
                   apa60f  LIKE apa_file.apa60f, #FUN-C80102 add
                   apa61f  LIKE apa_file.apa61f, #FUN-C80102 add
                   apa60   LIKE apa_file.apa60,  #FUN-C80102 add
                   apa61   LIKE apa_file.apa61,  #FUN-C80102 add
                   apa56   LIKE apa_file.apa56,  #FUN-C80102 add
                   apa33   LIKE apa_file.apa33,  #FUN-C80102 add
                   apa19   LIKE apa_file.apa19,  #FUN-C80102 add
                   apa20   LIKE apa_file.apa20,  #FUN-4B0079
                   apa41   LIKE apa_file.apa41,  #FUN-C80102 add
                   apalegal LIKE apa_file.apalegal #FUN-C80102 add
                  #apa07   LIKE apa_file.apa07,   #FUN-C80102 mark
                  #FUN-C80102--mark--str--
                  #apa34f  LIKE apa_file.apa34f,  #CHI-A50026 add 
                  #apa35f  LIKE apa_file.apa35f,  #CHI-B50056
                  #apa65f  LIKE apa_file.apa65f,  #CHI-A50026 add
                  #apa35_uf LIKE apa_file.apa65f, #CHI-A50026 add
                  #apa34   LIKE apa_file.apa34,  #No.FUN-A30028 
                  #apa35   LIKE apa_file.apa35,  #FUN-4B0079
                  #apa35_u LIKE apa_file.apa35,  #FUN-4B0079
                  #apa100  LIKE apa_file.apa100  #FUN-630043
                  #FUN-C80102--mark--end--
                  END RECORD,
#FUN-C80102--add--str--
       g_apa_1     DYNAMIC ARRAY OF RECORD
                   yymm    LIKE type_file.chr100,
                   apa00   LIKE apa_file.apa00,  
                   apa05   LIKE apa_file.apa05,  
                   pmc03   LIKE pmc_file.pmc03,  
                   apa54   LIKE apa_file.apa54,  
                   aag02   LIKE aag_file.aag02,
                   apa36   LIKE apa_file.apa36, 
                   apr02   LIKE apr_file.apr02, 
                   apalegal_1 LIKE apa_file.apalegal,  
                   apa22   LIKE apa_file.apa22,  #FUN-D10072
                   gem02   LIKE gem_file.gem02,  #FUN-D10072
                  #apa13   LIKE apa_file.apa11,  #TQC-D60041
                   apa13   LIKE apa_file.apa01,  #TQC-D60041
                   apa31f  LIKE apa_file.apa31f, 
                   apa32f  LIKE apa_file.apa32f, 
                   apa65f  LIKE apa_file.apa65f, 
                   apa34f  LIKE apa_file.apa34f, 
                   apa35f  LIKE apa_file.apa35f, 
                   amt1    LIKE apa_file.apa34,  
                   apa31   LIKE apa_file.apa31,  
                   apa32   LIKE apa_file.apa32,  
                   apa65   LIKE apa_file.apa65,  
                   apa34   LIKE apa_file.apa34,  
                   apa35   LIKE apa_file.apa35,  
                   amt2    LIKE apa_file.apa34f, 
                   apa06   LIKE apa_file.apa06,  
                   apa07   LIKE apa_file.apa07,  
                   pmy01   LIKE pmy_file.pmy01,  
                   pmy02   LIKE pmy_file.pmy02,  
                   apa60f  LIKE apa_file.apa60f, 
                   apa61f  LIKE apa_file.apa61f, 
                   apa60   LIKE apa_file.apa60,  
                   apa61   LIKE apa_file.apa61,  
                   apa20   LIKE apa_file.apa20, 
                   apa33   LIKE apa_file.apa33,
                   apalegal LIKE apa_file.apalegal   
                  END RECORD,
#FUN-C80102--add--end--       
       pay_sw     LIKE type_file.num5,         # No.FUN-690028 SMALLINT
       g_wc,g_sql STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN
       g_rec_b    LIKE type_file.num5, 	       #單身筆數  #No.FUN-690028 SMALLINT
       g_rec_b2   LIKE type_file.num5, 	       #單身筆數  #FUN-C80102 add
       g_cnt      LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE g_msg      LIKE type_file.chr1000       #No.FUN-A320028
DEFINE l_ac       LIKE type_file.num5          #No.FUN-A320028 
DEFINE l_ac1      LIKE type_file.num5          #FUN-C80102 add
DEFINE g_filter_wc  STRING                     #FUN-C80102 add 
DEFINE g_flag         LIKE type_file.chr1    #FUN-C80102 
DEFINE g_action_flag  LIKE type_file.chr100  #FUN-C80102 
DEFINE g_comb         ui.ComboBox            #FUN-C80102 
DEFINE g_cmd          LIKE type_file.chr1000 #FUN-C80102
#FUN-C80102--add--str--
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
#FUN-C80102--add--end--
#FUN-D40121--add--str--
DEFINE l_u    LIKE type_file.chr1
DEFINE l_org  LIKE type_file.chr1
DEFINE l_c    LIKE type_file.chr1
DEFINE l_wc   STRING  
DEFINE g_net  LIKE apv_file.apv04
#FUN-D40121--add--end--
 
MAIN
   DEFINE l_time	LIKE type_file.chr8    #計算被使用時間  #No.FUN-690028 VARCHAR(8)
   DEFINE l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   #FUN-D40121--add--str--
   LET l_u = ARG_VAL(1)
   LET l_org = ARG_VAL(2)
   LET l_c = ARG_VAL(3)
   LET l_wc = ARG_VAL(4)
   LET l_wc = cl_replace_str(l_wc, "\\\"", "'") 
   #FUN-D40121--add--end--
   
   LET pay_sw    = 1

   OPEN WINDOW q100_w WITH FORM "aap/42f/aapq100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   FOR g_cnt = 8 TO 17 DISPLAY '' AT g_cnt,1 END FOR
 
#FUN-C80102--add--str--
   CALL cl_set_comp_entry("c",FALSE)               
   CALL cl_set_comp_visible("apalegal",FALSE)               
   CALL cl_set_act_visible("revert_filter",FALSE)  
   INITIALIZE tm.* TO NULL
   LET tm.a = '4'  
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

   LET g_comb = ui.ComboBox.forName("u")
   CALL g_comb.removeItem('6') 
   IF cl_null(l_wc) THEN     #FUN-D40121 add
      CALL q100_q() 
   #FUN-D40121--add--str--
   ELSE
      CALL q100_get_temp('1=1','1=1')  
      CALL q100_t()
   END IF 
   #FUN-D40121--add--end--
#FUN-C80102--add--end--   
   CALL q100_menu()
   DROP TABLE aapq100_tmp;
   CLOSE WINDOW q100_w               #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q100_cs()
   DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   l_wc        STRING                #MOD-B10024

   CLEAR FORM #清除畫面
   CALL g_apa.clear()
   CALL cl_opmsg('q')
#  INITIALIZE tm.* TO NULL			# Default condition   #FUN-C80102 mark
#  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033 #FUN-C80102 mark	

   DISPLAY BY NAME tm.a,tm.u,tm.org,tm.c  #FUN-C80102 add 
   DIALOG ATTRIBUTE(UNBUFFERED)  
  #INPUT BY NAME pay_sw WITHOUT DEFAULTS  #FUN-C80102 mark
   INPUT BY NAME tm.a,tm.u,tm.org,tm.c ATTRIBUTES (WITHOUT DEFAULTS=TRUE)  #FUN-C80102 add
      #No.FUN-580031 --start--     HCN
      BEFORE INPUT
        #CALL cl_qbe_init()  #FUN-C80102 mark
         CALL cl_qbe_display_condition(lc_qbe_sn)  #FUN-C80102 add 
      #No.FUN-580031 --end--       HCN

#FUN-C80102--mark--str-- 
#     AFTER FIELD pay_sw
#        IF pay_sw < 1 OR pay_sw > 2 THEN
#           NEXT FIELD pay_sw
#        END IF
#FUN-C80102--mark--str-- 

#FUN-C80102--add--str-- 
     #AFTER FIELD org   #TQC-D60041
      ON CHANGE org     #TQC-D60041
        #IF tm.org = 'Y' THEN 
        #   CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",TRUE)
        #ELSE
        #   CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",FALSE)
        #END IF
         IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
            CALL cl_set_comp_entry("c",TRUE)
         ELSE
            CALL cl_set_comp_entry("c",FALSE)
         END IF
         
      #AFTER FIELD u   #TQC-D60041
       ON CHANGE u     #TQC-D60041
          IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
             CALL cl_set_comp_entry("c",TRUE)
          ELSE
             CALL cl_set_comp_entry("c",FALSE)
          END IF

       AFTER INPUT 
        # CALL cl_set_comp_visible("apalegal",FALSE)
        # IF tm.org = 'N' THEN  
        #    CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",FALSE)
        # ELSE
        #    CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",TRUE)
        # END IF
   END INPUT

   CONSTRUCT tm.wc ON apa00,apa01,apa02,apa05,apa13,apa14,
                      apa31f,apa32f,apa65f,apa34f,apa35f,amt1,
                      apa31,apa32,apa65,apa34,apa35,amt2,
                      apa21,apa22,apa08,apa44,apa12,apa11,
                      apa06,apa07,pmy01,apa36,apa54,apa99,
                      apa15,apa16,apa60f,apa61f,apa60,apa61,
                      apa56,apa33,apa19,apa20,apa41
                FROM s_apa[1].apa00,s_apa[1].apa01,s_apa[1].apa02,s_apa[1].apa05,s_apa[1].apa13,s_apa[1].apa14,
                     s_apa[1].apa31f,s_apa[1].apa32f,s_apa[1].apa65f,s_apa[1].apa34f,s_apa[1].apa35f,s_apa[1].amt1,
                     s_apa[1].apa31,s_apa[1].apa32,s_apa[1].apa65,s_apa[1].apa34,s_apa[1].apa35,s_apa[1].amt2,
                     s_apa[1].apa21,s_apa[1].apa22,s_apa[1].apa08,s_apa[1].apa44,s_apa[1].apa12,s_apa[1].apa11,
                     s_apa[1].apa06,s_apa[1].apa07,s_apa[1].pmy01,s_apa[1].apa36,s_apa[1].apa54,s_apa[1].apa99,
                     s_apa[1].apa15,s_apa[1].apa16,s_apa[1].apa60f,s_apa[1].apa61f,s_apa[1].apa60,s_apa[1].apa61,
                     s_apa[1].apa56,s_apa[1].apa33,s_apa[1].apa19,s_apa[1].apa20,s_apa[1].apa41
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

   END CONSTRUCT
      AFTER DIALOG
          CALL cl_set_comp_visible("apalegal",FALSE)
          IF tm.org = 'N' THEN  
             CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",FALSE)
          ELSE
             CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",TRUE)
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

          WHEN INFIELD(apa06) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06
               NEXT FIELD apa06

          WHEN INFIELD(apa11) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa11
               NEXT FIELD apa11

          WHEN INFIELD(apa36) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa36
               NEXT FIELD apa36


          WHEN INFIELD(apa54)         
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag02"         
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa54
               NEXT FIELD apa54

          WHEN INFIELD(apa15) # TAX CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               IF g_aza.aza26 = '2' THEN              
                  LET g_qryparam.form ="q_gec8_1"   
               ELSE
                  LET g_qryparam.form ="q_gec8"  
               END IF
               LET g_qryparam.arg1 = '1'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa15
               NEXT FIELD apa15

          WHEN INFIELD(apa13) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa13
               NEXT FIELD apa13

          WHEN INFIELD(apa19) # HOLD CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apo"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa19
               NEXT FIELD apa19

          WHEN INFIELD(apa05) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa05
               NEXT FIELD apa05


          WHEN INFIELD(pmy01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmy"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmy01
               NEXT FIELD pmy01
         END CASE 
     

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
        #CONTINUE INPUT  #FUN-C80102 mark
         CONTINUE DIALOG #FUN-C80102 add
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
  #END INPUT   #FUN-C80102 mark
   END DIALOG  #FUN-C80102 add
   IF INT_FLAG THEN
      LET INT_FLAG = 0  #FUN-C80102 add 
     #RETURN            #FUN-C80102 mark
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C80102 add
      EXIT PROGRAM                                     #FUN-C80102 add
   END IF          
#FUN-C80102--mark--str---
#  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
#  CONSTRUCT BY NAME tm.wc ON apa01,apa12,apa08,apa13,apa44,apa07,apa20,apa35,apa100           #FUN-C30105 add apa44
#     #No.FUN-580031 --start--
#     BEFORE CONSTRUCT
#        CALL cl_qbe_display_condition(lc_qbe_sn)
#     #No.FUN-580031 ---end---
   
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
 
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121 
 
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
 
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
 
#     #No.FUN-580031 --start--     HCN
#     ON ACTION qbe_save
#        CALL cl_qbe_save()
#     #No.FUN-580031 --end--       HCN
#  END CONSTRUCT
#  IF INT_FLAG THEN
#     RETURN
#  END IF
#FUN-C80102--mark--end---
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
   LET tm.wc =cl_replace_str(tm.wc, "amt1", "apa34f-apa35f")   #FUN-C80102
   LET tm.wc =cl_replace_str(tm.wc, "amt2", "apa34-apa35")     #FUN-C80102
   LET tm.wc =cl_replace_str(tm.wc, "pmy01", "pmc02")          #FUN-C80102
  #LET l_wc = cl_replace_str(tm.wc ,"apa08" ,"apk03")                   #MOD-B10024  #FUN-C80102 mark
   LET g_wc = cl_replace_str(tm.wc ,"apa08" ,"apk03")                   #MOD-B10024  #FUN-C80102 add

  #CALL q100()  #FUN-C80102 add     #No.FUN-CB0146 Mark
   CALL q100_get_temp(tm.wc,g_wc)   #No.FUN-CB0146 Add
   CALL q100_t()  #FUN-C80102 add
#FUN-C80102--mark---str--
# #LET g_sql="SELECT apa01,apa12,apa08,apa13,apa44,apa07,",      #MOD-B10024
#  LET g_sql="SELECT DISTINCT apa01,apa12,apa08,apa13,apa44,apa07,",          #MOD-B10024    #FUN-C30105 add apa44
# #          "       apa20,apa35,0,apa100,apa73",  #FUN-630043         #MOD-890175 mark
# #          "       apa20,apa35,0,apa100,apa34-apa35",  #FUN-630043   #MOD-890175
# #CHI-A50026 mark --start--
# #           "       apa20,apa34,apa35,0,apa100,apa34-apa35",  #FUN-630043   #MOD-890175  #No.FUN-A30028 add apa34 
# #CHI-A50026 mark --end--
#            #"       apa20,apa34f,apa65f,apa34f-apa65f,apa34,apa35,apa34-apa35,apa100",  #CHI-A50026  #TQC-B10068 mark
#            "       apa20,apa34f,apa35f,apa65f,apa34f-apa35f,apa34,apa35,apa34-apa35,apa100", #TQC-B10068 add #CHI-B50056 add apa35f
#            " FROM apa_file,apk_file ",                                #MOD-B10024 add apk_file           
#           #" WHERE apa41='Y' AND apa42 = 'N' AND ",tm.wc CLIPPED                                                #MOD-B10024 mark
#            " WHERE apa41='Y' AND apa42 = 'N' AND apa01 = apk01 AND ((",tm.wc CLIPPED,") OR (",l_wc CLIPPED,"))" #MOD-B10024
#  PREPARE q100_p FROM g_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
#     EXIT PROGRAM
#  END IF
#  DECLARE q100_cs CURSOR FOR q100_p
#FUN-C80102--mark---end--
END FUNCTION

#FUN-C80102--add--str--
FUNCTION q100()
   CALL q100_table()
   LET g_sql = "INSERT INTO aapq100_tmp",                                                                
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ", 
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?   )" 
               
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        
      EXIT PROGRAM                                                                                                                 
   END IF
   CALL q100_get_tmp(tm.wc,g_wc)
END FUNCTION

FUNCTION q100_table()
      DROP TABLE aapq100_tmp;
      CREATE TEMP TABLE aapq100_tmp(
                   apa00   LIKE apa_file.apa00,
                   apa01   LIKE apa_file.apa01,
                   apa02   LIKE apa_file.apa02,
                   apa05   LIKE apa_file.apa05,
                   pmc03   LIKE pmc_file.pmc03,
                   apa13   LIKE apa_file.apa13,
                   apa14   LIKE apa_file.apa14,
                   apa31f  LIKE apa_file.apa31f,
                   apa32f  LIKE apa_file.apa32f,
                   apa65f  LIKE apa_file.apa65f,
                   apa34f  LIKE apa_file.apa34f,
                   apa35f  LIKE apa_file.apa35f,
                   amt1    LIKE apa_file.apa34,
                   apa31   LIKE apa_file.apa31,
                   apa32   LIKE apa_file.apa32,
                   apa65   LIKE apa_file.apa65,
                   apa34   LIKE apa_file.apa34,
                   apa35   LIKE apa_file.apa35,
                   amt2    LIKE apa_file.apa34f,
                   apa21   LIKE apa_file.apa21,
                   gen02   LIKE gen_file.gen02,
                   apa22   LIKE apa_file.apa22,
                   gem02   LIKE gem_file.gem02,
                   apa08   LIKE type_file.chr500,   #No.FUN-CB0146 Mod  apa_file.apa08 --> type_file.chr100  #modify 100---->500 by dengsy170104
                   apa44   LIKE apa_file.apa44,
                   apa12   LIKE apa_file.apa12,
                   apa11   LIKE apa_file.apa11,
                   pma02   LIKE pma_file.pma02,
                   apa06   LIKE apa_file.apa06,
                   apa07   LIKE apa_file.apa07,
                   pmy01   LIKE pmy_file.pmy01,
                   pmy02   LIKE pmy_file.pmy02,
                   apa36   LIKE apa_file.apa36,
                   apr02   LIKE apr_file.apr02,
                   apa54   LIKE apa_file.apa54,
                   aag02   LIKE aag_file.aag02,
                   apa99   LIKE apa_file.apa99,
                   apa15   LIKE apa_file.apa15,
                   apa16   LIKE apa_file.apa16,
                   apa60f  LIKE apa_file.apa60f,
                   apa61f  LIKE apa_file.apa61f,
                   apa60   LIKE apa_file.apa60,
                   apa61   LIKE apa_file.apa61,
                   apa56   LIKE apa_file.apa56,
                   apa33   LIKE apa_file.apa33,
                   apa19   LIKE apa_file.apa19,
                   apa20   LIKE apa_file.apa20,
                   apa41   LIKE apa_file.apa41, 
                   apalegal LIKE apa_file.apalegal) 
                      
END FUNCTION


FUNCTION q100_get_tmp(p_wc1,p_wc2)
DEFINE l_sql LIKE type_file.chr1000 
DEFINE sr    RECORD 
                   apa00   LIKE apa_file.apa00,
                   apa01   LIKE apa_file.apa01,
                   apa02   LIKE apa_file.apa02,
                   apa05   LIKE apa_file.apa05,
                   pmc03   LIKE pmc_file.pmc03,
                   apa13   LIKE apa_file.apa13,
                   apa14   LIKE apa_file.apa14,
                   apa31f  LIKE apa_file.apa31f,
                   apa32f  LIKE apa_file.apa32f,
                   apa65f  LIKE apa_file.apa65f,
                   apa34f  LIKE apa_file.apa34f,
                   apa35f  LIKE apa_file.apa35f,
                   amt1    LIKE apa_file.apa34,
                   apa31   LIKE apa_file.apa31,
                   apa32   LIKE apa_file.apa32,
                   apa65   LIKE apa_file.apa65,
                   apa34   LIKE apa_file.apa34,
                   apa35   LIKE apa_file.apa35,
                   amt2    LIKE apa_file.apa34f,
                   apa21   LIKE apa_file.apa21,
                   gen02   LIKE gen_file.gen02,
                   apa22   LIKE apa_file.apa22,
                   gem02   LIKE gem_file.gem02,
                   apa08   LIKE apa_file.apa08,
                   apa44   LIKE apa_file.apa44,
                   apa12   LIKE apa_file.apa12,
                   apa11   LIKE apa_file.apa11,
                   pma02   LIKE pma_file.pma02,
                   apa06   LIKE apa_file.apa06,
                   apa07   LIKE apa_file.apa07,
                   pmy01   LIKE pmy_file.pmy01,
                   pmy02   LIKE pmy_file.pmy02,
                   apa36   LIKE apa_file.apa36,
                   apr02   LIKE apr_file.apr02,
                   apa54   LIKE apa_file.apa54,
                   aag02   LIKE aag_file.aag02,
                   apa99   LIKE apa_file.apa99,
                   apa15   LIKE apa_file.apa15,
                   apa16   LIKE apa_file.apa16,
                   apa60f  LIKE apa_file.apa60f,
                   apa61f  LIKE apa_file.apa61f,
                   apa60   LIKE apa_file.apa60,
                   apa61   LIKE apa_file.apa61,
                   apa56   LIKE apa_file.apa56,
                   apa33   LIKE apa_file.apa33,
                   apa19   LIKE apa_file.apa19,
                   apa20   LIKE apa_file.apa20,
                   apa41   LIKE apa_file.apa41,
                   apalegal LIKE apa_file.apalegal 
             END RECORD
DEFINE
    p_wc1           LIKE type_file.chr1000 
DEFINE
    p_wc2           LIKE type_file.chr1000 
DEFINE l_apk03      LIKE apk_file.apk03

    LET l_sql = "SELECT apa00,apa01,apa02,apa05,pmc03,apa13,apa14,",
                "       apa31f,apa32f,apa65f,apa34f,apa35f,apa34f-apa35f,apa31,apa32,apa65,",
                "       apa34,apa35,apa34-apa35,apa21,'',apa22,'',apa08,apa44,apa12,apa11,'',apa06,apa07,pmc02,'',",
                "       apa36,'',apa54,'',apa99,apa15,apa16,apa61f,apa60f,apa60,apa61,apa56,apa33,apa19,apa20,apa41,apalegal ",           
                "  FROM apa_file LEFT OUTER JOIN apk_file ON apa01 = apk01  ",
                "                LEFT OUTER JOIN pmc_file ON pmc01 = apa06  ",       
                " WHERE apa41='Y' AND apa42 = 'N' AND ((",p_wc1 CLIPPED,") OR (",p_wc2 CLIPPED,"))"
   CASE tm.a
      WHEN "1" LET l_sql = l_sql CLIPPED," AND apa00 IN (11,12,15,21,22,23,24) "
      WHEN "2" LET l_sql = l_sql CLIPPED," AND apa00 IN (13,17,25) "
      WHEN "3" LET l_sql = l_sql CLIPPED," AND apa00 IN (16,26) "
   END CASE
   LET l_sql = l_sql CLIPPED," ORDER BY apa00,apa01,apa02 "
   PREPARE q100_p FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
   DECLARE q100_cs CURSOR FOR q100_p 
   FOREACH q100_cs INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     SELECT DISTINCT pmy02 INTO sr.pmy02 FROM pmy_file WHERE pmy01 = sr.pmy01 
     SELECT DISTINCT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.apa22
     SELECT DISTINCT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.apa21
     SELECT DISTINCT apr02 INTO sr.apr02 FROM apr_file WHERE apr01 = sr.apa36
     SELECT DISTINCT pma02 INTO sr.pma02 FROM pma_file WHERE pma01 = sr.apa11
     SELECT DISTINCT aag02 INTO sr.aag02 FROM aag_file WHERE aag01 = sr.apa54

     IF sr.apa08 = 'MISC' THEN
        LET sr.apa08 = ''
        DECLARE apk_cs CURSOR FOR
            SELECT apk03 FROM apk_file WHERE apk01=sr.apa01
          FOREACH apk_cs INTO l_apk03
            IF cl_null(sr.apa08) THEN
               LET sr.apa08 = l_apk03
            ELSE
               LET sr.apa08 = sr.apa08,",",l_apk03
            END IF
          END FOREACH
        IF cl_null(sr.apa08) THEN
           LET sr.apa08 = 'MISC'
        END IF
     END IF

     IF cl_null(sr.apa20) THEN LET sr.apa20 = 0 END IF 
     IF cl_null(sr.apa33) THEN LET sr.apa33 = 0 END IF 

     CALL p100_comp_oox(sr.apa01) RETURNING g_net   #FUN-D40121 add
     LET sr.amt2 = sr.amt2 + g_net                  #FUN-D40121 add
     
     IF sr.apa00 matches '2*' THEN 
        LET sr.apa31f = sr.apa31f * (-1)
        LET sr.apa31  = sr.apa31  * (-1)
        LET sr.apa32f = sr.apa32f * (-1)
        LET sr.apa32  = sr.apa32  * (-1)
        LET sr.apa34f = sr.apa34f * (-1)
        LET sr.apa34  = sr.apa34  * (-1)
        LET sr.apa65f = sr.apa65f * (-1)
        LET sr.apa65  = sr.apa65  * (-1)
        LET sr.apa35f = sr.apa35f * (-1)
        LET sr.apa35  = sr.apa35  * (-1)
        LET sr.amt1   = sr.amt1   * (-1)
        LET sr.amt2   = sr.amt2   * (-1)
     END IF

     EXECUTE insert_prep USING sr.*  
   END FOREACH      
END FUNCTION

FUNCTION q100_t()
   IF tm.org = 'Y' THEN 
      CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",TRUE) 
      CALL cl_set_comp_visible("apa13_1,apa31f_1,apa32f_1,apa60f_1,apa61f_1,apa65f_1,apa34f_1,apa35f_1,amt1_1",TRUE) 
   ELSE
      CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",FALSE) 
      CALL cl_set_comp_visible("apa13_1,apa31f_1,apa32f_1,apa60f_1,apa61f_1,apa65f_1,apa34f_1,apa35f_1,amt1_1",FALSE) 
   END  IF 
   CLEAR FORM
   CALL g_apa.clear()
   CALL q100_show()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q100_show()
   DISPLAY tm.u TO u
   DISPLAY tm.c TO c
   DISPLAY tm.a TO a 
   DISPLAY tm.org TO org 

   CALL q100_b_fill_1()
   CALL q100_b_fill_2()
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

   CALL q100_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q100_set_visible()
   CALL cl_set_comp_visible("yymm,apa00_1,apa05_1,pmc03_1,apalegal_2,apa06_1,apa07_1,pmy01_1,pmy02_1,apa54_1,aag02_1,apa36_1,apr02_1,apa22_1,gem02_1",TRUE)   #FUN-D10072 add apa22_1
#  CALL cl_set_comp_visible("apa31f_1,apa32f_1,apa60f_1,apa61f_1,apa65f_1,apa34f_1,apa35f_1,amt1_1",TRUE)
   CALL cl_set_comp_visible("apa31_1,apa32_1,apa60_1,apa61_1,apa65_1,apa34_1,apa35_1,amt2_1,apa20,apa33_1,apalegal_1",TRUE)
   CASE tm.u
     WHEN "1" CALL cl_set_comp_visible("yymm,apa00_1,apalegal_2,apa54_1,aag02_1,apa36_1,apr02_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "2" CALL cl_set_comp_visible("yymm,apa05_1,pmc03_1,apalegal_2,pmy01_1,pmy02_1,apa54_1,aag02_1,apa36_1,apr02_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "3" CALL cl_set_comp_visible("apa00_1,apa05_1,pmc03_1,apalegal_2,pmy01_1,pmy02_1,apa54_1,aag02_1,apa36_1,apr02_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "4" CALL cl_set_comp_visible("yymm,apa00_1,apa05_1,pmc03_1,apalegal_2,pmy01_1,pmy02_1,apa36_1,apr02_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "5" CALL cl_set_comp_visible("yymm,apa00_1,apa05_1,pmc03_1,apalegal_2,pmy01_1,pmy02_1,apa54_1,aag02_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "6" CALL cl_set_comp_visible("yymm,apa00_1,apa05_1,pmc03_1,pmy01_1,pmy02_1,apa54_1,aag02_1,apa36_1,apr02_1,apalegal_1,apa22_1,gem02_1",FALSE) #FUN-D10072 add apa22_1
     WHEN "7" CALL cl_set_comp_visible("yymm,apa00_1,apa05_1,pmc03_1,apalegal_2,pmy01_1,pmy02_1,apa54_1,aag02_1,apa36_1,apr02_1",FALSE) #FUN-D10072 add apa22_1
   END CASE
END FUNCTION

FUNCTION q100_b_fill_1()
DEFINE g_tot11   LIKE apa_file.apa31
DEFINE g_tot21   LIKE apa_file.apa31
DEFINE g_tot31   LIKE apa_file.apa31
DEFINE g_tot41   LIKE apa_file.apa31
DEFINE g_tot51   LIKE apa_file.apa31
DEFINE g_tot61   LIKE apa_file.apa31
DEFINE g_tot71   LIKE apa_file.apa31
DEFINE g_tot81   LIKE apa_file.apa31
DEFINE g_tot91   LIKE apa_file.apa31

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF    #FUN-D40121 add
   LET g_sql = "SELECT * FROM aapq100_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               "   AND ",l_wc CLIPPED,    #FUN-D40121 add
               " ORDER BY apa00,apa01,apa02 "

   PREPARE aapq100_pb1 FROM g_sql
   DECLARE apa_curs1  CURSOR FOR aapq100_pb1        #CURSOR

   CALL g_apa.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0
   LET g_tot61 = 0
   LET g_tot71 = 0
   LET g_tot81 = 0
   LET g_tot91 = 0

   FOREACH apa_curs1 INTO g_apa[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach_apa:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     LET g_tot11 = g_tot11 + g_apa[g_cnt].apa31
     LET g_tot21 = g_tot21 + g_apa[g_cnt].apa32
     LET g_tot31 = g_tot31 + g_apa[g_cnt].apa60
     LET g_tot41 = g_tot41 + g_apa[g_cnt].apa61
     LET g_tot51 = g_tot51 + g_apa[g_cnt].apa65
     LET g_tot61 = g_tot61 + g_apa[g_cnt].apa34
     LET g_tot71 = g_tot71 + g_apa[g_cnt].apa35
     LET g_tot81 = g_tot81 + g_apa[g_cnt].amt2
     LET g_tot91 = g_tot91 + g_apa[g_cnt].apa33
     
     LET g_cnt = g_cnt + 1

     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH
   DISPLAY g_tot11 TO FORMONLY.apa31_tot1
   DISPLAY g_tot21 TO FORMONLY.apa32_tot1
   DISPLAY g_tot31 TO FORMONLY.apa60_tot1
   DISPLAY g_tot41 TO FORMONLY.apa61_tot1
   DISPLAY g_tot51 TO FORMONLY.apa65_tot1
   DISPLAY g_tot61 TO FORMONLY.apa34_tot1
   DISPLAY g_tot71 TO FORMONLY.apa35_tot1
   DISPLAY g_tot81 TO FORMONLY.amt2_tot1
   DISPLAY g_tot91 TO FORMONLY.apa33_tot1

   CALL g_apa.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q100_b_fill_2()
DEFINE g_tot1   LIKE apa_file.apa31
DEFINE g_tot2   LIKE apa_file.apa31
DEFINE g_tot3   LIKE apa_file.apa31
DEFINE g_tot4   LIKE apa_file.apa31
DEFINE g_tot5   LIKE apa_file.apa31
DEFINE g_tot6   LIKE apa_file.apa31
DEFINE g_tot7   LIKE apa_file.apa31
DEFINE g_tot8   LIKE apa_file.apa31
DEFINE g_tot9   LIKE apa_file.apa31
DEFINE l_apa13  LIKE apa_file.apa13

   CALL g_apa_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   LET g_tot1 = 0
   LET g_tot2 = 0
   LET g_tot3 = 0
   LET g_tot4 = 0
   LET g_tot5 = 0
   LET g_tot6 = 0
   LET g_tot7 = 0
   LET g_tot8 = 0
   LET g_tot9 = 0
  
   IF tm.c = "Y" THEN 
      LET g_sql = " SELECT DISTINCT apa13 FROM aapq100_tmp ORDER BY apa13"
      PREPARE q100_bp_d FROM g_sql
      DECLARE q100_curs_d CURSOR FOR q100_bp_d
      FOREACH q100_curs_d INTO l_apa13
         CALL q100_get_sum(l_apa13)
         LET g_tot1 = g_tot1 + g_apa_1[g_cnt].apa31
         LET g_tot2 = g_tot2 + g_apa_1[g_cnt].apa32
         LET g_tot3 = g_tot3 + g_apa_1[g_cnt].apa60
         LET g_tot4 = g_tot4 + g_apa_1[g_cnt].apa61
         LET g_tot5 = g_tot5 + g_apa_1[g_cnt].apa65
         LET g_tot6 = g_tot6 + g_apa_1[g_cnt].apa34
         LET g_tot7 = g_tot7 + g_apa_1[g_cnt].apa35
         LET g_tot8 = g_tot8 + g_apa_1[g_cnt].amt2
         LET g_tot9 = g_tot9 + g_apa_1[g_cnt].apa33
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF 
      END FOREACH
      DISPLAY g_tot1 TO FORMONLY.apa31_tot
      DISPLAY g_tot2 TO FORMONLY.apa32_tot
      DISPLAY g_tot3 TO FORMONLY.apa60_tot
      DISPLAY g_tot4 TO FORMONLY.apa61_tot
      DISPLAY g_tot5 TO FORMONLY.apa65_tot
      DISPLAY g_tot6 TO FORMONLY.apa34_tot
      DISPLAY g_tot7 TO FORMONLY.apa35_tot
      DISPLAY g_tot8 TO FORMONLY.amt2_tot
      DISPLAY g_tot9 TO FORMONLY.apa33_tot
   ELSE
      CALL q100_get_sum('')
   END IF     
END FUNCTION

FUNCTION q100_get_sum(p_apa13)
DEFINE p_apa13   LIKE apa_file.apa13
DEFINE l_tot1    LIKE apa_file.apa31
DEFINE l_tot2    LIKE apa_file.apa31
DEFINE l_tot3    LIKE apa_file.apa31
DEFINE l_tot4    LIKE apa_file.apa31
DEFINE l_tot5    LIKE apa_file.apa31
DEFINE l_tot6    LIKE apa_file.apa31
DEFINE l_tot7    LIKE apa_file.apa31
DEFINE l_tot8    LIKE apa_file.apa31
DEFINE l_tot9    LIKE apa_file.apa31
DEFINE l_tot10   LIKE apa_file.apa31
DEFINE l_tot11   LIKE apa_file.apa31
DEFINE l_tot12   LIKE apa_file.apa31
DEFINE l_tot13   LIKE apa_file.apa31
DEFINE l_tot14   LIKE apa_file.apa31
DEFINE l_tot15   LIKE apa_file.apa31
DEFINE l_tot16   LIKE apa_file.apa31
DEFINE l_tot17   LIKE apa_file.apa31
DEFINE l_tot18   LIKE apa_file.apa31
DEFINE l_year   LIKE type_file.num5
DEFINE l_month  LIKE type_file.num5
DEFINE l_yy     STRING
DEFINE l_mm     STRING
DEFINE l_tot19  LIKE apa_file.apa13  #TQC-D60041

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
   LET l_tot14 = 0 
   LET l_tot15 = 0 
   LET l_tot16 = 0 
   LET l_tot17 = 0 
   LET l_tot18 = 0 
   LET l_tot19 = NULL #TQC-D60041

   #FUN-D40121--add--str--
   IF cl_null(l_wc) THEN 
      LET l_wc = '1=1'
   END IF 
   #FUN-D40121--add--end--
   
   CASE tm.u
      WHEN "1"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '','',apa05,'','','','','','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f),"  #FUN-D10072 add ''
      ELSE
        LET g_sql = "SELECT '','',apa05,'','','','','','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f),"   #FUN-D10072 add ''
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),", 
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,pmy01,'',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),apalegal ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa05,apa13,apa06,apa07,pmy01,apalegal ",
                    " ORDER BY apa05,apa13,apa06,apa07,pmy01,apalegal "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa05,apa06,apa07,pmy01,apalegal ",
                    " ORDER BY apa05,apa06,apa07,pmy01,apalegal "
      END IF
        PREPARE q100_pb1 FROM g_sql
        DECLARE q100_curs1 CURSOR FOR q100_pb1
        FOREACH q100_curs1 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct pmy02 INTO g_apa_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_apa_1[g_cnt].pmy01
           SELECT distinct pmc03 INTO g_apa_1[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_apa_1[g_cnt].apa05
                  
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33
         
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH 

      WHEN "2"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '',apa00,'','','','','','','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f),"#FUN-D10072 add  
      ELSE
        LET g_sql = "SELECT '',apa00,'','','','','','','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add 
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),",
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),apalegal ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa00,apa13,apa06,apa07,apalegal ",
                    " ORDER BY apa00,apa13,apa06,apa07,apalegal "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa00,apa06,apa07,apalegal ",
                    " ORDER BY apa00,apa06,apa07,apalegal "
      END IF
        PREPARE q100_pb2 FROM g_sql
        DECLARE q100_curs2 CURSOR FOR q100_pb2
        FOREACH q100_curs2 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct apr02 INTO g_apa_1[g_cnt].apr02 FROM apr_file WHERE apr01 = g_apa_1[g_cnt].apa36
           SELECT distinct aag02 INTO g_apa_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_apa_1[g_cnt].apa54
           SELECT distinct pmy02 INTO g_apa_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_apa_1[g_cnt].pmy01



           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33
         
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH 

     WHEN "3"
      IF tm.org = "Y" THEN
       #LET g_sql = "SELECT YEAR(apa12),MONTH(apa12),'','','','','','','','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add  #TQC-D60041
        LET g_sql = "SELECT YEAR(apa12),MONTH(apa12),'','','','','','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add        #TQC-D60041
      ELSE
       #LET g_sql = "SELECT YEAR(apa12),MONTH(apa12),'','','','','','','','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add     #TQC-D60041
        LET g_sql = "SELECT YEAR(apa12),MONTH(apa12),'','','','','','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add           #TQC-D60041
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),",
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),apalegal ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY YEAR(apa12),MONTH(apa12),apa13,apa06,apa07,apalegal ",
                    " ORDER BY YEAR(apa12),MONTH(apa12),apa13,apa06,apa07,apalegal "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY YEAR(apa12),MONTH(apa12),apa06,apa07,apalegal ",
                    " ORDER BY YEAR(apa12),MONTH(apa12),apa06,apa07,apalegal "
      END IF
        PREPARE q100_pb3 FROM g_sql
        DECLARE q100_curs3 CURSOR FOR q100_pb3
        FOREACH q100_curs3 INTO l_year,l_month,g_apa_1[g_cnt].apa00,g_apa_1[g_cnt].apa05,g_apa_1[g_cnt].pmc03,
                                g_apa_1[g_cnt].apa54,g_apa_1[g_cnt].aag02,g_apa_1[g_cnt].apa36,g_apa_1[g_cnt].apr02,
                                g_apa_1[g_cnt].apalegal_1,g_apa_1[g_cnt].apa13,g_apa_1[g_cnt].apa31f,g_apa_1[g_cnt].apa32f,
                                g_apa_1[g_cnt].apa65f,g_apa_1[g_cnt].apa34f,
                                g_apa_1[g_cnt].apa35f,g_apa_1[g_cnt].amt1,g_apa_1[g_cnt].apa31,g_apa_1[g_cnt].apa32,
                                g_apa_1[g_cnt].apa65,g_apa_1[g_cnt].apa34,
                                g_apa_1[g_cnt].apa35,g_apa_1[g_cnt].amt2,
                                g_apa_1[g_cnt].apa06,g_apa_1[g_cnt].apa07,g_apa_1[g_cnt].pmy01,g_apa_1[g_cnt].pmy02,
                                g_apa_1[g_cnt].apa60f,g_apa_1[g_cnt].apa61f,g_apa_1[g_cnt].apa60,g_apa_1[g_cnt].apa61,
                                g_apa_1[g_cnt].apa20,g_apa_1[g_cnt].apa33,g_apa_1[g_cnt].apalegal
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_2:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct apr02 INTO g_apa_1[g_cnt].apr02 FROM apr_file WHERE apr01 = g_apa_1[g_cnt].apa36
           SELECT distinct aag02 INTO g_apa_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_apa_1[g_cnt].apa54
           SELECT distinct pmy02 INTO g_apa_1[g_cnt].pmy02 FROM pmy_file WHERE pmy01 = g_apa_1[g_cnt].pmy01

           LET l_mm = l_month
           LET l_mm = l_mm.trim()
           LET l_yy = l_year
           LET l_yy = l_yy.trim()
           LET g_apa_1[g_cnt].yymm = l_yy,'/',l_mm
 
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33

           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH

      WHEN "4"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '','','','',apa54,'','','','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add 
      ELSE
        LET g_sql = "SELECT '','','','',apa54,'','','','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add 
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),", 
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),apalegal ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa54,apa13,apa06,apa07,apalegal ",
                    " ORDER BY apa54,apa13,apa06,apa07,apalegal "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa54,apa06,apa07,apalegal ",
                    " ORDER BY apa54,apa06,apa07,apalegal "
      END IF
        PREPARE q100_pb4 FROM g_sql
        DECLARE q100_curs4 CURSOR FOR q100_pb4
        FOREACH q100_curs4 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct aag02 INTO g_apa_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_apa_1[g_cnt].apa54
                  
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33
         
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH 

      WHEN "5"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '','','','','','',apa36,'','','','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add 
      ELSE
        LET g_sql = "SELECT '','','','','','',apa36,'','','','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add  
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),", 
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),apalegal ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED   #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa36,apa13,apa06,apa07,apalegal ",
                    " ORDER BY apa36,apa13,apa06,apa07,apalegal "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apa36,apa06,apa07,apalegal ",
                    " ORDER BY apa36,apa06,apa07,apalegal "
      END IF
        PREPARE q100_pb5 FROM g_sql
        DECLARE q100_curs5 CURSOR FOR q100_pb5
        FOREACH q100_curs5 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct apr02 INTO g_apa_1[g_cnt].apr02 FROM apr_file WHERE apr01 = g_apa_1[g_cnt].apa36
                  
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33
         
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH 

      WHEN "6"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '','','','','','','','',apalegal,'','',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f),"#FUN-D10072 add  
      ELSE
        LET g_sql = "SELECT '','','','','','','','',apalegal,'','','',SUM(apa31f),SUM(apa32f),SUM(apa65f)," #FUN-D10072 add 
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),", 
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
                    "       SUM(apa20),SUM(apa33),'' ",
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apalegal,apa13,apa06,apa07 ",
                    " ORDER BY apalegal,apa13,apa06,apa07 "
      ELSE
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY apalegal,apa06,apa07 ",
                    " ORDER BY apalegal,apa06,apa07 "
      END IF
        PREPARE q100_pb6 FROM g_sql
        DECLARE q100_curs6 CURSOR FOR q100_pb6
        FOREACH q100_curs6 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
                  
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33
         
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH 
    
    #FUN-D10072 --add-
    WHEN "7"
      IF tm.org = "Y" THEN
        LET g_sql = "SELECT '','','','','','','','','',apa22,'',apa13,SUM(apa31f),SUM(apa32f),SUM(apa65f),"
      ELSE
        LET g_sql = "SELECT '','','','','','','','','',apa22,'','',SUM(apa31f),SUM(apa32f),SUM(apa65f),"
      END IF
        LET g_sql = g_sql CLIPPED,
                    "       SUM(apa34f),SUM(apa35f),SUM(apa34f-apa35f),SUM(apa31),SUM(apa32),SUM(apa65),",
                    "       SUM(apa34),SUM(apa35),SUM(apa34-apa35),apa06,apa07,'','',",
                    "       SUM(apa60f),SUM(apa61f),SUM(apa60),SUM(apa61),",
		   #"       SUM(apa20),SUM(apa33),'' ",         #TQC-D60041
                    "       SUM(apa20),SUM(apa33),apalegal ",   #TQC-D60041
                    "  FROM aapq100_tmp ",
                    "  WHERE ",g_filter_wc CLIPPED,
                    "   AND ",l_wc CLIPPED    #FUN-D40121 add
        IF tm.c = "Y" THEN LET g_sql = g_sql CLIPPED," AND apa13 = '",p_apa13,"' " END IF
      IF tm.org = "Y" THEN
        LET g_sql = g_sql CLIPPED,
                   #" GROUP BY apa22,apa13,apa06,apa07 ", #TQC-D60041 
                   #" ORDER BY apa22,apa13,apa06,apa07 "  #TQC-D60041 
                    " GROUP BY apa22,apa13,apa06,apa07,apalegal ", #TQC-D60041
                    " ORDER BY apa22,apa13,apa06,apa07,apalegal "  #TQC-D60041
      ELSE
        LET g_sql = g_sql CLIPPED,
                   #" GROUP BY apa22,apa06,apa07 ",#TQC-D60041 
                   #" ORDER BY apa22,apa06,apa07 " #TQC-D60041 
                    " GROUP BY apa22,apa06,apa07,apalegal ", #TQC-D60041
                    " ORDER BY apa22,apa06,apa07,apalegal "  #TQC-D60041
      END IF
        PREPARE q100_pb7 FROM g_sql
        DECLARE q100_curs7 CURSOR FOR q100_pb7
        FOREACH q100_curs7 INTO g_apa_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_apa_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct gem02 INTO g_apa_1[g_cnt].gem02 FROM gem_file WHERE gem01 = g_apa_1[g_cnt].apa22  #FUN-D10072 
           LET l_tot19 = g_apa_1[g_cnt].apa13   #TQC-D60041
           LET l_tot1 = l_tot1 + g_apa_1[g_cnt].apa31f
           LET l_tot2 = l_tot2 + g_apa_1[g_cnt].apa32f
           LET l_tot3 = l_tot3 + g_apa_1[g_cnt].apa60f
           LET l_tot4 = l_tot4 + g_apa_1[g_cnt].apa61f
           LET l_tot5 = l_tot5 + g_apa_1[g_cnt].apa65f
           LET l_tot6 = l_tot6 + g_apa_1[g_cnt].apa34f
           LET l_tot7 = l_tot7 + g_apa_1[g_cnt].apa35f
           LET l_tot8 = l_tot8 + g_apa_1[g_cnt].amt1
           LET l_tot9 = l_tot9 + g_apa_1[g_cnt].apa31
           LET l_tot10 = l_tot10 + g_apa_1[g_cnt].apa32
           LET l_tot11 = l_tot11 + g_apa_1[g_cnt].apa60
           LET l_tot12 = l_tot12 + g_apa_1[g_cnt].apa61
           LET l_tot13 = l_tot13 + g_apa_1[g_cnt].apa65
           LET l_tot14 = l_tot14 + g_apa_1[g_cnt].apa34
           LET l_tot15 = l_tot15 + g_apa_1[g_cnt].apa35
           LET l_tot16 = l_tot16 + g_apa_1[g_cnt].amt2
           LET l_tot17 = l_tot17 + g_apa_1[g_cnt].apa20
           LET l_tot18 = l_tot18 + g_apa_1[g_cnt].apa33

           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
        END FOREACH
    #FUN-D10072 --add- 
    END CASE
    IF tm.c = 'N' THEN 
       DISPLAY l_tot9 TO  FORMONLY.apa31_tot
       DISPLAY l_tot10 TO FORMONLY.apa32_tot
       DISPLAY l_tot11 TO FORMONLY.apa60_tot
       DISPLAY l_tot12 TO FORMONLY.apa61_tot
       DISPLAY l_tot13 TO FORMONLY.apa65_tot
       DISPLAY l_tot14 TO FORMONLY.apa34_tot
       DISPLAY l_tot15 TO FORMONLY.apa35_tot
       DISPLAY l_tot16 TO FORMONLY.amt2_tot
       DISPLAY l_tot18 TO FORMONLY.apa33_tot
    END IF
    IF tm.c = "Y" THEN 
      #LET g_apa_1[g_cnt].apa13 = cl_getmsg('amr-003',g_lang)   #TQC-D60041 
       LET g_apa_1[g_cnt].apa13 = l_tot19,"  ",cl_getmsg('amr-003',g_lang)  #TQC-D60041 add l_tot19
       LET g_apa_1[g_cnt].apa31f = l_tot1
       LET g_apa_1[g_cnt].apa32f = l_tot2
       LET g_apa_1[g_cnt].apa60f = l_tot3
       LET g_apa_1[g_cnt].apa61f = l_tot4
       LET g_apa_1[g_cnt].apa65f = l_tot5
       LET g_apa_1[g_cnt].apa34f = l_tot6
       LET g_apa_1[g_cnt].apa35f = l_tot7
       LET g_apa_1[g_cnt].amt1 = l_tot8
       LET g_apa_1[g_cnt].apa31 = l_tot9
       LET g_apa_1[g_cnt].apa32 = l_tot10
       LET g_apa_1[g_cnt].apa60 = l_tot11
       LET g_apa_1[g_cnt].apa61 = l_tot12
       LET g_apa_1[g_cnt].apa65 = l_tot13
       LET g_apa_1[g_cnt].apa34 = l_tot14
       LET g_apa_1[g_cnt].apa35 = l_tot15
       LET g_apa_1[g_cnt].amt2 = l_tot16
       LET g_apa_1[g_cnt].apa20 = l_tot17
       LET g_apa_1[g_cnt].apa33 = l_tot18
    END IF
    DISPLAY ARRAY g_apa_1 TO s_apa_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY
    IF tm.c != 'Y' THEN   
       CALL g_apa_1.deleteElement(g_cnt)
       LET g_rec_b2 = g_cnt - 1
    ELSE
       LET g_rec_b2 = g_cnt 
    END IF
    DISPLAY g_rec_b2 TO FORMONLY.cnt1
END FUNCTION

FUNCTION q100_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_apa.clear()
   CALL g_apa_1.clear()
   CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1,apalegal",TRUE)
   DISPLAY BY NAME tm.u,tm.org,tm.a,tm.c
   CONSTRUCT l_wc ON apa00,apa01,apa02,apa05,apa13,apa14,
                     apa31f,apa32f,apa65f,apa34f,apa35f,amt1,
                     apa31,apa32,apa65,apa34,apa35,amt2,
                     apa21,apa22,apa08,apa44,apa12,apa11,
                     apa06,apa07,pmy01,apa36,apa54,apa99,
                     apa15,apa16,apa60f,apa61f,apa60,apa61,
                     apa56,apa33,apa19,apa20,apa41
                FROM s_apa[1].apa00,s_apa[1].apa01,s_apa[1].apa02,s_apa[1].apa05,s_apa[1].apa13,s_apa[1].apa14,
                     s_apa[1].apa31f,s_apa[1].apa32f,s_apa[1].apa65f,s_apa[1].apa34f,s_apa[1].apa35f,s_apa[1].amt1,
                     s_apa[1].apa31,s_apa[1].apa32,s_apa[1].apa65,s_apa[1].apa34,s_apa[1].apa35,s_apa[1].amt2,
                     s_apa[1].apa21,s_apa[1].apa22,s_apa[1].apa08,s_apa[1].apa44,s_apa[1].apa12,s_apa[1].apa11,
                     s_apa[1].apa06,s_apa[1].apa07,s_apa[1].pmy01,s_apa[1].apa36,s_apa[1].apa54,s_apa[1].apa99,
                     s_apa[1].apa15,s_apa[1].apa16,s_apa[1].apa60f,s_apa[1].apa61f,s_apa[1].apa60,s_apa[1].apa61,
                     s_apa[1].apa56,s_apa[1].apa33,s_apa[1].apa19,s_apa[1].apa20,s_apa[1].apa41
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

          WHEN INFIELD(apa06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06
               NEXT FIELD apa06

          WHEN INFIELD(apa11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa11
               NEXT FIELD apa11

          WHEN INFIELD(apa36)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa36
               NEXT FIELD apa36


          WHEN INFIELD(apa54)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa54
               NEXT FIELD apa54

          WHEN INFIELD(apa15) # TAX CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               IF g_aza.aza26 = '2' THEN
                  LET g_qryparam.form ="q_gec8_1"
               ELSE
                  LET g_qryparam.form ="q_gec8"
               END IF
               LET g_qryparam.arg1 = '1'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa15
               NEXT FIELD apa15

          WHEN INFIELD(apa13)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa13
               NEXT FIELD apa13

          WHEN INFIELD(apa19) # HOLD CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apo"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa19
               NEXT FIELD apa19

          WHEN INFIELD(apa05) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa05
               NEXT FIELD apa05


          WHEN INFIELD(pmy01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmy"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmy01
               NEXT FIELD pmy01
      END CASE
      AFTER CONSTRUCT
          CALL cl_set_comp_visible("apalegal",FALSE)
          IF tm.org = 'N' THEN  
             CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",FALSE)
          ELSE
             CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1",TRUE)
          END IF
         
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
#FUN-C80102--add--end--
 
#中文的MENU
FUNCTION q100_menu()
 
   WHILE TRUE
#FUN-C80102--add--str-- 
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q100_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q100_bp2()
         END IF
      END IF 
#FUN-C80102--add--end--
#     CALL q100_bp("G")  #FUN-C80102 mark
      CASE g_action_choice
#FUN-C80102--add--str--
         WHEN "page1"
               CALL q100_bp("G")
         
         WHEN "page2"
               CALL q100_bp2()
  
         WHEN "data_filter"
               IF cl_chk_act_auth() THEN
                  CALL q100_filter_askkey()
                  CALL q100_show()
               ELSE                               #FUN-C80102
                  LET g_action_choice = " "       #FUN-C80102 
               END IF            

         WHEN "revert_filter"
              IF cl_chk_act_auth() THEN
                 LET g_filter_wc = ''
                 CALL cl_set_act_visible("revert_filter",FALSE) 
                 CALL q100_show() 
               ELSE                               #FUN-C80102
                  LET g_action_choice = " "       #FUN-C80102 
              END IF
#FUN-C80102--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            ELSE                               #FUN-C80102
               LET g_action_choice = " "       #FUN-C80102 
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
         WHEN "qry_apa" 
            IF cl_chk_act_auth() THEN    
               LET l_ac = ARR_CURR()    
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN       
                  CALL q100_apa_q() 
                  CALL cl_cmdrun(g_msg)     
               END IF                      
            END IF                        
            LET g_action_choice = " "  #FUN-C80102 
#No.FUN-A30028 --end
         #FUN-4B0009
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  #FUN-C80102 add
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_apa),'','')
                END IF
             END IF  #FUN-C80102
#FUN-C80120--add--str--
             IF g_action_flag = "page2" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_apa_1),'','')
                END IF
             END IF
#FUN-C80120--add--end--
            LET g_action_choice = " "  #FUN-C80102 
         #--
#            MESSAGE "test by Raymon"
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL cl_set_comp_visible("apa13,apa31f,apa32f,apa60f,apa61f,apa65f,apa34f,apa35f,amt1,apalegal",TRUE)
    CALL q100_cs()
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF  #FUN-C80102 mark
#   CALL q100_b_fill() #單身   #FUN-C80102 mark
END FUNCTION

#FUN-C80102--mark--str-- 
#FUNCTION q100_b_fill()              #BODY FILL UP
#  #DEFINE amt   LIKE type_file.num20_6     # No:FUN-690028 DEC(20,6)  #FUN-4B0079 #CHI-A50026 mark
#   DEFINE l_apk03 LIKE apk_file.apk03   #MOD-920361
 
#   FOR g_cnt = 1 TO g_apa.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_apa[g_cnt].* TO NULL
#   END FOR
#   LET g_cnt = 1
#  #FOREACH q100_cs INTO g_apa[g_cnt].*,amt  #CHI-A50026 mark
#   FOREACH q100_cs INTO g_apa[g_cnt].*      #CHI-A50026
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
#         EXIT PROGRAM
#      END IF
#      #-----MOD-920361---------
#      IF g_apa[g_cnt].apa08 = 'MISC' THEN
#         LET g_apa[g_cnt].apa08 = ''
#         DECLARE apk_cs CURSOR FOR
#           SELECT apk03 FROM apk_file WHERE apk01=g_apa[g_cnt].apa01
#         FOREACH apk_cs INTO l_apk03
#           IF cl_null(g_apa[g_cnt].apa08) THEN 
#              LET g_apa[g_cnt].apa08 = l_apk03
#           ELSE
#              LET g_apa[g_cnt].apa08 = g_apa[g_cnt].apa08,",",l_apk03
#           END IF
#         END FOREACH
#         IF cl_null(g_apa[g_cnt].apa08) THEN 
#            LET g_apa[g_cnt].apa08 = 'MISC'
#         END IF
#      END IF
#      #-----END MOD-920361-----
#      IF g_apa[g_cnt].apa20 IS NULL THEN
#         LET g_apa[g_cnt].apa20=0
#      END IF
#     #CHI-A50026 mark --start--
#     # IF amt IS NULL THEN
#     #    LET amt  =0
#     # END IF
#     #CHI-A50026 mark --end--
#     #--bug no:A067
#     #LET g_apa[g_cnt].apa35_u = amt - g_apa[g_cnt].apa35 - g_apa[g_cnt].apa20
#     #LET g_apa[g_cnt].apa35_u = amt - g_apa[g_cnt].apa20   #MOD-890175 mark
#     #LET g_apa[g_cnt].apa35_u = amt                        #MOD-890175  #CHI-A50026 mark
#      IF g_apa[g_cnt].apa35_u < 0 THEN LET g_apa[g_cnt].apa35_u = 0 END IF
#       #MOD-4B0225
#     #IF pay_sw = 1 AND amt<=0 THEN                   #CHI-A50026 mark
#      IF pay_sw = 1 AND g_apa[g_cnt].apa35_u<=0 THEN  #CHI-A50026
#         CONTINUE FOREACH
#      END IF
#      #--
#
#      IF g_cnt > g_max_rec THEN
#         CALL cl_err( '', 9035, 0 )
#         EXIT FOREACH
#      END IF
#      LET g_cnt = g_cnt + 1
#   END FOREACH
#   CALL g_apa.deleteElement(g_cnt)  #No.TQC-6B0104
#   LET g_rec_b = g_cnt - 1
#   DISPLAY g_rec_b TO cnt
#   CALL SET_COUNT(g_rec_b)
#END FUNCTION
#FUN-C80102--mark--end---
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
#  CALL SET_COUNT(g_rec_b)  #FUN-C80102 mark
   LET g_action_flag = 'page1'  #FUN-C80102 
  
 
   #FUN-C80102--add--str---  
   IF g_action_choice = "page1"  AND NOT cl_null(tm.u) AND g_flag != '1' THEN
      CALL q100_b_fill_1()
   END IF
   #FUN-C80102--add--end---
   LET g_action_choice = " "
   LET g_flag = ' '   #FUN-C80102
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_apa TO s_apa.*  #FUN-C80102 mark
   DISPLAY BY NAME tm.a,tm.u,tm.org,tm.c
#FUN-C80102--add--str--
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.org,tm.c FROM u,org,c ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("c",TRUE)
            ELSE
               CALL cl_set_comp_entry("c",FALSE)
            END IF
            
            IF NOT cl_null(tm.u)  THEN 
               CALL q100_b_fill_2()
               CALL q100_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q100_b_fill_1()
               CALL g_apa_1.clear()
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.apa31_tot
               DISPLAY 0  TO FORMONLY.apa32_tot
               DISPLAY 0  TO FORMONLY.apa60_tot
               DISPLAY 0  TO FORMONLY.apa61_tot
               DISPLAY 0  TO FORMONLY.apa65_tot
               DISPLAY 0  TO FORMONLY.apa34_tot
               DISPLAY 0  TO FORMONLY.apa35_tot
               DISPLAY 0  TO FORMONLY.amt2_tot
               DISPLAY 0  TO FORMONLY.apa33_tot
            END IF
            DISPLAY BY NAME tm.u
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
                CALL cl_set_comp_entry("c",TRUE)
             ELSE
                LET tm.c = 'N'
                DISPLAY BY NAME tm.c
                CALL cl_set_comp_entry("c",FALSE)
             END IF
            #CALL q100()                      #No.FUN-CB0146 Mark
             CALL q100_get_temp(tm.wc,g_wc)   #No.FUN-CB0146 Add
             CALL q100_t()
             EXIT DIALOG

          ON CHANGE c
             CALL q100_b_fill_2()
             CALL q100_set_visible()
             CALL cl_set_comp_visible("page1", FALSE)
             CALL ui.interface.refresh()
             CALL cl_set_comp_visible("page1", TRUE)
             LET g_action_choice = "page2"

      END INPUT 
 
      DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b)   
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont() 
      END DISPLAY 
#FUN-C80102--add--end--    
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#FUN-C80102--add--str--
      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q100_b_fill_1()
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

      ON ACTION qry_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 AND NOT cl_null(g_apa[l_ac].apa44) THEN
            LET g_cmd = "aglt110 "," '",g_apa[l_ac].apa44,"' "," ","  " 
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF

#FUN-C80102--add--end--
      ON ACTION query
         LET g_action_choice="query"
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ON ACTION help
         LET g_action_choice="help"
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ON ACTION exit
         LET g_action_choice="exit"
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        #CONTINUE DISPLAY #FUN-C80102 mark
         CONTINUE DIALOG #FUN-C80102 add
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
      #--
 
      # No.FUN-530067 --start--
     #AFTER DISPLAY       #FUN-C80102 mark
     #   CONTINUE DISPLAY #FUN-C80102 mark
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
#No.FUN-A30028 --begin
      ON ACTION qry_apa
         LET g_action_choice = 'qry_apa'
        #EXIT DISPLAY  #FUN-C80102 mark
         EXIT DIALOG   #FUN-C80102 add
#No.FUN-A30028 --end 
  #END DISPLAY #FUN-C80102 mark
   END DIALOG  #FUN-C80102 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C80102--add--str--
FUNCTION q100_bp2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.a,tm.u,tm.org,tm.c TO a,u,org,c
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
               CALL q100_b_fill_2()
               CALL q100_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q100_b_fill_1()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_apa_1.clear()  
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.apa31_tot
               DISPLAY 0  TO FORMONLY.apa32_tot
               DISPLAY 0  TO FORMONLY.apa60_tot
               DISPLAY 0  TO FORMONLY.apa61_tot
               DISPLAY 0  TO FORMONLY.apa65_tot
               DISPLAY 0  TO FORMONLY.apa34_tot
               DISPLAY 0  TO FORMONLY.apa35_tot
               DISPLAY 0  TO FORMONLY.amt2_tot
               DISPLAY 0  TO FORMONLY.apa33_tot
            END IF
            DISPLAY tm.u TO u 
            EXIT DIALOG

          ON CHANGE org
             IF NOT cl_null(tm.u) AND tm.org = 'Y' THEN
               CALL cl_set_comp_entry("c",TRUE)
             ELSE
               CALL cl_set_comp_entry("c",FALSE)
             END IF
            #CALL q100()                      #No.FUN-CB0146 Mark
             CALL q100_get_temp(tm.wc,g_wc)   #No.FUN-CB0146 Add
             CALL q100_t()
             EXIT DIALOG

          ON CHANGE c
             CALL q100_b_fill_2()
             CALL q100_set_visible()
             LET g_action_choice = "page2"

      END INPUT

      DISPLAY ARRAY g_apa_1 TO s_apa_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
         END DISPLAY 

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q100_b_fill_1()
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

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         IF l_ac1 > 0  THEN
            CALL q100_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1" 
            LET g_flag = '1'            
            EXIT DIALOG 
         END IF

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

FUNCTION q100_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_tot11   LIKE apa_file.apa31
DEFINE l_tot21   LIKE apa_file.apa31
DEFINE l_tot31   LIKE apa_file.apa31
DEFINE l_tot41   LIKE apa_file.apa31
DEFINE l_tot51   LIKE apa_file.apa31
DEFINE l_tot61   LIKE apa_file.apa31
DEFINE l_tot71   LIKE apa_file.apa31
DEFINE l_tot81   LIKE apa_file.apa31
DEFINE l_tot91   LIKE apa_file.apa31
DEFINE l_yymm    STRING
DEFINE l_yy      STRING
DEFINE l_mm1     STRING
DEFINE l_mm2     STRING

   LET l_tot11 = 0
   LET l_tot21 = 0
   LET l_tot31 = 0
   LET l_tot41 = 0
   LET l_tot51 = 0
   LET l_tot61 = 0
   LET l_tot71 = 0 
   LET l_tot81 = 0
   LET l_tot91 = 0 
   
   CASE tm.u
     WHEN "1"
        LET g_sql = "SELECT * FROM aapq100_tmp ",
                    " WHERE apa05 = '",g_apa_1[p_ac].apa05,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'",
                    "   AND apalegal ='",g_apa_1[p_ac].apalegal,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apa05,apa13,apa06,apa07,apalegal  "
        PREPARE aapq100_pb_detail1 FROM g_sql
        DECLARE apa_curs_detail1  CURSOR FOR aapq100_pb_detail1        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH apa_curs_detail1 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH   

      WHEN "2"
        LET g_sql = "SELECT * FROM aapq100_tmp ", 
                    " WHERE apa00 = '",g_apa_1[p_ac].apa00,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'",
                    "   AND apalegal ='",g_apa_1[p_ac].apalegal,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apa00,apa13,apa06,apa07,apalegal  "   
        PREPARE aapq100_pb_detail2 FROM g_sql
        DECLARE apa_curs_detail2  CURSOR FOR aapq100_pb_detail2        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH apa_curs_detail2 INTO g_apa[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH   
  
      WHEN "3"
        LET l_yymm = g_apa_1[p_ac].yymm
        LET l_yy = l_yymm.subString(1,4)
        LET l_mm1 = l_yymm.subString(6,6)
        LET l_mm2 = l_yymm.subString(6,7)
        LET g_sql = "SELECT * FROM aapq100_tmp ", 
                    " WHERE apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"' ",
                    "   AND YEAR(apa12) = '",l_yy,"' AND (MONTH(apa12) = '",l_mm1,"' OR MONTH(apa12) = '",l_mm2,"') ",
                    "   AND apalegal = '",g_apa_1[p_ac].apalegal,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY YEAR(apa12),MONTH(apa12),apa13,apa06,apa07,apalegal  " 
        PREPARE aapq100_pb_detail3 FROM g_sql
        DECLARE apa_curs_detail3  CURSOR FOR aapq100_pb_detail3        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH apa_curs_detail3 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH

     WHEN "4"
        LET g_sql = "SELECT * FROM aapq100_tmp ",
                    " WHERE apa54 = '",g_apa_1[p_ac].apa54,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'",
                    "   AND apalegal ='",g_apa_1[p_ac].apalegal,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apa54,apa13,apa06,apa07,apalegal  "
        PREPARE aapq100_pb_detail4 FROM g_sql
        DECLARE apa_curs_detail4  CURSOR FOR aapq100_pb_detail4        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH apa_curs_detail4 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH   

     WHEN "5"
        LET g_sql = "SELECT * FROM aapq100_tmp ",
                    " WHERE apa36 = '",g_apa_1[p_ac].apa36,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'",
                    "   AND apalegal ='",g_apa_1[p_ac].apalegal,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apa36,apa13,apa06,apa07,apalegal  "
        PREPARE aapq100_pb_detail5 FROM g_sql
        DECLARE apa_curs_detail5  CURSOR FOR aapq100_pb_detail5        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH apa_curs_detail5 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH   

     WHEN "6"
        LET g_sql = "SELECT * FROM aapq100_tmp ",
                    " WHERE apalegal = '",g_apa_1[p_ac].apalegal_1,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'"
        IF tm.org = 'Y' THEN 
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apalegal,apa13,apa06,apa07  "
        PREPARE aapq100_pb_detail6 FROM g_sql
        DECLARE apa_curs_detail6  CURSOR FOR aapq100_pb_detail6        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH apa_curs_detail6 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH   

     #FUN-D10072 --add-
     WHEN "7"
        LET g_sql = "SELECT * FROM aapq100_tmp ",
                    " WHERE apa22 = '",g_apa_1[p_ac].apa22,"' AND apa06 = '",g_apa_1[p_ac].apa06,"' ",
                    "   AND apa07 = '",g_apa_1[p_ac].apa07,"'"
        IF tm.org = 'Y' THEN
           LET g_sql = g_sql CLIPPED," AND apa13 = '",g_apa_1[p_ac].apa13,"'"
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY apa22,apa13,apa06,apa07  "
        PREPARE aapq100_pb_detail7 FROM g_sql
        DECLARE apa_curs_detail7  CURSOR FOR aapq100_pb_detail7        #CURSOR
        CALL g_apa.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH apa_curs_detail7 INTO g_apa[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_tot11 = l_tot11 + g_apa[g_cnt].apa31
           LET l_tot21 = l_tot21 + g_apa[g_cnt].apa32
           LET l_tot31 = l_tot31 + g_apa[g_cnt].apa60
           LET l_tot41 = l_tot41 + g_apa[g_cnt].apa61
           LET l_tot51 = l_tot51 + g_apa[g_cnt].apa65
           LET l_tot61 = l_tot61 + g_apa[g_cnt].apa34
           LET l_tot71 = l_tot71 + g_apa[g_cnt].apa35
           LET l_tot81 = l_tot81 + g_apa[g_cnt].amt2
           LET l_tot91 = l_tot91 + g_apa[g_cnt].apa33
           LET g_cnt = g_cnt + 1
       END FOREACH
     #FUN-D10072 --add- 
   END CASE
   DISPLAY l_tot11 TO FORMONLY.apa31_tot1
   DISPLAY l_tot21 TO FORMONLY.apa32_tot1
   DISPLAY l_tot31 TO FORMONLY.apa60_tot1
   DISPLAY l_tot41 TO FORMONLY.apa61_tot1
   DISPLAY l_tot51 TO FORMONLY.apa65_tot1
   DISPLAY l_tot61 TO FORMONLY.apa34_tot1
   DISPLAY l_tot71 TO FORMONLY.apa35_tot1
   DISPLAY l_tot81 TO FORMONLY.amt2_tot1
   DISPLAY l_tot91 TO FORMONLY.apa33_tot1
   CALL g_apa.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
#FUN-C80102--add--end--
#No.FUN-A30028 --begin
FUNCTION q100_apa_q()
DEFINE l_apa00    LIKE apa_file.apa00

    LET g_msg =''
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 = g_apa[l_ac].apa01
    IF NOT sqlCA.sqlcode THEN
       IF l_apa00 ='23' THEN
          LET g_msg ='aapq230'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='25' THEN
          LET g_msg ='aapq231'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='24' THEN
          LET g_msg ='aapq240'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='11' THEN
          LET g_msg ='aapt110'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='12' THEN
          LET g_msg ='aapt120'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='13' THEN
          LET g_msg ='aapt121'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='15' THEN
          LET g_msg ='aapt150'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='17' THEN
          LET g_msg ='aapt151'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='16' THEN
          LET g_msg ='aapt160'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='21' THEN
          LET g_msg ='aapt210'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='22' THEN
          LET g_msg ='aapt220'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='26' THEN
          LET g_msg ='aapt260'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
    END IF

END FUNCTION
#No.FUN-A30028 --end

#Patch....NO.TQC-610035 <001> #

#No.FUN-CB0146 ---start--- Add
FUNCTION q100_get_temp(p_wc1,p_wc2)
DEFINE l_sql   STRING
DEFINE p_wc1   LIKE type_file.chr1000 
DEFINE p_wc2   LIKE type_file.chr1000 
DEFINE l_apk03 LIKE apk_file.apk03

   DISPLAY "START TIME: ",TIME

   IF cl_null(p_wc1) THEN LET p_wc1 = " 1=1" END IF
   IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
   CALL q100_table()
   LET l_sql = "INSERT INTO aapq100_tmp "
   #LET l_sql = l_sql,"SELECT DISTINCT apa00 ,apa01 ,apa02        ,apa05,pmc03,apa13,apa14,apa31f,apa32f     ,apa65f,",
   LET l_sql = l_sql,"SELECT DISTINCT apa00,apa01,apa02,apa05,CASE WHEN apa00 IN (13,17,25) THEN apa07 ELSE pmc03 END,",   #MOD-D40029
                     "       apa13,apa14,apa31f,apa32f     ,apa65f,",                                                      #MOD-D40029
                     "       apa34f,apa35f,apa34f-apa35f,apa31,apa32,apa65,apa34,apa35 ,apa34-apa35,apa21 ,",
                     "       gen02 ,apa22 ,gem02        ,",
                     "       CASE WHEN apa08 = 'MISC' THEN (SELECT listagg(apk03,',')  WITHIN GROUP(ORDER BY apk03) AS apk03 FROM apk_file WHERE apk01 = apa01) ELSE apa08 END apa08,",
                     "       apa44,apa12,apa11,pma02 ,apa06      ,apa07 ,",
                     "       pmc02 ,pmy02 ,apa36        ,apr02,apa54,'',apa99,apa15 ,apa16      ,apa61f,",
                     "       apa60f,apa60 ,apa61        ,apa56,",
                     "       CASE WHEN apa33 IS NULL THEN 0 ELSE apa33 END,",
                     "       apa19 ,",
                     "       CASE WHEN apa20 IS NULL THEN 0 ELSE apa20 END,",
                     "       apa41 ,apalegal ",           
                     "  FROM apa_file LEFT JOIN apk_file ON apa01 = apk01 ",
                     "                LEFT JOIN pmc_file ON pmc01 = apa06 ",
                     "                LEFT JOIN pmy_file ON pmy01 = pmc02 ",
                     "                LEFT JOIN gem_file ON gem01 = apa22 ",
                     "                LEFT JOIN gen_file ON gen01 = apa21 ",
                     "                LEFT JOIN apr_file ON apr01 = apa36 ",
                     "                LEFT JOIN pma_file ON pma01 = apa11 ",
                     " WHERE apa41='Y' AND apa42 = 'N' AND ((",p_wc1 CLIPPED,") OR (",p_wc2 CLIPPED,"))"
   CASE tm.a
      WHEN "1" LET l_sql = l_sql CLIPPED," AND apa00 IN (11,12,15,21,22,23,24) "
      WHEN "2" LET l_sql = l_sql CLIPPED," AND apa00 IN (13,17,25) "
      WHEN "3" LET l_sql = l_sql CLIPPED," AND apa00 IN (16,26) "
   END CASE
   LET l_sql = l_sql CLIPPED," ORDER BY apa00,apa01,apa02 "
   PREPARE q100_ins_temp FROM l_sql
   EXECUTE q100_ins_temp

   #FUN-D40121--add--str--
   IF g_apz.apz27 = 'Y' THEN
      LET l_sql = " MERGE INTO aapq100_tmp o",
                  "      USING (SELECT SUM(oox10) a,oox03 FROM oox_file",
                  "             WHERE oox00 = 'AP' GROUP BY oox03 ) x",
                  "         ON (o.apa01 = x.oox03) ",
                  "  WHEN MATCHED ",
                  " THEN ",
                  "  UPDATE ",
                  "     SET o.amt2 =o.amt2 + (CASE WHEN o.apa00 LIKE '1%' THEN nvl(x.a,0)*(-1) ELSE nvl(x.a,0) END ) "
      PREPARE q100_upd_temp_1 FROM l_sql
      EXECUTE q100_upd_temp_1
   END IF
   #FUN-D40121--add--end--

   LET l_sql = "UPDATE aapq100_tmp SET apa31f = apa31f * (-1),",
               "                       apa31  = apa31  * (-1),",
               "                       apa32f = apa32f * (-1),",
               "                       apa32  = apa32  * (-1),",
               "                       apa34f = apa34f * (-1),",
               "                       apa34  = apa34  * (-1),",
               "                       apa65f = apa65f * (-1),",
               "                       apa65  = apa65  * (-1),",
               "                       apa35f = apa35f * (-1),",
               "                       apa35  = apa35  * (-1),",
               "                       amt1   = amt1   * (-1),",
               "                       amt2   = amt2   * (-1) ",
               " WHERE apa00 LIKE '2%'"
   PREPARE q100_upd_temp FROM l_sql
   EXECUTE q100_upd_temp

   LET l_sql = "UPDATE aapq100_tmp t SET t.aag02 = (SELECT s.aag02 FROM aag_file s WHERE s.aag01 = t.apa54 AND rownum = 1)"
   PREPARE q100_upd_temp1 FROM l_sql
   EXECUTE q100_upd_temp1

   DISPLAY "END   TIME: ",TIME

END FUNCTION
#No.FUN-CB0146 ---end  --- Add

#FUN-D40121--add--str--
FUNCTION p100_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00

    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF

    RETURN l_net
END FUNCTION
#FUN-D40121--add--end--


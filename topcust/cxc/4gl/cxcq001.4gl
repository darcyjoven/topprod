# Prog. Version..: '5.25.04-11.09.15(00007)'     #
#
# Pattern name...: aapq001.4gl
# Descriptions...: 暫估月度統計查詢作業
# Date & Author..: 12/11/29 By wangrr   #FUN-CB0120
# ...............: NO.FUN-D60022 13/06/06 By yuhuabao 由aglq001->aapq001(删除aglq001)
# Modify.........: No.FUN-D10110 13/07/01 By wangrr 9主機追單,在個本幣金額旁邊增加原幣金額欄位,本幣金額採用月底重評估匯率計算本幣金額

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_ape02    LIKE ape_file.ape02,
       g_ape03    LIKE ape_file.ape03
DEFINE g_ape      DYNAMIC ARRAY OF RECORD
                 cch04_2 LIKE cch_file.cch04,
                 BJYL LIKE type_file.num26_10,
                 LJYL LIKE type_file.num26_10,
                 #add 201215------s
                 BJYL_LJYL LIKE type_file.num26_10,
                 cch11_2 LIKE type_file.num20_6,
                 cch21_2 LIKE type_file.num20_6,
                 cch31_2 LIKE type_file.num20_6,
                 cch41_2 LIKE type_file.num20_6,
                 cch91_2 LIKE type_file.num20_6,
                 #add 201215------e
                 cch01_1 LIKE cch_file.cch01,
                 sfb02_1 LIKE sfb_file.sfb02,
                 sfb99_1 LIKE sfb_file.sfb99,
                 sfb05_1 LIKE sfb_file.sfb05,
                 ima02_1 LIKE ima_file.ima02,
                 ima021_1 LIKE ima_file.ima021,
                 ima57_1 LIKE ima_file.ima57,
                 cch04_1 LIKE cch_file.cch04,
                 ima02a_1 LIKE ima_file.ima02,
                 ima021a_1 LIKE ima_file.ima021,
                 ima57a_1 LIKE ima_file.ima57,
                 sfb98_1 LIKE sfb_file.sfb98,
                 cch11_1 LIKE cch_file.cch11,
                 cch21_1 LIKE cch_file.cch21,
                 cch31_1 LIKE cch_file.cch31,
                 cch41_1 LIKE cch_file.cch41,
                 cch91_1 LIKE cch_file.cch91,
                 aag01_1 LIKE aag_file.aag01,
                 aag02_1 LIKE aag_file.aag02
       END RECORD
        
 DEFINE g_ape_1      DYNAMIC ARRAY OF RECORD
                 cch04 LIKE cch_file.cch04,
                 imd02_1  LIKE type_file.num26_10,
                 img03  LIKE type_file.num26_10,
                 #add 201215------s
                 img03_imd02 LIKE type_file.num26_10,
                 QCSL1 LIKE type_file.num20_6,
                 RKSL1 LIKE type_file.num20_6,
                 CKSL1 LIKE type_file.num20_6,
                 QMSL1 LIKE type_file.num20_6,
                 #add 201215------e
                 ima01 LIKE ima_file.ima01,
                 ima02 LIKE ima_file.ima02,
                 ima021 LIKE ima_file.ima021,
                 imk02 LIKE imk_file.imk02,
                 imd02 LIKE imd_file.imd02,
                 ima25 LIKE ima_file.ima25,
                 QCSL LIKE cch_file.cch11,
                 RKSL LIKE cch_file.cch11,
                 CKSL LIKE cch_file.cch11,
                 QMSL LIKE cch_file.cch11
       END RECORD
DEFINE g_wc,g_sql       STRING,
       l_ac             LIKE type_file.num5,    
       g_rec_b          LIKE type_file.num10   
DEFINE g_cnt            LIKE type_file.num10  
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10   
DEFINE g_curs_index     LIKE type_file.num10   
DEFINE g_jump           LIKE type_file.num10   
DEFINE mi_no_ask        LIKE type_file.num5   
DEFINE g_tot11   LIKE apa_file.apa31
DEFINE g_tot21   LIKE apa_file.apa31
DEFINE g_tot31   LIKE apa_file.apa31
DEFINE g_tot41   LIKE apa_file.apa31
DEFINE g_tot51   LIKE apa_file.apa31
DEFINE g_tot71   LIKE apa_file.apa31
DEFINE g_tot81   LIKE apa_file.apa31
DEFINE g_tot91   LIKE apa_file.apa31
DEFINE g_tot01   LIKE apa_file.apa31
DEFINE g_action_flag  LIKE type_file.chr100  #FUN-C80102
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
DEFINE   g_argv1       LIKE type_file.num5
DEFINE   g_argv2       LIKE type_file.num5 
#add 201217-----s
#add 201217-----s
   
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 (進入時間) 
   
   LET g_argv1 = ARG_VAL(1)  #年度          
   LET g_argv2 = ARG_VAL(2)  #期別 
            
   IF cl_null(g_argv1) OR cl_null(g_argv2) THEN 
      LET g_argv1=YEAR(g_today)
      LET g_argv2=MONTH(g_today)
   END IF       
     
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW q001_w AT p_row,p_col WITH FORM "cxc/42f/cxcq001" #FUN-D60022
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
    CALL q001_cre_tmp()
   CALL q001_q()

   CALL q001_b_fill()
   CALL q001_b_fill_1()
    CALL q001_menu()
   CLOSE WINDOW q001_w             #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #計算使用時間 (退出使間)
END MAIN

#QBE 查詢資料
FUNCTION q001_cs()
  
   CLEAR FORM #清除畫面
   CALL g_ape.clear()
   CALL cl_opmsg('q')
   LET g_ape02=NULL
   LET g_ape03=NULL
   CALL cl_set_head_visible("","YES")    
   #FUN-D10110--MOD--str--
   #CONSTRUCT g_wc ON ape02,ape03,ape01,ape04,ape05,ape06,ape07,ape08,ape09,
   #                  ape10,ape11,ape12,ape13,ape14,ape15,ape16,ape17,ape18,
   #                  ape19,ape20,ape21,ape22
   #             FROM ape02,ape03,s_ape[1].ape01,s_ape[1].ape04,s_ape[1].ape05,
   #                  s_ape[1].ape06,s_ape[1].ape07,s_ape[1].ape08,s_ape[1].ape09,
   #                  s_ape[1].ape10,s_ape[1].ape11,s_ape[1].ape12,s_ape[1].ape13,
   #                  s_ape[1].ape14,s_ape[1].ape15,s_ape[1].ape16,s_ape[1].ape17,
   #                  s_ape[1].ape18,s_ape[1].ape19,s_ape[1].ape20,s_ape[1].ape21,
   #                  s_ape[1].ape22
   CONSTRUCT g_wc ON ape02,ape03,ape01,ape04,ape30,ape41,ape05,ape06,ape31,ape07,
                     ape32,ape08,ape09,ape10,ape33,ape11,ape34,ape12,ape13,ape14,
                     ape35,ape15,ape36,ape16,ape37,ape17,ape38,ape18,ape19,ape20,
                     ape39,ape21,ape40,ape22,ape42,ape43
                FROM ape02,ape03,s_ape[1].ape01,s_ape[1].ape04,s_ape[1].ape30,
                     s_ape[1].ape41,s_ape[1].ape05,s_ape[1].ape06,s_ape[1].ape31,
                     s_ape[1].ape07,s_ape[1].ape32,s_ape[1].ape08,s_ape[1].ape09,
                     s_ape[1].ape10,s_ape[1].ape33,s_ape[1].ape11,s_ape[1].ape34,
                     s_ape[1].ape12,s_ape[1].ape13,s_ape[1].ape14,s_ape[1].ape35,
                     s_ape[1].ape15,s_ape[1].ape36,s_ape[1].ape16,s_ape[1].ape37,
                     s_ape[1].ape17,s_ape[1].ape38,s_ape[1].ape18,s_ape[1].ape19,
                     s_ape[1].ape20,s_ape[1].ape39,s_ape[1].ape21,s_ape[1].ape40,
                     s_ape[1].ape22,s_ape[1].ape42,s_ape[1].ape43
   #FUN-D10110--MOD--end
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
             
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ape01) #供應商
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape01	
               NEXT FIELD ape01
            WHEN INFIELD(ape04) #料號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape04	
               NEXT FIELD ape04
            #FUN-D10110--add--str--
             WHEN INFIELD(ape30) #幣種
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape30"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape30	
               NEXT FIELD ape30
            #FUN-D10110--add--end
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		 CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   IF cl_null(g_wc) THEN LET g_wc=" 1=1 " END IF
 
   LET g_sql="SELECT DISTINCT ape02,ape03 FROM ape_file",
             " WHERE ",g_wc CLIPPED,
             " ORDER BY ape02,ape03 "
   PREPARE q001_prepare FROM g_sql
   DECLARE q001_cs SCROLL CURSOR FOR q001_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT(ape02||ape03)) FROM ape_file ",
             " WHERE ",g_wc
   PREPARE q001_precount FROM g_sql
   DECLARE q001_count CURSOR FOR q001_precount
END FUNCTION
 
#中文的MENU
FUNCTION q001_menu()
   DEFINE l_cmd     STRING
    
    
   
   WHILE TRUE
    
     #FUN-C80102--add--str-- 
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q001_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q001_bp_1("G")
         END IF
      END IF 
#FUN-C80102--add--end--
#     CALL q100_bp("G")  #FUN-C80102 mark
      CASE g_action_choice
#FUN-C80102--add--str--
         WHEN "page1"
               CALL q001_bp("G")
         
         WHEN "page2"
               CALL q001_bp_1("G")
      #CALL q001_bp("G")
     #LET g_action_choice = "query"
      #CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
#               LET l_cmd='p_query "aapq001" "',g_wc CLIPPED,'"'
#               CALL cl_cmdrun(l_cmd)
#            END IF
         WHEN "exporttoexcel"
            # IF cl_chk_act_auth() THEN
               # CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ape),'','')
             #END IF
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  #FUN-C80102 add
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ape),'','')
                END IF
             END IF  #FUN-C80102
                IF g_action_flag = "page2" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ape_1),'','')
                END IF
             END IF
             LET g_action_choice = " "
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ape02) THEN
                  LET g_doc.column1 = "ape02"
                  LET g_doc.value1 = g_ape02
                  CALL cl_doc()
               END IF
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q001_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
       OPEN q001_count
       FETCH q001_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION q001_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1    #處理方式 
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     q001_cs INTO g_ape02,g_ape03
       WHEN 'P' FETCH PREVIOUS q001_cs INTO g_ape02,g_ape03
       WHEN 'F' FETCH FIRST    q001_cs INTO g_ape02,g_ape03
       WHEN 'L' FETCH LAST     q001_cs INTO g_ape02,g_ape03
       WHEN '/'
          IF NOT mi_no_ask THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
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
          FETCH ABSOLUTE g_jump q001_cs INTO g_ape02,g_ape03
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_ape02=NULL
       LET g_ape03=NULL
       RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO FORMONLY.idx
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

   CALL q001_show()
END FUNCTION
 
FUNCTION q001_show()
   DISPLAY g_ape02,g_ape03 TO ape02,ape03
   CALL q001_b_fill() #單身
    CALL q001_b_fill_1()
     LET g_action_choice = "page1" 
    CALL q001_menu() #單身
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION q001_b_fill()              #BODY FILL UP
 DEFINE l_chr LIKE type_file.chr20

     
      LET l_chr = g_argv1 USING '&&&&',g_argv2 USING '&&'
      
#    LET g_sql = "SELECT cch04,1,1,cch01,sfb02,sfb99,sfb05,CP.ima02,CP.ima021,CP.ima57,cch04,YJ.ima02,YJ.ima021,YJ.ima57,sfb98,cch11,cch21,cch31,cch41,cch91,aag01,aag02 ",
#               " FROM cch_file ",
#               " left join sfb_file on sfb01=cch01 " ,
#               " left join ima_file CP on sfb05=CP.ima01 ",
#               " left join ima_file YJ on cch04=YJ.ima01 ",
#               " left join aag_file  on aag01=sfb03 ",
#               " WHERE  cch02=2020 and cch03=5 and INSTR(cch04, '.')>1 and SUBSTR(cch04, 1, 1) <> 'K' ",
#               " and cch04  in ( SELECT ta_ccc01 ",
#               " FROM ta_ccp_file,",
#               "  (SELECT cch04  FROM ex_ccg_result ",
#               " WHERE yym = 2020 AND mmy = 5 AND INSTR(cch04, '.') > 0   AND SUBSTR(cch04, 1, 1) <> 'K'",
#               "        GROUP BY CCH04) HYB, ",
#               "              (SELECT YJLH FROM ex_ccg_WGD, EX_BOM_CP  ",
#               " WHERE CCH04 = CPLH AND ex_bom_cp.yy = yym AND ex_bom_cp.mm = mmy  AND yym =2020 AND mmy =5 AND to_char(sxrq1, 'yyyyMM') <= 202005 ",
#               " AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > 202005 AND INSTR(YJLH, '.') > 1 ",
#               "  GROUP BY YJLH ) HYC ",
#               " WHERE INSTR(ta_ccc01, '.') > 0  AND ta_ccc01 = HYB.cch04(+)   AND ta_ccc01 = HYC.YJLH(+)",
#               "  AND (ta_ccc211 <> 0 OR ta_ccc217 <> 0  OR ta_ccc18<>0  OR ta_ccc214 <> 0 OR ta_ccc11 <> 0 OR ta_ccc31 <> 0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 or ta_ccc41 <> 0 OR ta_ccc43 <> 0 OR ta_ccc61 <> 0 OR ta_ccc91 <> 0 OR ta_ccc213 <> 0  OR ta_ccc81<>0 OR ta_ccc98<>0)  AND ta_ccc02 = 2020 AND ta_ccc03 = 5)"
# 
#cx1:依据传参查询出对应料号并插临时表 cxcq001_tmp01
   LET g_sql = " INSERT INTO cxcq001_tmp01 ",
               " SELECT ta_ccc01,ta_ccc02,ta_ccc03 ",
               " FROM ta_ccp_file, ",
               "  (SELECT cch04  FROM ex_ccg_result ",
               " WHERE yym = ",g_argv1, " AND mmy = ",g_argv2," AND INSTR(cch04, '.') > 0   AND SUBSTR(cch04, 1, 1) <> 'K'",
               "        GROUP BY CCH04) HYB, ",
               "              (SELECT YJLH FROM ex_ccg_WGD, EX_BOM_CP  ",
               " WHERE CCH04 = CPLH AND ex_bom_cp.yy = yym AND ex_bom_cp.mm = mmy  AND yym =",g_argv1, " AND mmy =",g_argv2, " AND to_char(sxrq1, 'yyyyMM') <= '",l_chr ,"'",
               " AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > '",l_chr,"' AND INSTR(YJLH, '.') > 1 ",
               "  GROUP BY YJLH ) HYC ",
               " WHERE INSTR(ta_ccc01, '.') > 0  AND ta_ccc01 = HYB.cch04(+)   AND ta_ccc01 = HYC.YJLH(+)",
               "  AND (ta_ccc211 <> 0 OR ta_ccc217 <> 0  OR ta_ccc18<>0  OR ta_ccc214 <> 0 OR ta_ccc11 <> 0 OR ta_ccc31 <> 0 ",
               "   OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 or ta_ccc41 <> 0 OR ta_ccc43 <> 0 OR ta_ccc61 <> 0 OR ta_ccc91 <> 0  ",
               "   OR ta_ccc213 <> 0  OR ta_ccc81<>0 OR ta_ccc98<>0)  AND ta_ccc02 = ",g_argv1, " AND ta_ccc03 = ",g_argv2
   PREPARE q001_ins_tmp1 FROM g_sql    
   EXECUTE q001_ins_tmp1
#cx2             
   LET g_sql = " INSERT INTO cxcq001_tmp02 ",
               " SELECT cch04,1,1,",
               #add 201215 ----s
               "1,cch11,cch21,cch31,cch41,cch91, ",
               #add 201215 ----e 
               "cch01,sfb02,
                        sfb99,sfb05,CP.ima02,CP.ima021,CP.ima57,
                        cch04,YJ.ima02,YJ.ima021,YJ.ima57,sfb98,
                        cch11,cch21,cch31,cch41,cch91,",
               #"         aag01,aag02 ",
               "YJ.ima39,aag02",  #add 201216
               " FROM cch_file ",
               " left join sfb_file on sfb01=cch01 " ,
               " left join ima_file CP on sfb05=CP.ima01 ",
               " left join ima_file YJ on cch04=YJ.ima01 ",
               " left join aag_file  on aag01=YJ.ima39 ",  #modify sfb03 to ima39 201216
               " WHERE  cch02=",g_argv1," and cch03=",g_argv2," and INSTR(cch04, '.')>1 and SUBSTR(cch04, 1, 1) <> 'K' ",
               " and cch04  in ( SELECT ta_ccc01 FROM cxcq001_tmp01 )"
#               " and cch04  in ( SELECT ta_ccc01 ",
#               " FROM ta_ccp_file,",
#               "  (SELECT cch04  FROM ex_ccg_result ",
#               " WHERE yym = ",g_argv1, " AND mmy = ",g_argv2," AND INSTR(cch04, '.') > 0   AND SUBSTR(cch04, 1, 1) <> 'K'",
#               "        GROUP BY CCH04) HYB, ",
#               "              (SELECT YJLH FROM ex_ccg_WGD, EX_BOM_CP  ",
#               " WHERE CCH04 = CPLH AND ex_bom_cp.yy = yym AND ex_bom_cp.mm = mmy  AND yym =",g_argv1, " AND mmy =",g_argv2, " AND to_char(sxrq1, 'yyyyMM') <= '",l_chr ,"'",
#               " AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > '",l_chr,"' AND INSTR(YJLH, '.') > 1 ",
#               "  GROUP BY YJLH ) HYC ",
#               " WHERE INSTR(ta_ccc01, '.') > 0  AND ta_ccc01 = HYB.cch04(+)   AND ta_ccc01 = HYC.YJLH(+)",
#               "  AND (ta_ccc211 <> 0 OR ta_ccc217 <> 0  OR ta_ccc18<>0  OR ta_ccc214 <> 0 OR ta_ccc11 <> 0 OR ta_ccc31 <> 0 ",
#               "   OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 or ta_ccc41 <> 0 OR ta_ccc43 <> 0 OR ta_ccc61 <> 0 OR ta_ccc91 <> 0  ",
#               "   OR ta_ccc213 <> 0  OR ta_ccc81<>0 OR ta_ccc98<>0)  AND ta_ccc02 = ",g_argv1, " AND ta_ccc03 = ",g_argv2, " )"               
   PREPARE q001_ins_tmp2_1 FROM g_sql    
   EXECUTE q001_ins_tmp2_1
#cx3:cxci009数据准备
   LET g_sql = " INSERT INTO cxcq001_tmp05 ",
               " SELECT DISTINCT ex_imk01,ex_imk04,ex_imk05,ex_imk06,ex_bl,BJYL,LJYL",
               " FROM ex_imk_file, ",
               " ( SELECT distinct CPLH,YJLH,BJYL,LJYL from 
                 (SELECT distinct CPLH,YJLH,BJYL,LJYL,row_number() OVER(PARTITION BY  CPLH,YJLH ORDER BY BJYL) as row_flg
                    FROM EX_BOM_CP " ,
               " WHERE yy = ",g_argv1," AND mm = ",g_argv2," 
                 AND to_char(sxrq1, 'yyyyMM') <= '",l_chr,"' AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) >'",l_chr,"' ",
               " AND INSTR(YJLH, '.') > 1  AND INSTR(CPLH, '-') > 1 ) where row_flg =1) BOM ",
               " WHERE ex_imk04=CPLH and ex_imk01=YJLH and ex_imk01 <> ex_imk04 and ex_imk05 = ",g_argv1," and ex_imk06 = ",g_argv2," "
   PREPARE q001_ins_tmp5 FROM g_sql    
   EXECUTE q001_ins_tmp5                  
#cx4             
   LET g_sql = " INSERT INTO cxcq001_tmp02 ",
               " SELECT yjlh,bjyl,ljyl,",
               #add 201215 ----s
               "ljyl/bjyl,
                case when yjlh = cplh then cch11 else cch11*ljyl end,
                case when yjlh = cplh then cch21 else cch21*ljyl end,
                case when yjlh = cplh then cch31 else cch31*ljyl end,
                case when yjlh = cplh then cch41 else cch41*ljyl end,
                case when yjlh = cplh then cch91 else cch91*ljyl end, ",
               #add 201215 ----e 
               "cch01,sfb02,
                        sfb99,sfb05,CP.ima02,CP.ima021,CP.ima57,
                        cplh,YJ.ima02,YJ.ima021,YJ.ima57,sfb98,
                        cch11,cch21,cch31,cch41,cch91,",
               #"        aag01,aag02 ",
               "YJ.ima39,aag02",  #add 201216
               " FROM cxcq001_tmp05 ",         
               " left join cch_file on cch04= cplh and cch02 = yy and cch03 = mm",
               " left join sfb_file on sfb01=cch01 " ,
               " left join ima_file CP on sfb05=CP.ima01 ",
               " left join ima_file YJ on cch04=YJ.ima01 ",
               " left join aag_file  on aag01=YJ.ima39 ",  #modify sfb03 to ima39 201216
               " WHERE  yy=",g_argv1," and mm=",g_argv2," and INSTR(cch04, '-')>1 and cch04 is not null "            
   PREPARE q001_ins_tmp2_2 FROM g_sql    
   EXECUTE q001_ins_tmp2_2
#CX5
   LET g_sql = " INSERT INTO cxcq001_tmp02 ",
               " SELECT BOM.YJLH,BOM.BJYL,BOM.LJYL,",
               #add 201215 ----s
               "BOM.LJYL/BOM.BJYL,
                case when BOM.YJLH = BOM.CPLH then cch11 else cch11*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then cch21 else cch21*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then cch31 else cch31*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then cch41 else cch41*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then cch91 else cch91*BOM.LJYL end, ",
               #add 201215 ----e 
               "cch01,sfb02,
                        sfb99,sfb05,CP.ima02,CP.ima021,CP.ima57,
                        BOM.CPLH,YJ.ima02,YJ.ima021,YJ.ima57,sfb98,
                        cch11,cch21,cch31,cch41,cch91,
                        YJ.ima39,aag02 ",  #modify aag01 to ima39
               " FROM cch_file ",
               " left join sfb_file on sfb01=cch01 " ,
               " left join ima_file CP on sfb05=CP.ima01 ",
               " left join ima_file YJ on cch04=YJ.ima01 ",
               " left join aag_file  on aag01=YJ.ima39 ",  #modify sfb03 to ima39 201216
               " left join (select distinct CPLH,YJLH,BJYL,LJYL,YY,MM from EX_BOM_CP ",
               "             where yy=",g_argv1," and mm=",g_argv2," ",
               "               AND to_char(sxrq1, 'yyyyMM') <= '",l_chr,"' ",
               "               AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > '",l_chr,"' ", 
               "               and INSTR(YJLH, '.') > 1) BOM ",
               "        on cch04=BOM.CPLH ",
               " WHERE  cch02 =",g_argv1," and cch03 =",g_argv2," and INSTR(cch04, '-')>1 ", 
               "   and cch04 not in (select cch04 FROM cxcq001_tmp02 ) AND BOM.CPLH is not null "            
   PREPARE q001_ins_tmp2_3 FROM g_sql    
   EXECUTE q001_ins_tmp2_3
    
   LET g_sql = " SELECT * from cxcq001_tmp02 "   
    PREPARE q001_pb FROM g_sql
    
    DECLARE q001_bcs CURSOR FOR q001_pb
    CALL g_ape.clear()
    LET g_cnt = 1 
   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0
    FOREACH q001_bcs INTO g_ape[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q001_bcs:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
         --LET g_tot11 = g_tot11 + g_ape[g_cnt].cch11_2
     --LET g_tot21 = g_tot21 + g_ape[g_cnt].cch21_2
     --LET g_tot31 = g_tot31 + g_ape[g_cnt].cch31_2
     --LET g_tot41 = g_tot41 + g_ape[g_cnt].cch41_2
     --LET g_tot51 = g_tot51 + g_ape[g_cnt].cch91_2
	LET g_cnt = g_cnt + 1
    END FOREACH

    LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0

    SELECT sum(cch11_1),sum(cch21_1),sum(cch31_1),sum(cch41_1),sum(cch91_1) 
      INTO g_tot11,g_tot21,g_tot31,g_tot41,g_tot51
      FROM cxcq001_tmp02
     
      DISPLAY g_tot11 TO FORMONLY.apa31_tot1
   DISPLAY g_tot21 TO FORMONLY.apa32_tot1
   DISPLAY g_tot31 TO FORMONLY.apa60_tot1
   DISPLAY g_tot41 TO FORMONLY.apa61_tot1
   DISPLAY g_tot51 TO FORMONLY.apa65_tot1 
   
    CALL g_ape.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
FUNCTION q001_b_fill_1() 
   DEFINE l_flag            LIKE type_file.chr1,   
          l_bdate,l_edate   LIKE type_file.dat
   DEFINE l_chr LIKE type_file.chr20
   #add 201217-----s
   DEFINE l_yy  LIKE type_file.num5,
          l_mm  LIKE type_file.num5
   #add 201217-----s
     
      LET l_chr = g_argv1 USING '&&&&',g_argv2 USING '&&'    
     IF  NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
        CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,l_bdate,l_edate 
     END IF 
#axcq461数据准备

    #add 201217-----s  #获取上期年度和期别 以便计算本期期初数量
    IF g_argv2 = 1 THEN 
       LET l_yy = g_argv1 - 1
       LET l_mm = 12
    ELSE
       LET l_yy = g_argv1
       LET l_mm = g_argv2 - 1 
    END IF 
    #add 201217-----e
    LET g_sql = " INSERT INTO cxcq001_tmp03 ",
                " select ima01,ima02,ima021,imk02,imd02,ima25,sum(qcsl) qcsl,sum(qcje) qcje,sum(rksl) rksl,sum(rkje) rkje,sum(cksl) cksl,sum(ckje) ckje,sum(qmsl) qmsl,sum(qmje) qmje  
                   from ima_file 
                   left join (select imk01,imk02,sum(NVL(imk09,0)) qcsl,sum(NVL(imk09*ccc23,0)) qcje,0 rksl,0 rkje,0 cksl,0 ckje,0 qmsl,0 qmje 
                                from imk_file,ccc_file 
                               where imk01 = ccc01 and imk05 = ccc02 and imk06 = ccc03 and imk05 = ",l_yy," and imk06 = ",l_mm," and imk02 not in (select jce02 from jce_file) 
                               group by imk01,imk02",  #modify g_argv1 to l_yy 、g_argv2 to l_mm 201217
                              
                "              union all
                               select imk01,imk02,0 qcsl,0 qcje,0 rksl,0 rkje,0 cksl,0 ckje,sum(NVL(imk09,0)) qmsl,sum(NVL(imk09*ccc23,0)) qmje
                               from imk_file,ccc_file
                               where imk01 = ccc01 and imk05 = ccc02 and imk06 = ccc03 and imk05 = ",g_argv1," and imk06 = ",g_argv2," and imk02 not in (select jce02 from jce_file) 
                               group by imk01,imk02 
                               
                               union all
                               select tlf01,tlf902,0 qcsl,0 qcje,sum(NVL(decode(tlf907,1,tlf10*tlf12,0),0)) rksl,sum(NVL(decode(tlf907,1,decode(tlf13,'aimt324',tlf10*tlf12*ccc23,tlf21 )),0)) rkje, 
                                      sum(NVL(decode(tlf907,1,0,tlf10*tlf12),0)) cksl,sum(NVL(decode(tlf907,1,0,decode(tlf13,'aimt324',tlf10*tlf12*ccc23,tlf21 )),0)) ckje, 0 qmsl,0 qmje 
                               from tlf_file left join ccc_file on ccc01 = tlf01 and ccc02 = year(tlf06) and ccc03 = month(tlf06)  ",
                               " where (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"')  and tlf907 <> 0 and tlf902 not in (select jce02 from jce_file)",
                               "   group by tlf01,tlf902 
                               
                               union all                                                                           
                               select ccb01,'axct002',0,0,0,sum(NVL(case when ccb22>0 then ccb22 else 0 end,0)) ,0,sum(NVL(case when ccb22>0 then 0 else ccb22 end,0))*(-1) ,0,0 
                               from ccb_file
                               where (ccb02*12+ccb03) between 24245 and 24245
                               group by ccb01  
                               
                               union all 
                               select imk01,imk02,sum(NVL(imk09,0)) qcsl,0 qcje,0 rksl,0 rkje,0 cksl,0 ckje,0 qmsl,0 qmje
                               from imk_file
                               where imk05 = ",g_argv1," and imk06 = ",g_argv2,"  and imk02 in (select jce02 from jce_file) 
                               group by imk01,imk02  ", #modify g_argv1 to l_yy 、g_argv2 to l_mm 201217
                               
                   "           union all 
                               select imk01,imk02,0 qcsl,0 qcje,0 rksl,0 rkje,0 cksl,0 ckje,sum(NVL(imk09,0)) qmsl,0 qmje 
                               from imk_file 
                               where imk05 = ",g_argv1," and imk06 = ",g_argv2,"  and imk02 in (select jce02 from jce_file) 
                               group by imk01,imk02  
                               
                               union all 
                               select tlf01,tlf902,0 qcsl,0 qcje,sum(NVL(decode(tlf907,1,tlf10*tlf12,0),0)) rksl,0 rkje,sum(NVL(decode(tlf907,1,0,tlf10*tlf12),0)) cksl,0 ckje, 0 qmsl,0 qmje 
                                 from tlf_file left join ccc_file on ccc01 = tlf01 and ccc02 = year(tlf06) and ccc03 = month(tlf06)",
            "                   where (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"') and tlf907 <> 0  and tlf902 in (select jce02 from jce_file) ",
            "                   group by tlf01,tlf902 
                  ) on ima01 = imk01
            left join imd_file on imd01 = imk02
           where (qcsl > 0 or rksl > 0 or cksl > 0 or qmsl > 0 or qcje > 0 or rkje > 0 or ckje > 0 or qmje > 0)
            group by ima01,ima02,ima021,imk02,imd02,ima25 "
    PREPARE q001_ins_tmp3 FROM g_sql    
    EXECUTE q001_ins_tmp3           
#CX6                        
    LET g_sql = " INSERT INTO cxcq001_tmp04 ",
                #" SELECT CX1.ta_ccc01,1,1,FP.ima01,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,FP.qcsl,FP.rksl,FP.cksl,FP.qmsl",  #mark 201217
                " SELECT CX1.ta_ccc01,1,1,",
                "1,sum(FP.qcsl),sum(FP.rksl),sum(FP.cksl),sum(FP.qmsl)," , #add 201217
                "FP.ima01,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,sum(FP.qcsl),sum(FP.rksl),sum(FP.cksl),sum(FP.qmsl)",  #add 201217
                "   FROM  cxcq001_tmp03 FP ",
                "   left join cxcq001_tmp01 CX1 on CX1.ta_ccc01=FP.IMA01 and CX1.ta_ccc02=",g_argv1," and CX1.ta_ccc03=",g_argv2,
                "  WHERE FP.ima01 in ( SELECT ta_ccc01 FROM cxcq001_tmp01 ) AND INSTR(FP.ima01, '.')>1 and SUBSTR(FP.ima01, 1, 1) <> 'K'and FP.imk02 in ('XBC','P002')" 
                ," GROUP BY CX1.ta_ccc01,FP.ima01,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25"  #add 201217
    PREPARE q001_ins_tmp4_1 FROM g_sql    
    EXECUTE q001_ins_tmp4_1 
#CX7                        
    LET g_sql = " INSERT INTO cxcq001_tmp04 ",
                #" SELECT CX3.yjlh,CX3.bjyl,CX3.ljyl,CX3.cplh,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,FP.qcsl,FP.rksl,FP.cksl,FP.qmsl", #mark 201217
                " SELECT CX3.yjlh,CX3.bjyl,CX3.ljyl,",
                "CX3.ljyl/CX3.bjyl,
                case when CX3.yjlh = CX3.cplh then sum(FP.qcsl) else sum(FP.qcsl)*CX3.ljyl end,
                case when CX3.yjlh = CX3.cplh then sum(FP.rksl) else sum(FP.rksl)*CX3.ljyl end,
                case when CX3.yjlh = CX3.cplh then sum(FP.cksl) else sum(FP.cksl)*CX3.ljyl end,
                case when CX3.yjlh = CX3.cplh then sum(FP.qmsl) else sum(FP.qmsl)*CX3.ljyl end," , #add 201217
                "CX3.cplh,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,sum(FP.qcsl),sum(FP.rksl),sum(FP.cksl),sum(FP.qmsl)",  #add 201217
                "   FROM  cxcq001_tmp05 CX3",
                "   left join cxcq001_tmp03 FP on FP.ima01 = CX3.cplh ",
                "  WHERE FP.ima01 is not null and INSTR(FP.ima01, '-')>1" 
                ," GROUP BY CX3.yjlh,CX3.bjyl,CX3.ljyl,CX3.ljyl/CX3.bjyl,CX3.cplh,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25"  #add 201217
    PREPARE q001_ins_tmp4_2 FROM g_sql    
    EXECUTE q001_ins_tmp4_2    
#CX8                        
    LET g_sql = " INSERT INTO cxcq001_tmp04 ",
                " SELECT BOM.YJLH,BOM.BJYL,BOM.LJYL,",
                "BOM.LJYL/BOM.BJYL,
                case when BOM.YJLH = BOM.CPLH then sum(FP.qcsl) else sum(FP.qcsl)*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then sum(FP.rksl) else sum(FP.rksl)*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then sum(FP.cksl) else sum(FP.cksl)*BOM.LJYL end,
                case when BOM.YJLH = BOM.CPLH then sum(FP.qmsl) else sum(FP.qmsl)*BOM.LJYL end,",  #add 201217
                #"BOM.CPLH,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,FP.qcsl,FP.rksl,FP.cksl,FP.qmsl", #mark 201217
                "BOM.CPLH,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25,sum(FP.qcsl),sum(FP.rksl),sum(FP.cksl),sum(FP.qmsl)",
                "   FROM  cxcq001_tmp03 FP ",
                "   left join (select distinct CPLH,YJLH,BJYL,LJYL,YY,MM from EX_BOM_CP ",
                "               where yy=",g_argv1," and mm=",g_argv2," 
                                  AND to_char(sxrq1, 'yyyyMM') <= '",l_chr,"' 
                                  AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > '",l_chr,"'
                                  and INSTR(YJLH, '.') > 1) BOM ",
                "          ON FP.ima01=BOM.CPLH ",
                "  WHERE BOM.CPLH is not null AND INSTR(FP.ima01, '-')>1 and FP.ima01 not in (SELECT ima01 from cxcq001_tmp04) " 
                ," GROUP BY BOM.YJLH,BOM.BJYL,BOM.LJYL,BOM.LJYL/BOM.BJYL,BOM.CPLH,FP.ima02,FP.ima021,FP.imk02,FP.imd02,FP.ima25"  #add 201217
    PREPARE q001_ins_tmp4_3 FROM g_sql    
    EXECUTE q001_ins_tmp4_3
        
    LET g_sql = " select * from cxcq001_tmp04 "                     
    PREPARE q001_pb1 FROM g_sql
    
    DECLARE q001_bcs1 CURSOR FOR q001_pb1
    CALL g_ape_1.clear()
    LET g_cnt = 1 
   LET g_tot71 = 0
   LET g_tot81 = 0
   LET g_tot91 = 0
   LET g_tot01 = 0
  
    FOREACH q001_bcs1 INTO g_ape_1[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q001_bcs:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       
     LET g_tot71 = g_tot71 + g_ape_1[g_cnt].QCSL1
     LET g_tot81 = g_tot81 + g_ape_1[g_cnt].RKSL1
     LET g_tot91 = g_tot91 + g_ape_1[g_cnt].CKSL1
     LET g_tot01 = g_tot01 + g_ape_1[g_cnt].QMSL1
      
       LET g_cnt = g_cnt + 1
    END FOREACH
     
   DISPLAY g_tot71 TO FORMONLY.apa11_tot
   DISPLAY g_tot81 TO FORMONLY.apa12_tot
   DISPLAY g_tot91 TO FORMONLY.apa21_tot
   DISPLAY g_tot01 TO FORMONLY.apa15_tot
   
    CALL g_ape_1.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt1
END FUNCTION
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   LET g_action_flag = 'page1'  #FUN-C80102 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ape TO s_apa.* ATTRIBUTE(UNBUFFERED)
    
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
       ON ACTION PAGE2
         LET g_action_choice = 'page2'
         EXIT DISPLAY          
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)     
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE DISPLAY    
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY   
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                         	
         CALL cl_set_head_visible("","AUTO")   
 
   END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION    
 FUNCTION q001_bp_1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   LET g_action_flag = 'page2'  #FUN-C80102 
   CALL cl_set_act_visible("accept,cancel", FALSE)
     DISPLAY ARRAY g_ape_1 TO s_apa_1.* ATTRIBUTE(UNBUFFERED)
    
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
       ON ACTION page1
         LET g_action_choice = 'page1'
         EXIT DISPLAY           
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)     
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE DISPLAY    
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY   
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                         	
         CALL cl_set_head_visible("","AUTO")   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q001_cre_tmp()
WHENEVER ERROR CONTINUE
#cxcq902表的字段，确定查询品号、查询年、查询月
 DROP TABLE cxcq001_tmp01
   CREATE TEMP TABLE cxcq001_tmp01
     (ta_ccc01      LIKE cch_file.cch04,            
      ta_ccc02      LIKE type_file.num5,              
      ta_ccc03      LIKE type_file.num5)
#关联每月工单元件在制成本档（cch_file)查询明细及组成用量、单位转换率  #CX2/CX4/CX5   
 DROP TABLE cxcq001_tmp02
   CREATE TEMP TABLE cxcq001_tmp02
     (yjlh          LIKE cch_file.cch04,            
      bjyl          LIKE type_file.num26_10,              
      ljyl          LIKE type_file.num26_10,
      ljyl_1        LIKE type_file.num26_10,  #add 201215
      cch11_1       LIKE type_file.num20_6, #add 201215
      cch21_1       LIKE type_file.num20_6,  #add 201215
      cch31_1       LIKE type_file.num20_6,  #add 201215
      cch41_1       LIKE type_file.num20_6,  #add 201215
      cch91_1       LIKE type_file.num20_6,  #add 201215
      cch01         LIKE cch_file.cch01,
      sfb02         LIKE sfb_file.sfb02,
      sfb99         LIKE sfb_file.sfb99,
      sfb05         LIKE sfb_file.sfb05,
      ima02         LIKE ima_file.ima02,
      ima021        LIKE ima_file.ima021,
      ima57         LIKE ima_file.ima57,
      cch04         LIKE cch_file.cch04,
      ima02a        LIKE ima_file.ima02,
      ima021a       LIKE ima_file.ima021,
      ima57a        LIKE ima_file.ima57,
      sfb98         LIKE sfb_file.sfb98,
      cch11         LIKE cch_file.cch11,
      cch21         LIKE cch_file.cch21,
      cch31         LIKE cch_file.cch31,
      cch41         LIKE cch_file.cch41,
      cch91         LIKE cch_file.cch91,
      aag01         LIKE aag_file.aag01,
      aag02          VARCHAR(40)
      )      
#axcq461数据
 DROP TABLE cxcq001_tmp03
   CREATE TEMP TABLE cxcq001_tmp03
     (ima01         LIKE ima_file.ima01,
      ima02         LIKE ima_file.ima02,
      ima021        LIKE ima_file.ima021,
      imk02         LIKE imk_file.imk02,
      imd02         LIKE imd_file.imd02, 
      ima25         LIKE ima_file.ima25,           
      qcsl          LIKE type_file.num20_6,
      qcje          LIKE type_file.num20_6,
      rksl          LIKE type_file.num20_6,
      rkje          LIKE type_file.num20_6,
      cksl          LIKE type_file.num20_6,
      ckje          LIKE type_file.num20_6,
      qmsl          LIKE type_file.num20_6,
      qmje           DECIMAL(20,6)
      )
#page2
 DROP TABLE cxcq001_tmp04
   CREATE TEMP TABLE cxcq001_tmp04
     (cch04 LIKE cch_file.cch04,
      imd02_1  LIKE type_file.num26_10,
      img03   LIKE type_file.num26_10,
      img03_imd02 LIKE type_file.num26_10,
      qcsl1 LIKE type_file.num20_6,
      rksl1 LIKE type_file.num20_6,
      cksl1 LIKE type_file.num20_6,
      qmsl1  LIKE type_file.num20_6,
      ima01 LIKE ima_file.ima01,
      ima02 LIKE ima_file.ima02,
      ima021 LIKE ima_file.ima021,
      imk02 LIKE imk_file.imk02,
      imd02 LIKE imd_file.imd02,
      ima25 LIKE ima_file.ima25,
      qcsl LIKE cch_file.cch11,
      rksl LIKE cch_file.cch11,
      cksl LIKE cch_file.cch11,
      qmsl  DECIMAL(15,3)
      )
#cxci009数据
 DROP TABLE cxcq001_tmp05
   CREATE TEMP TABLE cxcq001_tmp05
     (yjlh    LIKE ima_file.ima01,
      cplh    LIKE ima_file.ima01,
      yy      LIKE type_file.num5,
      mm      LIKE ima_file.ima01,
      ex_bl   LIKE type_file.num26_10,
      bjyl    LIKE type_file.num26_10,
      ljyl     DECIMAL(20,10)
      )            
END FUNCTION  

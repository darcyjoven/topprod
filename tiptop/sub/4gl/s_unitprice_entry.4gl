# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_unitprice_entry.4gl
# Descriptions...: 根据价格条件管控单价,金额栏位是否可以人工输入
# Date & Author..: NO.FUN-9C0120 2009/12/21 By mike 
# Input Parameter: p_cust     客戶編號
#                  p_term     價格條件
#                  p_plant    机构别
#                  p_pflag    单价取得否  #FUN-B70087 add
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B70087 11/07/21 By zhangll 增加oah07取得单价后单价,金额栏位的控管
# Modify.........: No:MOD-B90023 11/09/06 By johung axmt410、axmt800金額欄位不可修改
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:FUN-C50051 12/05/10 By lixiang axmt700_slk的單價欄位控管

DATABASE ds
GLOBALS "../../config/top.global"

#FUNCTION s_unitprice_entry(p_cust,p_term,p_plant)
FUNCTION s_unitprice_entry(p_cust,p_term,p_plant,p_pflag)  #FUN-B70087 mod
DEFINE p_cust   LIKE occ_file.occ01
DEFINE p_term   LIKE oah_file.oah01
DEFINE p_plant  LIKE azp_file.azp01
DEFINE p_pflag  LIKE type_file.chr1   #FUN-B70087 add  单价取得否
DEFINE l_dbs    LIKE azp_file.azp03
DEFINE l_oah04  LIKE oah_file.oah04
DEFINE l_oah07  LIKE oah_file.oah07   #FUN-B70087 add  取到价格允许修改
DEFINE l_sql    STRING

   WHENEVER ERROR CONTINUE
 
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET l_dbs=g_dbs_tra
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel azp_file',SQLCA.SQLCODE,1)
   END IF
   
   LET l_dbs = s_dbstring(l_dbs CLIPPED)

   IF cl_null(p_term) THEN
      #LET l_sql = "SELECT occ44 FROM ",l_dbs,"occ_file ",
      LET l_sql = "SELECT occ44 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                  " WHERE occ01 = '",p_cust,"' ",
                  "   AND occ1004='1' ",
                  "   AND occacti='Y' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE pre_sel_occ1 FROM l_sql
      EXECUTE pre_sel_occ1 INTO p_term
      IF SQLCA.SQLCODE THEN
         CALL cl_err('sel occ_file','sub-221',1)
      END IF
   END IF
    
   #LET l_sql = "SELECT oah04 FROM ",l_dbs,"oah_file ",
   LET l_sql = "SELECT oah04,oah07 FROM ",cl_get_target_table(g_plant_new,'oah_file'), #FUN-A50102  #FUN-B70087 add oah07
               " WHERE oah01 = '",p_term,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102   
   PREPARE pre_sel_oah FROM l_sql
   EXECUTE pre_sel_oah INTO l_oah04,l_oah07  #FUN-B70087 add oah07
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel oah_file','sub-221',1) 
   END IF
   
   IF l_oah04 IS NULL THEN LET l_oah04='N' END IF   
   IF l_oah07 IS NULL THEN LET l_oah07='N' END IF   #FUN-B70087 add
   
   CASE
      WHEN g_prog='axmt410_1' 
        #FUN-BC0088 ----- add start ------
        IF p_pflag = 'M' THEN
            CALL cl_set_comp_entry("oeb13",TRUE)
        ELSE 
        #FUN-BC0088 ----- add end ------
           #FUN-B70087 mod
           #CALL cl_set_comp_entry("oeb13",l_oah04='Y') 
            IF p_pflag = 'N' THEN
               IF l_oah04 = 'Y' THEN
                  CALL cl_set_comp_entry("oeb13",TRUE)
               ELSE
                  CALL cl_set_comp_entry("oeb13",FALSE)
               END IF
            ELSE
               IF l_oah07 = 'Y' THEN
                  CALL cl_set_comp_entry("oeb13",TRUE)
               ELSE
                  CALL cl_set_comp_entry("oeb13",FALSE)
               END IF
            END IF
           #FUN-B70087 mod--end
        END IF #FUN-BC0088 add
      WHEN (g_prog[1,7]='axmt410' OR g_prog[1,7]='axmt400'
            OR g_prog[1,7]='axmt420' OR g_prog[1,7]='axmt810')
        #FUN-BC0088 ----- add start ------
        IF p_pflag = 'M' THEN
            CALL cl_set_comp_entry("oeb13",TRUE)
        ELSE 
        #FUN-BC0088 ----- add end ------
           #FUN-B70087 mod
           #CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",l_oah04='Y')
            IF p_pflag = 'N' THEN
               IF l_oah04 = 'Y' THEN
                 #CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",TRUE)   #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeb13",TRUE)                #MOD-B90023
               ELSE
                 #CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",FALSE)  #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeb13",FALSE)               #MOD-B90023
               END IF
            ELSE
               IF l_oah07 = 'Y' THEN
                 #CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",TRUE)   #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeb13",TRUE)                #MOD-B90023
               ELSE
                 #CALL cl_set_comp_entry("oeb13,oeb14,oeb14t",FALSE)  #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeb13",FALSE)               #MOD-B90023
               END IF
            END IF
           #FUN-B70087 mod--end
        END IF #FUN-BC0088 add
      WHEN (g_prog='axmt650' OR g_prog[1,7]='axmt620' OR g_prog[1,7]='axmt610' 
            OR g_prog[1,7]='axmt628' OR g_prog[1,7]='axmt629' OR g_prog[1,7]='axmt640'
            OR g_prog='axmt820' OR g_prog='axmt821' OR g_prog='axmt850' )
         #FUN-BC0088 -------- add start ----------
         IF p_pflag = 'M' THEN
            CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",TRUE)
         ELSE
         #FUN-BC0088 -------- add end ----------
            #FUN-B70087 mod
            #CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",l_oah04='Y')
             IF p_pflag = 'N' THEN
                IF l_oah04 = 'Y' THEN
                   CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",TRUE)
                ELSE
                   CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",FALSE)
                END IF
             ELSE
                IF l_oah07 = 'Y' THEN
                   CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",TRUE)
                ELSE
                   CALL cl_set_comp_entry("ogb13,ogb14,ogb14t",FALSE)
                END IF
             END IF
            #FUN-B70087 mod--end
         END IF #FUN-BC0088 add
      WHEN g_prog[1,7]='axmt800'
        #FUN-BC0088 -------- add start ----------
        IF p_pflag = 'M' THEN
            CALL cl_set_comp_entry("oeq13a",TRUE)
        ELSE
        #FUN-BC0088 -------- add end ----------
           #FUN-B70087 mod
           #CALL cl_set_comp_entry("oeq13a,oeq14a",l_oah04='Y')
            IF p_pflag = 'N' THEN
               IF l_oah04 = 'Y' THEN
                 #CALL cl_set_comp_entry("oeq13a,oeq14a,oeq14ta",TRUE)   #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeq13a",TRUE)                  #MOD-B90023
               ELSE
                 #CALL cl_set_comp_entry("oeq13a,oeq14a,oeq14ta",FALSE)  #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeq13a",FALSE)                 #MOD-B90023
               END IF
            ELSE
               IF l_oah07 = 'Y' THEN
                 #CALL cl_set_comp_entry("oeq13a,oeq14a,oeq14ta",TRUE)   #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeq13a",TRUE)                  #MOD-B90023
               ELSE
                 #CALL cl_set_comp_entry("oeq13a,oeq14a,oeq14ta",FALSE)  #MOD-B90023 mark
                  CALL cl_set_comp_entry("oeq13a",FALSE)                 #MOD-B90023
               END IF
            END IF
           #FUN-B70087 mod--end
        END IF #FUN-BC0088 add
      WHEN g_prog='axmt700' OR g_prog='axmt840'
        #FUN-BC0088 -------- add start ----------
        IF p_pflag = 'M' THEN
            CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",TRUE)
        ELSE
        #FUN-BC0088 -------- add end ----------
           #FUN-B70087 mod
           #CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",l_oah04='Y')
            IF p_pflag = 'N' THEN
               IF l_oah04 = 'Y' THEN
                  CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",TRUE)
               ELSE
                  CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",FALSE)
               END IF
            ELSE
               IF l_oah07 = 'Y' THEN
                  CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",TRUE)
               ELSE
                  CALL cl_set_comp_entry("b1_ohb13,b1_ohb14,b1_ohb14t,b2_ohb14,b2_ohb14t",FALSE)
               END IF
            END IF
           #FUN-B70087 mod--end
        END IF #FUN-BC0088 add
    #FUN-C50051---add--begin--
      WHEN g_prog='axmt700_slk'
        IF g_azw.azw04 ='2' THEN
           IF p_pflag = 'M' THEN
               CALL cl_set_comp_entry("ohbslk13",TRUE)
           ELSE
              IF p_pflag = 'N' THEN
                 IF l_oah04 = 'Y' THEN
                    CALL cl_set_comp_entry("ohbslk13",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("ohbslk13",FALSE)
                 END IF
              ELSE
                 IF l_oah07 = 'Y' THEN
                    CALL cl_set_comp_entry("ohbslk13",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("ohbslk13",FALSE)
                 END IF
              END IF
           END IF
        END IF 
    #FUN-C50051---add--end--
      OTHERWISE EXIT CASE
   END CASE

END FUNCTION 
#FUN-9C0120 

# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Pattern name...: s_upd_abbr.4gl
# Descriptions...: 更新廠商/客戶簡稱
# Date & Author..: 10/04/01 By Carrier   #No.FUN-A30110
# Usage..........: CALL s_upd_abbr(p_no,p_abbr,p_dbs,p_flag)
# Input Parameter: p_no    廠商/客戶編號
#                  p_abbr  廠商/客戶簡稱
#                  p_dbs   database
#                  p_flag  1.廠商 2.客戶
#                  p_ask   Y.詢問 N.不詢問
# Return code....: NULL
# Modify.........: No.FUN-A50102 10/07/02 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AB0113 10/11/30 By rainy 補過單
# Modify.........: No.TQC-BB0002 10/11/01 By Carrier MISC/EMPL时不做处理
# Modify.........: No:FUN-BB0049 11/11/15 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No.TQC-C10035 12/01/12 By Carrier delete lock sql 
# Modify.........: No.MOD-CC0121 12/12/27 By jt_chen 修正s_upd_abbr.4gl在INSERT INTO npr_file增加nprlegal欄位

DATABASE ds

GLOBALS "../../config/top.global"    #No.FUN-A30110
DEFINE g_no           LIKE pmc_file.pmc01
DEFINE g_abbr         LIKE pmc_file.pmc03
DEFINE t_dbs          LIKE type_file.chr21
DEFINE t_plant        LIKE type_file.chr21    #FUN-A50102
DEFINE g_sql          STRING
DEFINE g_msg          STRING

#FUNCTION s_upd_abbr(p_no,p_abbr,p_dbs,p_flag,p_ask)
FUNCTION s_upd_abbr(p_no,p_abbr,p_plant,p_flag,p_ask,p_cmd)  #FUN-A50102  #No.FUN-BB0049
   DEFINE p_no        LIKE pmc_file.pmc01
   DEFINE p_abbr      LIKE pmc_file.pmc03 
   DEFINE p_dbs       LIKE type_file.chr21   
   DEFINE p_plant     LIKE type_file.chr21    #FUN-A50102
   DEFINE p_flag      LIKE type_file.chr1
   DEFINE p_ask       LIKE type_file.chr1
   DEFINE p_cmd       LIKE type_file.chr1     #No.FUN-BB0049
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_flag1     LIKE type_file.num5
   DEFINE l_ze01      LIKE ze_file.ze01
   DEFINE l_upd       LIKE type_file.chr1 
   DEFINE l_prg_tot   LIKE type_file.num5   
   DEFINE l_aza125    LIKE aza_file.aza125   #No.FUN-BB0049
   DEFINE l_aza126    LIKE aza_file.aza126   #No.FUN-BB0049
   DEFINE l_str       STRING                 #No.FUN-BB0049

   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(p_no)   THEN RETURN END IF
   IF cl_null(p_abbr) THEN RETURN END IF
   IF cl_null(p_flag) OR p_flag NOT MATCHES '[12]' THEN RETURN END IF
   #IF cl_null(p_dbs)  THEN LET p_dbs = g_dbs END IF      
   IF cl_null(p_plant)  THEN LET p_plant = g_plant END IF #FUN-A50102

   LET g_no   = p_no
   LET g_abbr = p_abbr
   #LET t_dbs  = s_dbstring(p_dbs) 
   LET t_plant  = p_plant          #FUN-A50102
   
   #No.FUN-BB0049  --Begin
   LET g_sql = " SELECT aza125,aza126 FROM ",cl_get_target_table(p_plant,'aza_file'),
               "  WHERE aza01 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE aza_p1 FROM g_sql
   EXECUTE aza_p1 INTO l_aza125,l_aza126
   IF SQLCA.sqlcode <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select aza_file fail',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #No.FUN-BB0049  --End  

   LET l_upd = 'N'
   #CALL s_check_pmc01_occ01(p_no,p_abbr,p_dbs,p_flag,p_ask)  #FUN-A50102
   CALL s_check_pmc01_occ01(p_no,p_abbr,p_plant,p_flag,p_ask) #FUN-A50102 
        RETURNING l_flag,l_flag1
   IF l_flag = FALSE THEN
      LET g_success = 'N'
      RETURN
   ELSE
      IF l_flag1 = TRUE THEN
         LET l_upd = 'Y'
      END IF
   END IF

   #No.FUN-BB0049  --Begin
   IF p_cmd MATCHES '[ac]' AND l_upd = 'N' THEN
      LET l_aza126 = 'N'
   END IF

   IF l_aza126 = 'Y' THEN   #历史资料
      #新增或是复制时,是否要提高,要CHECK相对应的TABLE是否有值
      IF p_cmd = 'u' OR l_upd = 'Y' THEN   #No.FUN-BB0049
         LET l_str = p_plant CLIPPED,':',p_abbr CLIPPED
         IF NOT cl_confirm2('apm-817',l_str) THEN
            LET l_aza126 = 'N'
         END IF
      END IF
   END IF

   LET l_prg_tot = 0
   IF l_aza126 = 'N' THEN       #历史资料不修改
      IF l_aza125 = 'N' THEN    #简称可不一致
         LET l_prg_tot = 0          #不进行修改
      ELSE                          #简称要一致
         IF l_upd = 'Y' THEN        #厂商/客户编号相同
            LET l_prg_tot = 1       #更新厂商档或是客户档
         ELSE
            LET l_prg_tot = 0       #无资料需更新
         END IF
      END IF
   ELSE                                            #历史资料要更新
      IF l_aza125 = 'N' OR l_upd = 'N' THEN    #简称可不一致 或是 厂商/客户编号不一致
         IF p_flag = '1' THEN       #厂商
            LET l_prg_tot = 18                     #更新厂商相关档案
         ELSE
            LET l_prg_tot = 29                     #更新客户相关档案
         END IF
      ELSE                                         #简称要一致 & 厂商/客户编号有相同的现象
         LET l_prg_tot = 48                        #对应简称要修改 & 厂商/客户相关档案也要修改
      END IF
   END IF

   IF l_prg_tot > 0 THEN   #有更新
      CALL cl_progress_bar(l_prg_tot)
      IF l_prg_tot = 1 THEN
         IF p_flag = '1' THEN
            CALL s_upd_occ02()
         ELSE
            CALL s_upd_pmc03()
         END IF
      ELSE
         CASE l_prg_tot
              WHEN 18  CALL s_upd_pmc()     #更新廠商簡稱
              WHEN 29  CALL s_upd_occ()     #更新客户簡稱
              WHEN 48  
                       IF p_flag = '1' THEN
                          CALL s_upd_pmc()     #更新廠商簡稱
                          CALL s_upd_occ02()
                          CALL s_upd_occ()     #更新客户簡稱
                       ELSE
                          CALL s_upd_occ()     #更新客户簡稱
                          CALL s_upd_pmc03()
                          CALL s_upd_pmc()     #更新廠商簡稱
                       END IF
         END CASE
      END IF

   END IF

   #IF p_flag = '1' THEN
   #   IF l_upd = 'Y' THEN
   #      LET l_prg_tot = 48
   #   ELSE
   #      LET l_prg_tot = 18
   #   END IF
   #   CALL cl_progress_bar(l_prg_tot)

   #   CALL s_upd_pmc()     #更新廠商簡稱
   #   IF l_upd = 'Y' THEN
   #      CALL s_upd_occ02()
   #      CALL s_upd_occ()  #更新客戶簡稱
   #   END IF
   #ELSE
   #   IF l_upd = 'Y' THEN
   #      LET l_prg_tot = 48
   #   ELSE
   #      LET l_prg_tot = 29
   #   END IF
   #   CALL cl_progress_bar(l_prg_tot)

   #   CALL s_upd_occ()     #更新客戶簡稱
   #   IF l_upd = 'Y' THEN
   #      CALL s_upd_pmc03()
   #      CALL s_upd_pmc()  #更新廠商簡稱
   #   END IF
   #END IF
   #No.FUN-BB0049  --End  
END FUNCTION

FUNCTION s_upd_pmc()

   #明細檔更新,只要更新對應的簡稱字段內容
   CALL s_upd_apa07()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_apf12()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_cop06()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_imo04()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nmd24()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nng51()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ofd41()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_off04()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ofr02()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_pmca03()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_rvu05()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_aqe11()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_bnb06()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_cor08()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nme13()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nmg19()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_npq22()
   IF g_success = 'N' THEN RETURN END IF

   #統計檔更新,由于簡稱是KEY值,可能更新完后,出現key值重復的現象
   #故要特別處理
   CALL s_upd_npr02()
   #No.TQC-C10035  --Begin
   #UNLOCK TABLE npr_file   #最后時unlock
   #No.TQC-C10035  --End  
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION s_upd_occ()

   #明細檔更新,只要更新對應的簡稱字段內容
   CALL s_upd_amd41()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_coo06()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nmh30()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nnr041()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_occa02()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oea032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oew032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oey032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ofa032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ofd02()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oga032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oha032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ohc061()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oma032()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_oma69()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_ooa032()
   IF g_success = 'N' THEN RETURN END IF

#  CALL s_upd_ooo02()
#  IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_rma04()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_rmn03()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_aqe11()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_bnb06()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_cor08()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nme13()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_nmg19()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_npq22()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_lne05()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_lua061()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_luc031()
   IF g_success = 'N' THEN RETURN END IF

   CALL s_upd_lue05()
   IF g_success = 'N' THEN RETURN END IF

   #統計檔更新,由于簡稱是KEY值,可能更新完后,出現key值重復的現象
   #故要特別處理
   CALL s_upd_npr02()
   #No.TQC-C10035  --Begin
   #UNLOCK TABLE npr_file   #最后時unlock
   #No.TQC-C10035  --End  
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION s_upd_npr02()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_npr       RECORD LIKE npr_file.*

   CALL cl_progressing("update npr02")
   #LET g_sql = " SELECT COUNT(UNIQUE npr02) FROM ",t_dbs CLIPPED,"npr_file ",
   LET g_sql = " SELECT COUNT(UNIQUE npr02) FROM ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102
               "  WHERE npr01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102               
   PREPARE npr_cnt_p1 FROM g_sql
   EXECUTE npr_cnt_p1 INTO l_n
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('npr01' ,g_no,'npr_cnt_p1' ,SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_n >= 1 THEN
      #No.TQC-C10035  --Begin
      ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"npr_file IN EXCLUSIVE MODE"
      #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102
      #            " IN EXCLUSIVE MODE" 
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
      #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102                
      #PREPARE npr_lock_p FROM g_sql                                                
      #EXECUTE npr_lock_p                                                           
      #IF STATUS THEN                                                               
      #   CALL s_errmsg('','','lock table npr_file',STATUS,1)                       
      #   LET g_success = 'N'                                                       
      #   RETURN                                                                    
      #END IF   
      #No.TQC-C10035  --End  
      IF l_n = 1 THEN  #只有一個簡稱,則直接update即可
         #LET g_sql = "UPDATE ",t_dbs CLIPPED,"npr_file", 
         LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102    
                     "   SET npr02 = '",g_abbr,"'",                                   
                     " WHERE npr01 = '",g_no,"'"  
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102 
         PREPARE npr_upd_p FROM g_sql                                                 
         IF SQLCA.sqlcode THEN                                                        
            CALL s_errmsg('npr01',g_no,'prepare npr_upd_p',SQLCA.sqlcode,1)           
            LET g_success = 'N'                                                       
            RETURN                                                                    
         END IF                                                                       
         EXECUTE npr_upd_p                                                            
         IF SQLCA.sqlcode THEN                                                        
            CALL s_errmsg('npr01',g_no,'update npr02',SQLCA.sqlcode,1)                
            LET g_success = 'N'                                                       
         END IF
      ELSE
         #LET g_sql = " SELECT COUNT(UNIQUE npr02) FROM ",t_dbs CLIPPED,"npr_file",
         LET g_sql = " SELECT COUNT(UNIQUE npr02) FROM ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102   
                     "  WHERE npr00 = ? AND npr01 = ? ",
                     "    AND npr03 = ? AND npr04 = ? ",
                     "    AND npr05 = ? AND npr08 = ? ",
                     "    AND npr09 = ? AND npr10 = ? ",
                     "    AND npr11 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
         PREPARE npr_cnt_p2 FROM g_sql

         #LET g_sql = " UPDATE ",t_dbs CLIPPED,"npr_file",
         LET g_sql = " UPDATE ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102   
                     "    SET npr02 = '",g_abbr,"'",
                     "  WHERE npr00 = ? AND npr01 = ? ",
                     "    AND npr03 = ? AND npr04 = ? ",
                     "    AND npr05 = ? AND npr08 = ? ",
                     "    AND npr09 = ? AND npr10 = ? ",
                     "    AND npr11 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
         PREPARE npr_upd_p2 FROM g_sql                                                 
         IF SQLCA.sqlcode THEN                                                        
            CALL s_errmsg('','','prepare npr_upd_p2',SQLCA.sqlcode,1)           
            LET g_success = 'N'                                                       
            RETURN                                                                    
         END IF                                                                       

         #LET g_sql = " DELETE FROM ",t_dbs CLIPPED,"npr_file",
         LET g_sql = " DELETE FROM ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102  
                     "  WHERE npr00 = ? AND npr01 = ? ",
                     "    AND npr03 = ? AND npr04 = ? ",
                     "    AND npr05 = ? AND npr08 = ? ",
                     "    AND npr09 = ? AND npr10 = ? ",
                     "    AND npr11 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
         PREPARE npr_del_p1 FROM g_sql                                                 
         IF SQLCA.sqlcode THEN                                                        
            CALL s_errmsg('','','prepare npr_del_p1',SQLCA.sqlcode,1)           
            LET g_success = 'N'                                                       
            RETURN                                                                    
         END IF                                                                       

         #LET g_sql = " INSERT INTO ",t_dbs CLIPPED,"npr_file ",
         LET g_sql = " INSERT INTO ",cl_get_target_table(t_plant,'npr_file'), #FUN-A50102 
                     "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
                     "         ?,?,?,?,?             )"            #MOD-CC0121 add ,?
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
         PREPARE npr_ins_p1 FROM g_sql                                                 
         IF SQLCA.sqlcode THEN                                                        
            CALL s_errmsg('','','prepare npr_ins_p1',SQLCA.sqlcode,1)           
            LET g_success = 'N'                                                       
            RETURN                                                                    
         END IF                                                                       

         LET g_sql = " SELECT npr00,npr01,'',npr03,npr04,npr05,",
                     "        SUM(npr06f),SUM(npr06),SUM(npr07f),SUM(npr07),",
                     "        npr08,npr09,npr10,npr11,nprlegal",   #MOD-CC0121 add ,nprlegal
                     "   FROM npr_file ",
                     "  WHERE npr01 = '",g_no,"'",
                     "  GROUP BY npr00,npr01,npr03,npr04,npr05,npr08,npr09,npr10,npr11,nprlegal "   #MOD-CC0121 add ,nprlegal
         DECLARE npr_cs CURSOR FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('npr01',g_no,'declare npr_cs',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         FOREACH npr_cs INTO l_npr.*
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('npr01',g_no,'foreach npr_cs',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE npr_cnt_p2 USING l_npr.npr00, l_npr.npr01, l_npr.npr03,
                                     l_npr.npr04, l_npr.npr05, l_npr.npr08,
                                     l_npr.npr09, l_npr.npr10, l_npr.npr11
                                INTO l_n 
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_npr.npr00,'/',l_npr.npr01,'/',l_npr.npr03,'/',
                               l_npr.npr04,'/',l_npr.npr05,'/',l_npr.npr08,'/',
                               l_npr.npr09,'/',l_npr.npr10,'/',l_npr.npr11
               CALL s_errmsg('npr00,npr01,npr03,npr04,npr05,npr08,npr09,npr10,npr11',g_showmsg,'execute npr_cnt_p2',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
            IF l_n = 1 THEN
               EXECUTE npr_upd_p2 USING l_npr.npr00, l_npr.npr01, l_npr.npr03,
                                        l_npr.npr04, l_npr.npr05, l_npr.npr08,
                                        l_npr.npr09, l_npr.npr10, l_npr.npr11
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  LET g_showmsg = l_npr.npr00,'/',l_npr.npr01,'/',l_npr.npr03,'/',
                                  l_npr.npr04,'/',l_npr.npr05,'/',l_npr.npr08,'/',
                                  l_npr.npr09,'/',l_npr.npr10,'/',l_npr.npr11
                  CALL s_errmsg('npr00,npr01,npr03,npr04,npr05,npr08,npr09,npr10,npr11',g_showmsg,'update npr',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               CONTINUE FOREACH
            END IF

            IF cl_null(l_npr.npr06f) THEN LET l_npr.npr06f = 0 END IF
            IF cl_null(l_npr.npr06 ) THEN LET l_npr.npr06  = 0 END IF
            IF cl_null(l_npr.npr07f) THEN LET l_npr.npr07f = 0 END IF
            IF cl_null(l_npr.npr07 ) THEN LET l_npr.npr07  = 0 END IF
            LET l_npr.npr02 = g_abbr

            EXECUTE npr_del_p1 USING l_npr.npr00, l_npr.npr01, l_npr.npr03,
                                     l_npr.npr04, l_npr.npr05, l_npr.npr08,
                                     l_npr.npr09, l_npr.npr10, l_npr.npr11
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_showmsg = l_npr.npr00,'/',l_npr.npr01,'/',l_npr.npr03,'/',
                               l_npr.npr04,'/',l_npr.npr05,'/',l_npr.npr08,'/',
                               l_npr.npr09,'/',l_npr.npr10,'/',l_npr.npr11
               CALL s_errmsg('npr00,npr01,npr03,npr04,npr05,npr08,npr09,npr10,npr11',g_showmsg,'delete npr',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF

            EXECUTE npr_ins_p1 USING l_npr.*
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_showmsg = l_npr.npr00,'/',l_npr.npr01,'/',l_npr.npr02,'/',
                               l_npr.npr03,'/',l_npr.npr04,'/',l_npr.npr05,'/',
                               l_npr.npr08,'/',l_npr.npr09,'/',l_npr.npr10,'/',
                               l_npr.npr11
               CALL s_errmsg('npr00,npr01,npr02,npr03,npr04,npr05,npr08,npr09,npr10,npr11',g_showmsg,'insert npr',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END IF
END FUNCTION

FUNCTION s_upd_amd41()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"amd_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'amd_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
   #PREPARE amd_lock_p FROM g_sql
   #EXECUTE amd_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table amd_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update amd41")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"amd_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'amd_file'), #FUN-A50102
               "   SET amd41 = '",g_abbr,"'",
               " WHERE amd40 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102               
   PREPARE amd_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('amd40',g_no,'prepare amd_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE amd_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('amd40',g_no,'update amd41',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"amd_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'amd_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102   
   #PREPARE amd_unlock_p FROM g_sql
   #EXECUTE amd_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_apa07()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"apa_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'apa_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE apa_lock_p FROM g_sql
   #EXECUTE apa_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table apa_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update apa07")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"apa_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'apa_file'), #FUN-A50102
               "   SET apa07 = '",g_abbr,"'",
               " WHERE apa06 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE apa_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('apa06',g_no,'prepare apa_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE apa_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('apa06',g_no,'update apa07',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"apa_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'apa_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE apa_unlock_p FROM g_sql
   #EXECUTE apa_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_apf12()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"apf_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'apf_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE apf_lock_p FROM g_sql
   #EXECUTE apf_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table apf_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update apf12")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"apf_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'apf_file'), #FUN-A50102
               "   SET apf12 = '",g_abbr,"'",
               " WHERE apf03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE apf_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('apf03',g_no,'prepare apf_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE apf_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('apf03',g_no,'update apf12',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"apf_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'apf_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE apf_unlock_p FROM g_sql
   #EXECUTE apf_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_aqe11()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"aqe_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'aqe_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE aqe_lock_p FROM g_sql
   #EXECUTE aqe_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table aqe_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update aqe11")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"aqe_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'aqe_file'), #FUN-A50102
               "   SET aqe11 = '",g_abbr,"'",
               " WHERE aqe03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE aqe_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('aqe03',g_no,'prepare aqe_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE aqe_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('aqe03',g_no,'update aqe11',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"aqe_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'aqe_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102  
   #PREPARE aqe_unlock_p FROM g_sql
   #EXECUTE aqe_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_bnb06()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"bnb_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'bnb_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102  
   #PREPARE bnb_lock_p FROM g_sql
   #EXECUTE bnb_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table bnb_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update bnb06")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"bnb_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'bnb_file'), #FUN-A50102
               "   SET bnb06 = '",g_abbr,"'",
               " WHERE bnb05 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE bnb_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('bnb05',g_no,'prepare bnb_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE bnb_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('bnb05',g_no,'update bnb06',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"bnb_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'bnb_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE bnb_unlock_p FROM g_sql
   #EXECUTE bnb_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_coo06()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"coo_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'coo_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE coo_lock_p FROM g_sql
   #EXECUTE coo_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table coo_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update coo06")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"coo_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'coo_file'), #FUN-A50102
               "   SET coo06 = '",g_abbr,"'",
               " WHERE coo05 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE coo_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('coo05',g_no,'prepare coo_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE coo_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('coo05',g_no,'update coo06',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"coo_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'coo_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE coo_unlock_p FROM g_sql
   #EXECUTE coo_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_cop06()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"cop_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'cop_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE cop_lock_p FROM g_sql
   #EXECUTE cop_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table cop_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update cop06")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"cop_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'cop_file'), #FUN-A50102
               "   SET cop06 = '",g_abbr,"'",
               " WHERE cop05 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE cop_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('cop05',g_no,'prepare cop_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE cop_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('cop05',g_no,'update cop06',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"cop_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'cop_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE cop_unlock_p FROM g_sql
   #EXECUTE cop_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_cor08()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"cor_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'cor_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE cor_lock_p FROM g_sql
   #EXECUTE cor_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table cor_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update cor08")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"cor_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'cor_file'), #FUN-A50102
               "   SET cor08 = '",g_abbr,"'",
               " WHERE cor07 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE cor_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('cor07',g_no,'prepare cor_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE cor_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('cor07',g_no,'update cor08',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"cor_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'cor_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE cor_unlock_p FROM g_sql
   #EXECUTE cor_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_imo04()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"imo_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'imo_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE imo_lock_p FROM g_sql
   #EXECUTE imo_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table imo_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update imo04")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"imo_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'imo_file'), #FUN-A50102
               "   SET imo04 = '",g_abbr,"'",
               " WHERE imo03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE imo_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('imo03',g_no,'prepare imo_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE imo_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('imo03',g_no,'update imo04',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"imo_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'imo_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE imo_unlock_p FROM g_sql
   #EXECUTE imo_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_lne05()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"lne_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'lne_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lne_lock_p FROM g_sql
   #EXECUTE lne_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table lne_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update lne05")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"lne_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'lne_file'), #FUN-A50102
               "   SET lne05 = '",g_abbr,"'",
               " WHERE lne01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE lne_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lne01',g_no,'prepare lne_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE lne_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lne01',g_no,'update lne05',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"lne_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'lne_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lne_unlock_p FROM g_sql
   #EXECUTE lne_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_lua061()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"lua_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'lua_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lua_lock_p FROM g_sql
   #EXECUTE lua_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table lua_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update lua061")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"lua_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'lua_file'), #FUN-A50102
               "   SET lua061 = '",g_abbr,"'",
               " WHERE lua06 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE lua_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lua06',g_no,'prepare lua_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE lua_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lua06',g_no,'update lua061',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"lua_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'lua_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lua_unlock_p FROM g_sql
   #EXECUTE lua_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_luc031()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"luc_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'luc_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE luc_lock_p FROM g_sql
   #EXECUTE luc_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table luc_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update luc031")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"luc_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'luc_file'), #FUN-A50102
               "   SET luc031 = '",g_abbr,"'",
               " WHERE luc03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE luc_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('luc03',g_no,'prepare luc_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE luc_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('luc03',g_no,'update luc031',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"luc_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'luc_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE luc_unlock_p FROM g_sql
   #EXECUTE luc_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_lue05()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"lue_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'lue_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lue_lock_p FROM g_sql
   #EXECUTE lue_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table lue_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update lue05")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"lue_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'lue_file'), #FUN-A50102
               "   SET lue05 = '",g_abbr,"'",
               " WHERE lue01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE lue_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lue01',g_no,'prepare lue_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE lue_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lue01',g_no,'update lue05',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"lue_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'lue_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE lue_unlock_p FROM g_sql
   #EXECUTE lue_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nmd24()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nmd_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nmd_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmd_lock_p FROM g_sql
   #EXECUTE nmd_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nmd_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nmd24")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nmd_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nmd_file'), #FUN-A50102
               "   SET nmd24 = '",g_abbr,"'",
               " WHERE nmd08 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE nmd_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmd08',g_no,'prepare nmd_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nmd_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmd08',g_no,'update nmd24',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nmd_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nmd_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmd_unlock_p FROM g_sql
   #EXECUTE nmd_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nme13()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nme_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nme_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nme_lock_p FROM g_sql
   #EXECUTE nme_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nme_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nme13")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nme_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nme_file'), #FUN-A50102
               "   SET nme13 = '",g_abbr,"'",
               " WHERE nme25 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE nme_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nme25',g_no,'prepare nme_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nme_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nme25',g_no,'update nme13',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nme_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nme_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nme_unlock_p FROM g_sql
   #EXECUTE nme_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nmg19()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nmg_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nmg_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmg_lock_p FROM g_sql
   #EXECUTE nmg_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nmg_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nmg19")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nmg_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nmg_file'), #FUN-A50102
               "   SET nmg19 = '",g_abbr,"'",
               " WHERE nmg18 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102              
   PREPARE nmg_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmg18',g_no,'prepare nmg_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nmg_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmg18',g_no,'update nmg19',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nmg_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nmg_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmg_unlock_p FROM g_sql
   #EXECUTE nmg_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nmh30()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nmh_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nmh_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmh_lock_p FROM g_sql
   #EXECUTE nmh_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nmh_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nmh30")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nmh_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nmh_file'), #FUN-A50102
               "   SET nmh30 = '",g_abbr,"'",
               " WHERE nmh11 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE nmh_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmh11',g_no,'prepare nmh_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nmh_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmh11',g_no,'update nmh30',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nmh_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nmh_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nmh_unlock_p FROM g_sql
   #EXECUTE nmh_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nng51()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nng_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nng_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nng_lock_p FROM g_sql
   #EXECUTE nng_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nng_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nng51")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nng_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nng_file'), #FUN-A50102
               "   SET nng51 = '",g_abbr,"'",
               " WHERE nng48 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE nng_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nng48',g_no,'prepare nng_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nng_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nng48',g_no,'update nng51',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nng_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nng_file')#FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nng_unlock_p FROM g_sql
   #EXECUTE nng_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_nnr041()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"nnr_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'nnr_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nnr_lock_p FROM g_sql
   #EXECUTE nnr_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table nnr_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update nnr041")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"nnr_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'nnr_file'), #FUN-A50102
               "   SET nnr041 = '",g_abbr,"'",
               " WHERE nnr04 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE nnr_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nnr04',g_no,'prepare nnr_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE nnr_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nnr04',g_no,'update nnr041',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"nnr_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'nnr_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE nnr_unlock_p FROM g_sql
   #EXECUTE nnr_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_npq22()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"npq_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'npq_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE npq_lock_p FROM g_sql
   #EXECUTE npq_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table npq_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update npq22")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"npq_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'npq_file'), #FUN-A50102
               "   SET npq22 = '",g_abbr,"'",
               " WHERE npq21 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE npq_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('npq21',g_no,'prepare npq_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE npq_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('npq21',g_no,'update npq22',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"npq_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'npq_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE npq_unlock_p FROM g_sql
   #EXECUTE npq_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_occa02()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"occa_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'occa_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE occa_lock_p FROM g_sql
   #EXECUTE occa_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table occa_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update occa02")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"occa_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'occa_file'), #FUN-A50102
               "   SET occa02 = '",g_abbr,"'",
               " WHERE occa01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE occa_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('occa01',g_no,'prepare occa_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE occa_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('occa01',g_no,'update occa02',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"occa_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'occa_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE occa_unlock_p FROM g_sql
   #EXECUTE occa_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oea032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oea_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oea_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oea_lock_p FROM g_sql
   #EXECUTE oea_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oea_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oea032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oea_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oea_file'), #FUN-A50102
               "   SET oea032 = '",g_abbr,"'",
               " WHERE oea03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
   PREPARE oea_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oea03',g_no,'prepare oea_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oea_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oea03',g_no,'update oea032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oea_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oea_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oea_unlock_p FROM g_sql
   #EXECUTE oea_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oew032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oew_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oew_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oew_lock_p FROM g_sql
   #EXECUTE oew_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oew_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oew032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oew_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oew_file'), #FUN-A50102
               "   SET oew032 = '",g_abbr,"'",
               " WHERE oew03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oew_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oew03',g_no,'prepare oew_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oew_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oew03',g_no,'update oew032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oew_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oew_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oew_unlock_p FROM g_sql
   #EXECUTE oew_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oey032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oey_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oey_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oey_lock_p FROM g_sql
   #EXECUTE oey_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oey_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oey032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oey_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oey_file'), #FUN-A50102
               "   SET oey032 = '",g_abbr,"'",
               " WHERE oey03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oey_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oey03',g_no,'prepare oey_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oey_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oey03',g_no,'update oey032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oey_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oey_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oey_unlock_p FROM g_sql
   #EXECUTE oey_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ofa032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ofa_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ofa_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofa_lock_p FROM g_sql
   #EXECUTE ofa_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ofa_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ofa032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ofa_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ofa_file'), #FUN-A50102
               "   SET ofa032 = '",g_abbr,"'",
               " WHERE ofa03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ofa_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofa03',g_no,'prepare ofa_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ofa_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofa03',g_no,'update ofa032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ofa_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ofa_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofa_unlock_p FROM g_sql
   #EXECUTE ofa_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ofd02()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ofd_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ofd_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofd02_lock_p FROM g_sql
   #EXECUTE ofd02_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ofd_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ofd02")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ofd_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ofd_file'), #FUN-A50102
               "   SET ofd02 = '",g_abbr,"'",
               " WHERE ofd01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
   PREPARE ofd02_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofd01',g_no,'prepare ofd02_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ofd02_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofd01',g_no,'update ofd02',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ofd_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ofd_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofd02_unlock_p FROM g_sql
   #EXECUTE ofd02_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ofd41()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ofd_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ofd_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofd41_lock_p FROM g_sql
   #EXECUTE ofd41_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ofd_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ofd41")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ofd_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ofd_file'), #FUN-A50102
               "   SET ofd41 = '",g_abbr,"'",
               " WHERE ofd40 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ofd41_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofd40',g_no,'prepare ofd41_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ofd41_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofd40',g_no,'update ofd41',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ofd_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ofd_file')#FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofd41_unlock_p FROM g_sql
   #EXECUTE ofd41_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_off04()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"off_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'off_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE off_lock_p FROM g_sql
   #EXECUTE off_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table off_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update off04")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"off_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'off_file'), #FUN-A50102
               "   SET off04 = '",g_abbr,"'",
               " WHERE off03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE off_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('off03',g_no,'prepare off_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE off_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('off03',g_no,'update off04',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"off_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'off_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE off_unlock_p FROM g_sql
   #EXECUTE off_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ofr02()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ofr_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ofr_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofr_lock_p FROM g_sql
   #EXECUTE ofr_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ofr_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ofr02")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ofr_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ofr_file'), #FUN-A50102
               "   SET ofr02 = '",g_abbr,"'",
               " WHERE ofr01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ofr_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofr01',g_no,'prepare ofr_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ofr_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ofr01',g_no,'update ofr02',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ofr_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ofr_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ofr_unlock_p FROM g_sql
   #EXECUTE ofr_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oga032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oga_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oga_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oga_lock_p FROM g_sql
   #EXECUTE oga_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oga_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oga032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oga_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oga_file'), #FUN-A50102
               "   SET oga032 = '",g_abbr,"'",
               " WHERE oga03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oga_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oga03',g_no,'prepare oga_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oga_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oga03',g_no,'update oga032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oga_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oga_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oga_unlock_p FROM g_sql
   #EXECUTE oga_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oha032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oha_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oha_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oha_lock_p FROM g_sql
   #EXECUTE oha_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oha_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oha032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oha_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oha_file'), #FUN-A50102
               "   SET oha032 = '",g_abbr,"'",
               " WHERE oha03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oha_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oha03',g_no,'prepare oha_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oha_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oha03',g_no,'update oha032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oha_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oha_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oha_unlock_p FROM g_sql
   #EXECUTE oha_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ohc061()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ohc_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ohc_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ohc_lock_p FROM g_sql
   #EXECUTE ohc_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ohc_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ohc061")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ohc_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ohc_file'), #FUN-A50102
               "   SET ohc061 = '",g_abbr,"'",
               " WHERE ohc06 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ohc_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ohc06',g_no,'prepare ohc_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ohc_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ohc06',g_no,'update ohc061',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ohc_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ohc_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ohc_unlock_p FROM g_sql
   #EXECUTE ohc_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oma032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oma_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oma_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oma032_lock_p FROM g_sql
   #EXECUTE oma032_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oma_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oma032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oma_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oma_file'), #FUN-A50102
               "   SET oma032 = '",g_abbr,"'",
               " WHERE oma03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oma032_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma03',g_no,'prepare oma032_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oma032_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma03',g_no,'update oma032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oma_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oma_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oma032_unlock_p FROM g_sql
   #EXECUTE oma032_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_oma69()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"oma_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'oma_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oma69_lock_p FROM g_sql
   #EXECUTE oma69_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table oma_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update oma69")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"oma_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'oma_file'), #FUN-A50102
               "   SET oma69 = '",g_abbr,"'",
               " WHERE oma68 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE oma69_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma68',g_no,'prepare oma69_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE oma69_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma68',g_no,'update oma69',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"oma_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'oma_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE oma69_unlock_p FROM g_sql
   #EXECUTE oma69_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ooa032()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ooa_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ooa_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ooa_lock_p FROM g_sql
   #EXECUTE ooa_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ooa_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ooa032")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ooa_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ooa_file'), #FUN-A50102
               "   SET ooa032 = '",g_abbr,"'",
               " WHERE ooa03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ooa_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ooa03',g_no,'prepare ooa_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ooa_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ooa03',g_no,'update ooa032',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ooa_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ooa_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ooa_unlock_p FROM g_sql
   #EXECUTE ooa_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_ooo02()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"ooo_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'ooo_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ooo_lock_p FROM g_sql
   #EXECUTE ooo_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table ooo_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update ooo02")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"ooo_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'ooo_file'), #FUN-A50102
               "   SET ooo02 = '",g_abbr,"'",
               " WHERE ooo01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE ooo_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ooo01',g_no,'prepare ooo_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE ooo_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ooo01',g_no,'update ooo02',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"ooo_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'ooo_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE ooo_unlock_p FROM g_sql
   #EXECUTE ooo_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_pmca03()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"pmca_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'pmca_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE pmca_lock_p FROM g_sql
   #EXECUTE pmca_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table pmca_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update pmca03")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"pmca_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'pmca_file'), #FUN-A50102
               "   SET pmca03 = '",g_abbr,"'",
               " WHERE pmca01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102             
   PREPARE pmca_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmca01',g_no,'prepare pmca_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE pmca_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmca01',g_no,'update pmca03',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"pmca_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'pmca_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE pmca_unlock_p FROM g_sql
   #EXECUTE pmca_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_rma04()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"rma_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'rma_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rma_lock_p FROM g_sql
   #EXECUTE rma_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table rma_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update rma04")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"rma_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'rma_file'), #FUN-A50102
               "   SET rma04 = '",g_abbr,"'",
               " WHERE rma03 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE rma_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rma03',g_no,'prepare rma_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE rma_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rma03',g_no,'update rma04',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"rma_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'rma_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rma_unlock_p FROM g_sql
   #EXECUTE rma_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_rmn03()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"rmn_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'rmn_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rmn_lock_p FROM g_sql
   #EXECUTE rmn_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table rmn_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update rmn03")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"rmn_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'rmn_file'), #FUN-A50102
               "   SET rmn03 = '",g_abbr,"'",
               " WHERE rmn02 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE rmn_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rmn02',g_no,'prepare rmn_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE rmn_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rmn02',g_no,'update rmn03',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"rmn_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'rmn_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rmn_unlock_p FROM g_sql
   #EXECUTE rmn_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_rvu05()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"rvu_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'rvu_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rvu_lock_p FROM g_sql
   #EXECUTE rvu_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table rvu_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update rvu05")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"rvu_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'rvu_file'), #FUN-A50102
               "   SET rvu05 = '",g_abbr,"'",
               " WHERE rvu04 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE rvu_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rvu04',g_no,'prepare rvu_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE rvu_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rvu04',g_no,'update rvu05',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"rvu_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'rvu_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE rvu_unlock_p FROM g_sql
   #EXECUTE rvu_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_pmc03()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"pmc_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'pmc_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE pmc_lock_p FROM g_sql
   #EXECUTE pmc_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table pmc_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update pmc03")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"pmc_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'pmc_file'), #FUN-A50102
               "   SET pmc03 = '",g_abbr,"'",
               " WHERE pmc01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE pmc_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',g_no,'prepare pmc_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE pmc_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',g_no,'update pmc03',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"pmc_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'pmc_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE pmc_unlock_p FROM g_sql
   #EXECUTE pmc_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

FUNCTION s_upd_occ02()
   #No.TQC-C10035  --Begin
   ##LET g_sql = "LOCK TABLE ",t_dbs CLIPPED,"occ_file IN EXCLUSIVE MODE"
   #LET g_sql = "LOCK TABLE ",cl_get_target_table(t_plant,'occ_file'), #FUN-A50102
   #            " IN EXCLUSIVE MODE"
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE occ_lock_p FROM g_sql
   #EXECUTE occ_lock_p
   #IF STATUS THEN
   #   CALL s_errmsg('','','lock table occ_file',STATUS,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #No.TQC-C10035  --End  
   CALL cl_progressing("update occ02")
   #LET g_sql = "UPDATE ",t_dbs CLIPPED,"occ_file",
   LET g_sql = "UPDATE ",cl_get_target_table(t_plant,'occ_file'), #FUN-A50102
               "   SET occ02 = '",g_abbr,"'",
               " WHERE occ01 = '",g_no,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102            
   PREPARE occ_upd_p FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('occ01',g_no,'prepare occ_upd_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE occ_upd_p
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('occ01',g_no,'update occ02',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   #No.TQC-C10035  --Begin
   ##LET g_sql = "UNLOCK TABLE ",t_dbs CLIPPED,"occ_file"
   #LET g_sql = "UNLOCK TABLE ",cl_get_target_table(t_plant,'occ_file') #FUN-A50102
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(g_sql,t_plant) RETURNING g_sql #FUN-A50102
   #PREPARE occ_unlock_p FROM g_sql
   #EXECUTE occ_unlock_p
   #No.TQC-C10035  --End  
END FUNCTION

#Returning 1: RETSULT TRUE/FALSE   
#Returning 2: update
#FUNCTION s_check_pmc01_occ01(p_no,p_abbr,p_dbs,p_flag,p_ask)
FUNCTION s_check_pmc01_occ01(p_no,p_abbr,p_plant,p_flag,p_ask)  #FUN-A50102
   DEFINE p_no        LIKE pmc_file.pmc01
   DEFINE p_abbr      LIKE pmc_file.pmc03
   DEFINE p_dbs       LIKE type_file.chr21 
   DEFINE p_plant     LIKE type_file.chr21  #FUN-A50102
   DEFINE p_flag      LIKE type_file.chr1
   DEFINE p_ask       LIKE type_file.chr1
   DEFINE c_abbr      LIKE pmc_file.pmc03
   DEFINE l_str       STRING
   DEFINE l_ze01      LIKE ze_file.ze01
   DEFINE l_ze03      LIKE ze_file.ze03
   DEFINE l_aza125    LIKE aza_file.aza125   #No.FUN-BB0049
 
   LET g_plant_new =p_plant
   CALL s_getdbs()
   LET p_dbs = g_dbs_new
   IF cl_null(p_dbs)  THEN LET p_dbs = g_dbs END IF
   IF cl_null(p_plant)  THEN LET p_plant = g_plant END IF #FUN-A50102
   IF cl_null(p_no)   THEN RETURN TRUE,FALSE END IF
   IF cl_null(p_abbr) THEN RETURN TRUE,FALSE END IF
   IF cl_null(p_flag) OR p_flag NOT MATCHES '[12]' THEN 
      RETURN FALSE,FALSE 
   END IF

   #No.TQC-BB0002  --Begin                                                      
   IF p_no MATCHES 'MISC*' OR p_no MATCHES 'EMPL*' THEN                         
      RETURN TRUE,FALSE                                                         
   END IF                                                                       
   #No.TQC-BB0002  --End 

   #No.FUN-BB0049  --Begin
   LET g_sql = " SELECT aza125 FROM ",cl_get_target_table(p_plant,'aza_file'),
               "  WHERE aza01 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE aza_p2 FROM g_sql
   EXECUTE aza_p2 INTO l_aza125
   IF SQLCA.sqlcode <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select aza_file fail',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('sel aza',SQLCA.sqlcode,1)
      END IF
       RETURN FALSE,FALSE
   END IF

   IF l_aza125 = 'N' THEN RETURN TRUE,FALSE END IF
   #No.FUN-BB0049  --End  

   IF p_flag = '1' THEN    #供應商
      #LET g_sql = " SELECT occ02 FROM ",s_dbstring(p_dbs),"occ_file",
      LET g_sql = " SELECT occ02 FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
                  "  WHERE occ01 = '",p_no,"'"
      LET g_msg = 'occ01' 
   ELSE                    #客戶
      #LET g_sql = " SELECT pmc03 FROM ",s_dbstring(p_dbs),"pmc_file",
      LET g_sql = " SELECT pmc03 FROM ",cl_get_target_table(p_plant,'pmc_file'), #FUN-A50102
                  "  WHERE pmc01 = '",p_no,"'"
      LET g_msg = 'pmc01' 
   END IF 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE check_p1 FROM g_sql
   EXECUTE check_p1 INTO c_abbr
   IF SQLCA.sqlcode = 100 THEN 
      RETURN TRUE,FALSE 
   ELSE
      IF SQLCA.sqlcode <> 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg(g_msg,p_no,'select fail',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err(p_abbr,SQLCA.sqlcode,1)
         END IF
         RETURN FALSE,FALSE
      END IF
   END IF

   IF p_abbr <> c_abbr THEN
      IF p_ask = 'N' THEN RETURN TRUE,TRUE END IF
      LET l_str = p_plant CLIPPED,':',p_abbr CLIPPED,'(',c_abbr CLIPPED,')'   #No.FUN-BB0049
      IF p_flag = '1' THEN
         LET l_ze01 = 'apm-814'
      ELSE
         LET l_ze01 = 'apm-813'
      END IF
      SELECT ze03 INTO l_ze03 FROM ze_file 
       WHERE ze01 = l_ze01
         AND ze02 = g_lang
      LET l_str = l_str CLIPPED,',',l_ze03 CLIPPED

      IF p_flag = '1' THEN
         LET l_ze01 = 'apm-811'
      ELSE
         LET l_ze01 = 'apm-810'
      END IF
      IF NOT cl_confirm2(l_ze01,l_str) THEN 
      #  RETURN FALSE,FALSE   #No.FUN-BB0049
         RETURN TRUE,FALSE    #No.FUN-BB0049
      ELSE
         RETURN TRUE,TRUE
      END IF
   END IF
   RETURN TRUE,FALSE

END FUNCTION
#FUN-AB0113

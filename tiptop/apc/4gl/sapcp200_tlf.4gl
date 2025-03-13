# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: sapcp200_tlf.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Date & Author..: 92/05/25 By Pin
# Usage..........: CALL s_tlf2(p_cost,p_reason,p_plant)
# Input Parameter: p_cost    1. Current
#                  p_reason  是否需取得該異動之異動原因
#                            1.需要 0.不需要
#                  p_plant   機構別
# Return Code....: None
# Modify.........: No:FUN-A30116 10/04/21 BY Cockroah copy and change for pos_db up to tiptop_db
# Modify.........: No:FUN-A50102 10/07/14 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-B10099 11/01/12 By shiwuying 重新过单

DATABASE ds 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
FUNCTION p200_tlf(p_cost,p_reason,p_plant) #No.FUN-870007 #FUN-A30116
    DEFINE
        p_factor        LIKE pml_file.pml09, 	#No.FUN-680147 DECIMAL(16,8)
        p_cost          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        p_dbs           LIKE azp_file.azp03,
        p_tdbs          LIKE type_file.chr21,   #FUN-980014 add
        p_reason        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE apo_file.apo02, 	#No.FUN-680147 VARCHAR(04)
#       l_sql           LIKE type_file.chr1000, #No.FUN-680147 VARCHAR(1000) #No.TQC-930155-mark
        l_sql STRING,    #No.TQC-930155
        s_f             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE p_plant LIKE type_file.chr20  #No.FUN-870007
 
    WHENEVER ERROR CALL cl_err_msg_log      #NO.TQC-9A0109
    IF g_tlf.tlf021 IS NULL THEN LET g_tlf.tlf021=' ' END IF
    IF g_tlf.tlf022 IS NULL THEN LET g_tlf.tlf022=' ' END IF
    IF g_tlf.tlf023 IS NULL THEN LET g_tlf.tlf023=' ' END IF
    IF g_tlf.tlf031 IS NULL THEN LET g_tlf.tlf031=' ' END IF
    IF g_tlf.tlf032 IS NULL THEN LET g_tlf.tlf032=' ' END IF
    IF g_tlf.tlf033 IS NULL THEN LET g_tlf.tlf033=' ' END IF
    IF g_tlf.tlf027 IS NULL THEN LET g_tlf.tlf027 = 0 END IF
    IF g_tlf.tlf037 IS NULL THEN LET g_tlf.tlf037 = 0 END IF
 
    LET g_tlf.tlf07 = TODAY
    LET g_tlf.tlf08 = TIME  
    IF g_tlf.tlf13 = 'aimp880' THEN LET g_tlf.tlf08='99:99:99' END IF
    IF cl_null(g_tlf.tlf12) THEN LET g_tlf.tlf12=1 END IF 
    IF cl_null(g_tlf.tlf026) THEN LET g_tlf.tlf026 = g_tlf.tlf036 END IF 
    IF cl_null(g_tlf.tlf036) THEN LET g_tlf.tlf036 = g_tlf.tlf026 END IF 
    IF g_tlf.tlf05 IS NULL THEN LET g_tlf.tlf05   =' ' END IF
 
    #------ 97/06/23
    LET g_tlf.tlf905=' '
    LET g_tlf.tlf906=0    
    LET g_tlf.tlf907=0
    LET g_tlf.tlf66 =''
    LET g_tlf.tlf211=''
    IF g_tlf.tlf02=50 AND g_tlf.tlf03=50 THEN
       PROMPT "來源與目的不可均為50:" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
       
       END PROMPT
       LET g_success='N' RETURN
    END IF
    IF g_tlf.tlf02=50 THEN                ##--- 出庫
       LET g_tlf.tlf902=g_tlf.tlf021
       LET g_tlf.tlf903=g_tlf.tlf022
       LET g_tlf.tlf904=g_tlf.tlf023
       LET g_tlf.tlf905=g_tlf.tlf026
       LET g_tlf.tlf906=g_tlf.tlf027
       LET g_tlf.tlf907=-1             
    END IF
    IF g_tlf.tlf03=50 THEN                ##--- 入庫
       LET g_tlf.tlf902=g_tlf.tlf031
       LET g_tlf.tlf903=g_tlf.tlf032
       LET g_tlf.tlf904=g_tlf.tlf033
       LET g_tlf.tlf905=g_tlf.tlf036
       LET g_tlf.tlf906=g_tlf.tlf037
       LET g_tlf.tlf907=1             
    END IF
#No.FUN-560060--begin
#   LET g_tlf.tlf61=g_tlf.tlf905[1,3]		#971028 Roger
    LET g_tlf.tlf61=g_tlf.tlf905[1,g_doc_len]		#971028 Roger
#No.FUN-560060--end  
 
#No.FUN-870007-start-
    LET g_plant_new = p_plant CLIPPED  
   #FUN-980014 --begin
    #CALL s_gettrandbs()
    #LET p_dbs = g_dbs_new
    #CALL s_getdbs()
    #LET p_dbs = g_dbs_new
    #CALL s_gettrandbs()
    #LET p_tdbs = g_dbs_tra
   #FUN-980014 --end
    LET g_tlf.tlfplant = g_plant_new
    SELECT azw02 INTO g_tlf.tlflegal FROM azw_file WHERE azw01=g_plant_new
#No.FUN-870007--end--
 
    #--------------------------------------------------------------------------
    #LET l_sql = "SELECT imd09 FROM ",p_dbs CLIPPED,"imd_file ",
    LET l_sql = "SELECT imd09 FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
                " WHERE imd01='",g_tlf.tlf902 CLIPPED,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE imd_cur FROM l_sql
    DECLARE imd_curs CURSOR FOR imd_cur
    OPEN imd_curs
    FETCH imd_curs INTO g_tlf.tlf901
    IF STATUS
       THEN
       #CALL cl_err('sel imd_file','mfg9040',1)  #FUN-670091
        CALL cl_err3("sel","imd_file",g_tlf.tlf902,"",STATUS,"","",0) #FUN-670091
       LET g_success='N' RETURN
    END IF
    #--------------------------------------------------------------------------
    LET l_sql =
    #"SELECT img21 FROM ",p_dbs CLIPPED,"img_file",  #FUN-980014
    #"SELECT img21 FROM ",p_tdbs CLIPPED,"img_file",  #FUN-980014
    "SELECT img21 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
    "    WHERE img01='",g_tlf.tlf01,"'",
    "      AND img02='",g_tlf.tlf902,"'",
    "      AND img03='",g_tlf.tlf903,"'",
    "      AND img04='",g_tlf.tlf904,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #No.FUN-870007
    PREPARE img21_cur FROM l_sql
    DECLARE img21_curs CURSOR FOR img21_cur
    OPEN img21_curs
    FETCH img21_curs INTO g_tlf.tlf60
    IF STATUS OR g_tlf.tlf60 IS NULL THEN LET g_tlf.tlf60=1 END IF
    #--------------------------------------------------------------------------
    IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
#       IF NOT s_chksmz1(g_tlf.tlf01,g_tlf.tlf905[1,g_doc_len],g_tlf.tlf902,g_tlf.tlf903,p_dbs) #FUN-560043 #No.FUN-870007-mark
     #FUN-A30116 when pos_db up to tiptop_db ,no checking----20100421----
     # IF NOT s_chksmz1(g_tlf.tlf01,g_tlf.tlf905[1,g_doc_len],g_tlf.tlf902,g_tlf.tlf903,g_plant_new)  #No.FUN-870007
     #    THEN LET g_success='N' RETURN
     # END IF
    END IF
    #--------------------------------------------------------------------------

#No.TQC-930155-start-
#   LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"tlf_file",
    #LET l_sql="INSERT INTO ",p_dbs CLIPPED,"tlf_file (",  #FUN-980014
    #LET l_sql="INSERT INTO ",p_tdbs CLIPPED,"tlf_file (",  #FUN-980014
    LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tlf_file')," (", #FUN-A50102    
              "tlf01,   tlf02,   tlf020,  tlf021,  tlf022,  tlf023,  tlf024,  tlf025,  tlf026,  tlf027,",
              "tlf03,   tlf030,  tlf031,  tlf032,  tlf033,  tlf034,  tlf035,  tlf036,  tlf037,  tlf04,",
              "tlf05,   tlf06,   tlf07,   tlf08,   tlf09,   tlf10,   tlf11,   tlf12,   tlf13,   tlf14,",
              "tlf15,   tlf16,   tlf17,   tlf18,   tlf19,   tlf20,   tlf21,   tlf211,  tlf212,  tlf2131,",
              "tlf2132, tlf214,  tlf215,  tlf2151, tlf216,  tlf2171, tlf2172, tlf219,  tlf218,  tlf220,",
              "tlf221,  tlf222,  tlf2231, tlf2232, tlf224,  tlf225,  tlf2251, tlf226,  tlf2271, tlf2272,",
              "tlf229,  tlf230,  tlf231,  tlf60,   tlf61,   tlf62,   tlf63,   tlf64,   tlf65,   tlf66,",
              "tlf901,  tlf902,  tlf903,  tlf904,  tlf905,  tlf906,  tlf907,  tlf908,  tlf909,  tlf910,",
              "tlf99,   tlf930,  tlf931,  tlf151,  tlf161,  tlf2241, tlf2242, tlf2243, tlfcost, tlf41,",
              "tlf42,   tlf43,   tlf211x, tlf212x, tlf21x,  tlf221x, tlf222x, tlf2231x,tlf2232x,tlf2241x,",
              "tlf2242x,tlf2243x,tlf224x, tlf65x,  tlfplant,tlflegal,tlf27,tlf28)",  #No.FUN-870007-add tlfplant,tlflegal #FUN-9B0149#TQC-A40013--add tlf28
#No.TQC-930155--end--
   {ckp#1}      " VALUES(?,?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",     #FUN-690071 #MOD-8A0055 add 6個?
                        #"?)"                       #MOD-8A0055 #TQC-930155--mark----
                        "?,?,?,?,?,?,?,?,?,?,",     #TQC-930155--add-------
                        "?,?,?,?,?,?,?)"                #TQC-930155--add-------  #No.FUN-870007-add ? #FUN-9B0149 #TQC-A40013--add?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE tlf_ins FROM l_sql
#   DECLARE tlf_ins1 CURSOR FOR tlf_ins
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = "N"
       RETURN
    END IF
    EXECUTE tlf_ins USING g_tlf.*
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       #CALL cl_err('(s_tlf2:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
        CALL cl_err3("ins","tlf_file","","",STATUS,"","",1)  #FUN-670091
       RETURN
    END IF
    #--------------------------------------------------------------------------
END FUNCTION
 
#依'料號'及'單別'檢查倉庫儲位正確否
#FUN-A30116  #TQC-B10099

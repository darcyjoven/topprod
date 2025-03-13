database ds

type sfb record
    sfb01    like sfb_file.sfb01,
    sfb81    like sfb_file.sfb81,
    sfb05    like sfb_file.sfb05,
    ima02    like ima_file.ima02,
    ima021   like ima_file.ima021,
    sfb08    like sfb_file.sfb08,
    sfb081   like sfb_file.sfb081,
    sfb22    like sfb_file.sfb22,
    sfb221   like sfb_file.sfb221,
    sfa03    like sfa_file.sfa03,
    ima02_1  like ima_file.ima02,
    ima021_1 like ima_file.ima021,
    sfa05    like sfa_file.sfa05,
    sfa06    like sfa_file.sfa06
end record

main
    define l_sfb dynamic array of sfb
    define l_cnt integer
    define l_sql string

    let l_sql = "select sfb01,sfb81,sfb05,a.ima02,a.ima021,sfb08,sfb081,sfb22 ,sfb221,sfa03,b.ima02,b.ima021,sfa05,sfa06 ",
                "  from sfb_file left join ima_file a on a.ima01=sfb05, ",
                "       sfa_file left join ima_file b on b.ima01=sfa03 ",
                " where sfb81 = to_date('230712','yymmdd') and sfb05 like 'AA%' ",
                "   and sfa01=sfb01 "
    declare sfb_cur cursor from l_sql

    let l_cnt = 1
    foreach sfb_cur into l_sfb[l_cnt].*
        if l_sfb[l_cnt].sfa03[1,4] = "M.PK" then
            continue foreach
        end if
        let l_cnt = l_cnt + 1
        display l_sfb[l_cnt].sfb01,
                l_sfb[l_cnt].sfb81,
                l_sfb[l_cnt].sfb05,
                l_sfb[l_cnt].ima02,
                l_sfb[l_cnt].ima021,
                l_sfb[l_cnt].sfb08,
                l_sfb[l_cnt].sfb081,
                l_sfb[l_cnt].sfb22,
                l_sfb[l_cnt].sfb221,
                l_sfb[l_cnt].sfa03,
                l_sfb[l_cnt].ima02_1,
                l_sfb[l_cnt].ima021_1,
                l_sfb[l_cnt].sfa05,
                l_sfb[l_cnt].sfa06
    end foreach
end main

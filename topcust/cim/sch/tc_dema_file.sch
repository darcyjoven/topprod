/*
================================================================================
檔案代號:tc_dea_file
檔案名稱:demo作业单头资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_dea_file
(
tc_dea01   varchar2(20) NOT NULL ,       /*demo单号*/
tc_dea02   date    NOT NULL,             /*demo时间*/
tc_dea03   number(5) NOT NULL,           /*demo修改班次*/
tc_dea04   varchar2(1),                  /*demoCheckbox*/
tc_dea05   varchar2(1),                  /*demo*/
tc_dea06   varchar2(20),                 /*demobtnedit*/
tc_dea07   varchar2(20),                 /*demoComboBox*/
tc_dea08   varchar2(5),                  /*RadioGroup*/
tc_dea09   number(5),                    /*Slider*/
tc_dea10   number(5),                    /*SpinEdit*/
tc_dea11   varchar2(20),                 /*TimeEdit*/
tc_dea12   varchar2(500),                /*Image*/
tc_dea13   varchar2(500),                /*WebComponent*/
tc_dea14   varchar2(1000)  ,             /*demo备注*/
tc_dea15   date    NOT NULL,             /*demo创建时间*/
tc_dea16   varchar2(20) NOT NULL ,       /*demo创建人员*/
tc_dea17   date    NOT NULL,             /*demo修改时间*/
tc_dea18   varchar2(20) NOT NULL ,       /*demo修改人员*/
tc_dea19   date    NOT NULL,             /*demo审核时间*/
tc_dea20   varchar2(20) NOT NULL ,       /*demo审核人员*/
tc_deaud01 varchar2(20),                 /**/
tc_deaud02 varchar2(20),                 /**/
tc_deaud03 varchar2(20),                 /**/
tc_deaud04 number(5),                    /**/
tc_deaud05 number(5),                    /**/
tc_deaud06 number(5),                    /**/
tc_deaud07 date ,                        /**/
tc_deaud08 date ,                        /**/
tc_deaud09 date ,                        /**/
tc_deaud10 varchar2(1000)                /**/
);

create unique index tc_dea_01 on alb_file (tc_dea01);
create        index tc_dea_02 on alb_file (tc_dea01,tc_dea02); 
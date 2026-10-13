/*
================================================================================
檔案代號:ccs_file
檔案名稱:料件标准成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccs_file
(
ccs01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
ccs02       varchar2(10) NOT NULL,   /*标准成本版本                           */
                                     /*標準成本版本                           */
ccs03       number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
ccs03a      number(20,6),            /*标准成本-材料                          */
                                     /*標準成本-材料                          */
ccs03b      number(20,6),            /*标准成本-人工                          */
                                     /*標準成本-人工                          */
ccs03c      number(20,6),            /*标准成本-制费                          */
                                     /*標準成本-製費                          */
ccs03d      number(20,6),            /*标准成本-加工                          */
                                     /*標準成本-加工                          */
ccs03e      number(20,6),            /*标准成本-其他                          */
                                     /*標準成本-其他                          */
ccsuser     varchar2(10),            /*最近更改人                             */
                                     /*最近修改人                             */
ccsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccs03f      number(20,6) DEFAULT '0',/*标准成本-制费三                        */
ccs03g      number(20,6) DEFAULT '0',/*标准成本-制费四                        */
ccs03h      number(20,6) DEFAULT '0',/*标准成本-制费五                        */
ccsorig     varchar2(10),            /*资料建立部门                           */
ccsoriu     varchar2(10),            /*资料建立者                             */
ccslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ccs_file add  constraint ccs_pk primary key  (ccs01,ccs02) enable validate;
grant select on ccs_file to tiptopgp;
grant update on ccs_file to tiptopgp;
grant delete on ccs_file to tiptopgp;
grant insert on ccs_file to tiptopgp;
grant index on ccs_file to public;
grant select on ccs_file to ods;

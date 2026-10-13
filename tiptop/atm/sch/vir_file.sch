/*
================================================================================
檔案代號:vir_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vir_file
(
vir01       varchar2(20) NOT NULL,   /*VIP卡号                                */
vir02       date,                    /*使用日期                               */
vir03       varchar2(1),             /*使用方式                               */
vir04       varchar2(40),            /*赠品料号                               */
vir05       number(15,3),            /*数量                                   */
virplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
virlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index vir_01 on vir_file (vir01);
grant select on vir_file to tiptopgp;
grant update on vir_file to tiptopgp;
grant delete on vir_file to tiptopgp;
grant insert on vir_file to tiptopgp;
grant index on vir_file to public;
grant select on vir_file to ods;

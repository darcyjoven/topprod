/*
================================================================================
檔案代號:bnh_file
檔案名稱:销售预测资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bnh_file
(
bnh01       varchar2(1),             /*销售区分                               */
                                     /*0.全部  1.內銷                         */
bnh02       date,                    /*销售日期                               */
                                     /*銷售日期from                           */
bnh03       varchar2(40),            /*料件编号                               */
bnh04       number(15,3),            /*数量                                   */
bnh05       date,                    /*销售日期                               */
                                     /*銷售日期to                             */
bnhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index bnh_01 on bnh_file (bnh01,bnh02,bnh03);
grant select on bnh_file to tiptopgp;
grant update on bnh_file to tiptopgp;
grant delete on bnh_file to tiptopgp;
grant insert on bnh_file to tiptopgp;
grant index on bnh_file to public;
grant select on bnh_file to ods;

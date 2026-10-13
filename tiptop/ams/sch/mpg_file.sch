/*
================================================================================
檔案代號:mpg_file
檔案名稱:MPS 订单异动log 档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mpg_file
(
mpg01       varchar2(40),            /*MPS 料号                               */
                                     /*MPS 料號                               */
mpg02       varchar2(20),            /*订单单号                               */
                                     /*訂單單號                               */
mpg03       number(5),               /*项次                                   */
                                     /*項次                                   */
mpg04       date,                    /*需求日期                               */
mpg05       number(15,3),            /*需求数量                               */
                                     /*需求數量                               */
mpg06       number(5),               /*状况                                   */
                                     /*狀況(1 or -1)                          */
mpg07       varchar2(40),            /*来源料号                               */
                                     /*來源料號                               */
mpg08       date,                    /*异动日期                               */
                                     /*異動日期                               */
mpg09       varchar2(1),             /*异动来源                               */
                                     /*異動來源                               */
                                     /*'A':新增                               */
                                     /*'U':修改                               */
                                     /*'R':刪除                               */
                                     /*'C':結案                               */
                                     /*'Z':結案還原                           */
mpgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mpglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index mpg_01 on mpg_file (mpg01,mpg04);
create        index mpg_02 on mpg_file (mpg02,mpg03);
grant select on mpg_file to tiptopgp;
grant update on mpg_file to tiptopgp;
grant delete on mpg_file to tiptopgp;
grant insert on mpg_file to tiptopgp;
grant index on mpg_file to public;
grant select on mpg_file to ods;

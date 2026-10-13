/*
================================================================================
檔案代號:gih_file
檔案名稱:采购预算档 (单头)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gih_file
(
gih01       varchar2(6) NOT NULL,    /*预测编号                               */
                                     /*預測編號                               */
gih02       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別 1:外購料  2:內購料                */
gih03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號      (輸入 '*' 表示全部)      */
gihacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gihuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gihgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gihmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gihdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gihorig     varchar2(10),            /*资料建立部门                           */
gihoriu     varchar2(10)             /*资料建立者                             */
);

create        index gih_02 on gih_file (gih01);
alter table gih_file add  constraint gih_pk primary key  (gih01,gih02,gih03) enable validate;
grant select on gih_file to tiptopgp;
grant update on gih_file to tiptopgp;
grant delete on gih_file to tiptopgp;
grant insert on gih_file to tiptopgp;
grant index on gih_file to public;
grant select on gih_file to ods;

/*
================================================================================
檔案代號:sft_file
檔案名稱:工单发料底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sft_file
(
sft01       varchar2(20) NOT NULL,   /*发料单号                               */
                                     /*發料單號                               */
sft03       varchar2(20) NOT NULL,   /*工单                                   */
                                     /*工單                                   */
sft04       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
sft05       number(15,3),            /*未发数量                               */
                                     /*未發數量                               */
sft06       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*發料單位                               */
sft10       number(5) NOT NULL,      /*作业序号                               */
                                     /*作業序號                               */
sftplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sftlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sft_file add  constraint sft_pk primary key  (sft01,sft03,sft04,sft06,sft10) enable validate;
grant select on sft_file to tiptopgp;
grant update on sft_file to tiptopgp;
grant delete on sft_file to tiptopgp;
grant insert on sft_file to tiptopgp;
grant index on sft_file to public;
grant select on sft_file to ods;

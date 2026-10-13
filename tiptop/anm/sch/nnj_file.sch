/*
================================================================================
檔案代號:nnj_file
檔案名稱:融资、长贷还息付款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnj_file
(
nnj01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號                               */
nnj02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
nnj03       varchar2(20),            /*短期融资单号/长期贷款合约              */
                                     /*短期融資單號/長期貸款合約              */
nnj04       varchar2(1),             /*付息方式                               */
                                     /*付息方式 (1.每月付息 2.還本還息)       */
nnj05       date,                    /*起算日期                               */
nnj06       date,                    /*止算日期                               */
nnj07       number(5),               /*利息天数                               */
                                     /*利息天數                               */
nnj08       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*利率％         #No:7354                */
nnj09       varchar2(1),             /*1.融资 2.中长贷合约                    */
                                     /*1.融資 2.中長貸合約                    */
nnj10       number(5),               /*No Use                                 */
nnj11       number(20,6),            /*暂估原币利息                           */
                                     /*暫估原幣利息   02/11/26 alter          */
nnj12       number(20,6),            /*实付原币利息                           */
                                     /*實付原幣利息   02/11/26 alter          */
nnj13       number(20,6),            /*暂估本币利息                           */
                                     /*暫估本幣利息   02/11/26 alter          */
nnj14       number(20,6),            /*实付本币利息                           */
                                     /*實付本幣利息   02/11/26 alter          */
nnj15       number(20,6),            /*利差损失                               */
                                     /*利差損失       02/11/26 alter          */
nnj16       number(20,6),            /*汇差损失                               */
                                     /*匯差損失       02/11/26 alter          */
nnjud01     varchar2(255),           /*自订字段-Textedit                      */
nnjud02     varchar2(40),            /*自订字段-文字                          */
nnjud03     varchar2(40),            /*自订字段-文字                          */
nnjud04     varchar2(40),            /*自订字段-文字                          */
nnjud05     varchar2(40),            /*自订字段-文字                          */
nnjud06     varchar2(40),            /*自订字段-文字                          */
nnjud07     number(15,3),            /*自订字段-数值                          */
nnjud08     number(15,3),            /*自订字段-数值                          */
nnjud09     number(15,3),            /*自订字段-数值                          */
nnjud10     number(10),              /*自订字段-整数                          */
nnjud11     number(10),              /*自订字段-整数                          */
nnjud12     number(10),              /*自订字段-整数                          */
nnjud13     date,                    /*自订字段-日期                          */
nnjud14     date,                    /*自订字段-日期                          */
nnjud15     date,                    /*自订字段-日期                          */
nnjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnj_file add  constraint nnj_pk primary key  (nnj01,nnj02) enable validate;
grant select on nnj_file to tiptopgp;
grant update on nnj_file to tiptopgp;
grant delete on nnj_file to tiptopgp;
grant insert on nnj_file to tiptopgp;
grant index on nnj_file to public;
grant select on nnj_file to ods;

/*
================================================================================
檔案代號:qcb_file
檔案名稱:单次抽样计划资料维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qcb_file
(
qcb01       varchar2(1) NOT NULL,    /*检验程度                               */
                                     /* (N:正常檢驗 T:加嚴檢驗 R:減量檢驗)    */
qcb02       number(7,3) NOT NULL,    /*允收水准                               */
                                     /*允收水準                               */
qcb03       varchar2(1) NOT NULL,    /*样本字号                               */
                                     /*樣本字號                               */
qcb04       varchar2(1),             /*调整样本字号                           */
                                     /*調整樣本字號                           */
qcb05       number(5),               /*接受数量                               */
                                     /*Accept數量                             */
qcb06       number(5)                /*拒绝数量                               */
                                     /*Rejcet數量                             */
);

alter table qcb_file add  constraint qcb_pk primary key  (qcb01,qcb02,qcb03) enable validate;
grant select on qcb_file to tiptopgp;
grant update on qcb_file to tiptopgp;
grant delete on qcb_file to tiptopgp;
grant insert on qcb_file to tiptopgp;
grant index on qcb_file to public;
grant select on qcb_file to ods;

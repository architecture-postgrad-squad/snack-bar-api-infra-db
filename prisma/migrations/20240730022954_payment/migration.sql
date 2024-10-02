/*
  Warnings:

  - A unique constraint covering the columns `[externalId]` on the table `Payment` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Order" ALTER COLUMN "status" SET DEFAULT 'Aguardando Pagamento';

-- AlterTable
ALTER TABLE "Payment" ADD COLUMN     "externalId" VARCHAR(255),
ADD COLUMN     "status" VARCHAR(255) NOT NULL DEFAULT 'Aguardando Pagamento';

-- CreateIndex
CREATE UNIQUE INDEX "Payment_externalId_key" ON "Payment"("externalId");

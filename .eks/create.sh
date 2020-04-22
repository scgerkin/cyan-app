#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Creating cluster...${NC}"
eksctl create cluster -f stack.yaml
echo -e "${RED}Creating LoadBalancer Service...${NC}"
kubectl apply -f templates/svc-lb.yaml
echo -e "${RED}Creating Replication Controllers...${NC}"
kubectl apply -f templates/rc-blue.yaml
kubectl apply -f templates/rc-green.yaml

echo -e "${RED}Listing clusters...${NC}"
eksctl get clusters --region=us-east-2
echo -e "${RED}Listing K8 resources...${NC}"
kubectl get all

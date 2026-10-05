
    function [correlationCoeff, mutualInfo] = compareImages(img1, img2) 
    %% metatroph se grayscale an xreiazetai
    if size(img1, 3) == 3
       img1 = rgb2gray(img1);
       img2 = rgb2gray(img2);
    end

    %% allagh se double 
    mask1 = img1 > 0; 
    mask2 = img2 > 0; 
    % maska gia epilogh pixels poy den einai mayra kai stis 2 eikones
    mask3 = mask1 & mask2;  

    % pairnei ta oxi mavra pixels apo thn maska 3
    img1Masked = double(img1(mask3)); 
    img2Masked = double(img2(mask3));  

    %%susxetish me corr2
    correlationCoeff = corr2(img1Masked, img2Masked);  % Compute correlation coefficient between masked images
    %sysxetish tvn eikonwn/vlepoyme gia megalew apokliseis
    img1Masked = (img1Masked - min(img1Masked)) / (max(img1Masked) - min(img1Masked));
    img2Masked = (img2Masked - min(img2Masked)) / (max(img2Masked) - min(img2Masked));

    %% ypologismos endiamesoy istogrammatos
    jointHist = hist3([img1Masked(:), img2Masked(:)], 'Nbins', [256, 256]);

    %kanonikopoihsh
    jointHist = jointHist / sum(jointHist(:));

    %syntijh
    pX = sum(jointHist, 2);  % Marginal of img1
    pY = sum(jointHist, 1);  % Marginal of img2

    %% entropy
    entropyX = -sum(pX .* log2(pX + eps));  % Add epsilon to avoid log(0)
    entropyY = -sum(pY .* log2(pY + eps));
    %apotelesmata
    jointEntropy = -sum(jointHist(:) .* log2(jointHist(:) + eps));
    mutualInfo = entropyX + entropyY - jointEntropy;
    

end


